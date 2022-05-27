// Clear memory
clear 
set more off

// Import RI results
svmat rm_b_storage  
svmat rm_se_storage  
svmat mm_b_storage 
svmat mm_se_storage 
svmat dsrm_b_storage
svmat dsrm_se_storage 
svmat dsmm_b_storage 
svmat dsmm_se_storage 
svmat drm_b_storage 
svmat drm_se_storage 
svmat dmm_b_storage  
svmat dmm_se_storage 

format * %20.5f

gen actual = 0
compress
save  "temp/randomization_inference_storage.dta", replace

clear 
svmat rm_b_s2 
svmat rm_se_s2 
svmat mm_b_s2 
svmat mm_se_s2 
svmat dsrm_b_s2 
svmat dsrm_se_s2  
svmat dsmm_b_s2  
svmat dsmm_se_s2  
svmat drm_b_s2  
svmat drm_se_s2  
svmat dmm_b_s2   
svmat dmm_se_s2 

rename *_s2* *_storage*

gen actual=1
append using   "temp/randomization_inference_storage.dta"


gen run = _n

reshape long ///
 rm_b_storage@  ///
 rm_se_storage@  ///
 mm_b_storage@ ///
 mm_se_storage@  ///
 dsrm_b_storage@ ///
 dsrm_se_storage@  ///
 dsmm_b_storage@  ///
 dsmm_se_storage@  ///
 drm_b_storage@  ///
 drm_se_storage@  ///
 dmm_b_storage@   ///
 dmm_se_storage@  ///
 , i(run) j(counter)
 
 gen y_variable = ""
 gen age_group = ""
		local counter = 1
		local y_list mj_use_365 mj_use_30 mj_first_use alc_use_30 tob_use_30 coke_use_365  
		
		foreach y in `y_list' {
			
			local age_order_list 1 3 4 5 6
			foreach age_group in `age_order_list' {
			
				replace y_variable = "`y'" if counter == `counter'
				replace age_group = "`age_group'" if counter == `counter'
			
			local counter = `counter' + 1 
			}
		}
		
rename *_storage *
// Make sure these all have the y_variable

scalar df = 50

// Calculate RI p-value for each coef. 
local coef_list rm mm dsrm dsmm  dmm drm

foreach coef in `coef_list' {
	gen `coef'_ri_p_value = .
	local y_list mj_use_365 mj_use_30 mj_first_use alc_use_30 tob_use_30 coke_use_365 

	gen `coef'_z_score	= abs(((`coef'_b - 0)/`coef'_se))
	gen `coef'_p_value	= 2*ttail(df,`coef'_z_score)

	foreach y in `y_list' {

		local age_order_list 1 3 4 5 6
		foreach age_group in `age_order_list' {
		
			sum `coef'_b if y_variable=="`y'" & age_group=="`age_group'" & actual ==1
			local abs_mean = abs(`r(mean)')
			
			count if abs(`coef'_b) > `abs_mean' & y_variable=="`y'" & age_group=="`age_group'" & actual ==0
			local larger = `r(N)'
			
			count if  y_variable=="`y'" & age_group=="`age_group'"  & actual ==0
			local total = `r(N)'
			
			replace `coef'_ri_p_value = `larger'/`total' if y_variable=="`y'" & age_group=="`age_group'"  & actual ==1
		 
		}
	}
}
keep if !missing(rm_ri_p_value)

gen rm_act_p_value = 2*ttail(df,abs(rm_b/rm_se))
gen rm_disp_act_p_value = 2*ttail(df,abs(drm_b/drm_se))

order y_variable age_group ///
	rm_b rm_act_p_value rm_ri_p_value ///
	drm_b rm_disp_act_p_value drm_ri_p_value 
	
keep  y_variable age_group ///
	rm_b rm_act_p_value rm_ri_p_value ///
	drm_b rm_disp_act_p_value drm_ri_p_value 
	
	
	*tostring age_group, replace
	gen age_label = ""
		// Make labels for table
				replace age_label= "12 to 17" if age_group =="1"

				replace age_label=  "18 to 25" if age_group =="3"
	
				replace age_label=  "12 and up" if age_group =="4"
	
				replace age_label=  "18 and up" if age_group =="5"
	
				replace age_label=  "26 and up" if age_group =="6"
			
			
			gen y = ""
					replace y= "\emph{Marijuana use in the past 365 days}" if y_variable =="mj_use_365"

			
			
			
					replace y= "\addlinespace[1.5ex]\emph{Marijuana use in the past 30 days}" if y_variable =="mj_use_30"
			
			
			
			

					replace y= "\addlinespace[1.5ex]\emph{New marijuana initiates in the past two years}" if y_variable =="mj_first_use"

			
			
			
					replace y=  "\addlinespace[1.5ex]\emph{Alcohol use in the past 30 days}" if y_variable =="alc_use_30"
	
			
			
					replace y= "\addlinespace[1.5ex]\emph{Tobacco use in the past 30 days}" if y_variable =="tob_use_30"
	
			
			
					replace y=  "\addlinespace[1.5ex]\emph{Cocaine use in the past 365 days}" if y_variable =="coke_use_365"
		

drop if missing(y)

order y age_label
replace y = "" if age_label!="12 to 17"

drop y_variable age_group

save "temp/randomization_inference_p_value_storage.dta", replace
