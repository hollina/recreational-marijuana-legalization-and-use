// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta", clear

// Label variable names
label var mj_use_365 "Marijuana use in past 365 days"
label var aud_use_365 "Reported alcohol use disorder in past 365 days"
label var coke_use_365 "Cocaine use in past 365 days"
label var alc_use_30 "Alcohol use in past 30 days"
label var cig_use_30 "Cigarette use in past 365 days"
label var mj_use_30 "Marijuana use in past 30 days"
label var tob_use_30 "Tobacco use in past 30 days"
label var mj_first_use "Marijuana first use in past 365 days"
label var mj_use_ratio "Marijuana use ratio"

// Label and transform variables
label var 	ave_median_income "Median income, \\$10k"
replace ave_median_income = ave_median_income/10000

label var 	ave_unemp_rate "Unemployment rate, [0-100]" 

label var 	ave_pop "Population, 100k" 
replace ave_pop  = ave_pop/100000

label var 	ave_male "\% Male, [0-100]" 
replace ave_male = ave_male*100

label var 	ave_white "\% White, [0-100]" 
replace ave_white = ave_white*100

label var 	ave_black "\% Black, [0-100]" 
replace ave_black = ave_black*100

label var 	hispanic "\% Hispanic, [0-100]" 
replace hispanic = hispanic*100


label var 	age15_24 "\% 15-24, [0-100]" 
replace age15_24 = age15_24*100

label var 	age25_44 "\% 25-44, [0-100]" 
replace age25_44 = age25_44*100

label var 	age0_14 "\% 0-14, [0-100]" 
replace age0_14 = age0_14*100

label var 	age45_64 "\% 45-64, [0-100]" 
replace age45_64 = age45_64*100


label var 	age65up "\% 65+, [0-100]" 
replace age65up = age65up*100

label var 	ave_othrace "\% Other race, [0-100]" 
replace ave_othrace = ave_othrace*100


label var 	property_crime_rate "Property crimes per 100k"  
replace property_crime_rate = property_crime_rate/10


label var 	violent_crime_rate "Violent crimes per 100k" 
replace violent_crime_rate = violent_crime_rate/10


       

label var rm "Recreational marijuana legal"
label var mm "Medical marijuana legal"
label var disp "Medical marijuana dispensaries open"
label var rm_disp "Recreational marijuana dispensaries open"

// Summarize variable	

estpost summarize ///
	rm rm_disp mm disp ///
	ave_median_income ave_unemp_rate ///
	ave_pop ave_male ave_white ave_black hispanic ///
	age0_14 age15_24 age25_44 age45_64 age65up  ///
	violent_crime_rate property_crime_rate ///
	if age_category==1

esttab using "output/tables/summary_statistics_other_variables.tex", replace ///
cells("mean(fmt(%20.2f) label(\multicolumn{1}{c}{Mean} )) sd(fmt(%20.2f) label(\multicolumn{1}{c}{S.D.}) ) min(fmt(%20.2f) label(\multicolumn{1}{c}{Min.}) ) max(fmt(%20.2f) label(\multicolumn{1}{c}{Max.})) count(fmt(%3.0f) label(\multicolumn{1}{c}{N}))  ") ///
nomtitle nonum label f alignment(S S) booktabs nomtitles b(%20.2f) se(%20.2f) eqlabels(none) eform  ///
 noobs substitute(\_ _)

