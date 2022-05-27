// Clear memory
clear all

// Open cleaned dataset
use data_for_analysis/nsduh_1999_2016_state_comparison_data.dta

//////////////////////////////////////////////////////////////////////////////
drop if missing(state)
// Organize
sort state year


// Reshape long
gen str2 str_fips = string(StateFIPS, "%02.0f")
*gen str4 str_year = string(year, "%4.0f")
gen id_for_reshape  = str_fips+year


// Create local macro 
reshape long ///
	mj_use_365_@ ///
	aud_use_365_@ ///
	coke_use_365_@ ///
	mj_use_30_@ ///
	tob_use_30_@ ///
	cig_use_30_@ ///
	alc_use_30_@ ///
	mj_first_use_@ ///
	mj_use_ratio_@ ///
	, i(id_for_reshape) j(age_category) string 
	
// Drop what we don't need
drop id_for_reshape str_fips 

label define label_age_category 4 "12 to 17"  6 "12 to 20" 7 "18 to 25" ///
	 1 "12 and up"  2 "18 and up"  3 "26 and up"

replace age_category = "12 and up" if age_category=="12"
replace age_category = "18 and up" if age_category=="18"
replace age_category = "26 and up" if age_category=="26"
replace age_category = "12 to 17" if age_category=="12_17"
replace age_category = "12 to 20" if age_category=="12_20"
replace age_category = "18 to 25" if age_category=="18_25"

encode age_category, gen(label_age_category)
drop age_category
rename label_age_category age_category

// Clean up names
rename *_ *

// Label variable names
label var mj_use_365 "Marijuana use in past 365 days"
label var aud_use_365 "Reported alcohol use disorder in past 365 days"
label var coke_use_365 "Cocaine use in past 365 days"
label var alc_use_30 "Alcohol use in past 30 days"
label var cig_use_30 "Cigarette use in past 365 days"
label var mj_use_30 "Marijuana use in past 30 days"
label var tob_use_30 "Tobacco use in past 30 days"
label var mj_first_use "Marijuana first use in past two-years"
label var mj_use_ratio "Marijuana use ratio"

 // Summarize variable		
	
// Add the multicolumn prefix for latex	
label define label_age_category 4 "\multicolumn{1}{c}{12 to 17}"  6 "\multicolumn{1}{c}{12 to 20}" 7 "\multicolumn{1}{c}{18 to 25}" ///
	 1 "\multicolumn{1}{c}{12 and up}"  2 "\multicolumn{1}{c}{18 and up}"  3 "\multicolumn{1}{c}{26 and up}", replace
	 
estpost tabstat mj_use_365 mj_use_30 mj_first_use alc_use_30 tob_use_30 coke_use_365 ///
	, statistics(mean sd)   columns(statistics) listwise by(age_category) nototal missing casewise
	

esttab using "output/tables/summary_statistics.tex", ///
	noobs main(mean) aux(sd) nomtitle nonumber  unstack label ///
	nostar nonote ///
	b(%9.2f) ///	
	replace f

