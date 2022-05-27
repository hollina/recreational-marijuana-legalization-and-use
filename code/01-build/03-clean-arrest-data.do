clear all 

// Unzip file
!unzip "raw_data/crime/arrests/ucr_arrests_monthly_all_crimes_race_2000_2016_dta.zip" -d temp

// Import the data and stack it

use temp/temp/ucr_arrests_monthly_all_crimes_race_2000.dta
erase temp/temp/ucr_arrests_monthly_all_crimes_race_2000.dta
forvalues n = 2001(1)2016 {
	append using temp/temp/ucr_arrests_monthly_all_crimes_race_`n'.dta
	erase temp/temp/ucr_arrests_monthly_all_crimes_race_`n'.dta
}

*Some agencies report in all 12 months in every year. Others give incomplete reports in some years.
egen lowest_months_reported = min(number_of_months_reported), by(ori)
egen highest_months_reported = max(number_of_months_reported), by(ori)

gen c = 1
egen nobs = sum(c), by(ori)

*Make an indicator for agencies associated with cities with at least 10,000 people.
gen city_gte10k = 0
replace city_gte10k = 1 if population_group=="city 10,000 thru 24,999"
replace city_gte10k = 1 if population_group=="city 25,000 thru 49,999"
replace city_gte10k = 1 if population_group=="city 50,000 thru 99,999"
replace city_gte10k = 1 if population_group=="city 100,000 thru 249,999"
replace city_gte10k = 1 if population_group=="city 250,000 thru 499,999"
replace city_gte10k = 1 if population_group=="city 500,000 thru 999,999"
replace city_gte10k = 1 if population_group=="city 1,000,000+"
	

*Some agencies may change their city size category over time.
*Flag cities that are ever below 10,000
egen eabove_city_gte10k = max(city_gte10k), by(ori)

*Inclusion criteria: 
*City Sample: police agencies who represent cities that ever have more than 10,000 people.
gen city_sample = eabove_city_gte10k==1

*Unbalanced Annual Sample: City Sample + Full Reporting in Current Year.
gen unbalanced_sample = 0
replace unbalanced_sample = 1 if city_sample==1 & number_of_months_reported==12

*Totally Balanced Sample: City Sample + Full Reporting In all 12 Years
gen totally_balanced_samp = 0
replace totally_balanced_samp = 1 if city_sample==1 & lowest_months_reported==12 & nobs == 204

*Limit to the city sample and save. We can impose the further restrictions in the analysis.
keep if city_sample==1


//State FIPS is missing for some states 
destring fips_state_code, replace
rename fips_state_code StateFIPS
rename state_abb st_abbrv
	
replace StateFIPS=	6	if 	st_abbrv=="CA"
replace StateFIPS=	13	if 	st_abbrv=="GA"
replace StateFIPS=	42	if 	st_abbrv=="PA"
replace StateFIPS=	26	if 	st_abbrv=="MI"
replace StateFIPS=	9	if 	st_abbrv=="CT"

rename st_abbrv st
	

rename population ucr_pop
***************************************************************************************************************************
*Collect the outcome variables
***************************************************************************************************************************
*Possession of Drugs
global poss_cannabis "poss_cannabis_adult_amer_ind poss_cannabis_adult_asian poss_cannabis_adult_black poss_cannabis_adult_white poss_cannabis_juv_amer_ind poss_cannabis_juv_asian poss_cannabis_juv_black poss_cannabis_juv_white"

global poss_heroin_coke "poss_heroin_coke_adult_amer_ind poss_heroin_coke_adult_asian poss_heroin_coke_adult_black poss_heroin_coke_adult_white poss_heroin_coke_juv_amer_ind poss_heroin_coke_juv_asian poss_heroin_coke_juv_black poss_heroin_coke_juv_white"

global poss_synth_narc "poss_synth_narc_adult_amer_ind poss_synth_narc_adult_asian poss_synth_narc_adult_black poss_synth_narc_adult_white poss_synth_narc_juv_amer_ind poss_synth_narc_juv_asian poss_synth_narc_juv_black poss_synth_narc_juv_white"

global poss_other_drug "poss_other_drug_adult_amer_ind poss_other_drug_adult_asian poss_other_drug_adult_black poss_other_drug_adult_white poss_other_drug_juv_amer_ind poss_other_drug_juv_asian poss_other_drug_juv_black poss_other_drug_juv_white"

global poss_drug_total "poss_drug_total_adult_amer_ind poss_drug_total_adult_asian poss_drug_total_adult_black poss_drug_total_adult_white poss_drug_total_juv_amer_ind poss_drug_total_juv_asian poss_drug_total_juv_black poss_drug_total_juv_white"


global possession "$poss_cannabis $poss_heroin_coke $poss_synth_narc $poss_other_drug $poss_drug_total"

***************************************************************************************************************************
*Sale of Drugs
global sale_cannabis "sale_cannabis_adult_amer_ind sale_cannabis_adult_asian sale_cannabis_adult_black sale_cannabis_adult_white sale_cannabis_juv_amer_ind sale_cannabis_juv_asian sale_cannabis_juv_black sale_cannabis_juv_white"

global sale_heroin_coke "sale_heroin_coke_adult_amer_ind sale_heroin_coke_adult_asian sale_heroin_coke_adult_black sale_heroin_coke_adult_white sale_heroin_coke_juv_amer_ind sale_heroin_coke_juv_asian sale_heroin_coke_juv_black sale_heroin_coke_juv_white"

global sale_synth_narc "sale_synth_narc_adult_amer_ind sale_synth_narc_adult_asian sale_synth_narc_adult_black sale_synth_narc_adult_white sale_synth_narc_juv_amer_ind sale_synth_narc_juv_asian sale_synth_narc_juv_black sale_synth_narc_juv_white"

global sale_other_drug "sale_other_drug_adult_amer_ind sale_other_drug_adult_asian sale_other_drug_adult_black sale_other_drug_adult_white sale_other_drug_juv_amer_ind sale_other_drug_juv_asian sale_other_drug_juv_black sale_other_drug_juv_white"

global sale_drug_total "sale_drug_total_adult_amer_ind sale_drug_total_adult_asian sale_drug_total_adult_black sale_drug_total_adult_white sale_drug_total_juv_amer_ind sale_drug_total_juv_asian sale_drug_total_juv_black sale_drug_total_juv_white"

global sale_drug "$sale_cannabis $sale_heroin_coke $sale_synth_narc $sale_other_drug $sale_drug_total"

global total_drug "total_drug_adult_amer_ind total_drug_adult_asian total_drug_adult_black total_drug_adult_white total_drug_juv_amer_ind total_drug_juv_asian total_drug_juv_black total_drug_juv_white"

***************************************************************************************************************************
*Alcohol
global drunkenness "drunkenness_adult_amer_ind drunkenness_adult_asian drunkenness_adult_black drunkenness_adult_white drunkenness_juv_amer_ind drunkenness_juv_asian drunkenness_juv_black drunkenness_juv_white"

global dui "dui_adult_amer_ind dui_adult_asian dui_adult_black dui_adult_white dui_juv_amer_ind dui_juv_asian dui_juv_black dui_juv_white"

global liquor "liquor_adult_amer_ind liquor_adult_asian liquor_adult_black liquor_adult_white liquor_juv_amer_ind liquor_juv_asian liquor_juv_black liquor_juv_white"

global alcohol "$drunkenness $dui $liquor"

***************************************************************************************************************************
*Weapons
global weapons "weapons_adult_amer_ind weapons_adult_asian weapons_adult_black weapons_adult_white weapons_juv_amer_ind weapons_juv_asian weapons_juv_black weapons_juv_white"

***************************************************************************************************************************
*Family, Sex, Prostitution
global family_off "family_off_adult_amer_ind family_off_adult_asian family_off_adult_black family_off_adult_white family_off_juv_amer_ind family_off_juv_asian family_off_juv_black family_off_juv_white"

global oth_sex_off "oth_sex_off_adult_amer_ind oth_sex_off_adult_asian oth_sex_off_adult_black oth_sex_off_adult_white oth_sex_off_juv_amer_ind oth_sex_off_juv_asian oth_sex_off_juv_black oth_sex_off_juv_white"

global prostitution "prostitution_adult_amer_ind prostitution_adult_asian prostitution_adult_black prostitution_adult_white prostitution_juv_amer_ind prostitution_juv_asian prostitution_juv_black prostitution_juv_white"

global runaways "runaways_adult_amer_ind runaways_adult_asian runaways_adult_black runaways_adult_white runaways_juv_amer_ind runaways_juv_asian runaways_juv_black runaways_juv_white"

global famsex "$family_off $oth_sex_off $prostitution $runaways"

***************************************************************************************************************************
*Gambling
global gamble_bookmake "gamble_bookmake_adult_amer_ind gamble_bookmake_adult_asian gamble_bookmake_adult_black gamble_bookmake_adult_white gamble_bookmake_juv_amer_ind gamble_bookmake_juv_asian gamble_bookmake_juv_black gamble_bookmake_juv_white"

global gamble_lottery "gamble_lottery_adult_amer_ind gamble_lottery_adult_asian gamble_lottery_adult_black gamble_lottery_adult_white gamble_lottery_juv_amer_ind gamble_lottery_juv_asian gamble_lottery_juv_black gamble_lottery_juv_white"

global gamble_other "gamble_other_adult_amer_ind gamble_other_adult_asian gamble_other_adult_black gamble_other_adult_white gamble_other_juv_amer_ind gamble_other_juv_asian gamble_other_juv_black gamble_other_juv_white"

global gamble_total "gamble_total_adult_amer_ind gamble_total_adult_asian gamble_total_adult_black gamble_total_adult_white gamble_total_juv_amer_ind gamble_total_juv_asian gamble_total_juv_black gamble_total_juv_white"

global gambling "$gamble_bookmake $gamble_lottery $gamble_other $gamble_total"

***************************************************************************************************************************
*Violence
global agg_assault "agg_assault_adult_amer_ind agg_assault_adult_asian agg_assault_adult_black agg_assault_adult_white agg_assault_juv_amer_ind agg_assault_juv_asian agg_assault_juv_black agg_assault_juv_white"

global manslaught_neg "manslaught_neg_adult_amer_ind manslaught_neg_adult_asian manslaught_neg_adult_black manslaught_neg_adult_white manslaught_neg_juv_amer_ind manslaught_neg_juv_asian manslaught_neg_juv_black manslaught_neg_juv_white"

global murder "murder_adult_amer_ind murder_adult_asian murder_adult_black murder_adult_white murder_juv_amer_ind murder_juv_asian murder_juv_black murder_juv_white"

global oth_assault "oth_assault_adult_amer_ind oth_assault_adult_asian oth_assault_adult_black oth_assault_adult_white oth_assault_juv_amer_ind oth_assault_juv_asian oth_assault_juv_black oth_assault_juv_white"

global rape "rape_adult_amer_ind rape_adult_asian rape_adult_black rape_adult_white rape_juv_amer_ind rape_juv_asian rape_juv_black rape_juv_white"

global violence "$agg_assault $manslaught_neg $murder $oth_assault $rape"

***************************************************************************************************************************
*Theft and Property 
global theft "theft_adult_amer_ind theft_adult_asian theft_adult_black theft_adult_white theft_juv_amer_ind theft_juv_asian theft_juv_black theft_juv_white"

global burglary "burglary_adult_amer_ind burglary_adult_asian burglary_adult_black burglary_adult_white burglary_juv_amer_ind burglary_juv_asian burglary_juv_black burglary_juv_white"

global mtr_veh_theft "mtr_veh_theft_adult_amer_ind mtr_veh_theft_adult_asian mtr_veh_theft_adult_black mtr_veh_theft_adult_white mtr_veh_theft_juv_amer_ind mtr_veh_theft_juv_asian mtr_veh_theft_juv_black mtr_veh_theft_juv_white"

global robbery "robbery_adult_amer_ind robbery_adult_asian robbery_adult_black robbery_adult_white robbery_juv_amer_ind robbery_juv_asian robbery_juv_black robbery_juv_white"

global vandalism "vandalism_adult_amer_ind vandalism_adult_asian vandalism_adult_black vandalism_adult_white vandalism_juv_amer_ind vandalism_juv_asian vandalism_juv_black vandalism_juv_white"

global arson "arson_adult_amer_ind arson_adult_asian arson_adult_black arson_adult_white arson_juv_amer_ind arson_juv_asian arson_juv_black arson_juv_white"

global stolen_prop "stolen_prop_adult_amer_ind stolen_prop_adult_asian stolen_prop_adult_black stolen_prop_adult_white stolen_prop_juv_amer_ind stolen_prop_juv_asian stolen_prop_juv_black stolen_prop_juv_white"

global theftProp "$theft $burglary $mtr_veh_theft $robbery $vandalism $arson $stolen_prop"

***************************************************************************************************************************
*White Collar Crime
global embezzlement "embezzlement_adult_amer_ind embezzlement_adult_asian embezzlement_adult_black embezzlement_adult_white embezzlement_juv_amer_ind embezzlement_juv_asian embezzlement_juv_black embezzlement_juv_white"

global forgery "forgery_adult_amer_ind forgery_adult_asian forgery_adult_black forgery_adult_white forgery_juv_amer_ind forgery_juv_asian forgery_juv_black forgery_juv_white"

global fraud "fraud_adult_amer_ind fraud_adult_asian fraud_adult_black fraud_adult_white fraud_juv_amer_ind fraud_juv_asian fraud_juv_black fraud_juv_white"

global whitecollar "$embezzlement $forgery $fraud"

***************************************************************************************************************************
*Other
global curfew_loiter "curfew_loiter_adult_amer_ind curfew_loiter_adult_asian curfew_loiter_adult_black curfew_loiter_adult_white curfew_loiter_juv_amer_ind curfew_loiter_juv_asian curfew_loiter_juv_black curfew_loiter_juv_white"

global disorder_cond "disorder_cond_adult_amer_ind disorder_cond_adult_asian disorder_cond_adult_black disorder_cond_adult_white disorder_cond_juv_amer_ind disorder_cond_juv_asian disorder_cond_juv_black disorder_cond_juv_white"

global vagrancy "vagrancy_adult_amer_ind vagrancy_adult_asian vagrancy_adult_black vagrancy_adult_white vagrancy_juv_amer_ind vagrancy_juv_asian vagrancy_juv_black vagrancy_juv_white"

global suspicion "suspicion_adult_amer_ind suspicion_adult_asian suspicion_adult_black suspicion_adult_white suspicion_juv_amer_ind suspicion_juv_asian suspicion_juv_black suspicion_juv_white"

rename (all_other_adult_amer_ind  all_other_adult_asian all_other_adult_black all_other_adult_white) (all_oth_nt_adult_amer_ind all_oth_nt_adult_asian all_oth_nt_adult_black all_oth_nt_adult_white)

rename (all_other_juv_amer_ind all_other_juv_asian all_other_juv_black all_other_juv_white) (all_oth_nt_juv_amer_ind all_oth_nt_juv_asian all_oth_nt_juv_black all_oth_nt_juv_white)

global all_other_nontraffic "all_other_nontraffic_adult_amer_ind all_other_nontraffic_adult_asian all_other_nontraffic_adult_black all_other_nontraffic_adult_white all_other_nontraffic_juv_amer_ind all_other_nontraffic_juv_asian all_other_nontraffic_juv_black all_other_nontraffic_juv_white"

global other "$curfew_loiter $disorder_cond $vagrancy $suspicion"

***************************************************************************************************************************

*collapse the data to the annual level
global all_outcomes "$possession $sale_drug $total_drug $alcohol $weapons $famsex $gambling $violence $theftProp $whitecollar $other"

encode state, gen(nstate)
encode st, gen(nst)
encode fips_state_county_code, gen(ncounty)

drop state st fips_state_county_code
rename (nstate nst ncounty)(state st fips_state_county_code)

gcollapse (first) state st StateFIPS fips_state_county_code (mean) ucr_pop totally_balanced_samp (sum) $all_outcomes, by(ori year)

decode state, gen(sstate)
drop state
rename sstate state

decode st, gen(sst)
drop st
rename sst st

decode fips_state_county_code, gen(sf)
drop fips_state_county_code
rename sf fips_state_county_code

order ori year state st StateFIPS fips_state_county_code

compress

*destring fips_state_county_code, replace
encode ori, gen(ori_num)

*Limit to the balanced sample: Population over 10k, full 12 months, every single year 
keep if totally_balanced_samp==1 


global index_vars "ori ori_num year state st StateFIPS fips_state_county_code ucr_pop"


*Make a stacked long form data set. A row should be an agency-race-year.
foreach race in white black asian amer_ind {
	preserve
		*keep only the outcomes from the race in the current iteration.
		keep  $index_vars *_`race'
		
		*drop the race suffix
		rename *_`race' *
		
		*make a categorical race variable
		gen race = "`race'"
		
		*save the temporary data. These race specific arrests.
		save "temp/`race'_arrests.dta", replace
	restore
}
*Stack up the four race specific files.
use "temp/white_arrests.dta", clear
append using "temp/black_arrests.dta"
append using "temp/asian_arrests.dta"
append using "temp/amer_ind_arrests.dta"

*Make a numeric race variable.
rename race str_race
gen race = 1 if str_race == "white"
replace race = 2 if str_race == "black"
replace race = 3 if str_race == "asian"
replace race = 3 if str_race == "amer_ind"
label define nr 1 "white" 2 "black" 3 "other" 
label values race nr

drop str_race

*Put the variables in a nice order.
order ori ori_num year state st StateFIPS fips_state_county_code ucr_pop race ucr_pop poss_cannabis_adult poss_cannabis_juv sale_cannabis_adult sale_cannabis_juv	family_off_adult	family_off_juv	drunkenness_adult	drunkenness_juv	dui_adult dui_juv liquor_adult liquor_juv runaways_adult runaways_juv curfew_loiter_adult curfew_loiter_juv	disorder_cond_adult	disorder_cond_juv vagrancy_adult vagrancy_juv suspicion_adult suspicion_juv poss_heroin_coke_adult	poss_heroin_coke_juv poss_synth_narc_adult poss_synth_narc_juv poss_other_drug_adult poss_other_drug_juv poss_drug_total_adult	poss_drug_total_juv sale_heroin_coke_adult sale_heroin_coke_juv	sale_synth_narc_adult	sale_synth_narc_juv	sale_other_drug_adult	sale_other_drug_juv	sale_drug_total_adult sale_drug_total_juv total_drug_adult total_drug_juv weapons_adult	weapons_juv	gamble_bookmake_adult gamble_bookmake_juv gamble_lottery_adult gamble_lottery_juv gamble_other_adult gamble_other_juv	gamble_total_adult gamble_total_juv agg_assault_adult agg_assault_juv oth_assault_adult	oth_assault_juv prostitution_adult	prostitution_juv rape_adult	rape_juv oth_sex_off_adult oth_sex_off_juv robbery_adult robbery_juv theft_adult theft_juv	burglary_adult burglary_juv stolen_prop_adult stolen_prop_juv mtr_veh_theft_adult mtr_veh_theft_juv	vandalism_adult	vandalism_juv arson_adult arson_juv	embezzlement_adult embezzlement_juv forgery_adult forgery_juv fraud_adult fraud_juv	manslaught_neg_adult	manslaught_neg_juv	murder_adult murder_juv

*Collect all of the outcome variables into a global.
global all_outcomes "poss_cannabis_adult poss_cannabis_juv sale_cannabis_adult sale_cannabis_juv family_off_adult family_off_juv drunkenness_adult drunkenness_juv dui_adult dui_juv liquor_adult liquor_juv runaways_adult runaways_juv curfew_loiter_adult curfew_loiter_juv disorder_cond_adult disorder_cond_juv vagrancy_adult vagrancy_juv suspicion_adult suspicion_juv poss_heroin_coke_adult poss_heroin_coke_juv poss_synth_narc_adult poss_synth_narc_juv poss_other_drug_adult poss_other_drug_juv poss_drug_total_adult poss_drug_total_juv sale_heroin_coke_adult sale_heroin_coke_juv sale_synth_narc_adult sale_synth_narc_juv sale_other_drug_adult sale_other_drug_juv sale_drug_total_adult sale_drug_total_juv total_drug_adult total_drug_juv weapons_adult weapons_juv gamble_bookmake_adult gamble_bookmake_juv gamble_lottery_adult gamble_lottery_juv gamble_other_adult gamble_other_juv gamble_total_adult gamble_total_juv agg_assault_adult agg_assault_juv oth_assault_adult oth_assault_juv prostitution_adult prostitution_juv rape_adult rape_juv oth_sex_off_adult oth_sex_off_juv robbery_adult robbery_juv theft_adult theft_juv burglary_adult burglary_juv stolen_prop_adult stolen_prop_juv mtr_veh_theft_adult mtr_veh_theft_juv vandalism_adult vandalism_juv arson_adult arson_juv embezzlement_adult embezzlement_juv forgery_adult forgery_juv fraud_adult fraud_juv manslaught_neg_adult manslaught_neg_juv murder_adult murder_juv"

gcollapse (sum) poss_cannabis_juv sale_cannabis_juv poss_cannabis_adult sale_cannabis_adult, ///
	by(StateFIPS year)	
		
		
*Bring in the state laws
merge 1:1 StateFIPS year using data_for_analysis/intermediate/medical_marijuana_status_single_year.dta

*Drop some extra years from the regulation data, which goes from 1996 to 2018
drop if _merge==2
tab _merge
drop _merge

* Merge in population. 
merge 1:1 StateFIPS year using "data_for_analysis/intermediate/pop_by_juv_by_year.dta"

drop if _merge==2
tab _merge
drop _merge

* Merge in median income
merge 1:1 StateFIPS year using "data_for_analysis/intermediate/median_income_by_year.dta"
drop if _merge==2
tab _merge
drop _merge

sort StateFIPS year

* Merge in unemployment rate 
merge 1:1 StateFIPS year using "data_for_analysis/intermediate/unemployment_rate_by_year.dta"

drop if _merge==2
tab _merge
drop _merge

sort StateFIPS year

* Gen rates 
gen r_poss_cannabis_juv = (poss_cannabis_juv / pop_juv)*100000
gen r_poss_cannabis_adult = (poss_cannabis_adult / pop_adult)*100000

gen r_sale_cannabis_juv = (sale_cannabis_juv / pop_juv)*100000
gen r_sale_cannabis_adult = (sale_cannabis_adult / pop_adult)*100000

 * add census region
gen region = .
replace region = 1  if StateFIPS==00
replace region = 1  if StateFIPS==00
replace region = 1  if StateFIPS==09
replace region = 1  if StateFIPS==23
replace region = 1  if StateFIPS==25
replace region = 1  if StateFIPS==33
replace region = 1  if StateFIPS==44
replace region = 1  if StateFIPS==50
replace region = 1  if StateFIPS==00
replace region = 1  if StateFIPS==34
replace region = 1  if StateFIPS==36
replace region = 1  if StateFIPS==42
replace region = 2  if StateFIPS==00
replace region = 2  if StateFIPS==00
replace region = 2  if StateFIPS==17
replace region = 2  if StateFIPS==18
replace region = 2  if StateFIPS==26
replace region = 2  if StateFIPS==39
replace region = 2  if StateFIPS==55
replace region = 2  if StateFIPS==00
replace region = 2  if StateFIPS==19
replace region = 2  if StateFIPS==20
replace region = 2  if StateFIPS==27
replace region = 2  if StateFIPS==29
replace region = 2  if StateFIPS==31
replace region = 2  if StateFIPS==38
replace region = 2  if StateFIPS==46
replace region = 3  if StateFIPS==00
replace region = 3  if StateFIPS==00
replace region = 3  if StateFIPS==10
replace region = 3  if StateFIPS==11
replace region = 3  if StateFIPS==12
replace region = 3  if StateFIPS==13
replace region = 3  if StateFIPS==24
replace region = 3  if StateFIPS==37
replace region = 3  if StateFIPS==45
replace region = 3  if StateFIPS==51
replace region = 3  if StateFIPS==54
replace region = 3  if StateFIPS==00
replace region = 3  if StateFIPS==01
replace region = 3  if StateFIPS==21
replace region = 3  if StateFIPS==28
replace region = 3  if StateFIPS==47
replace region = 3  if StateFIPS==00
replace region = 3  if StateFIPS==05
replace region = 3  if StateFIPS==22
replace region = 3  if StateFIPS==40
replace region = 3  if StateFIPS==48
replace region = 4  if StateFIPS==00
replace region = 4  if StateFIPS==00
replace region = 4  if StateFIPS==04
replace region = 4  if StateFIPS==08
replace region = 4  if StateFIPS==16
replace region = 4  if StateFIPS==30
replace region = 4  if StateFIPS==32
replace region = 4  if StateFIPS==35
replace region = 4  if StateFIPS==49
replace region = 4  if StateFIPS==56
replace region = 4  if StateFIPS==00
replace region = 4  if StateFIPS==02
replace region = 4  if StateFIPS==06
replace region = 4  if StateFIPS==15
replace region = 4  if StateFIPS==41
replace region = 4  if StateFIPS==53


* Add population by year
merge 1:1 StateFIPS year using "data_for_analysis/intermediate/population_by_year.dta"
keep if _merge == 3
drop _merge

* Add percent
gen percent_adult = pop_adult/population
gen percent_juv = pop_juv/population 


* Save file for analysis
compress
save "data_for_analysis/arrest_data.dta", replace

* Clean up
erase "temp/white_arrests.dta"
erase "temp/black_arrests.dta"
erase "temp/asian_arrests.dta"
erase "temp/amer_ind_arrests.dta"
!rmdir temp/temp
