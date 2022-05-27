
// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta", clear

///////////////////////////////////////////////////////////////////////////////
// Generate a natural log of each variable


// Create local macro of all y variables
qui ds  age0_14 age15_24 age25_44 age45_64 age65up ave_male ave_white 
foreach y in `r(varlist)' {
	gen ln_`y' = ln(`y') //There are no zeros. So it's a straight log. 
}

// Create list of controls
global list_of_controls2 ave_median_income ave_unemp_rate  

gen ln_pop = ln(pop_total)
label var ln_pop "Natural Log of Pop"

// Keep only one age group since all else will be the same 
keep if age_category == 1
///////////////////////////////////////////////////////////////////////////////
// Without census region by year fe

capture est sto clear
local y_list ln_age0_14 ln_age15_24 ln_age25_44 ln_age45_64 ln_age65up ln_ave_male ln_ave_white ln_pop
foreach y in `y_list' {

		////////////////////////////////////////////////////////////////////////////////
		// Run a single regression
		reghdfe `y'  i.mm i.rm i.disp i.rm_disp $list_of_controls2 ,  absorb(StateFIPS year_group_id) vce(cluster StateFIPS)

		// Store the Recreational legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar rm_rounded_estimate = round(b,.01)
		local rm_rounded_estimate : di %3.2f rm_rounded_estimate
		scalar rm_string_estimate = "`rm_rounded_estimate'"

		// Round Standard Errors
		scalar rm_rounded_se = round(se_v2,.01)
		local rm_rounded_se : di %3.2f rm_rounded_se
		scalar rm_string_se = "("+"`rm_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar rm_string_estimate = rm_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar rm_string_estimate = rm_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar rm_string_estimate = rm_string_estimate + "\nlsym{1}"

		}
		else {
			scalar rm_string_estimate = rm_string_estimate 
		}			
			
		// Add the results
		estadd local rm_b_str =rm_string_estimate
		estadd local rm_se_str =rm_string_se	
			
		// Store the Medical legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_rounded_estimate = round(b,.01)
		local mm_rounded_estimate : di %3.2f mm_rounded_estimate
		scalar mm_string_estimate = "`mm_rounded_estimate'"

		// Round Standard Errors
		scalar mm_rounded_se = round(se_v2,.01)
		local mm_rounded_se : di %3.2f mm_rounded_se
		scalar mm_string_se = "("+"`mm_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_string_estimate = mm_string_estimate 
		}			
			
		// Add the results
		estadd local mm_b_str =mm_string_estimate
		estadd local mm_se_str =mm_string_se	
				

		// Store the dispensary + medical effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.disp]+_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_disp_rounded_estimate = round(b,.01)
		local  mm_disp_rounded_estimate : di %3.2f mm_disp_rounded_estimate
		scalar mm_disp_string_estimate = "`mm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar mm_disp_rounded_se = round(se_v2,.01)
		local  mm_disp_rounded_se : di %3.2f mm_disp_rounded_se
		scalar mm_disp_string_se = "("+"`mm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_disp_string_estimate = mm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local mm_disp_b_str = mm_disp_string_estimate
		estadd local mm_disp_se_str= mm_disp_string_se
		
		// Store the rec dispensary + rec effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm_disp]+_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar rm_disp_rounded_estimate = round(b,.01)
		local  rm_disp_rounded_estimate : di %3.2f rm_disp_rounded_estimate
		scalar rm_disp_string_estimate = "`rm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar rm_disp_rounded_se = round(se_v2,.01)
		local  rm_disp_rounded_se : di %3.2f rm_disp_rounded_se
		scalar rm_disp_string_se = "("+"`rm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar rm_disp_string_estimate = rm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local rm_disp_b_str = rm_disp_string_estimate
		estadd local rm_disp_se_str= rm_disp_string_se
				
		// Add indicators for state and year fixed-effects.
		estadd local state_fe "Yes"
		estadd local year_fe "Yes"
		estadd local region_by_year_fe "No"
		estadd local controls "Yes"

		// Store the model
		est sto m_`y'
}

	esttab m_ln_age0_14 m_ln_age15_24 m_ln_age25_44 m_ln_age45_64 m_ln_age65up  m_ln_ave_male m_ln_ave_white  m_ln_pop ///
		using "output/tables/mj_legalization_and_population.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
			stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str  ///
			mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str ///
				, fmt(0 0 0 0 0 0 0) ///
			layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
			label("\emph{Without region-by-year fixed effects} &&&&&\\ \emph{but with year fixed effects} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~")) ///
		drop(*) se b(%9.2f) booktabs ///
		f replace  ///
		mtitles("0 to 14"  "15 to 24" "25 to 44"  "45 to 64"  "~65+~" "~~~~~Male~~~~~" "~~~~~White~~~~~" "~~~~~Total~~~~~") 


capture est sto clear
local y_list ln_age0_14 ln_age15_24 ln_age25_44 ln_age45_64 ln_age65up ln_ave_male ln_ave_white ln_pop
foreach y in `y_list' {

		////////////////////////////////////////////////////////////////////////////////
		// Run a single regression
		reghdfe `y'  i.mm i.rm i.disp i.rm_disp $list_of_controls2 ,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)

		// Store the Recreational legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar rm_rounded_estimate = round(b,.01)
		local rm_rounded_estimate : di %3.2f rm_rounded_estimate
		scalar rm_string_estimate = "`rm_rounded_estimate'"

		// Round Standard Errors
		scalar rm_rounded_se = round(se_v2,.01)
		local rm_rounded_se : di %3.2f rm_rounded_se
		scalar rm_string_se = "("+"`rm_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar rm_string_estimate = rm_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar rm_string_estimate = rm_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar rm_string_estimate = rm_string_estimate + "\nlsym{1}"

		}
		else {
			scalar rm_string_estimate = rm_string_estimate 
		}			
			
		// Add the results
		estadd local rm_b_str =rm_string_estimate
		estadd local rm_se_str =rm_string_se	
			
		// Store the Medical legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_rounded_estimate = round(b,.01)
		local mm_rounded_estimate : di %3.2f mm_rounded_estimate
		scalar mm_string_estimate = "`mm_rounded_estimate'"

		// Round Standard Errors
		scalar mm_rounded_se = round(se_v2,.01)
		local mm_rounded_se : di %3.2f mm_rounded_se
		scalar mm_string_se = "("+"`mm_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_string_estimate = mm_string_estimate 
		}			
			
		// Add the results
		estadd local mm_b_str =mm_string_estimate
		estadd local mm_se_str =mm_string_se	
				

		// Store the dispensary + medical effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.disp]+_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_disp_rounded_estimate = round(b,.01)
		local  mm_disp_rounded_estimate : di %3.2f mm_disp_rounded_estimate
		scalar mm_disp_string_estimate = "`mm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar mm_disp_rounded_se = round(se_v2,.01)
		local  mm_disp_rounded_se : di %3.2f mm_disp_rounded_se
		scalar mm_disp_string_se = "("+"`mm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_disp_string_estimate = mm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local mm_disp_b_str = mm_disp_string_estimate
		estadd local mm_disp_se_str= mm_disp_string_se
		
		// Store the rec dispensary + rec effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm_disp]+_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar rm_disp_rounded_estimate = round(b,.01)
		local  rm_disp_rounded_estimate : di %3.2f rm_disp_rounded_estimate
		scalar rm_disp_string_estimate = "`rm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar rm_disp_rounded_se = round(se_v2,.01)
		local  rm_disp_rounded_se : di %3.2f rm_disp_rounded_se
		scalar rm_disp_string_se = "("+"`rm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar rm_disp_string_estimate = rm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local rm_disp_b_str = rm_disp_string_estimate
		estadd local rm_disp_se_str= rm_disp_string_se
				
		// Add indicators for state and year fixed-effects.
		estadd local state_fe "Yes"
		estadd local year_fe "Yes"
		estadd local region_by_year_fe "No"
		estadd local controls "Yes"

		// Store the model
		est sto m_`y'
}

	esttab m_ln_age0_14 m_ln_age15_24 m_ln_age25_44 m_ln_age45_64 m_ln_age65up  m_ln_ave_male m_ln_ave_white   m_ln_pop ///
	using "output/tables/mj_legalization_and_population.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str controls state_fe   N, fmt(0  0 0 0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"   "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("\emph{With region-by-year fixed effects} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~" ///
		" \addlinespace \hline Controls" "State fixed-effects" "Observations")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles nonumbers noline 
		
