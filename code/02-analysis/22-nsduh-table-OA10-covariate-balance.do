***** Clear memory *****
clear all

set more off

// Open cleaned dataset
use "data_for_analysis/rml_panel_data.dta"


// List controls 
global list_of_controls ave_median_income ave_unemp_rate ave_male ave_white

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


label var 	age0_14 "\% 0-14, [0-100]" 
replace age0_14 = age0_14*100


label var 	age15_24 "\% 15-24, [0-100]" 
replace age15_24 = age15_24*100



label var 	age25_44 "\% 25-44, [0-100]" 
replace age25_44 = age25_44*100



label var 	age45_64 "\% 45-64, [0-100]" 
replace age45_64 = age45_64*100



label var 	age65up "\% 65+, [0-100]" 
replace age65up = age65up*100

replace violent_crime_rate  = violent_crime_rate/1000
replace property_crime_rate  = property_crime_rate/1000

label var violent_crime_rate "Violent crime rate per 100"
label var property_crime_rate "Property crime rate per 100"


label var rm "Recreational marijuana law"
label var mm "Medical marijuana law"
label var disp "Medical marijuana dispensaries in state"

////////////////////////////////////////////////////////////////////////////////
// Run a simple regression

global covariates= "ave_pop ave_black hispanic age0_14 age15_24 age25_44 age45_64 age65up violent_crime_rate property_crime_rate"


*store the number of covariates
global length_of_cov: list sizeof global(covariates)
*Get the standard deviations
mean $covariates
estat sd
matrix csd = r(sd)'
eststo csd 
mat list csd

*Now get regression adjusted mean differences

*Make a place to store the coefficients
matrix define meanDiff_betas = J($length_of_cov, 1, .)
matrix define meanDiff_betas_se = J($length_of_cov, 1, .)
matrix define meanDiff_betas_p = J($length_of_cov, 1, .)

local count = 0
foreach y of global covariates {
	local count = `count' + 1
	
	reghdfe `y' i.rm,  absorb(StateFIPS year_group_id  i.region#i.year_group_id) vce(cluster StateFIPS)	
	
	nlcom (exp(_b[1.rm])-1)
	mat b = r(b)
	mat V = r(V)

	scalar b = b[1,1]
	matrix meanDiff_betas[`count',1] = b 
	scalar se_v2 = sqrt(V[1,1])
	matrix meanDiff_betas_se[`count',1] = se_v2

	scalar p_val = 2*ttail(`e(df_r)',abs(b/se_v2))
	matrix meanDiff_betas_p[`count',1] = p_val

	// Round Estimates to Whatever place we need
	scalar rm_rounded_estimate = round(b,.01)
	local rm_rounded_estimate : di %3.2f rm_rounded_estimate
	scalar rm_string_estimate = "`rm_rounded_estimate'"

	// Round Standard Errors
	scalar rm_rounded_se = round(se_v2,.01)
	local rm_rounded_se : di %3.2f rm_rounded_se
	scalar rm_string_se = "("+"`rm_rounded_se'"+")"

	//Add Stars for Significance 
	if p_val <= .01	{
		scalar rm_string_estimate = rm_string_estimate + "\nlsym{3}"
	}	

	if p_val>.01 & p_val<=.05 {
		scalar rm_string_estimate = rm_string_estimate + "\nlsym{2}"
	}

	if  p_val>.05 & p_val<=.1 {
		scalar rm_string_estimate = rm_string_estimate + "\nlsym{1}"
	}
	
	else {
		scalar rm_string_estimate = rm_string_estimate 
	}			
			
	// Add the results
	estadd local rm_b_str =rm_string_estimate
	estadd local rm_se_str =rm_string_se	
	
	est sto m1_`y'


}

*Check to see if it worked
matrix list meanDiff_betas
matrix list meanDiff_betas_se
matrix list meanDiff_betas_p


local count = 0
foreach y of global covariates {
	local count = `count' + 1
	
	reghdfe `y' i.rm,  absorb(StateFIPS year_group_id  i.region#i.year_group_id) vce(cluster StateFIPS)	
	
	
	*calculate the cohen's d diff.
	scalar cohen_d = meanDiff_betas[`count',1] / csd[`count',1]
	scalar cohen_d_rounded_estimate = round(cohen_d,.01)
	local cohen_d_rounded_estimate : di %3.2f cohen_d_rounded_estimate
	scalar cohen_d_string_estimate = "`cohen_d_rounded_estimate'"
	estadd local rm_b_str =cohen_d_string_estimate

	est sto m2_`y'

}

*Check to see if it worked
matrix list meanDiff_betas
matrix list meanDiff_betas_se
matrix list meanDiff_betas_p

*Compute Cohen's D and store it in a matrix
matrix cohensD = J($length_of_cov, 1, .)
forvalues j = 1(1)$length_of_cov{
	matrix cohensD[`j', 1] = meanDiff_betas[`j',1] / csd[`j',1]
}
matrix list cohensD

*store the cohen's D as a model


matrix d = cohensD'
matrix colnames d = $covariates
ereturn post d
eststo d

*store the coeffients as a model
matrix beta = meanDiff_betas'
matrix colnames beta = $covariates
ereturn post beta
eststo beta

*store the se as a model
matrix se = meanDiff_betas_se'
matrix colnames se = $covariates
ereturn post se
eststo se

*store the p_val as a model
matrix p_val = meanDiff_betas_p'
matrix colnames p_val = $covariates
ereturn post p_val
eststo p_val


local y ave_pop 
local lbl: var label `y'
esttab m1_`y' m2_`y' using "output/tables/covariance_balance_test.tex" ///
		,star(* 0.10 ** 0.05 *** .01)  ///
		se ///
		b(%9.2f) ///
		booktabs ///
		f ///
		replace  ///
		mtitles("Mean difference" "Standardized Difference") ///
		label ///
		drop(*) ///
		stats(rm_b_str rm_se_str ///
			, fmt(0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("`lbl'" "~")) 

		local y_list  ave_black hispanic age0_14 age15_24 age25_44 age45_64 age65up violent_crime_rate property_crime_rate
foreach y in `y_list' {

*local y ave_unemp_rate 
local lbl: var label `y'
esttab m1_`y' m2_`y' using "output/tables/covariance_balance_test.tex" ///
		,star(* 0.10 ** 0.05 *** .01)  ///
		se ///
		b(%9.2f) ///
		booktabs ///
		f ///
		append  ///
		nomtitles ///
		noline ///
		nonumbers ///
		label ///
		drop(*) ///
		stats(rm_b_str rm_se_str ///
			, fmt(0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
		label("`lbl'" "~")) 
}
