///////////////////////////////////////////////////////////////////////////////
// Create Marijuana Use in Past Year By Age (Table 1)

// Clear memory
clear all

// Open cleaned dataset
use "data_for_analysis/nsduh_1999_2016_state_comparison_data.dta"

// Create difference list
local timing = 365
local age_list   18 
local product_list mj 

// Keep only what we need for the 
keep if year =="2005-2006" |  year =="2016-2017"
keep  st_abbrv year mj_use_365_18 ave_pop rm

// Create a population in 2006 variable
bysort st_abbrv: egen population_2006 = mean(ave_pop) if year =="2005-2006"
bysort st_abbrv: egen population = mean(population_2006) 

// Make sure the data is sorted correctly
gen time = 0
replace time =1 if year=="2016-2017"

sort st_abbrv time

bysort st_abbrv: gen diff_mj_use_365_18 =   mj_use_365_18[_n] - mj_use_365_18[_n-1]
bysort st_abbrv: gen per_diff_mj_use_365_18 =   (diff_mj_use_365_18/mj_use_365_18[_n-1])*100

// Drop the variables and observations we won't need for the figure
drop if time==0
drop time mj_use_365_18  year population_2006 ave_pop

/////////////////////////////////////////////////////////////////////////////////
// Plot the differences in percent change


// Create correct averages for US w/o mj states and just mj states
set obs `=_N+1'
sum per_diff_mj_use_365_18 [aw =population]  if rm==0
local us_non_recreational = `r(mean)'
replace per_diff_mj_use_365_18 = `us_non_recreational' in 52
replace st_abbrv = "US mean without recreational marijuana states" in 52
replace rm=0 in 52

set obs `=_N+1'
sum per_diff_mj_use_365_18 [aw =population]  if rm==1
local us_recreational = `r(mean)'
replace per_diff_mj_use_365_18 = `us_recreational' in 53
replace st_abbrv = "Mean recreational marijuana state" in 53
replace rm=1 in 53

// Sort by the difference
gsort -per_diff_mj_use_365_18

// Create a rank based upon this difference
capture drop rank
capture drop fake_diff
gen rank = _n

// add a space so it's clear
*replace rank = rank + 1 if recreational_marijuana==0
replace rank = -2*rank
gen fake_diff=0



twoway ///
	scatter rank per_diff_mj_use_365_18 if rm==0 , mlabel(st_abbrv) mlabpos(3) mlabsize(2.25) msymbol(Oh) ///
	|| scatter rank per_diff_mj_use_365_18 if rm==1, mlabel(st_abbrv) mlabpos(3) mlabsize(2.25) msymbol(D) mcolor(turquoise) ///
	ylabel(, nolabels tlength(0) notick nogrid)		ytitle("")	 ///
	legend(pos(6) cols(2) label(1 "No Change in Recreational Marijuana Law") label(2 "Change in Recreational Marijuana Law") size(2.25)) ///
	ysc(off) ///
	xtitle("Percent change in past 365 day marijuana use for those aged 18 and up from 2005/2006 to 2016/2017", size(2.5)) ///
	xlabel(0(20)120,  tlength(0) notick labsize(2.25))	///
	xline(`us_non_recreational') xline(`us_recreational') ///
	ysize(5) 

graph export "output/plots/per_diff_mj_use_365_18.pdf", replace
