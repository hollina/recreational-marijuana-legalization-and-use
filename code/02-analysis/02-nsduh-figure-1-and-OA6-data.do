// Clear memory
clear all

// Open cleaned dataset
use data_for_analysis/nsduh_1999_2016_state_comparison_data.dta


// Keep only what we need for the 
keep if year =="2005-2006" |  year =="2016-2017"

keep  st_abbrv year mj_use_365_* mj_use_30_* ave_pop rm

bysort st_abbrv: egen rm_in_post = max(rm) 

gen time = 0 
replace time = 1 if  year =="2016-2017"
drop year

collapse (mean)  mj_use_365_* mj_use_30_* [aw = ave_pop], by(rm_in_post time)

reshape long mj_use_365_@ mj_use_30_@, i(rm time) j(age) string

tostring time, replace
reshape wide mj_use_365_@ mj_use_30_@, i(rm age) j(time) string

gen per_diff_365 = ((mj_use_365_1- mj_use_365_0)/mj_use_365_0)*100
gen per_diff_30 = ((mj_use_30_1- mj_use_30_0)/mj_use_30_0)*100

sort age rm_in_post 
gen order = _n


	gsort  age -rm_in_post
	capture drop diff_365
	bysort age: gen diff_365 = (per_diff_365[_n] - per_diff_365[_n+1])
	bysort age: gen diff_30 = (per_diff_30[_n] - per_diff_30[_n+1])

	replace age = "12 and up" if age == "12"
	replace age = "18 and up" if age == "18"
	replace age = "26 and up" if age == "26"
	replace age = "12 to 17" if age == "12_17"
	replace age = "18 to 25" if age == "18_25"
	
	drop order
	gen group_order = .
	replace group_order = 50 if age ==  "12 and up" 
	replace group_order = 40 if age ==  "18 and up" 
	replace group_order = 30 if age ==  "26 and up"  
	replace group_order = 20 if age ==  "12 to 17" 
	replace group_order = 10 if age ==  "18 to 25" 
	
	gsort group_order -rm_in_post
	gen other_order = .
	replace other_order = group_order + 1 if rm_in_post == 1
	replace other_order = group_order - 1 if rm_in_post == 0
	
	gen age_rec = ""
	replace age_rec = "12 and up, rec. states" if age ==  "12 and up" & rm_in_post == 1
	replace age_rec = "18 and up, rec. states" if age == "18 and up" & rm_in_post == 1
	replace age_rec = "26 and up, rec. states" if age == "26 and up" & rm_in_post == 1
	replace age_rec = "12 to 17,  rec. states" if age == "12 to 17" & rm_in_post == 1
	replace age_rec = "18 to 25, rec. states" if age == "18 to 25" & rm_in_post == 1
	
	replace age_rec = "12 and up, oth. states" if age ==  "12 and up" & rm_in_post == 0
	replace age_rec = "18 and up, oth. states" if age == "18 and up" & rm_in_post == 0
	replace age_rec = "26 and up, oth. states" if age == "26 and up" & rm_in_post == 0
	replace age_rec = "12 to 17, oth. states" if age == "12 to 17" & rm_in_post == 0
	replace age_rec = "18 to 25, oth. states" if age == "18 to 25" & rm_in_post == 0	
	compress
	
	export delimited using "temp/data-for-cleveland-plot.csv", replace
	
// For robustness check. 	
// Open cleaned dataset
use "data_for_analysis/nsduh_1999_2016_state_comparison_data.dta", clear


// Keep only what we need for the 
keep if year =="2008-2009" |  year =="2016-2017"

keep  st_abbrv year mj_use_365_* mj_use_30_* ave_pop rm

bysort st_abbrv: egen rm_in_post = max(rm) 

gen time = 0 
replace time = 1 if  year =="2016-2017"
drop year

collapse (mean)  mj_use_365_* mj_use_30_* [aw = ave_pop], by(rm_in_post time)

reshape long mj_use_365_@ mj_use_30_@, i(rm time) j(age) string

tostring time, replace
reshape wide mj_use_365_@ mj_use_30_@, i(rm age) j(time) string

gen per_diff_365 = ((mj_use_365_1- mj_use_365_0)/mj_use_365_0)*100
gen per_diff_30 = ((mj_use_30_1- mj_use_30_0)/mj_use_30_0)*100

sort age rm_in_post 
gen order = _n


gsort  age -rm_in_post
capture drop diff_365
bysort age: gen diff_365 = (per_diff_365[_n] - per_diff_365[_n+1])
bysort age: gen diff_30 = (per_diff_30[_n] - per_diff_30[_n+1])

replace age = "12 and up" if age == "12"
replace age = "18 and up" if age == "18"
replace age = "26 and up" if age == "26"
replace age = "12 to 17" if age == "12_17"
replace age = "18 to 25" if age == "18_25"

drop order
gen group_order = .
replace group_order = 50 if age ==  "12 and up" 
replace group_order = 40 if age ==  "18 and up" 
replace group_order = 30 if age ==  "26 and up"  
replace group_order = 20 if age ==  "12 to 17" 
replace group_order = 10 if age ==  "18 to 25" 

gsort group_order -rm_in_post
gen other_order = .
replace other_order = group_order + 1 if rm_in_post == 1
replace other_order = group_order - 1 if rm_in_post == 0

gen age_rec = ""
replace age_rec = "12 and up, rec. states" if age ==  "12 and up" & rm_in_post == 1
replace age_rec = "18 and up, rec. states" if age == "18 and up" & rm_in_post == 1
replace age_rec = "26 and up, rec. states" if age == "26 and up" & rm_in_post == 1
replace age_rec = "12 to 17,  rec. states" if age == "12 to 17" & rm_in_post == 1
replace age_rec = "18 to 25, rec. states" if age == "18 to 25" & rm_in_post == 1

replace age_rec = "12 and up, oth. states" if age ==  "12 and up" & rm_in_post == 0
replace age_rec = "18 and up, oth. states" if age == "18 and up" & rm_in_post == 0
replace age_rec = "26 and up, oth. states" if age == "26 and up" & rm_in_post == 0
replace age_rec = "12 to 17, oth. states" if age == "12 to 17" & rm_in_post == 0
replace age_rec = "18 to 25, oth. states" if age == "18 to 25" & rm_in_post == 0	
compress

export delimited using "temp/data-for-cleveland-plot-additional.csv", replace

// Clear memory
clear all

// Open cleaned dataset
// Open cleaned dataset
use "data_for_analysis/nsduh_1999_2016_state_comparison_data.dta"


// Keep only what we need for the 
keep if year =="2005-2006" |  year =="2008-2009" | year == "2016-2017"

keep  st_abbrv year mj_use_365_* mj_use_30_* ave_pop rm

bysort st_abbrv: egen rm_in_post = max(rm) 
drop if year == "2016-2017"
gen time = 0 
replace time = 1 if  year =="2008-2009"
drop year

collapse (mean)  mj_use_365_* mj_use_30_* [aw = ave_pop], by(rm_in_post time)

reshape long mj_use_365_@ mj_use_30_@, i(rm time) j(age) string

tostring time, replace
reshape wide mj_use_365_@ mj_use_30_@, i(rm age) j(time) string

gen per_diff_365 = ((mj_use_365_1- mj_use_365_0)/mj_use_365_0)*100
gen per_diff_30 = ((mj_use_30_1- mj_use_30_0)/mj_use_30_0)*100

sort age rm_in_post 
gen order = _n


gsort  age -rm_in_post
capture drop diff_365
bysort age: gen diff_365 = (per_diff_365[_n] - per_diff_365[_n+1])
bysort age: gen diff_30 = (per_diff_30[_n] - per_diff_30[_n+1])

replace age = "12 and up" if age == "12"
replace age = "18 and up" if age == "18"
replace age = "26 and up" if age == "26"
replace age = "12 to 17" if age == "12_17"
replace age = "18 to 25" if age == "18_25"

drop order
gen group_order = .
replace group_order = 50 if age ==  "12 and up" 
replace group_order = 40 if age ==  "18 and up" 
replace group_order = 30 if age ==  "26 and up"  
replace group_order = 20 if age ==  "12 to 17" 
replace group_order = 10 if age ==  "18 to 25" 

gsort group_order -rm_in_post
gen other_order = .
replace other_order = group_order + 1 if rm_in_post == 1
replace other_order = group_order - 1 if rm_in_post == 0

gen age_rec = ""
replace age_rec = "12 and up, rec. states" if age ==  "12 and up" & rm_in_post == 1
replace age_rec = "18 and up, rec. states" if age == "18 and up" & rm_in_post == 1
replace age_rec = "26 and up, rec. states" if age == "26 and up" & rm_in_post == 1
replace age_rec = "12 to 17,  rec. states" if age == "12 to 17" & rm_in_post == 1
replace age_rec = "18 to 25, rec. states" if age == "18 to 25" & rm_in_post == 1

replace age_rec = "12 and up, oth. states" if age ==  "12 and up" & rm_in_post == 0
replace age_rec = "18 and up, oth. states" if age == "18 and up" & rm_in_post == 0
replace age_rec = "26 and up, oth. states" if age == "26 and up" & rm_in_post == 0
replace age_rec = "12 to 17, oth. states" if age == "12 to 17" & rm_in_post == 0
replace age_rec = "18 to 25, oth. states" if age == "18 to 25" & rm_in_post == 0	
compress

export delimited using "temp/data-for-cleveland-plot-placebo.csv", replace
