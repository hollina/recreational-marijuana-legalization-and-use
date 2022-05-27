///////////////////////////////////////////////////////////////////////////////
// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta", clear

// List controls 
global list_of_controls ave_median_income ave_unemp_rate ave_male ave_white

///////////////////////////////////////////////////////////////////////////////
// Create excel sheet to store results
putexcel set "temp/closest_pre_period_match_storage.xlsx", replace
putexcel A1 = "Substance"
putexcel B1 = "Age group"
putexcel C1 = "Set of closest states"
putexcel D1 = "Pre-treatment mean of recreational marijuana states"
putexcel E1 = "Pre-treatment mean of closest states"
putexcel F1 = "Pre-treatment mean of left-out states"
local row = 2

///////////////////////////////////////////////////////////////////////////////
// Determine the set of "best" controls in the preperiod
local y_list mj_use_365 mj_use_30 mj_first_use alc_use_30 tob_use_30 coke_use_365  
foreach y in `y_list' { 
	bysort age_category: egen mean_`y'_rm =mean(`y') if year_group_id<11 &  ever_rm==1
	gsort age_category  -mean_`y'_rm
	bysort age_category: carryforward mean_`y'_rm, replace

	gen abs_diff_mean_`y' = abs(`y'-mean_`y'_rm)
	sum abs_diff_mean_`y' if ever_rm ==1 & year_group_id <11
	gen cohen_d_`y' =abs_diff_mean_`y'/`r(sd)'
	
	bysort StateFIPS age_category: egen mean_cohen_d_`y' = mean(cohen_d_`y') if year_group_id<11
	gsort StateFIPS age_category -mean_cohen_d_`y'
	bysort StateFIPS age_category: carryforward mean_cohen_d_`y', replace

	bysort age_category: egen mean_cohen_d_`y'_rm = mean(cohen_d_`y')  if year_group_id<11 &  ever_rm==1
	gsort  age_category -mean_cohen_d_`y'_rm
	bysort age_category: carryforward mean_cohen_d_`y'_rm, replace

	gen keep_for_`y' = 0 
	replace keep_for_`y' =1 if mean_cohen_d_`y'<=mean_cohen_d_`y'_rm*1.5
	replace keep_for_`y' =1  if ever_rm==1
	
	drop  mean_`y'_rm abs_diff_mean_`y' cohen_d_`y'
	sort StateFIPS age_category year_group_id

}


///////////////////////////////////////////////////////////////////////////////
// Try with census region by year fe

capture est sto clear
local y_list mj_use_365 mj_use_30 mj_first_use alc_use_30 tob_use_30 coke_use_365 
foreach y in `y_list' {
	
	local age_order_list 1 3 4 5 6
	foreach age_group in `age_order_list' {

		////////////////////////////////////////////////////////////////////////////////
		// Run a single regression
		reghdfe ln_`y'  i.mm i.rm i.disp i.rm_disp $list_of_controls if age_category == `age_group' & keep_for_`y' ==1 ,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)

		// Store the recreational marijuana effect
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
			
		// Store the medical marijuana effect
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
			

		// Store the dispensary effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.disp])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar disp_rounded_estimate = round(b,.01)
		local disp_rounded_estimate : di %3.2f disp_rounded_estimate
		scalar disp_string_estimate = "`disp_rounded_estimate'"

		// Round Standard Errors
		scalar disp_rounded_se = round(se_v2,.01)
		local disp_rounded_se : di %3.2f disp_rounded_se
		scalar disp_string_se = "("+"`disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar disp_string_estimate = disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar disp_string_estimate = disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar disp_string_estimate = disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar disp_string_estimate = disp_string_estimate 
		}		
		// Add the results
		estadd local disp_b_str =disp_string_estimate
		estadd local disp_se_str =disp_string_se		

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
		estadd local mm_disp_b_str = rm_disp_string_estimate
		estadd local mm_disp_se_str= rm_disp_string_se
		
		// Store the dispensary + medical effect
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
		
		// Make labels for table
			if "`age_group'"=="1" {
				local age_label "12 to 17"
			}
			if "`age_group'"=="3" {
				local age_label "18 to 25"
			}
			
			if "`age_group'"=="4" {
				local age_label "12 and up"
			}
			
			if "`age_group'"=="5" {
				local age_label "18 and up"
			}
			
			if "`age_group'"=="6" {
				local age_label "26 and up"
			}
			
			if "`y'" == "mj_use_365" {
				local label "Marijuana use in the past 365 days"
				local sym "O"
				local sym_size 3
				local sym_color "vermillion"
			}
			
			
			if "`y'" == "mj_use_30" {
				local label "Marijuana use in the past 30 days"
				local sym "S"
				local sym_size 3
				local sym_color "sea"
			}
			
			
			if "`y'" == "mj_first_use" {
				local sym "D"
				local sym_size 3
				local sym_color "turquoise"
				local label "New marijuana initiates in the past two years"

			}
			
			
			if "`y'" == "alc_use_30" {
				local label "Alcohol use in the past 30 days"
				local sym "T"
				local sym_size 3
				local sym_color "black"	
			}
			
			
			if "`y'" == "tob_use_30" {
				local label "Tobacco use in the past 30 days"
					local sym "X"
				local sym_size 3
				local sym_color "reddish"
			}
			
			
			if "`y'" == "coke_use_365" {
				local label "Cocaine use in the past 365 days"
				local sym "Oh"
				local sym_size 3
				local sym_color "black"
			}
			
			if "`y'" == "mj_use_ratio" {
				local label "Marijuana use intensity (this is a weird variable)"
			}
		// Record product
		putexcel A`row' = "`label'"
		
		// Record Age group 
		putexcel B`row' = "`age_label'"
		
		// Determine set of closest states
		capture drop test
		gen test = ""
					
		levelsof st_abbrv  if ever_rm==0 & year_group_id<11 & age_category == `age_group' & keep_for_`y' ==1, local(closest_states)
		foreach x in `closest_states' {
			replace test = test + ", " + "`x'"
		}
				
		local state_list `=test[1]'
		putexcel C`row' = "`state_list'"
		
		// Summarize the pre-treatment mean for treated
		sum `y' if ever_rm==1 & year_group_id<11 & age_category == `age_group' 
		estadd scalar pre_treat_mean_t = `r(mean)'
		scalar rounded_mean = round(`r(mean)',.01)
		local rounded_mean =rounded_mean
		putexcel D`row' = `rounded_mean'

		// Summarize the pre-treatment mean for selected control
		sum `y' if ever_rm==0 & year_group_id<11 & age_category == `age_group' & keep_for_`y' ==1
		estadd scalar pre_treat_mean_con = `r(mean)'
		scalar rounded_mean = round(`r(mean)',.01)
		local rounded_mean =rounded_mean
		putexcel E`row' = `rounded_mean'
		// Summarize the pre-treatment mean for left out controls
		sum `y' if ever_rm==0 & year_group_id<11 & age_category == `age_group' & keep_for_`y' ==0
		estadd scalar pre_treat_mean_no = `r(mean)'
		scalar rounded_mean = round(`r(mean)',.01)
		local rounded_mean =rounded_mean	
		putexcel F`row' = `rounded_mean'

		
		// Add indicators for state and year fixed-effects.
		estadd local state_fe "Yes"
		estadd local year_fe "No"
		estadd local region_by_year_fe "Yes"
		estadd local controls "Yes"
	
		// Store the model
		est sto ln_`y'_`age_group'
		
		// Add one to the row
		local row = `row' +1
	}
}


// Make table for marijuana use 
	local y mj_use_365 //mj_use_30 mj_first_use
	esttab   ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/mj_use_full_table_only_good_pretrends.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
		stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str  ///
			mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str N ///
				, fmt(0 0 0 0 0 0 0 0 0) ///
			layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
			label("\emph{Marijuana use in the past year} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Observations")) ///
		drop(*) se b(%9.2f) booktabs ///
		f replace  ///
		mtitles( "12 and up"  "18 and up"  "26 and up" "12 to 17"  "18 to 25")

	local y mj_use_30 //mj_first_use
	esttab   ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/mj_use_full_table_only_good_pretrends.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
	stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str  ///
			mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str N ///
				, fmt(0 0 0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("\emph{Marijuana use in the past 30 days} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Observations")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles noline nonumbers
		
	local y mj_first_use
	esttab  ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3  ///
		using "output/tables/mj_use_full_table_only_good_pretrends.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
				stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str N controls state_fe  region_by_year_fe , fmt(0 0 0 0 0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"   "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("\emph{Marijuana initiates in past two years} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~" ///
		"\hspace{0.5cm}Observations" " \addlinespace \hline Controls" "State fixed-effects"  "Region-by-year fixed-effects")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles nonumbers noline 	
		
// Make table for other substance use 
	local y alc_use_30 //mj_use_30 mj_first_use
	esttab   ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/other_use_full_table_only_good_pretrends.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
		stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str N ///
				, fmt(0 0 0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
		"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
		"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}") ///
		label("\emph{Alcohol use in the 30 days} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Observations")) ///
		drop(*) se b(%9.2f) booktabs ///
		f replace  ///
		mtitles( "12 and up"  "18 and up"  "26 and up" "12 to 17"  "18 to 25")

	local y tob_use_30 //mj_first_use
	esttab   ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3 ///
		using "output/tables/other_use_full_table_only_good_pretrends.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
		stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str N ///
				, fmt(0 0 0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("\emph{Tobacco use in the 30 days} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Observations")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles noline nonumbers
		
	local y coke_use_365
	esttab ln_`y'_4  ln_`y'_5  ln_`y'_6 ln_`y'_1 ln_`y'_3   ///
		using "output/tables/other_use_full_table_only_good_pretrends.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
				stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str N controls state_fe  region_by_year_fe, fmt( 0 0 0 0 0 0 0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ) ///
		label("\emph{Cocaine use in past year} &&&&&\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{5cm}{Medical legal and medical dispensary open}}" "~" ///
		"\hspace{0.5cm}Observations" "\addlinespace \hline Controls" "State fixed-effects"  "Region-by-year fixed-effects" )) ///
		drop(*) se b(%9.2f) booktabs ///
		f append  ///
		nomtitles nonumbers noline 	


