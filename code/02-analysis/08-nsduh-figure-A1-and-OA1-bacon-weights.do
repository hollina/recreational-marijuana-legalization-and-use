// Loop over each substance
local y_list mj_use_365 mj_use_30 alc_use_30 tob_use_30 coke_use_365 mj_first_use 
foreach y in `y_list' {

	// Loop over each age group
	local age_order_list  4 5 6 1 3
	foreach age_group in `age_order_list' {

	*local age_group  1
	*local y  mj_use_30
		///////////////////////////////////////////////////////////////////////////////
		// Part 1. Set-up
			if "`age_group'"=="1" {
				local age_label "12 to 17"
			}
			if "`age_group'"=="3" {
				local age_label "18 to 25"
			}
			
			if "`age_group'"=="4" {
				local age_label "12 and up"
			}
			
			if "`age_group'"=="5" {
				local age_label "18 and up"
			}
			
			if "`age_group'"=="6" {
				local age_label "26 and up"
			}
			
			if "`y'" == "mj_use_365" {
				local label "marijuana use in the past 365 days"
				local sym "O"
				local sym_size 3
				local sym_color "vermillion"
			}
			
			
			if "`y'" == "mj_use_30" {
				local label "marijuana use in the past 30 days"
				local sym "S"
				local sym_size 3
				local sym_color "sea"
			}
			
			
			if "`y'" == "mj_first_use" {
				local sym "D"
				local sym_size 3
				local sym_color "turquoise"
				local label "new marijuana initiates"

			}
			
			
			if "`y'" == "alc_use_30" {
				local label "alcohol use in the past 30 days"
				local sym "T"
				local sym_size 3
				local sym_color "black"	
			}
			
			
			if "`y'" == "tob_use_30" {
				local label "tobacco use in the past 30 days"
					local sym "X"
				local sym_size 3
				local sym_color "reddish"
			}
			
			
			if "`y'" == "coke_use_365" {
				local label "cocaine use in the past 365 days"
				local sym "Oh"
				local sym_size 3
				local sym_color "black"
			}
			
			if "`y'" == "mj_use_ratio" {
				local label "marijuana use intensity (this is a weird variable)"
			}
			
		********************************************************************************
		//Part 1.1: Determine Adoption Year and Timing Group
		********************************************************************************		
		
		********************************************************************************
		// Open cleaned dataset
		use "data_for_analysis/rml_panel_data.dta", clear
		********************************************************************************
		// Create numeric year
		capture drop year_numeric
		gen year_numeric = year_group_id+2002

		// Limit to a single age category since we are just 
		keep if age_category==`age_group'

		// Sort the dataset
		sort  StateFIPS year_numeric 

		********************************************************************************
		*Make an adoption year variable.
		gen rmyear = year_numeric if rm==1
		replace rmyear = 9999 if rm==0

		egen rm_adopt_year = min(rmyear), by(StateFIPS)
		replace rm_adopt_year = 0 if rm_adopt_year==9999
		drop rmyear

		gen rm_disp_year = year_numeric if rm_disp==1
		replace rm_disp_year = 9999 if rm_disp==0

		egen rm_disp_adopt_year = min(rm_disp_year), by(StateFIPS)
		replace rm_disp_adopt_year = 0 if rm_disp_adopt_year==9999
		drop rm_disp_year

		*Make dummies for each timing group. (Timing group 0 is the untreted group.)
		tab rm_adopt_year, gen(timeGroup_)
		rename 	(timeGroup_1 timeGroup_2 timeGroup_3 timeGroup_4 ) ///
				(timeGroup_0 timeGroup_1 timeGroup_2 timeGroup_3 )

		********************************************************************************
		//Part 1.2: Make a matrix that names all of the pairwise DIDs
		********************************************************************************
		//Make a matrix to store the names of the pairwise DIDs.
		matrix names = J(9,3,.)
		matrix colnames names = k l tg

		//Outer Loop over the timing groups.
		local rowcount = 0
		forvalues k = 1(1)3 {
			local rowcount = `rowcount'+1

			//timing group vs never treated pairs
			quietly sum rm_adopt_year if timeGroup_`k' == 1
			scalar k_adopt_year = r(mean)
			matrix names[`rowcount',1] = k_adopt_year
			matrix names[`rowcount',2] = 0
			matrix names[`rowcount',3] = k_adopt_year
				
			*Inner Loop over timing groups that are later than k.
			local start = `k' + 1
			forvalues l = `start'(1)3 {
			
				*Early vs Late
				local rowcount = `rowcount' + 1
				matrix names[`rowcount',1] = k_adopt_year
				quietly sum rm_adopt_year if timeGroup_`l' == 1
				scalar l_adopt_year = r(mean)
				matrix names[`rowcount',2] = l_adopt_year
				matrix names[`rowcount',3] = k_adopt_year
			
				*Late vs Early
				local rowcount = `rowcount'+1
				matrix names[`rowcount',1] = k_adopt_year
				matrix names[`rowcount',2] = l_adopt_year
				matrix names[`rowcount',3] = l_adopt_year
			}
		}
				
				
		********************************************************************************
		//Part 1.3: Compute the Goodman-Bacon weights for the simplest twoway fe model.
		//Note: these weights are identical for any outcome that you choose.
		********************************************************************************

		// Make a place to store the weights
		matrix rw = J(9,1,.)
		matrix w = J(9,1,.)

		//Outer Loop over the timing groups.
		local rowcount = 0
		forvalues k = 1(1)3 {
			local rowcount = `rowcount'+1

			//timing group vs never treated pairs
			//sample shares
			quietly sum timeGroup_`k'
			scalar kshare = r(mean)
			quietly sum timeGroup_0
			scalar lshare = r(mean)
			scalar pairshare = kshare / (kshare + lshare)
			
			*time shares
			quietly sum rm if timeGroup_`k' == 1
			scalar ktimeshare = r(mean)
			scalar ltimeshare = 0

			*Unnormalized weights
			scalar v = pairshare * (1 - pairshare) * ktimeshare * (1 - ktimeshare)
			matrix rw[`rowcount',1] = v * (kshare + lshare)^2 
			
			*Inner Loop over timing groups that are later than k
			local start = `k' + 1
			forvalues l = `start'(1)3 {
			
				*Sample Shares
				quietly su timeGroup_`l'
				scalar lshare = r(mean)
				scalar pairshare = kshare / (kshare + lshare)
				
				*Time Shares
				quietly sum rm if timeGroup_`l' == 1
				scalar ltimeshare = r(mean)
				
				*Early vs Late
				*Unnormalized weight
				local rowcount = `rowcount' + 1
				scalar v = pairshare * (1-pairshare) * ((ktimeshare - ltimeshare) / (1-ltimeshare)) * ((1-ktimeshare)/(1-ltimeshare))
				matrix rw[`rowcount',1] = v * ((kshare + lshare)*(1-ltimeshare))^2
				
				*Late vs Early
				*Compute unnormalized weight
				local rowcount = `rowcount' + 1
				scalar v = pairshare * (1-pairshare) * (ltimeshare/ktimeshare) * ((ktimeshare - ltimeshare)/ktimeshare)
				matrix rw[`rowcount',1] = v * ((kshare + lshare)*ktimeshare)^2
				}
		}

		*sum up the unnormalized weights.
		matrix define one = J(9,1,1)
		matrix tot_rw = one' * rw
		scalar sum_rw = tot_rw[1,1]
		matrix list rw

		*Make the final vector of weights
		matrix w = rw * (1/sum_rw)
		matrix list w
	
		////////////////////////////////////////////////////////////////////////////
		//Part 2: Compute the many pairwise DIDs for a chosen outcome.
		// 			Cycle over this with multiple dependent variables.
		////////////////////////////////////////////////////////////////////////////

		//Make a matrix to store the names of the pairwise DIDs.
		matrix dd = J(9,1,.)
		//Outer Loop over the timing groups.
		local rowcount = 0
		forvalues k = 1(1)3 {
			local rowcount = `rowcount'+1
			
			//timing group vs never treated pairs
			quietly sum rm_adopt_year if timeGroup_`k' == 1
			scalar k_adopt_year = r(mean)
			gen post = year_numeric>=k_adopt_year
			gen treatXpost = timeGroup_`k' * post
				
			gen TU_samp = timeGroup_`k' == 1 | timeGroup_0 == 1
			regress ln_`y' treatXpost post timeGroup_`k' if TU_samp==1
			nlcom 100*(exp(_b[treatXpost])-1)
			mat b = r(b)
			scalar b = b[1,1]
			matrix dd[`rowcount',1] = b
			drop TU_samp treatXpost post

			*Inner Loop over timing groups that are later than k.
			local start = `k' + 1
			forvalues l = `start'(1)3 {
			
				*Early vs Late
				local rowcount = `rowcount'+1
				quietly sum rm_adopt_year if timeGroup_`k' == 1
				scalar k_adopt_year = r(mean)
				gen post = year_numeric>=k_adopt_year
				gen treatXpost = timeGroup_`k' * post
				
				quietly sum rm_adopt_year if timeGroup_`l' == 1
				scalar l_adopt_year = r(mean)
				gen EL_samp = (timeGroup_`k' == 1 | timeGroup_`l' == 1) & year_numeric<l_adopt_year
				
				regress ln_`y' treatXpost post timeGroup_`k' if EL_samp==1
				nlcom 100*(exp(_b[treatXpost])-1)
				mat b = r(b)
				scalar b = b[1,1]
				matrix dd[`rowcount',1] = b
					
				drop EL_samp
				
				*Late vs Early
				local rowcount = `rowcount'+1
				drop post treatXpost
				gen post = year_numeric>=l_adopt_year
				gen treatXpost = timeGroup_`l' * post
				gen LE_samp = (timeGroup_`k' == 1 | timeGroup_`l' == 1) & year_numeric>k_adopt_year
			
				regress ln_`y' treatXpost post timeGroup_`l' if LE_samp==1
				nlcom 100*(exp(_b[treatXpost])-1)
				mat b = r(b)
				scalar b = b[1,1]
				matrix dd[`rowcount',1] = b
				drop LE_samp post treatXpost
				
			}
		}

		////////////////////////////////////////////////////////////////////////////
		//Part 4: Output the weights and the 2x2 DIDs and then make a graph.
		////////////////////////////////////////////////////////////////////////////

		*Names of the pairs.
		svmat names
		rename (names1 names2 names3) (group_k group_l treat_g)

		*Pairwise weights
		svmat w
		rename w1 dd_weight

		*2x2 DIDS
		svmat dd
		rename dd1 dd_2x2

		*Flag the types of 2x2 comparisons
		gen real_control = group_l == 0
		gen late_early = group_l==treat_g
		gen early_late = group_k==treat_g & group_l~=0

		*Compute the twoway fe coefficient
		reghdfe ln_`y' i.rm, absorb(StateFIPS year_numeric) vce(cluster StateFIPS)
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		scalar b = b[1,1]
		
		// Store the treatment effect and a label position for it
		local treatment_effect = b
		local treatment_effect_label_y = b*1.3
		local treatment_effect_label_x = .1 

		/*
		*Draw a graph with different colors for 2x2 comparison types
		graph twoway ///
		(scatter dd_2x2 dd_weight if real_control==1, msize(large) msymbol(o) mcolor(turquoise)) ///
		(scatter dd_2x2 dd_weight if early_late==1, msize(large) msymbol(o) mcolor(sky)) ///
		(scatter dd_2x2 dd_weight if late_early==1, msize(large) msymbol(oh) mcolor(reddish)), ///
		title("DID Decomposition") ytitle("2x2 DID") xtitle("Weight") ///
		legend(off) ///		
		xlabel(0(.1).4, nogrid)  ////
		name(color_types, replace)
		
		graph export "output/plots/temp_coady_bacon_weights_ln_`y'_age_`age_group'.png", replace
		*/
		// Create labels (k is treated. l is comparison group)
		tostring group_k, gen(first_year)
		tostring group_l, gen(second_year)
		
		replace first_year = "Early" if first_year =="2013"
		*replace first_year = "II" if first_year =="2015"
		replace first_year = "Mid" if first_year =="2016"
		replace first_year = "Late" if first_year =="2017"
		
		replace second_year = "Early" if second_year =="2013"
		*replace second_year = "II" if second_year =="2015"
		replace second_year = "Mid" if second_year =="2016"
		replace second_year = "Late" if second_year =="2017"

		replace second_year = "untreated" if second_year=="0"
		
		gen label = first_year + " v. " + second_year
		
		// Graph 
		twoway ///
			|| scatter dd_2x2 dd_weight if dd_2x2<`treatment_effect', msymbol(`sym') msize(5) mcolor(black) mlab(label) mlabpos(3) mlabsize(4) mlabgap(2) ///
			|| scatter dd_2x2 dd_weight if dd_2x2<`treatment_effect', msymbol(`sym') msize(5) mcolor(black) mlab(label) mlabpos(3) mlabsize(4) mlabgap(2) ///
			|| scatter dd_2x2 dd_weight if dd_2x2>`treatment_effect', msymbol(`sym') msize(5) mcolor(black) mlab(label) mlabpos(12) mlabsize(4)  mlabgap(2) ///
			|| scatter dd_2x2 dd_weight, msymbol(O) msize(4)  msymbol(`sym') mcolor(`sym_color') ///
				text(`treatment_effect_label_y' `treatment_effect_label_x'   "DD Est." , color(black) si(large) ) ///
				yline(`treatment_effect', lpattern("_") lcolor(gs7) lwidth(1)) ///
				yline(0, lpattern("-") lcolor(black) lwidth(1)) ///
				xtitle("Weight", size(6)) ///
				ytitle("Percent Change (DiD Coef.)", size(6)) ///
				xla(,nogrid notick labsize(6)) ///
				yla(,nogrid notick labsize(6)) ///
				subtitle("`age_label'" " ", size(8) pos(11)) ///
				legend(off) /// 
				xscale(range(-.02 .4)) ///
				graphregion(margin(r+2))
	
		graph export "output/plots/temp_bacon_weights_ln_`y'_age_`age_group'.png", replace
		graph save "output/plots/temp_bacon_weights_ln_`y'_age_`age_group'.gph", replace
		
		// Graph Age group six for first time differently since it was formatting oddly unless we added ylabels explicity. Not sure why.
		if "`y'" =="mj_first_use" & "`age_group'"=="6" {
			twoway ///
				|| scatter dd_2x2 dd_weight if dd_2x2<`treatment_effect', msymbol(`sym') msize(5) mcolor(black) mlab(label) mlabpos(3) mlabsize(4) mlabgap(2) ///
				|| scatter dd_2x2 dd_weight if dd_2x2>`treatment_effect', msymbol(`sym') msize(5) mcolor(black) mlab(label) mlabpos(12) mlabsize(4) mlabgap(2)  ///
				|| scatter dd_2x2 dd_weight, msymbol(O) msize(4)  msymbol(`sym') mcolor(`sym_color') ///
					text(`treatment_effect_label_y' `treatment_effect_label_x'   "DD Est." , color(black) si(large) ) ///
					yline(`treatment_effect', lpattern("_") lcolor(gs7) lwidth(1)) ///
					yline(0, lpattern("-") lcolor(black) lwidth(1)) ///
					xtitle("Weight", size(6)) ///
					ytitle("Percent Change (DiD Coef.)", size(6)) ///
					xla(,nogrid notick labsize(6)) ///
					yla(-40(20)40,nogrid notick labsize(6)) ///
					subtitle("`age_label'" " ", size(8) pos(11)) ///
					legend(off) ///
					xscale(range(-.02 .4)) ///
					graphregion(margin(r+2))
					
			graph export "output/plots/temp_bacon_weights_ln_`y'_age_`age_group'.png", replace
			graph save "output/plots/temp_bacon_weights_ln_`y'_age_`age_group'.gph", replace
		}
	}
}

// Combine by age group
local y_list mj_use_365 mj_use_30 alc_use_30 tob_use_30 coke_use_365 mj_first_use 

foreach y in `y_list' {
	graph combine ///
		"output/plots/temp_bacon_weights_ln_`y'_age_4" ///
		"output/plots/temp_bacon_weights_ln_`y'_age_5" ///
		"output/plots/temp_bacon_weights_ln_`y'_age_6" ///
		"output/plots/temp_bacon_weights_ln_`y'_age_1" ///
		"output/plots/temp_bacon_weights_ln_`y'_age_3" ///
		, col(1) ysize(20)  xcommon graphregion(margin(r+2))

	graph export "output/plots/bacon_weights_ln_`y'.pdf", replace
	
	
		erase "output/plots/temp_bacon_weights_ln_`y'_age_4.gph" 
		erase "output/plots/temp_bacon_weights_ln_`y'_age_5.gph" 
		erase "output/plots/temp_bacon_weights_ln_`y'_age_6.gph" 
		erase "output/plots/temp_bacon_weights_ln_`y'_age_1.gph" 
		erase "output/plots/temp_bacon_weights_ln_`y'_age_3.gph"
}

