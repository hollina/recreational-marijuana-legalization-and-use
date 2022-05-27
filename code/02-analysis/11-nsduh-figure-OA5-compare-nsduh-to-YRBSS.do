////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////    RECREATIONAL LAWS AND DRUG USE    //////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION:
// This file creates the dataset to compare NSDUH and YRBSS data
// Created by: Ashley Bradford
// Email: asbrad@iu.edu
// Last Edited:  12/07/20
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

clear all
capture log close
set more off
set matsize 10000
set maxvar 10000

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////    YRBS   ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Reading in YRBS
infix int year 114-121 ///
	int weight 125-134 ///
	int psu 143-150 ///
	int stratum 135-142 ///
	int sex 162-164 /// 
	int race7   171-173 ///
	int age 159-161 ///
	str q45 283-283 ///
	str q47 285-285 ///
using  "raw_data/yrbss/sadc_2019_national.dat", clear 

svyset psu [pweight=weight], strata(stratum) vce(linearized) singleunit(centered) 

destring q45, replace
destring q47, replace 

// Dropping missing values 
drop if missing(q45)
drop if missing(q47)
drop if missing(age)

// Getting rid of the 12 and below kids and the 18 and above kids 
drop if age == 1 | age == 7 
	replace age = 13 if age == 2
	replace age = 14 if age == 3
	replace age = 15 if age == 4
	replace age = 16 if age == 5 
	replace age = 17 if age == 6
	
rename age age_yrbs	

// Generating race indicators
gen native_yrbs=(race7 == 1)
gen asian_yrbs=(race7 == 2)
gen black_yrbs=(race7 == 3)
gen hispanic_yrbs=(race7 == 4)
gen pac_islander_yrbs=(race7 == 5)
gen white_yrbs=(race7 == 6)
gen other_yrbs=(race7 == 7)

// Generating sex indicator
gen female_yrbs=(sex == 1)

// Restricting to study time frame
drop if year < 2002 | year > 2017

// Generating measures to match with NSDUH
gen marijuana_ever_yrbs = (q45 > 1)
gen marijuana_30_yrbs = (q47 > 1)

svy: mean marijuana_30 

collapse (mean) marijuana_30 marijuana_ever age native asian black ///
	hispanic pac_islander white other female [pweight=weight], by(year)

foreach var in marijuana_30 marijuana_ever native asian black ///
	hispanic pac_islander white other female {
		
		replace `var' = `var' * 100 
		
}
compress
save "temp/yrbs_yearly.dta", replace


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////    NSDUH   //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "raw_data/nsduh/NSDUH_2002_2018.DTA", clear

rename *, lower

keep year mjever mjrec eduschlgo age2 catage newrace2 ///
	irsex vestr analwc* grskmrjmon grskmrjwk

// Cleaing up missing values
replace eduschlgo = . if (eduschlgo <= -1 | eduschlgo >= 85 )
replace mjever = . if (mjever>80 )
	drop if missing(mjever)


// Fixing age
destring age, replace

keep if age == 2 | age == 3 | age == 4 | age == 5 | age == 6
	rename age2 age_nsduh

replace age_nsduh = 13 if age_nsduh == 2 
replace age_nsduh = 14 if age_nsduh == 3
replace age_nsduh = 15 if age_nsduh == 4
replace age_nsduh = 16 if age_nsduh == 5
replace age_nsduh = 17 if age_nsduh == 6

// Generating race categories 
gen white_nsduh=(newrace2 == 1)
gen black_nsduh=(newrace2 == 2)
gen native_nsduh=(newrace2 == 3)
gen pac_islander_nsduh=(newrace2 == 4)
gen asian_nsduh=(newrace2 == 5)
gen other_nsduh=(newrace2 == 6)
gen hispanic_nsduh=(newrace2 == 7)

// Generating sex category
gen female_nsduh=(irsex == 2)

// Generating school category
gen in_school_nsduh=(eduschlgo==1)

// Marijuana use 
gen marijuana_ever_nsduh=(mjever==1)
gen marijuana_30_nsduh=(mjrec==1)

// Marijuana risk 
*drop if grskmrjmon == -9
*drop if grskmrjwk == -9

collapse (mean) marijuana_30 marijuana_ever age native asian black ///
	hispanic pac_islander white other female eduschlgo [pweight=analwc15], by(year)

destring year, replace

foreach var in marijuana_30 marijuana_ever native asian black ///
	hispanic pac_islander white other female {
		
		replace `var' = `var' * 100 
		
}

compress
merge 1:1 year using "temp/yrbs_yearly.dta", keep(3) nogen
save "temp/combined_yearly.dta", replace

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////    MJ DATA   /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// MJ data
use  "data_for_analysis/intermediate/medical_marijuana_status_single_year.dta", clear
	
	
collapse (sum) mm rm rm_disp disp, by(year)
keep if year >=2003 & year <=2017

save "temp/mj_data.dta", replace


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////    SEER    //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
clear  
use data_for_analysis/intermediate/population_by_year.dta

// Merging on MJ law data to get pop shares
merge m:1 StateFIPS year using "data_for_analysis/intermediate/medical_marijuana_status_single_year.dta", keep(3) nogen

keep year StateFIPS pop rm mm	
		
gen rec_pop = rm * pop
gen non_rec_pop = (1 - rm) * pop

// Collapsing to yearly level 
collapse (sum) rec_pop non_rec_pop, by(year)

gen rec_pop_share = rec_pop / (rec_pop + non_rec_pop)

// Merging on remaining data
merge 1:1 year using "temp/mj_data.dta", keep(3) nogen 
merge 1:1 year using "temp/combined_yearly.dta", keep(3) nogen 

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////    GRAPHS   /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
gen difference_30 = marijuana_30_yrbs - marijuana_30_nsduh
gen difference_ever = marijuana_ever_yrbs - marijuana_ever_nsduh

gen difference_30_p = ( (marijuana_30_yrbs - marijuana_30_nsduh) / marijuana_30_nsduh ) * 100
gen difference_ever_p = ( (marijuana_ever_yrbs - marijuana_ever_nsduh) / marijuana_ever_nsduh ) * 100

replace rec_pop_share = rec_pop_share*100

*lab var medmj "Recreational Law in Effect"
lab var year "Year"
lab var rec_pop_share "Share of Adolescents in Recreational States"

// Main Graph (30 days) by pop 
graph twoway /// 
	(connected difference_30 year, sort msymbol(o) mcolor(vermillion) ///
		lcolor(vermillion) mcolor(vermillion) lwidth(1.5))  ///
	(connected rec_pop_share year, sort msymbol(none) mcolor(turquoise) ///
		 lpattern("_") lcolor(turquoise) lwidth(1)), ///
	graphregion(color(white)) ///
	subtitle(Past month used, size(8)) ///
	ylabel(0(5)20, labsize(6)) xlabel(2003(2)2017, labsize(6)) legend(off)  xtitle("") ///
	text(3 2007 "Percent of 13-17 year olds" "living in states with RM laws" ///
		16 2011 "Difference in self-reported" "MJ use in YRBS vs NSDUH", size(6))

	graph export "output/plots/marijuana_30_pop.png", replace
	graph export "output/plots/marijuana_30_pop.pdf", replace
	
// Main Graph (ever) by pop 
graph twoway /// 
	(connected difference_ever year, sort msymbol(o) mcolor(vermillion) ///
		lcolor(vermillion) mcolor(vermillion)  lwidth(1.5))  ///
	(connected rec_pop_share year, sort msymbol(none) mcolor(turquoise) ///
		 lpattern("_") lcolor(turquoise) lwidth(1)), ///
	graphregion(color(white)) ///
	subtitle(Ever used, size(8)) ///
	ylabel(0(5)20, labsize(6)) xlabel(2003(2)2017, labsize(6)) legend(off)  xtitle("") ///
	text(3 2007 "Percent of 13-17 year olds" "living in states with RM laws" ///
		12 2009 "Difference in self-reported" "MJ use in YRBS vs NSDUH", size(6))
	
	graph export "output/plots/marijuana_ever_pop.png", replace
	graph export "output/plots/marijuana_ever_pop.pdf", replace
	
	
// Clean up
erase "temp/yrbs_yearly.dta"
erase "temp/mj_data.dta"
erase "temp/combined_yearly.dta"
