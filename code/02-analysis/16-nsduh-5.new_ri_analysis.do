// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta", clear

// List controls 
global list_of_controls ave_median_income ave_unemp_rate ave_male ave_white

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


// Set random seed
set seed 1234

// Merge in fake treatment status
merge m:1 StateFIPS year_group_id using "temp/temp_for_ri.dta"


local max_itr = 500


// Set row local 
local dataset_number = 1

forvalues dataset_number = 1(1)`max_itr' {
	//////////////////////////////////////////////////////////////////////////
	// Place treated states in excel sheet 
		
		local counter = 1
		local y_list mj_use_365 mj_use_30 mj_first_use alc_use_30 tob_use_30 coke_use_365  
		
		
		foreach y in `y_list' {
			// Store Y variable 
			*putexcel I`row' ="ln_`y'"
			
			local age_order_list 1 3 4 5 6
			foreach age_group in `age_order_list' {
				
				// Store Age Group
				*putexcel J`row' =`age_group'

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
	}

