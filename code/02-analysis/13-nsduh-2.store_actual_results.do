///////////////////////////////////////////////////////////////////////////////
// Actual results

// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta", clear

// List controls 
global list_of_controls ave_median_income ave_unemp_rate ave_male ave_white

matrix rm_b_s2 = J(1, 30,.) 
matrix rm_se_s2 = J(1, 30,.) 
		
matrix mm_b_s2 = J(1, 30,.) 
matrix mm_se_s2 = J(1, 30,.) 

matrix dsrm_b_s2 = J(1, 30,.) 
matrix dsrm_se_s2 = J(1, 30,.) 
		
matrix dsmm_b_s2 = J(1, 30,.) 
matrix dsmm_se_s2 = J(1, 30,.) 

matrix drm_b_s2 = J(1, 30,.) 
matrix drm_se_s2 = J(1, 30,.) 
		
matrix dmm_b_s2 = J(1, 30,.) 
matrix dmm_se_s2 = J(1, 30,.) 


		local counter = 1
		local y_list mj_use_365 mj_use_30 mj_first_use alc_use_30 tob_use_30 coke_use_365  
		
		foreach y in `y_list' {
			
			local age_order_list 1 3 4 5 6
			foreach age_group in `age_order_list' {
				
			
				////////////////////////////////////////////////////////////////////////////////
				// Run a single regression
				qui reghdfe ln_`y'  i.rm i.mm  i.disp i.rm_disp $list_of_controls if age_category == `age_group' ///
					,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)
				
		
				capture sum rm
				
				if `r(max)'!=0{			
					// Store the recreational coef
					qui nlcom 100*(exp(_b[1.rm])-1)
					mat b = r(b)
					mat V = r(V)

					scalar b = b[1,1]
					scalar se_v2 = sqrt(V[1,1])
					
					mat rm_b_s2[1, `counter'] = b
					mat rm_se_s2[1, `counter'] = se_v2
				}
				
				capture sum mm
				
				if `r(max)'!=0{		
					// Store the medical coef
					qui nlcom 100*(exp(_b[1.mm])-1)
					mat b = r(b)
					mat V = r(V)

					scalar b = b[1,1]
					scalar se_v2 = sqrt(V[1,1])
					
					mat mm_b_s2[1, `counter'] = b
					mat mm_se_s2[1, `counter'] = se_v2
				}
				
				capture sum disp
				
				if `r(max)'!=0{		
					// Store the disp coef
					qui nlcom 100*(exp(_b[1.disp])-1)
					mat b = r(b)
					mat V = r(V)

					scalar b = b[1,1]
					scalar se_v2 = sqrt(V[1,1])
					
					mat dsmm_b_s2[1, `counter'] = b
					mat dsmm_se_s2[1, `counter'] = se_v2
				}
				
				capture sum disp
				
				if `r(max)'!=0{		
					capture sum mm
					
					if `r(max)'!=0{		
						// Store the disp coef
						qui nlcom 100*(exp(_b[1.disp]+_b[1.mm])-1)
						mat b = r(b)
						mat V = r(V)

						scalar b = b[1,1]
						scalar se_v2 = sqrt(V[1,1])
						
					mat dmm_b_s2[1, `counter'] = b
					mat dmm_se_s2[1, `counter'] = se_v2
					}
				}
				
				capture sum rm_disp
				
				if `r(max)'!=0{		
					// Store the disp coef
					qui nlcom 100*(exp(_b[1.rm_disp])-1)
					mat b = r(b)
					mat V = r(V)

					scalar b = b[1,1]
					scalar se_v2 = sqrt(V[1,1])
					
					mat dsrm_b_s2[1, `counter'] = b
					mat dsrm_se_s2[1, `counter'] = se_v2
				}
				
				capture sum rm_disp
				
				if `r(max)'!=0{		
					capture sum rm
					
					if `r(max)'!=0{		
						// Store the disp coef
						qui nlcom 100*(exp(_b[1.rm_disp]+_b[1.rm])-1)
						mat b = r(b)
						mat V = r(V)

						scalar b = b[1,1]
						scalar se_v2 = sqrt(V[1,1])
						
						
					mat drm_b_s2[1, `counter'] = b
					mat drm_se_s2[1, `counter'] = se_v2
					}
				}
				*capture drop temp_test
				
				// Store degrees of freedom
				*putexcel O`row' = `e(df_r)'
				
				// Add one to the row
				local counter = `counter' + 1
			}

		}
	 reghdfe ln_mj_use_365  i.rm i.mm  i.disp i.rm_disp $list_of_controls if age_category == 1 ///
					,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS) 
				
	mat df = `e(df_r)'
