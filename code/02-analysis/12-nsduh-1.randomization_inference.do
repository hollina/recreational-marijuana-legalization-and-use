// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta", clear

set matsize 11000

// List controls 
global list_of_controls ave_median_income ave_unemp_rate ave_male ave_white


// Set random seed
set seed 1234

// Set max number of iterations
local max_itr = 500

////////////////////////////////////////////////////////////////////////////////
//  Create matrix to store results
matrix rm_b_storage = J(500, 30,.) 
matrix rm_se_storage = J(500, 30,.) 
		
matrix mm_b_storage = J(500, 30,.) 
matrix mm_se_storage = J(500, 30,.) 

matrix dsrm_b_storage = J(500, 30,.) 
matrix dsrm_se_storage = J(500, 30,.) 
		
matrix dsmm_b_storage = J(500, 30,.) 
matrix dsmm_se_storage = J(500, 30,.) 

matrix drm_b_storage = J(500, 30,.) 
matrix drm_se_storage = J(500, 30,.) 
		
matrix dmm_b_storage = J(500, 30,.) 
matrix dmm_se_storage = J(500, 30,.) 

// Assign fake treatment status to N states where N is a uniform integer draw from 1 to 51. 
sort StateFIPS
bysort StateFIPS: gen order=_n
forvalues dataset_number = 1(1)`max_itr' {
	local percent_rm = runiformint(1, 50)/51
	local percent_mm = runiformint(1, 50)/51
	local percent_disp = runiformint(1, 50)/51
	local percent_rm_disp = runiformint(1, 50)/51
	
	gen fake_ever_rm_`dataset_number' =.
	gen fake_ever_mm_`dataset_number' =.
	gen fake_ever_disp_`dataset_number' =.
	gen fake_ever_rm_disp_`dataset_number' =.
	 
	bysort StateFIPS: replace fake_ever_rm_`dataset_number' = rbinomial(1,`percent_rm') if order ==1
	bysort StateFIPS: replace fake_ever_mm_`dataset_number' = rbinomial(1,`percent_mm') if order ==1
	bysort StateFIPS: replace fake_ever_disp_`dataset_number' = rbinomial(1,`percent_disp') if order ==1
	bysort StateFIPS: replace fake_ever_rm_disp_`dataset_number' = rbinomial(1,`percent_rm_disp') if order ==1
	
	sort StateFIPS
	bysort StateFIPS: carryforward fake_ever_rm_`dataset_number', replace
	bysort StateFIPS: carryforward fake_ever_mm_`dataset_number', replace
	bysort StateFIPS: carryforward fake_ever_disp_`dataset_number', replace
	bysort StateFIPS: carryforward fake_ever_rm_disp_`dataset_number', replace
}

forvalues dataset_number = 1(1)`max_itr' {
	sort StateFIPS year 
	gen fake_rm_`dataset_number' = 0
	gen fake_mm_`dataset_number' = 0
	gen fake_disp_`dataset_number' = 0
	gen fake_rm_disp_`dataset_number' = 0

	levelsof StateFIPS if fake_ever_rm_`dataset_number'==1
	foreach st in `r(levels)' {
		local fake_start_year =  runiformint(1, 15) //Randomly drawn integer between 1 and 14 from uniform
		di `fake_start_year'
		replace fake_rm_`dataset_number' = 1 if year_group_id>=`fake_start_year' & fake_ever_rm_`dataset_number'==1 & StateFIPS==`st'

	}
		drop fake_ever_rm_`dataset_number' 

	levelsof StateFIPS if fake_ever_mm_`dataset_number'==1
	foreach st in `r(levels)' {
		local fake_start_year =  runiformint(1, 15) //Randomly drawn integer between 1 and 14 from uniform
		di `fake_start_year'
		di `fake_start_year'
		replace fake_mm_`dataset_number' = 1 if year_group_id>=`fake_start_year' & fake_ever_mm_`dataset_number'==1 & StateFIPS==`st'
	}
		drop fake_ever_mm_`dataset_number'

	levelsof StateFIPS if fake_ever_disp_`dataset_number'==1
	foreach st in `r(levels)' {

		local fake_start_year =  runiformint(1, 15) //Random number between 1 and 14
		di `fake_start_year'
		replace fake_disp_`dataset_number' = 1 if year_group_id>=`fake_start_year' & fake_ever_disp_`dataset_number'==1 & StateFIPS==`st'
	}
		drop fake_ever_disp_`dataset_number'
		
	levelsof StateFIPS if fake_ever_rm_disp_`dataset_number'==1
	foreach st in `r(levels)' {

		local fake_start_year =  runiformint(1, 15) //Random number between 1 and 14
		di `fake_start_year'
		replace fake_rm_disp_`dataset_number' = 1 if year_group_id>=`fake_start_year' & fake_ever_rm_disp_`dataset_number'==1 & StateFIPS==`st'
	}
		drop fake_ever_rm_disp_`dataset_number'

}

// Set row local 
local dataset_number = 1

forvalues dataset_number  = 1(1)`max_itr' {
	
		local counter = 1

		local y_list mj_use_365 mj_use_30 mj_first_use alc_use_30 tob_use_30 coke_use_365  
		
		
		foreach y in `y_list' {
			
			local age_order_list 1 3 4 5 6
			foreach age_group in `age_order_list' {
				
				// Store Age Group

				////////////////////////////////////////////////////////////////////////////////
				// Run a single regression
				qui reghdfe ln_`y'  i.fake_rm_`dataset_number' i.fake_mm_`dataset_number'  i.fake_disp_`dataset_number' i.fake_rm_disp_`dataset_number' $list_of_controls if age_category == `age_group' ///
					,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)
				
		
				capture sum fake_rm_`dataset_number'
				
				if `r(max)'!=0{			
					// Store the recreational coef
					qui nlcom 100*(exp(_b[1.fake_rm_`dataset_number'])-1)
					mat b = r(b)
					mat V = r(V)

					scalar b = b[1,1]
					scalar se_v2 = sqrt(V[1,1])
					
					mat rm_b_storage[`dataset_number', `counter'] = b
					mat rm_se_storage[`dataset_number', `counter'] = se_v2
				}
				
				capture sum fake_mm_`dataset_number'
				
				if `r(max)'!=0{		
					// Store the medical coef
					qui nlcom 100*(exp(_b[1.fake_mm_`dataset_number'])-1)
					mat b = r(b)
					mat V = r(V)

					scalar b = b[1,1]
					scalar se_v2 = sqrt(V[1,1])
					
					mat mm_b_storage[`dataset_number', `counter'] = b
					mat mm_se_storage[`dataset_number', `counter'] = se_v2
				}
				
				capture sum fake_disp_`dataset_number'
				
				if `r(max)'!=0{		
					// Store the disp coef
					qui nlcom 100*(exp(_b[1.fake_disp_`dataset_number'])-1)
					mat b = r(b)
					mat V = r(V)

					scalar b = b[1,1]
					scalar se_v2 = sqrt(V[1,1])
					
					mat dsmm_b_storage[`dataset_number', `counter'] = b
					mat dsmm_se_storage[`dataset_number', `counter'] = se_v2
				}
				
				capture sum fake_disp_`dataset_number'
				
				if `r(max)'!=0{		
					capture sum fake_mm_`dataset_number'
					
					if `r(max)'!=0{		
						// Store the disp coef
						qui nlcom 100*(exp(_b[1.fake_disp_`dataset_number']+_b[1.fake_mm_`dataset_number'])-1)
						mat b = r(b)
						mat V = r(V)

						scalar b = b[1,1]
						scalar se_v2 = sqrt(V[1,1])
						
					mat dmm_b_storage[`dataset_number', `counter'] = b
					mat dmm_se_storage[`dataset_number', `counter'] = se_v2
					}
				}
				**
				capture sum fake_rm_disp_`dataset_number'
				
				if `r(max)'!=0{		
					// Store the disp coef
					qui nlcom 100*(exp(_b[1.fake_rm_disp_`dataset_number'])-1)
					mat b = r(b)
					mat V = r(V)

					scalar b = b[1,1]
					scalar se_v2 = sqrt(V[1,1])
					
					mat dsrm_b_storage[`dataset_number', `counter'] = b
					mat dsrm_se_storage[`dataset_number', `counter'] = se_v2
				}
				
				capture sum fake_rm_disp_`dataset_number'
				
				if `r(max)'!=0{		
					capture sum fake_rm_`dataset_number'
					
					if `r(max)'!=0{		
						// Store the disp coef
						qui nlcom 100*(exp(_b[1.fake_rm_disp_`dataset_number']+_b[1.fake_rm_`dataset_number'])-1)
						mat b = r(b)
						mat V = r(V)

						scalar b = b[1,1]
						scalar se_v2 = sqrt(V[1,1])
						
					mat drm_b_storage[`dataset_number', `counter'] = b
					mat drm_se_storage[`dataset_number', `counter'] = se_v2
					}
				}

				// Add one to the row
				local counter = `counter' + 1
			}

			
				
		}
				di "///////////////////////////////////////////////////////////////"
				di ((`dataset_number')/(`max_itr'))*100
				di "Percent Done"
				di "///////////////////////////////////////////////////////////////"
	*}
}

