//////////////////////////////////////////////////////////////////////////////
// Part A - Recreational Marijuana Combined

use "data_for_analysis/rml_panel_data.dta", clear

// List controls 
global list_of_controls ave_median_income ave_unemp_rate ave_male ave_white

//////////////////////////////////////////////////////////////////////////////
// Make a combined coef plot of our main results

capture drop x
capture drop high
capture drop low
capture drop order
capture drop shape

gen order = _n

gen x = .
gen high = . 
gen low = .
gen shape = ""
gen shade =.

local row = 1

// Last 12 to 17
local y_list ///
	mj_use_365 ///
	mj_use_30 ///
	mj_first_use

foreach y in `y_list' {
//Run Estimation - Base
		reghdfe ln_`y'  i.mm i.rm i.disp if age_category == 4,  absorb(StateFIPS year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 1 in `row'

	local row = `row'+1
	
	//Run Estimation - Add Controls
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 4,  absorb(StateFIPS year_group_id ) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 2 in `row'

	local row = `row'+1
		
	//Run Estimation - Add Region by Year FE
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 4,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 3 in `row'

	local row = `row'+2
}
	local row = `row'+3

// Last 18 to 25
local y_list ///
	mj_use_365 ///
	mj_use_30 ///
	mj_first_use

foreach y in `y_list' {
//Run Estimation - Base
		reghdfe ln_`y'  i.mm i.rm i.disp if age_category == 5,  absorb(StateFIPS year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 1 in `row'

	local row = `row'+1
	
	//Run Estimation - Add Controls
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 5,  absorb(StateFIPS year_group_id ) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 2 in `row'

	local row = `row'+1
		
	//Run Estimation - Add Region by Year FE
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 5,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 3 in `row'

	local row = `row'+2
}
	local row = `row'+3

// Last 12 and up
local y_list ///
	mj_use_365 ///
	mj_use_30 ///
	mj_first_use

foreach y in `y_list' {
//Run Estimation - Base
		reghdfe ln_`y'  i.mm i.rm i.disp if age_category == 6,  absorb(StateFIPS year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 1 in `row'

	local row = `row'+1
	
	//Run Estimation - Add Controls
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 6,  absorb(StateFIPS year_group_id ) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 2 in `row'

	local row = `row'+1
		
	//Run Estimation - Add Region by Year FE
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 6,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 3 in `row'

	local row = `row'+2
}
	local row = `row'+3
	
// Last 18 and up
local y_list ///
	mj_use_365 ///
	mj_use_30 ///
	mj_first_use

foreach y in `y_list' {
//Run Estimation - Base
		reghdfe ln_`y'  i.mm i.rm i.disp if age_category == 1,  absorb(StateFIPS year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 1 in `row'

	local row = `row'+1
	
	//Run Estimation - Add Controls
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 1,  absorb(StateFIPS year_group_id ) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 2 in `row'

	local row = `row'+1
		
	//Run Estimation - Add Region by Year FE
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 1,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 3 in `row'

	local row = `row'+2
}
	local row = `row'+3

// Last 26 and up
local y_list ///
	mj_use_365 ///
	mj_use_30 ///
	mj_first_use

foreach y in `y_list' {
	//Run Estimation - Base
		reghdfe ln_`y'  i.mm i.rm i.disp if age_category == 3,  absorb(StateFIPS year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 1 in `row'

	local row = `row'+1
	
	//Run Estimation - Add Controls
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 3,  absorb(StateFIPS year_group_id ) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 2 in `row'

	local row = `row'+1
		
	//Run Estimation - Add Region by Year FE
		reghdfe ln_`y'  i.mm i.rm i.disp $list_of_controls if age_category == 3,  absorb(StateFIPS year_group_id i.region#i.year_group_id) vce(cluster StateFIPS)
	//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)


		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		replace x    = b in `row'
		replace high = b+ 1.96*se_v2  in `row'
		replace lo = b - 1.96*se_v2  in `row'
		replace shape = "`y'" in `row'
		replace shade = 3 in `row'

	local row = `row'+2
	
}
	local row = `row'+3

replace shape = "1" if shape =="mj_use_365"
replace shape = "2" if shape =="mj_use_30"
replace shape = "3" if shape =="mj_first_use"
destring shape, replace

twoway ///
	|| scatter   x order if x!=0 & order<72 & shape==1 & shade == 3, msymbol(O) mcolor(black) msize(2.5) ///
	|| rcap   low high order if x!=0 & order<72 & shape==1 & shade == 3,  lcolor(black)  msize(1.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==2 & shade == 3, msymbol(S) mcolor(black) msize(2.5) ///
	|| rcap   low high order if x!=0 & order<72 & shape==2 & shade == 3,  lcolor(black) msize(1.5)  ///
	|| scatter   x order if x!=0 & order<72 & shape==3 & shade == 3, msymbol(D) mcolor(black) msize(2.5) ///
	|| rcap   low high order if x!=0 & order<72 & shape==3 & shade == 3,  lcolor(black) msize(1.5)  ///	
	|| rcap   low high order if x!=0 & order<72 & shape==2 & shade == 2,  lcolor(black) msize(1.5)  ///
	|| rcap   low high order if x!=0 & order<72 & shape==3 & shade == 2,  lcolor(black) msize(1.5)  ///
	|| rcap   low high order if x!=0 & order<72 & shape==1 & shade == 2,  lcolor(black)  msize(1.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==1 & shade == 2, msymbol(O) mcolor(white) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==1 & shade == 2, msymbol(O) mcolor(black%50) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==2 & shade == 2, msymbol(S) mcolor(white) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==2 & shade == 2, msymbol(S) mcolor(black%50) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==3 & shade == 2, msymbol(D) mcolor(white) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==3 & shade == 2, msymbol(D) mcolor(black%50) msize(2.5) ///		
	|| rcap   low high order if x!=0 & order<72 & shape==2 & shade == 1,  lcolor(black) msize(1.5)  ///
	|| rcap   low high order if x!=0 & order<72 & shape==3 & shade == 1,  lcolor(black) msize(1.5)  ///
	|| rcap   low high order if x!=0 & order<72 & shape==1 & shade == 1,  lcolor(black)  msize(1.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==1 & shade == 1, msymbol(O) mcolor(black) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==1 & shade == 1, msymbol(O) mcolor(white) msize(1.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==2 & shade == 1, msymbol(S) mcolor(black) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==2 & shade == 1, msymbol(S) mcolor(white) msize(1.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==3 & shade == 1, msymbol(D) mcolor(black) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==3 & shade == 1, msymbol(D) mcolor(white) msize(1.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==1 & shade == 0, msymbol(Oh) mcolor(black) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==1 & shade == 0, msymbol(Sh) mcolor(black) msize(2.5) ///
	|| scatter   x order if x!=0 & order<72 & shape==1 & shade == 0, msymbol(Dh) mcolor(black) msize(2.5) ///
	|| scatteri 0 0 0 71, recast(line) lcol(gs10) lp(dash) lwidth(1) /// zero line
	xlabel(1 " " 6 "12 and up" 21 "18 and up" 36 "26 and up" 51 "12 to 17" 66 "18 to 25" 71 " ", nogrid notick labsize(3) axis(off)) ///
	xtitle("") ytitle("Percent Change (DiD Coef.)", size(4)) xscale(lcolor(whighte)) ///
	ylabel(-2.5 " " 0 "0" 10 "10" 20 "20" 30 "30" 40 "40" 50 "50") 	///
	aspect(.3) ///
	xsize(9) ///
	legend( ///
		subtitle("	Marijuana use in past 365 days						Marijuana use in past 30 days			New marijuana initiates				") ///
		size(4) pos(6) cols(3) order(25 26 27 11 13 15 1 3 5 ) ///
		label(1 "+ region-by-year fixed-effects") label(3 "+ region-by-year fixed-effects" ) label(5 "+ region-by-year fixed-effects" ) ///
		label(11 "+ control-variables") label(13 "+ control-variables" ) label(15 "+ control-variables" ) ///
		label(25 "Baseline with state and year fixed-effects") label(26 "Baseline" ) label(27 "Baseline" ) ///
		) 
	
	
graph export "output/plots/bw-main_recreational_figure_for_paper_robust_part_a.pdf", replace	
graph export "output/plots/bw-main_recreational_figure_for_paper_robust_part_a.png", replace	
