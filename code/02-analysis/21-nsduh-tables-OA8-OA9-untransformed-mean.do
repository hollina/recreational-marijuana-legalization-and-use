// Clear memory
clear all
set more off

// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta"

// List controls 
global list_of_controls ave_median_income ave_unemp_rate ave_male ave_white


///////////////////////////////////////////////////////////////////////////////
// Try with census region by year fe

capture est sto clear
local y_list mj_use_365 mj_use_30 mj_first_use  alc_use_30 tob_use_30 coke_use_365  
foreach y in `y_list' {
	
	local age_order_list 1 3 4 5 6
	foreach age_group in `age_order_list' {

		////////////////////////////////////////////////////////////////////////////////
		// Run a single regression
		reghdfe `y'  i.mm i.rm i.disp i.rm_disp $list_of_controls if age_category == `age_group',  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)

		// Store the Recreational legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom ((_b[1.rm]))
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
		nlcom ((_b[1.mm]))
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
		nlcom ((_b[1.disp]+_b[1.mm]))
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
		nlcom ((_b[1.rm_disp]+_b[1.rm]))
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
		estadd local year_fe "No"
		estadd local region_by_year_fe "Yes"
		estadd local controls "Yes"
	
		// Store the model
		est sto ln_`y'_`age_group'
	}
}
*\vspace{.25cm}\hspace{0.5cm}\shortstack[l]{}
// Make table for marijuana use 
	local y mj_use_365 //mj_use_30 mj_first_use
	esttab   ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/mj_full_table_mean.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
		stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str  ///
			mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str ///
				, fmt(0 0 0 0 0 0 0) ///
			layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
			label("\emph{Marijuana use in the past year} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~")) ///
		drop(*) se b(%9.2f) booktabs ///
		f replace  ///
		mtitles( "12 and up"  "18 and up"  "26 and up" "12 to 17"  "18 to 25")

	local y mj_use_30 //mj_first_use
	esttab  ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/mj_full_table_mean.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
	stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str  ///
			mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str ///
			, fmt(0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("\emph{Marijuana use in the past 30 days} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles noline nonumbers
		
	local y mj_first_use
	esttab  ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/mj_full_table_mean.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
				stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str controls state_fe  region_by_year_fe N, fmt(0 0 0 0 0 0 0 0 0  0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ) ///
		label("\emph{Marijuana initiates in past two years} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~" ///
		" \addlinespace \hline Controls" "State fixed-effects"  "Region-by-year fixed-effects" "Observations")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles nonumbers noline 	
		
// Make table for other substance use 
	local y alc_use_30 //mj_use_30 mj_first_use
	esttab   ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/other_use_full_table_mean.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
		stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str ///
			, fmt(0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("\emph{Alcohol use in the 30 days} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~")) ///
		drop(*) se b(%9.2f) booktabs ///
		f replace  ///
		mtitles("12 and up"  "18 and up"  "26 and up" "12 to 17"  "18 to 25" )

	local y tob_use_30 //mj_first_use
	esttab   ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/other_use_full_table_mean.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
		stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str ///
			, fmt(0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("\emph{Tobacco use in the 30 days} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles noline nonumbers
		
	local y coke_use_365
	esttab  ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/other_use_full_table_mean.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
				stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str controls state_fe  region_by_year_fe N, fmt(0 0 0 0 0 0 0 0 0  0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ) ///
		label("\emph{Cocaine use in past year} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~" ///
		" \addlinespace \hline Controls" "State fixed-effects"  "Region-by-year fixed-effects" "Observations")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles nonumbers noline 	
