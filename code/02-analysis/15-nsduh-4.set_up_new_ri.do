// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta", clear

// Only need one age category to set this up. It doesn't matter which one
keep if age_category==6

// Save this as a temp dataset that we will draw from
compress
save "temp/temp_for_ri_1.dta", replace

// Keep only the variables that we need
keep StateFIPS year mm rm disp rm_disp division region year_group_id age_category

keep StateFIPS		mm	disp	rm	rm_disp year_group_id
rename mm mm_
rename rm rm_
rename disp disp_
rename rm_disp rm_disp_

distinct StateFIPS

reshape wide mm_@ rm_@ disp_@ rm_disp_@, i(year_group_id) j(StateFIPS)

merge 1:m year_group_id using "temp/temp_for_ri_1.dta"


// Run procedure for N iterations
forvalues iteration = 1(1)500 {

	// Generate empty variables for this iteration
	gen fake_mm_`iteration' = .
	gen fake_rm_`iteration' = .
	gen fake_disp_`iteration' = .
	gen fake_rm_disp_`iteration' = .
	
	
	// Randomize treatment within census region
	forvalues r_numb = 1(1)4 { 
	
		// Create a list of states in each region
		levelsof StateFIPS if region==`r_numb'
		
		// Store this list as a local macro
		local list_of_states  "`r(levels)'"
		
		// Clear number list (if present from prior loop)
		local rnumbers " "
		
		// Generate a uniform draw for each state in the region and store all a long macro
		*Adapted from https://theesspreckelsen.wordpress.com/2014/08/05/stata-how-to-select-a-random-number-from-a-list/
		foreach num of local list_of_states { 
			local randomnumber = runiform()
			local rnumbers = "`rnumbers'`randomnumber' "
		}
		
		// Sort this list of random draws
		local selection : list sort rnumbers
			
		// Count the total number of entries in these random draws
		local total_count =  wordcount("`selection'")

		// Find out where each original state (by order) is mapped to (by order) using list of random draws
		forvalues i = 1(1)`total_count' {
		
			// What is the original state in question
			local OLDposofselected = word("`list_of_states'",`i') 
			// What is the original position of the state in question
			local OLDposinselectionlocal : list posof "`OLDposofselected'" in list_of_states 

			// What is the random number of the state in question
			local NEWposofselected = word("`selection'",`i') 
			
			// What is the position of the random number 
			local NEWposinselectionlocal : list posof "`NEWposofselected'" in rnumbers 
			
			// Map this random number to the original list of states to get the new state
			local NEWFIPS =  word("`list_of_states'",`NEWposinselectionlocal')
			
			// State the transform 
			di "`OLDposofselected' becomes `NEWFIPS'"
			
			// Create the randomized treatement variable for each state
			replace fake_mm_`iteration' = mm_`NEWFIPS' if StateFIPS==`OLDposofselected'
			replace fake_rm_`iteration' = rm_`NEWFIPS' if StateFIPS==`OLDposofselected'
			replace fake_disp_`iteration' = disp_`NEWFIPS' if StateFIPS==`OLDposofselected'
			replace fake_rm_disp_`iteration' = rm_disp_`NEWFIPS' if StateFIPS==`OLDposofselected'
				
		}
	}
}

// Keep only what we want and sort the data
keep StateFIPS year_group_id fake_*
order StateFIPS year_group_id
sort StateFIPS year_group_id

// Save the dataset so it can be merged with our main dataset of interest
compress
save "temp/temp_for_ri.dta", replace
erase "temp/temp_for_ri_1.dta"

