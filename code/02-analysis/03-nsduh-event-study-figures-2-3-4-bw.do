////////////////////////////////////////////////////////////////////////////////
local y_list mj_use_365 mj_use_30 mj_first_use 
foreach y in `y_list' {
	local age_order_list  4 5 6 1 3
	foreach age_group in `age_order_list' {
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
				local label "marijuana use in the past 365 days"
				local sym "O"
				local sym_size 3
				local sym_color "black"
			}
			
			
			if "`y'" == "mj_use_30" {
				local label "marijuana use in the past 30 days"
				local sym "S"
				local sym_size 3
				local sym_color "black"
			}
			
			
			if "`y'" == "mj_first_use" {
				local sym "D"
				local sym_size 3
				local sym_color "black"
				local label "new marijuana initiates"

			}
			
			
			if "`y'" == "alc_use_30" {
				local label "alcohol use in the past 30 days"
				local sym "T"
				local sym_size 3
				local sym_color "black"	
			}
			
			
			if "`y'" == "tob_use_30" {
				local label "tobacco use in the past 30 days"
					local sym "X"
				local sym_size 3
				local sym_color "black"
			}
			
			
			if "`y'" == "coke_use_365" {
				local label "cocaine use in the past 365 days"
				local sym "Oh"
				local sym_size 3
				local sym_color "black"
			}
			
			if "`y'" == "mj_use_ratio" {
				local label "marijuana use intensity (this is a weird variable)"
			}
			

			// Open master dataset
			use "data_for_analysis/rml_panel_data.dta", clear

			global list_of_controls ave_median_income ave_unemp_rate ave_male ave_white

			///////////////////////////////////////////////////////////////////////////////
			// Set up leads and lags
			// First create an "event time" variable
			sort StateFIPS year_group_id

			// Create numeric year
			capture drop year_numeric
			gen year_numeric = year_group_id+2002

			levelsof age_category

			sort StateFIPS  age_category year_numeric
			order StateFIPS age_category year_numeric

			// Merge alex created data
			merge m:1 StateFIPS year_numeric age_category using "data_for_analysis/intermediate/marijuana_status.dta"

			keep if age_category == `age_group'

			gen ln_y = ln_`y'

			///////////////////////////////////////////////////////////////////////////////
			// Import program for event study
			do "code/02-analysis/03.1-nsduh-event-study-program.do"


			gen ever_treated = ever_rm 

			// Generate time treated 
			bysort StateFIPS  age_category: egen first_rm_year = min(year_numeric) if rm==1
			bysort StateFIPS  age_category: egen time_treated = min(first_rm_year) 
			replace time_treated = . if ever_treated == 0
			
			
			// Generate treated
			gen treated = 0 
			replace treated = 1 if year_numeric >= time_treated & ever_treated == 1


			///////////////////////////////////////////////////////////////////
			// Create event study graph

			create_event_study_graph_ln, ///
				first_time(2003) ///
				last_time(2017) ///
				first_treated_time(2013) ///
				last_treated_time(2020) ///
				low_event_cap(-5) ///
				high_event_cap(2) ///
				low_event_cap_graph(-4) ///
				high_event_cap_graph(1) ///
				y_var(ln_y) ///
				dd_control_list("i.mm i.disp") ///
				control_list("ave_median_income ave_unemp_rate ave_male ave_white") ///
				fixed_effects("StateFIPS year_numeric") ///
				cluster_var("StateFIPS") ///
				x_label("Years since legalization") ///
				x_lab_step_size(2) ///
				y_label("none") ///
				graph_label("`age_label'") ///
				output_file_name("output/plots/bw-event-study-estimates-ln-`y'-age-`age_group'") ///
				time_variable(year_numeric) ///
				id_variable(StateFIPS) ///
				weight_var("none") ///
				marker_color(`sym_color') ///
				marker_symbol(`sym') ///
				marker_size(`sym_size')
				

		}
}


local y_list mj_use_365 mj_use_30 mj_first_use 
local figure_order = 2
foreach y in `y_list' {
	
 	// Make smaller versions. 
	
	graph combine ///
		"output/plots/bw-event-study-estimates-ln-`y'-age-4" ///
		"output/plots/bw-event-study-estimates-ln-`y'-age-1" ///
		"output/plots/bw-event-study-estimates-ln-`y'-age-5" ///
		"output/plots/bw-event-study-estimates-ln-`y'-age-3" ///
		"output/plots/bw-event-study-estimates-ln-`y'-age-6" ///
		, col(2) ysize(8)  xcommon graphregion(margin(r+2)) 

	graph export "output/plots/bw-event-study-estimates-ln-`y'-bw.pdf", replace
	
	graph export "output/plots/figure_`figure_order'.png", replace
	local figure_order = `figure_order' + 1
	
	// Clean up
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-4.gph" 
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-5.gph" 
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-6.gph" 
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-1.gph" 
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-3.gph" 
	
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-4.pdf" 
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-5.pdf" 
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-6.pdf" 
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-1.pdf" 
	erase "output/plots/bw-event-study-estimates-ln-`y'-age-3.pdf" 

	}

