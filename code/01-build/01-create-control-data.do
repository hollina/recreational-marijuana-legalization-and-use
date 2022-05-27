////////////////////////////////////////////////////////////////////////////////
////////////////////////////Marijuana law data//////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Import medical marijuana law data that was provided by Ashley Bradford
clear all
import excel "raw_data/marijuana_laws/state-marijuana-laws-12-11-20.xlsx", sheet("for stata")cellrange(A1:H52) firstrow

// Format data so it can be merged with the NSDUH data 
keep st effective_date recreational_effective dispensary_open_date  recreational_disp
rename st st_abbrv
rename effective_date medical_marijuana_effective
rename dispensary_open_date med_dispensary_open_date

drop if st_abbrv==""
expand 21

// Generate our preferred treatment (in the first year. So treated the whole time)
bysort st_abbrv: gen year=1999+_n
gen mm=(year>=year(medical_marijuana_effective))
	replace mm=0 if missing(medical_marijuana_effective)
gen disp=(year>=year(med_dispensary_open_date))
	replace disp=0 if missing(med_dispensary_open_date)
gen rm=(year>=year(recreational_effective))
	replace rm=0 if missing(recreational_effective)
gen rm_disp=(year>=year(recreational_disp))
	replace rm_disp=0 if missing(recreational_disp)
	
// Generate another equally valid treatment (in the second year. So treated part of the time allowed)
bysort st_abbrv: gen agr_year=2000+_n
gen agr_mm=(agr_year>=year(medical_marijuana_effective))
	replace agr_mm=0 if missing(medical_marijuana_effective)
gen agr_disp=(agr_year>=year(med_dispensary_open_date))
	replace agr_disp=0 if missing(med_dispensary_open_date)
gen agr_rm=(agr_year>=year(recreational_effective))
	replace agr_rm=0 if missing(recreational_effective)
gen agr_rm_disp=(agr_year>=year(recreational_disp))
	replace agr_rm_disp=0 if missing(recreational_disp)
	
keep st_abbrv mm rm disp rm_disp year agr_*
drop agr_year


// Add State FIPS
gen StateFIPS=.					
replace StateFIPS=	15	if 	st_abbrv=="HI"
replace StateFIPS=	1	if 	st_abbrv=="AL"
replace StateFIPS=	2	if 	st_abbrv=="AK"
replace StateFIPS=	4	if 	st_abbrv=="AZ"
replace StateFIPS=	5	if 	st_abbrv=="AR"
replace StateFIPS=	6	if 	st_abbrv=="CA"
replace StateFIPS=	8	if 	st_abbrv=="CO"
replace StateFIPS=	9	if 	st_abbrv=="CT"
replace StateFIPS=	10	if 	st_abbrv=="DE"
replace StateFIPS=	11	if 	st_abbrv=="DC"
replace StateFIPS=	12	if 	st_abbrv=="FL"
replace StateFIPS=	13	if 	st_abbrv=="GA"
replace StateFIPS=	16	if 	st_abbrv=="ID"
replace StateFIPS=	17	if 	st_abbrv=="IL"
replace StateFIPS=	18	if 	st_abbrv=="IN"
replace StateFIPS=	19	if 	st_abbrv=="IA"
replace StateFIPS=	20	if 	st_abbrv=="KS"
replace StateFIPS=	21	if 	st_abbrv=="KY"
replace StateFIPS=	22	if 	st_abbrv=="LA"
replace StateFIPS=	23	if 	st_abbrv=="ME"
replace StateFIPS=	24	if 	st_abbrv=="MD"
replace StateFIPS=	25	if 	st_abbrv=="MA"
replace StateFIPS=	26	if 	st_abbrv=="MI"
replace StateFIPS=	27	if 	st_abbrv=="MN"
replace StateFIPS=	28	if 	st_abbrv=="MS"
replace StateFIPS=	29	if 	st_abbrv=="MO"
replace StateFIPS=	30	if 	st_abbrv=="MT"
replace StateFIPS=	31	if 	st_abbrv=="NE"
replace StateFIPS=	32	if 	st_abbrv=="NV"
replace StateFIPS=	33	if 	st_abbrv=="NH"
replace StateFIPS=	34	if 	st_abbrv=="NJ"
replace StateFIPS=	35	if 	st_abbrv=="NM"
replace StateFIPS=	36	if 	st_abbrv=="NY"
replace StateFIPS=	37	if 	st_abbrv=="NC"
replace StateFIPS=	38	if 	st_abbrv=="ND"
replace StateFIPS=	39	if 	st_abbrv=="OH"
replace StateFIPS=	40	if 	st_abbrv=="OK"
replace StateFIPS=	41	if 	st_abbrv=="OR"
replace StateFIPS=	42	if 	st_abbrv=="PA"
replace StateFIPS=	44	if 	st_abbrv=="RI"
replace StateFIPS=	45	if 	st_abbrv=="SC"
replace StateFIPS=	46	if 	st_abbrv=="SD"
replace StateFIPS=	47	if 	st_abbrv=="TN"
replace StateFIPS=	48	if 	st_abbrv=="TX"
replace StateFIPS=	49	if 	st_abbrv=="UT"
replace StateFIPS=	50	if 	st_abbrv=="VT"
replace StateFIPS=	51	if 	st_abbrv=="VA"
replace StateFIPS=	53	if 	st_abbrv=="WA"
replace StateFIPS=	54	if 	st_abbrv=="WV"
replace StateFIPS=	55	if 	st_abbrv=="WI"
replace StateFIPS=	56	if 	st_abbrv=="WY"

compress
save "data_for_analysis/intermediate/medical_marijuana_status_single_year.dta", replace


//Rename years to fit with NSDUH data 
tostring year, replace
replace year="1995-1996" if year=="1995"
replace year="1996-1997" if year=="1996"
replace year="1997-1998" if year=="1997"
replace year="1998-1999" if year=="1998"
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003" 
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005" 
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008" 
replace year="2009-2010" if year=="2009" 
replace year="2010-2011" if year=="2010" 
replace year="2011-2012" if year=="2011" 
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014" 
replace year="2015-2016" if year=="2015" 
replace year="2016-2017" if year=="2016" 
replace year="2017-2018" if year=="2017" 
replace year="2018-2019" if year=="2018" 
replace year="2019-2020" if year=="2019" 
replace year="2020-2021" if year=="2020" 


sort StateFIPS year

compress
save "data_for_analysis/intermediate/medical_marijuana_status.dta", replace

// Create mergable with age groups 

// Genearte numeric year id
egen year_group_id = group(year)

// Create numeric year
gen year_numeric = year_group_id+1999

// Keep only what we need
keep StateFIPS year_numeric rm mm disp rm_disp


// Generate age category (1 2 3 4 5 6)
gen order = _n
expand 6
bysort order: gen age_category = _n
drop order

// Save dataset for merge
compress
save "data_for_analysis/intermediate/marijuana_status.dta", replace



////////////////////////////////////////////////////////////////////////////////
/////////////////////////////Median household income////////////////////////////
////////////////////////////////////////////////////////////////////////////////


clear all
import excel "raw_data/median_income/h08a.xls", sheet("h08A") cellrange(A4:BK59) firstrow clear
keep State  B D F H J L N P R T V X Z AB AD AF AH
rename B median_income_2016
rename D median_income_2015
rename F median_income_2014
rename H median_income_2012
rename J median_income_2011
rename L median_income_2010
rename N median_income_2009
rename P median_income_2008
rename R median_income_2007
rename T median_income_2006
rename V median_income_2005
rename X median_income_2004
rename Z median_income_2003
rename AB median_income_2002
rename AD median_income_2001
rename AF median_income_2000
rename AH median_income_1999

// 2013 DATA IS MISSING


drop if missing(median_income_2015)
drop in 1
destring median_income_2016, replace
destring median_income_2015, replace
destring median_income_2014, replace 
destring median_income_2012, replace 
destring median_income_2011, replace 
destring median_income_2010, replace 
destring median_income_2009, replace 
destring median_income_2008, replace 
destring median_income_2007, replace 
destring median_income_2006, replace 
destring median_income_2005, replace 
destring median_income_2004, replace 
destring median_income_2003, replace 
destring median_income_2002, replace 
destring median_income_2001, replace 
destring median_income_2000, replace 
destring median_income_1999, replace 

compress
drop if State=="United States"
gen state_name=strupper(State)
gen state_code=""

replace state_code ="AK" if state_name=="ALASKA"
replace state_code ="AL" if state_name=="ALABAMA"
replace state_code ="AR" if state_name=="ARKANSAS"
replace state_code ="AS" if state_name=="AMERICAN SAMOA"
replace state_code ="AZ" if state_name=="ARIZONA"
replace state_code ="CA" if state_name=="CALIFORNIA"
replace state_code ="CO" if state_name=="COLORADO"
replace state_code ="CT" if state_name=="CONNECTICUT"
replace state_code ="DC" if state_name=="DISTRICT OF COLUMBIA"
replace state_code ="DC" if state_name=="D.C."
replace state_code ="DE" if state_name=="DELAWARE"
replace state_code ="FL" if state_name=="FLORIDA"
replace state_code ="GA" if state_name=="GEORGIA"
replace state_code ="GU" if state_name=="GUAM"
replace state_code ="HI" if state_name=="HAWAII"
replace state_code ="IA" if state_name=="IOWA"
replace state_code ="ID" if state_name=="IDAHO"
replace state_code ="IL" if state_name=="ILLINOIS"
replace state_code ="IN" if state_name=="INDIANA"
replace state_code ="KS" if state_name=="KANSAS"
replace state_code ="KY" if state_name=="KENTUCKY"
replace state_code ="LA" if state_name=="LOUISIANA"
replace state_code ="MA" if state_name=="MASSACHUSETTS"
replace state_code ="MD" if state_name=="MARYLAND"
replace state_code ="ME" if state_name=="MAINE"
replace state_code ="MI" if state_name=="MICHIGAN"
replace state_code ="MN" if state_name=="MINNESOTA"
replace state_code ="MO" if state_name=="MISSOURI"
replace state_code ="MS" if state_name=="MISSISSIPPI"
replace state_code ="MT" if state_name=="MONTANA"
replace state_code ="NC" if state_name=="NORTH CAROLINA"
replace state_code ="ND" if state_name=="NORTH DAKOTA"
replace state_code ="NE" if state_name=="NEBRASKA"
replace state_code ="NH" if state_name=="NEW HAMPSHIRE"
replace state_code ="NJ" if state_name=="NEW JERSEY"
replace state_code ="NM" if state_name=="NEW MEXICO"
replace state_code ="NV" if state_name=="NEVADA"
replace state_code ="NY" if state_name=="NEW YORK"
replace state_code ="OH" if state_name=="OHIO"
replace state_code ="OK" if state_name=="OKLAHOMA"
replace state_code ="OR" if state_name=="OREGON"
replace state_code ="PA" if state_name=="PENNSYLVANIA"
replace state_code ="PR" if state_name=="PUERTO RICO"
replace state_code ="RI" if state_name=="RHODE ISLAND"
replace state_code ="SC" if state_name=="SOUTH CAROLINA"
replace state_code ="SD" if state_name=="SOUTH DAKOTA"
replace state_code ="TN" if state_name=="TENNESSEE"
replace state_code ="TX" if state_name=="TEXAS"
replace state_code ="UT" if state_name=="UTAH"
replace state_code ="VA" if state_name=="VIRGINIA"
replace state_code ="VI" if state_name=="VIRGIN ISLANDS"
replace state_code ="VT" if state_name=="VERMONT"
replace state_code ="WA" if state_name=="WASHINGTON"
replace state_code ="WI" if state_name=="WISCONSIN"
replace state_code ="WV" if state_name=="WEST VIRGINIA"
replace state_code ="WY" if state_name=="WYOMING"

drop State
rename state_code state

gen StateFIPS=.					
replace StateFIPS=	15	if 	state=="HI"
replace StateFIPS=	1	if 	state=="AL"
replace StateFIPS=	2	if 	state=="AK"
replace StateFIPS=	4	if 	state=="AZ"
replace StateFIPS=	5	if 	state=="AR"
replace StateFIPS=	6	if 	state=="CA"
replace StateFIPS=	8	if 	state=="CO"
replace StateFIPS=	9	if 	state=="CT"
replace StateFIPS=	10	if 	state=="DE"
replace StateFIPS=	11	if 	state=="DC"
replace StateFIPS=	12	if 	state=="FL"
replace StateFIPS=	13	if 	state=="GA"
replace StateFIPS=	16	if 	state=="ID"
replace StateFIPS=	17	if 	state=="IL"
replace StateFIPS=	18	if 	state=="IN"
replace StateFIPS=	19	if 	state=="IA"
replace StateFIPS=	20	if 	state=="KS"
replace StateFIPS=	21	if 	state=="KY"
replace StateFIPS=	22	if 	state=="LA"
replace StateFIPS=	23	if 	state=="ME"
replace StateFIPS=	24	if 	state=="MD"
replace StateFIPS=	25	if 	state=="MA"
replace StateFIPS=	26	if 	state=="MI"
replace StateFIPS=	27	if 	state=="MN"
replace StateFIPS=	28	if 	state=="MS"
replace StateFIPS=	29	if 	state=="MO"
replace StateFIPS=	30	if 	state=="MT"
replace StateFIPS=	31	if 	state=="NE"
replace StateFIPS=	32	if 	state=="NV"
replace StateFIPS=	33	if 	state=="NH"
replace StateFIPS=	34	if 	state=="NJ"
replace StateFIPS=	35	if 	state=="NM"
replace StateFIPS=	36	if 	state=="NY"
replace StateFIPS=	37	if 	state=="NC"
replace StateFIPS=	38	if 	state=="ND"
replace StateFIPS=	39	if 	state=="OH"
replace StateFIPS=	40	if 	state=="OK"
replace StateFIPS=	41	if 	state=="OR"
replace StateFIPS=	42	if 	state=="PA"
replace StateFIPS=	44	if 	state=="RI"
replace StateFIPS=	45	if 	state=="SC"
replace StateFIPS=	46	if 	state=="SD"
replace StateFIPS=	47	if 	state=="TN"
replace StateFIPS=	48	if 	state=="TX"
replace StateFIPS=	49	if 	state=="UT"
replace StateFIPS=	50	if 	state=="VT"
replace StateFIPS=	51	if 	state=="VA"
replace StateFIPS=	53	if 	state=="WA"
replace StateFIPS=	54	if 	state=="WV"
replace StateFIPS=	55	if 	state=="WI"
replace StateFIPS=	56	if 	state=="WY"

rename state st_abbrv
rename state_name state
reshape long median_income_@, i(StateFIPS) j(year)
rename *_ *


rename median_income ave_median_income
	lab var ave_median_income "Median Household Income"
	


///DO NOT NEED TO Create two year averages to fit with NSDUH BECAUSE IT IS ALREADY IN TWO YEAR AVG FORM


///Renaming year to fit with NSDUH 

tostring year, replace
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003"
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005"
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008"
replace year="2009-2010" if year=="2009"
replace year="2010-2011" if year=="2010"
replace year="2011-2012" if year=="2011"
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014"
replace year="2015-2016" if year=="2015"
replace year="2016-2017" if year=="2016"


replace state = proper(state)

sort StateFIPS year
compress
save "data_for_analysis/intermediate/median_income.dta", replace
///////////////////////////////////////////////////////////
// By year

clear all
import excel "raw_data/median_income/h08.xls", sheet("h08") cellrange(A5:BW116) allstring

local i = 1
foreach var of varlist * {
    rename `var' temp_`=substr(`var'[1],1,4)'_`i'
	local i = `i' + 1
}

rename temp_Stat_1 state
drop if missing(state)
drop if state == "United States"
drop if state == "State"
keep in 1/51
reshape long temp_@, i(state) j(year_stub) string
destring temp_, gen(median_income)
split year_stub, p("_")
destring year_stub1, gen(year)
destring year_stub2, gen(version)

drop if missing(year)
drop year_stub temp_ year_stub1 year_stub2
sort state year version
compress
bysort state year: gen order = _n
keep if order == 1
drop version order

gen state_name=strupper(state)
gen state_code=""

replace state_code ="AK" if state_name=="ALASKA"
replace state_code ="AL" if state_name=="ALABAMA"
replace state_code ="AR" if state_name=="ARKANSAS"
replace state_code ="AS" if state_name=="AMERICAN SAMOA"
replace state_code ="AZ" if state_name=="ARIZONA"
replace state_code ="CA" if state_name=="CALIFORNIA"
replace state_code ="CO" if state_name=="COLORADO"
replace state_code ="CT" if state_name=="CONNECTICUT"
replace state_code ="DC" if state_name=="DISTRICT OF COLUMBIA"
replace state_code ="DC" if state_name=="D.C."
replace state_code ="DE" if state_name=="DELAWARE"
replace state_code ="FL" if state_name=="FLORIDA"
replace state_code ="GA" if state_name=="GEORGIA"
replace state_code ="GU" if state_name=="GUAM"
replace state_code ="HI" if state_name=="HAWAII"
replace state_code ="IA" if state_name=="IOWA"
replace state_code ="ID" if state_name=="IDAHO"
replace state_code ="IL" if state_name=="ILLINOIS"
replace state_code ="IN" if state_name=="INDIANA"
replace state_code ="KS" if state_name=="KANSAS"
replace state_code ="KY" if state_name=="KENTUCKY"
replace state_code ="LA" if state_name=="LOUISIANA"
replace state_code ="MA" if state_name=="MASSACHUSETTS"
replace state_code ="MD" if state_name=="MARYLAND"
replace state_code ="ME" if state_name=="MAINE"
replace state_code ="MI" if state_name=="MICHIGAN"
replace state_code ="MN" if state_name=="MINNESOTA"
replace state_code ="MO" if state_name=="MISSOURI"
replace state_code ="MS" if state_name=="MISSISSIPPI"
replace state_code ="MT" if state_name=="MONTANA"
replace state_code ="NC" if state_name=="NORTH CAROLINA"
replace state_code ="ND" if state_name=="NORTH DAKOTA"
replace state_code ="NE" if state_name=="NEBRASKA"
replace state_code ="NH" if state_name=="NEW HAMPSHIRE"
replace state_code ="NJ" if state_name=="NEW JERSEY"
replace state_code ="NM" if state_name=="NEW MEXICO"
replace state_code ="NV" if state_name=="NEVADA"
replace state_code ="NY" if state_name=="NEW YORK"
replace state_code ="OH" if state_name=="OHIO"
replace state_code ="OK" if state_name=="OKLAHOMA"
replace state_code ="OR" if state_name=="OREGON"
replace state_code ="PA" if state_name=="PENNSYLVANIA"
replace state_code ="PR" if state_name=="PUERTO RICO"
replace state_code ="RI" if state_name=="RHODE ISLAND"
replace state_code ="SC" if state_name=="SOUTH CAROLINA"
replace state_code ="SD" if state_name=="SOUTH DAKOTA"
replace state_code ="TN" if state_name=="TENNESSEE"
replace state_code ="TX" if state_name=="TEXAS"
replace state_code ="UT" if state_name=="UTAH"
replace state_code ="VA" if state_name=="VIRGINIA"
replace state_code ="VI" if state_name=="VIRGIN ISLANDS"
replace state_code ="VT" if state_name=="VERMONT"
replace state_code ="WA" if state_name=="WASHINGTON"
replace state_code ="WI" if state_name=="WISCONSIN"
replace state_code ="WV" if state_name=="WEST VIRGINIA"
replace state_code ="WY" if state_name=="WYOMING"

drop state
rename state_code state

gen StateFIPS=.					
replace StateFIPS=	15	if 	state=="HI"
replace StateFIPS=	1	if 	state=="AL"
replace StateFIPS=	2	if 	state=="AK"
replace StateFIPS=	4	if 	state=="AZ"
replace StateFIPS=	5	if 	state=="AR"
replace StateFIPS=	6	if 	state=="CA"
replace StateFIPS=	8	if 	state=="CO"
replace StateFIPS=	9	if 	state=="CT"
replace StateFIPS=	10	if 	state=="DE"
replace StateFIPS=	11	if 	state=="DC"
replace StateFIPS=	12	if 	state=="FL"
replace StateFIPS=	13	if 	state=="GA"
replace StateFIPS=	16	if 	state=="ID"
replace StateFIPS=	17	if 	state=="IL"
replace StateFIPS=	18	if 	state=="IN"
replace StateFIPS=	19	if 	state=="IA"
replace StateFIPS=	20	if 	state=="KS"
replace StateFIPS=	21	if 	state=="KY"
replace StateFIPS=	22	if 	state=="LA"
replace StateFIPS=	23	if 	state=="ME"
replace StateFIPS=	24	if 	state=="MD"
replace StateFIPS=	25	if 	state=="MA"
replace StateFIPS=	26	if 	state=="MI"
replace StateFIPS=	27	if 	state=="MN"
replace StateFIPS=	28	if 	state=="MS"
replace StateFIPS=	29	if 	state=="MO"
replace StateFIPS=	30	if 	state=="MT"
replace StateFIPS=	31	if 	state=="NE"
replace StateFIPS=	32	if 	state=="NV"
replace StateFIPS=	33	if 	state=="NH"
replace StateFIPS=	34	if 	state=="NJ"
replace StateFIPS=	35	if 	state=="NM"
replace StateFIPS=	36	if 	state=="NY"
replace StateFIPS=	37	if 	state=="NC"
replace StateFIPS=	38	if 	state=="ND"
replace StateFIPS=	39	if 	state=="OH"
replace StateFIPS=	40	if 	state=="OK"
replace StateFIPS=	41	if 	state=="OR"
replace StateFIPS=	42	if 	state=="PA"
replace StateFIPS=	44	if 	state=="RI"
replace StateFIPS=	45	if 	state=="SC"
replace StateFIPS=	46	if 	state=="SD"
replace StateFIPS=	47	if 	state=="TN"
replace StateFIPS=	48	if 	state=="TX"
replace StateFIPS=	49	if 	state=="UT"
replace StateFIPS=	50	if 	state=="VT"
replace StateFIPS=	51	if 	state=="VA"
replace StateFIPS=	53	if 	state=="WA"
replace StateFIPS=	54	if 	state=="WV"
replace StateFIPS=	55	if 	state=="WI"
replace StateFIPS=	56	if 	state=="WY"

keep StateFIPS year median_income
order  StateFIPS year median_income
sort  StateFIPS year median_income

// Save single year median income
compress
save "data_for_analysis/intermediate/median_income_by_year.dta", replace

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Unemployment Rate///////////////////////////////
////////////////////////////////////////////////////////////////////////////////


clear all
import excel "raw_data/unemployment_rate/table12full99.xlsx", sheet("table12full99") cellrange(A8:N1923)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 1999

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_99.dta", replace


clear all
import excel "raw_data/unemployment_rate/table12full00.xlsx", sheet("table12full00") cellrange(A8:N1923)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2000

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_00.dta", replace


clear all

import excel "raw_data/unemployment_rate/table12full01.xlsx", sheet("table12full01") cellrange(A8:N2071)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2001

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_01.dta", replace


clear all
import excel "raw_data/unemployment_rate/table12full02.xlsx", sheet("table12full02") cellrange(A8:N2136)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2002

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_02.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full03.xlsx", sheet("table14full03") cellrange(A8:N2446)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2003

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_03.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full04.xlsx", sheet("table14full04") cellrange(A8:N2426)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2004

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_04.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full05.xlsx", sheet("table14full05") cellrange(A8:N2408)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2005

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_05.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full06.xlsx", sheet("table14full06") cellrange(A8:N2397)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2006

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_06.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full07.xlsx", sheet("table14full07") cellrange(A8:N2409)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2007

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_07.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full08.xlsx", sheet("table14full08") cellrange(A8:N2397)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2008

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_08.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full09.xlsx", sheet("table14full09") cellrange(A8:N2662)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2009

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_09.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full10.xlsx", sheet("table14full10") cellrange(A8:N2682)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2010

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_10.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full11.xlsx", sheet("table14full11") cellrange(A8:N2658)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2011

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_11.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full12.xlsx", sheet("table14full12") cellrange(A8:N2646)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2012

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_12.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full13.xlsx", sheet("table14full13") cellrange(A8:N2633)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2013

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_13.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full14.xlsx", sheet("table14full14") cellrange(A8:N2584)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2014

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_14.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14full15.xlsx", sheet("table14full15") cellrange(A8:N2268)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2015

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace

save "temp/unemployment_15.dta", replace

clear all
import excel "raw_data/unemployment_rate/table14full16.xlsx", sheet("table14full16") cellrange(A8:N2212)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2016

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_16.dta", replace


clear all
import excel "raw_data/unemployment_rate/table14afull17.xlsx", sheet("table14afull17") cellrange(A8:L1079)
keep if D=="Total"
rename C state
rename A StateFIPS
rename F labor_force
rename H number_employed
gen year = 2017

keep state StateFIPS labor_force number_employed year
compress
destring StateFIPS, replace
destring labor_force, replace
destring number_employed, replace
save "temp/unemployment_17.dta", replace


clear all
use "temp/unemployment_99.dta"
append using  "temp/unemployment_00.dta"
append using  "temp/unemployment_01.dta"
append using  "temp/unemployment_02.dta"
append using  "temp/unemployment_03.dta"
append using  "temp/unemployment_04.dta"
append using  "temp/unemployment_05.dta"
append using  "temp/unemployment_06.dta"
append using  "temp/unemployment_07.dta"
append using  "temp/unemployment_08.dta"
append using  "temp/unemployment_09.dta"
append using  "temp/unemployment_10.dta"
append using  "temp/unemployment_11.dta"
append using  "temp/unemployment_12.dta"
append using  "temp/unemployment_13.dta"
append using  "temp/unemployment_14.dta"
append using  "temp/unemployment_15.dta"
append using  "temp/unemployment_16.dta"
append using  "temp/unemployment_17.dta"


erase   "temp/unemployment_99.dta"
erase   "temp/unemployment_00.dta"
erase   "temp/unemployment_01.dta"
erase   "temp/unemployment_02.dta"
erase   "temp/unemployment_03.dta"
erase   "temp/unemployment_04.dta"
erase   "temp/unemployment_05.dta"
erase   "temp/unemployment_06.dta"
erase   "temp/unemployment_07.dta"
erase   "temp/unemployment_08.dta"
erase   "temp/unemployment_09.dta"
erase   "temp/unemployment_10.dta"
erase   "temp/unemployment_11.dta"
erase   "temp/unemployment_12.dta"
erase   "temp/unemployment_13.dta"
erase   "temp/unemployment_14.dta"
erase   "temp/unemployment_15.dta"
erase   "temp/unemployment_16.dta"
erase   "temp/unemployment_17.dta"


collapse (mean) number_employed labor_force, by(year StateFIPS)

//Generate rate
gen unemployment_rate = ((labor_force-number_employed)/labor_force)*100

// Save single year unemployment rate 
compress
save "data_for_analysis/intermediate/unemployment_rate_by_year.dta", replace

//Create averages to fit with NSDUH data (ex: the average of 1999 and 2000 is attached to the year 1999
bysort StateFIPS (year): gen ave_unemp_rate= (unemployment_rate + unemployment_rate[_n+1] ) / 2
	lab var ave_unemp_rate "Unemployment rate"
keep StateFIPS ave_unemp_rate year

tostring year, replace
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003"
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005"
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008"
replace year="2009-2010" if year=="2009"
replace year="2010-2011" if year=="2010"
replace year="2011-2012" if year=="2011"
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014"
replace year="2015-2016" if year=="2015"
replace year="2016-2017" if year=="2016"

drop if year=="2017"

sort StateFIPS year
compress
save "data_for_analysis/intermediate/unemployment_rate.dta", replace


////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// POPULATION ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

clear all

*Unzip 
!unzip "raw_data/seer/us.1969_2017.19ages.adjusted.txt.zip" -d temp
!unzip "raw_data/seer/us.1990_2017.19ages.adjusted.txt.zip" -d temp

// Create state population in 2013
clear all
infix year 1-4 str state 5-6 StateFIPS 7-8 CountyFIPS 9-11 registry 12-13 race 14 origin 15 sex 16 age 17-18 population 19-27 ///
	using "temp/us.1990_2017.19ages.adjusted.txt"
gcollapse (sum) pop, by(StateFIPS year)
keep if year == 2013
keep StateFIPS pop
rename pop population_2013
compress
save "data_for_analysis/intermediate/state_population_2013.dta", replace

// Create population by state two year averages. 
clear all
infix year 1-4 str state 5-6 StateFIPS 7-8 CountyFIPS 9-11 registry 12-13 race 14 origin 15 sex 16 age 17-18 population 19-27 ///
	using "temp/us.1969_2017.19ages.adjusted.txt"

keep if year>=1999

label define age 0 "<1" 1 "1-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65-69" 15 "70-74" 16 "75-79" 17 "80-84" 18 "85+"
label values age age
label variable age "Age Group"

drop registry

bysort StateFIPS  year: egen mpop_total = total(population)
bysort StateFIPS  year: egen pop_total = max(mpop_total)

drop mpop*
bysort StateFIPS  year: gen order =_n

keep if order ==1 
drop order

ds pop_*
foreach x in `r(varlist)' {

}


bysort StateFIPS year: keep if _n==1

//Create averages to fit with NSDUH data (the average of 1999 and 2000 is attached to the year 1999
bysort StateFIPS (year): gen ave_pop= (pop_total + pop_total[_n+1] ) / 2
	lab var ave_pop "State population"

tostring year, replace
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003"
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005"
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008"
replace year="2009-2010" if year=="2009"
replace year="2010-2011" if year=="2010"
replace year="2011-2012" if year=="2011"
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014"
replace year="2015-2016" if year=="2015"
replace year="2016-2017" if year=="2016"

sort StateFIPS year
drop if year=="2017"

compress
save "data_for_analysis/intermediate/population_data.dta", replace



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////     percent white by year    //////////////////
////////////////////////////////////////////////////////////////////////////////

clear all
infix year 1-4 str state 5-6 StateFIPS 7-8 CountyFIPS 9-11 registry 12-13 race 14 origin 15 sex 16 age 17-18 population 19-27 ///
	using "temp/us.1969_2017.19ages.adjusted.txt"
keep if year>=1999

gen white_pop = . 
replace white_pop = pop if race == 1

gen male_pop = . 
replace male_pop = pop if sex == 1

gcollapse (sum) male_pop white_pop pop, by(StateFIPS year)

gen male_percent = male_pop/pop 
gen white_percent = white_pop/pop

compress
save "data_for_analysis/intermediate/population_by_year.dta", replace

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////     RACE    ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

clear all
infix year 1-4 str state 5-6 StateFIPS 7-8 CountyFIPS 9-11 registry 12-13 race 14 origin 15 sex 16 age 17-18 population 19-27 ///
	using "temp/us.1969_2017.19ages.adjusted.txt"
keep if year>=1999

  gen race2="white" if race==1
   replace race2="black" if race==2
   replace race2="othrace" if race==3 | race==4
   collapse (sum) population, by(StateFIPS  year race2)

   reshape wide population, i(StateFIPS year) j(race2) string
   
   gen seerpop= populationblack +populationothrace +populationwhite
   gen white=populationwhite/seerpop
		lab var white "Proportion of residents who are White"
   gen black=populationblack/seerpop
   		lab var black "Proportion of residents who are Black"
   gen othrace=populationothrace/seerpop      
		lab var othrace "Proportion of residents who are other race"

//Create averages to fit with NSDUH data (the average of 1999 and 2000 is attached to the year 1999
bysort StateFIPS (year): gen ave_white= (white + white[_n+1] ) / 2
bysort StateFIPS (year): gen ave_black= (black + black[_n+1] ) / 2
bysort StateFIPS (year): gen ave_othrace= (othrace + othrace[_n+1] ) / 2


tostring year, replace
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003"
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005"
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008"
replace year="2009-2010" if year=="2009"
replace year="2010-2011" if year=="2010"
replace year="2011-2012" if year=="2011"
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014"
replace year="2015-2016" if year=="2015"
replace year="2016-2017" if year=="2016"



drop if year=="2017"

keep year StateFIPS ave_white ave_black ave_othrace

sort StateFIPS year

compress
save "data_for_analysis/intermediate/race_data.dta", replace

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// POP BY RACE BY YEAR///////////////////////////
////////////////////////////////////////////////////////////////////////////////

clear all

*Unzip 
!unzip "raw_data/seer/us.1969_2018.singleages.adjusted.txt.zip" -d temp

infix year 1-4 str state 5-6 StateFIPS 7-8 CountyFIPS 9-11 registry 12-13 race 14 origin 15 sex 16 age 17-18 population 19-27 ///
	using "temp/us.1969_2018.singleages.adjusted.txt", clear

keep if year>=1999


gen juv = 0 
replace juv = 1 if age <= 18

gcollapse (sum) pop, by(StateFIPS juv year)

rename pop pop_
reshape wide pop_@, i(StateFIPS year) j(juv)
rename pop_1 pop_juv
rename pop_0 pop_adult 

compress
save "data_for_analysis/intermediate/pop_by_juv_by_year.dta", replace
!rm "temp/us.1969_2018.singleages.adjusted.txt"


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// SEX ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
clear all
infix year 1-4 str state 5-6 StateFIPS 7-8 CountyFIPS 9-11 registry 12-13 race 14 origin 15 sex 16 age 17-18 population 19-27 ///
	using "temp/us.1969_2017.19ages.adjusted.txt"
keep if year>=1999


label define sex 1 "Male" 2 "Female" 
label values sex sex
label variable sex "Gender"

keep if year>=1999

  gen sex2="male" if sex==1
   replace sex2="female" if sex==2
   collapse (sum) population, by(StateFIPS  year sex2)

   reshape wide population, i(StateFIPS year) j(sex2) string
   
   gen seerpop= populationmale +populationfemale
   gen male=populationmale/seerpop
   gen female=populationfemale/seerpop

//Create averages to fit with NSDUH data (the average of 1999 and 2000 is attached to the year 1999
bysort StateFIPS (year): gen ave_male= (male + male[_n+1] ) / 2
bysort StateFIPS (year): gen ave_female= (female + female[_n+1] ) / 2
	lab var ave_male "Proportion of residents who are male"
	
tostring year, replace
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003"
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005"
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008"
replace year="2009-2010" if year=="2009"
replace year="2010-2011" if year=="2010"
replace year="2011-2012" if year=="2011"
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014"
replace year="2015-2016" if year=="2015"
replace year="2016-2017" if year=="2016"



drop if year=="2017"

keep year StateFIPS ave_male

sort StateFIPS year

compress
save "data_for_analysis/intermediate/sex_data.dta", replace



////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ETHNICITY ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

///Note: Every value for ethnicity (origin) is "9" in the SEER data file used for 
///the other population variables, so I used a different file from SEER 
clear all
infix year 1-4 str state 5-6 StateFIPS 7-8 CountyFIPS 9-11 registry 12-13 race 14 origin 15 sex 16 age 17-18 population 19-27 ///
	using "temp/us.1990_2017.19ages.adjusted.txt"
keep if year>=1999


label define origin 0 "Non-Hispanic" 1 "Hispanic" 9 "NA" 
label values origin origin
label variable origin "Origin"

 gen eth="non_hisp" if origin==0
   replace eth="hisp" if origin==1
   collapse (sum) population, by(StateFIPS  year eth)

   reshape wide population, i(StateFIPS year) j(eth) string
   
   gen seerpop= populationnon_hisp +populationhisp
   gen hispanic=populationhisp/seerpop
		lab var hispanic "Proportion of population that is Hispanic"
   gen non_hispanic=populationnon_hisp/seerpop
   

//Create averages to fit with NSDUH data (the average of 1999 and 2000 is attached to the year 1999
bysort StateFIPS (year): gen ave_hisp= (hispanic + hispanic[_n+1] ) / 2

tostring year, replace
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003"
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005"
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008"
replace year="2009-2010" if year=="2009"
replace year="2010-2011" if year=="2010"
replace year="2011-2012" if year=="2011"
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014"
replace year="2015-2016" if year=="2015"
replace year="2016-2017" if year=="2016"


drop if year=="2017"

keep year StateFIPS hispanic

sort StateFIPS year

compress
save "data_for_analysis/intermediate/ethnicity_data.dta", replace




////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////   AGE     ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
clear all
infix year 1-4 str state 5-6 StateFIPS 7-8 CountyFIPS 9-11 registry 12-13 race 14 origin 15 sex 16 agegrp 17-18 population 19-27 ///
	using "temp/us.1969_2017.19ages.adjusted.txt"
keep if year>=1999

label define age 0 "<1" 1 "1-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65-69" 15 "70-74" 16 "75-79" 17 "80-84" 18 "85+"
lab val agegrp ages
label variable age "Age Group"

   
   gen age0_14=(agegrp<=3)
   gen age15_24=(agegrp>=4 & agegrp<=5)
   gen age25_44=(agegrp>=6 & agegrp<=10)
   gen age45_64=(agegrp>=10 & agegrp<=13)
   gen age65up=(agegrp>=14)
   
   gen agegrp2=(age0_14)
      replace agegrp2=2 if age15_24==1
      replace agegrp2=3 if age25_44==1
      replace agegrp2=4 if age45_64==1
      replace agegrp2=5 if age65up==1

	tostring agegrp2, replace
    collapse (sum) population, by(StateFIPS year agegrp2) 

    reshape wide population, i(StateFIPS year) j(agegrp2) string
	
	gen seerpop=population1 + population2 + population3 + population4 + population5
		gen age0_14=population1/seerpop
		gen age15_24=population2/seerpop
		gen age25_44=population3/seerpop
		gen age45_64=population4/seerpop
		gen age65up=population5/seerpop
		
bysort StateFIPS (year): gen ave_age0_14= (age0_14 + age0_14[_n+1] ) / 2
bysort StateFIPS (year): gen ave_age15_24= (age15_24 + age15_24[_n+1] ) / 2
bysort StateFIPS (year): gen ave_age25_44= (age25_44 + age25_44[_n+1] ) / 2
bysort StateFIPS (year): gen ave_age45_64= (age45_64 + age45_64[_n+1] ) / 2
bysort StateFIPS (year): gen ave_age65up= (age65up + age65up[_n+1] ) / 2


tostring year, replace
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003"
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005"
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008"
replace year="2009-2010" if year=="2009"
replace year="2010-2011" if year=="2010"
replace year="2011-2012" if year=="2011"
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014"
replace year="2015-2016" if year=="2015"
replace year="2016-2017" if year=="2016"

drop if year=="2017"

keep year StateFIPS age0_14 age15_24 age25_44 age45_64 age65up
	lab var age15_24 "Proportion of state aged 15-24"
	lab var age25_44 "Proportion of state aged 25-44"
	lab var age45_64 "Proportion of state aged 45-64"
	lab var age65up "Proportion of state aged 65 and older"

sort StateFIPS year

compress
save "data_for_analysis/intermediate/age_data.dta", replace


*Remove unzipped file
!rm "temp/us.1969_2017.19ages.adjusted.txt"
!rm "temp/us.1990_2017.19ages.adjusted.txt"

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////      Crime Stats      ////////////////////////////
////////////////////////////////////////////////////////////////////////////////


clear all
import excel "raw_data/crime/CrimeStatebyState.xlsx", sheet("CrimeStatebyState")  firstrow clear
keep st_abbrv year violent_crime property_crime
drop if missing(st_abbrv)
compress

gen StateFIPS=.					
replace StateFIPS=	15	if 	st_abbrv=="HI"
replace StateFIPS=	1	if 	st_abbrv=="AL"
replace StateFIPS=	2	if 	st_abbrv=="AK"
replace StateFIPS=	4	if 	st_abbrv=="AZ"
replace StateFIPS=	5	if 	st_abbrv=="AR"
replace StateFIPS=	6	if 	st_abbrv=="CA"
replace StateFIPS=	8	if 	st_abbrv=="CO"
replace StateFIPS=	9	if 	st_abbrv=="CT"
replace StateFIPS=	10	if 	st_abbrv=="DE"
replace StateFIPS=	11	if 	st_abbrv=="DC"
replace StateFIPS=	12	if 	st_abbrv=="FL"
replace StateFIPS=	13	if 	st_abbrv=="GA"
replace StateFIPS=	16	if 	st_abbrv=="ID"
replace StateFIPS=	17	if 	st_abbrv=="IL"
replace StateFIPS=	18	if 	st_abbrv=="IN"
replace StateFIPS=	19	if 	st_abbrv=="IA"
replace StateFIPS=	20	if 	st_abbrv=="KS"
replace StateFIPS=	21	if 	st_abbrv=="KY"
replace StateFIPS=	22	if 	st_abbrv=="LA"
replace StateFIPS=	23	if 	st_abbrv=="ME"
replace StateFIPS=	24	if 	st_abbrv=="MD"
replace StateFIPS=	25	if 	st_abbrv=="MA"
replace StateFIPS=	26	if 	st_abbrv=="MI"
replace StateFIPS=	27	if 	st_abbrv=="MN"
replace StateFIPS=	28	if 	st_abbrv=="MS"
replace StateFIPS=	29	if 	st_abbrv=="MO"
replace StateFIPS=	30	if 	st_abbrv=="MT"
replace StateFIPS=	31	if 	st_abbrv=="NE"
replace StateFIPS=	32	if 	st_abbrv=="NV"
replace StateFIPS=	33	if 	st_abbrv=="NH"
replace StateFIPS=	34	if 	st_abbrv=="NJ"
replace StateFIPS=	35	if 	st_abbrv=="NM"
replace StateFIPS=	36	if 	st_abbrv=="NY"
replace StateFIPS=	37	if 	st_abbrv=="NC"
replace StateFIPS=	38	if 	st_abbrv=="ND"
replace StateFIPS=	39	if 	st_abbrv=="OH"
replace StateFIPS=	40	if 	st_abbrv=="OK"
replace StateFIPS=	41	if 	st_abbrv=="OR"
replace StateFIPS=	42	if 	st_abbrv=="PA"
replace StateFIPS=	44	if 	st_abbrv=="RI"
replace StateFIPS=	45	if 	st_abbrv=="SC"
replace StateFIPS=	46	if 	st_abbrv=="SD"
replace StateFIPS=	47	if 	st_abbrv=="TN"
replace StateFIPS=	48	if 	st_abbrv=="TX"
replace StateFIPS=	49	if 	st_abbrv=="UT"
replace StateFIPS=	50	if 	st_abbrv=="VT"
replace StateFIPS=	51	if 	st_abbrv=="VA"
replace StateFIPS=	53	if 	st_abbrv=="WA"
replace StateFIPS=	54	if 	st_abbrv=="WV"
replace StateFIPS=	55	if 	st_abbrv=="WI"
replace StateFIPS=	56	if 	st_abbrv=="WY"

keep st_abbrv year StateFIPS property_crime violent_crime
destring violent_crime, replace
compress
save "temp/temp_crime_data.dta", replace

///// NOTE, DATA ONLY GOES TO 2014, SO MUST APPEND 2015 DATA

import excel "raw_data/crime/table_5_crime_in_the_united_states_by_state_2015.xlsx", cellrange(A5:N506)sheet("15tbl05")  clear
keep A B E K
rename E violent_crime
rename A state_name
rename K property_crime
gen year=2015

replace state_name=state_name[_n-1] if state_name==""
replace B="State Total" if state_name=="DISTRICT OF COLUMBIA4" & B=="Total"

keep if B=="State Total" 
drop B

//Remove superscripts that were attached to some state names
replace state_name="GEORGIA" if state_name=="GEORGIA5"
replace state_name="DISTRICT OF COLUMBIA" if state_name=="DISTRICT OF COLUMBIA4"
replace state_name="INDIANA" if state_name=="INDIANA6"
replace state_name="MAINE" if state_name=="MAINE6"
replace state_name="MISSISSIPPI" if state_name=="MISSISSIPPI6"
replace state_name="NEBRASKA" if state_name=="NEBRASKA6"
replace state_name="NEW MEXICO" if state_name=="NEW MEXICO5"
replace state_name="NEW YORK" if state_name=="NEW YORK6"
replace state_name="NORTH CAROLINA" if state_name=="NORTH CAROLINA5"
replace state_name="OHIO" if state_name=="OHIO6"
replace state_name="OREGON" if state_name=="OREGON6"
replace state_name="RHODE ISLAND" if state_name=="RHODE ISLAND6"
replace state_name="UTAH" if state_name=="UTAH6"
replace state_name="WASHINGTON" if state_name=="WASHINGTON6"
replace state_name="WISCONSIN" if state_name=="WISCONSIN6"

gen state_code=""

replace state_code ="AK" if state_name=="ALASKA"
replace state_code ="AL" if state_name=="ALABAMA"
replace state_code ="AR" if state_name=="ARKANSAS"
replace state_code ="AS" if state_name=="AMERICAN SAMOA"
replace state_code ="AZ" if state_name=="ARIZONA"
replace state_code ="CA" if state_name=="CALIFORNIA"
replace state_code ="CO" if state_name=="COLORADO"
replace state_code ="CT" if state_name=="CONNECTICUT"
replace state_code ="DC" if state_name=="DISTRICT OF COLUMBIA"
replace state_code ="DC" if state_name=="D.C."
replace state_code ="DE" if state_name=="DELAWARE"
replace state_code ="FL" if state_name=="FLORIDA"
replace state_code ="GA" if state_name=="GEORGIA"
replace state_code ="GU" if state_name=="GUAM"
replace state_code ="HI" if state_name=="HAWAII"
replace state_code ="IA" if state_name=="IOWA"
replace state_code ="ID" if state_name=="IDAHO"
replace state_code ="IL" if state_name=="ILLINOIS"
replace state_code ="IN" if state_name=="INDIANA"
replace state_code ="KS" if state_name=="KANSAS"
replace state_code ="KY" if state_name=="KENTUCKY"
replace state_code ="LA" if state_name=="LOUISIANA"
replace state_code ="MA" if state_name=="MASSACHUSETTS"
replace state_code ="MD" if state_name=="MARYLAND"
replace state_code ="ME" if state_name=="MAINE"
replace state_code ="MI" if state_name=="MICHIGAN"
replace state_code ="MN" if state_name=="MINNESOTA"
replace state_code ="MO" if state_name=="MISSOURI"
replace state_code ="MS" if state_name=="MISSISSIPPI"
replace state_code ="MT" if state_name=="MONTANA"
replace state_code ="NC" if state_name=="NORTH CAROLINA"
replace state_code ="ND" if state_name=="NORTH DAKOTA"
replace state_code ="NE" if state_name=="NEBRASKA"
replace state_code ="NH" if state_name=="NEW HAMPSHIRE"
replace state_code ="NJ" if state_name=="NEW JERSEY"
replace state_code ="NM" if state_name=="NEW MEXICO"
replace state_code ="NV" if state_name=="NEVADA"
replace state_code ="NY" if state_name=="NEW YORK"
replace state_code ="OH" if state_name=="OHIO"
replace state_code ="OK" if state_name=="OKLAHOMA"
replace state_code ="OR" if state_name=="OREGON"
replace state_code ="PA" if state_name=="PENNSYLVANIA"
replace state_code ="PR" if state_name=="PUERTO RICO"
replace state_code ="RI" if state_name=="RHODE ISLAND"
replace state_code ="SC" if state_name=="SOUTH CAROLINA"
replace state_code ="SD" if state_name=="SOUTH DAKOTA"
replace state_code ="TN" if state_name=="TENNESSEE"
replace state_code ="TX" if state_name=="TEXAS"
replace state_code ="UT" if state_name=="UTAH"
replace state_code ="VA" if state_name=="VIRGINIA"
replace state_code ="VI" if state_name=="VIRGIN ISLANDS"
replace state_code ="VT" if state_name=="VERMONT"
replace state_code ="WA" if state_name=="WASHINGTON"
replace state_code ="WI" if state_name=="WISCONSIN"
replace state_code ="WV" if state_name=="WEST VIRGINIA"
replace state_code ="WY" if state_name=="WYOMING"

rename state_code state

gen StateFIPS=.					
replace StateFIPS=	15	if 	state=="HI"
replace StateFIPS=	1	if 	state=="AL"
replace StateFIPS=	2	if 	state=="AK"
replace StateFIPS=	4	if 	state=="AZ"
replace StateFIPS=	5	if 	state=="AR"
replace StateFIPS=	6	if 	state=="CA"
replace StateFIPS=	8	if 	state=="CO"
replace StateFIPS=	9	if 	state=="CT"
replace StateFIPS=	10	if 	state=="DE"
replace StateFIPS=	11	if 	state=="DC"
replace StateFIPS=	12	if 	state=="FL"
replace StateFIPS=	13	if 	state=="GA"
replace StateFIPS=	16	if 	state=="ID"
replace StateFIPS=	17	if 	state=="IL"
replace StateFIPS=	18	if 	state=="IN"
replace StateFIPS=	19	if 	state=="IA"
replace StateFIPS=	20	if 	state=="KS"
replace StateFIPS=	21	if 	state=="KY"
replace StateFIPS=	22	if 	state=="LA"
replace StateFIPS=	23	if 	state=="ME"
replace StateFIPS=	24	if 	state=="MD"
replace StateFIPS=	25	if 	state=="MA"
replace StateFIPS=	26	if 	state=="MI"
replace StateFIPS=	27	if 	state=="MN"
replace StateFIPS=	28	if 	state=="MS"
replace StateFIPS=	29	if 	state=="MO"
replace StateFIPS=	30	if 	state=="MT"
replace StateFIPS=	31	if 	state=="NE"
replace StateFIPS=	32	if 	state=="NV"
replace StateFIPS=	33	if 	state=="NH"
replace StateFIPS=	34	if 	state=="NJ"
replace StateFIPS=	35	if 	state=="NM"
replace StateFIPS=	36	if 	state=="NY"
replace StateFIPS=	37	if 	state=="NC"
replace StateFIPS=	38	if 	state=="ND"
replace StateFIPS=	39	if 	state=="OH"
replace StateFIPS=	40	if 	state=="OK"
replace StateFIPS=	41	if 	state=="OR"
replace StateFIPS=	42	if 	state=="PA"
replace StateFIPS=	44	if 	state=="RI"
replace StateFIPS=	45	if 	state=="SC"
replace StateFIPS=	46	if 	state=="SD"
replace StateFIPS=	47	if 	state=="TN"
replace StateFIPS=	48	if 	state=="TX"
replace StateFIPS=	49	if 	state=="UT"
replace StateFIPS=	50	if 	state=="VT"
replace StateFIPS=	51	if 	state=="VA"
replace StateFIPS=	53	if 	state=="WA"
replace StateFIPS=	54	if 	state=="WV"
replace StateFIPS=	55	if 	state=="WI"
replace StateFIPS=	56	if 	state=="WY"

rename state st_abbrv
drop state_name 
destring violent_crime, replace
destring property_crime, replace

sort StateFIPS year
compress
save "temp/temp_crime_data2.dta", replace

///// NOTE, DATA ONLY GOES TO 2014, SO MUST APPEND 2016 DATA

import excel "raw_data/crime/table_3_crime_in_the_united_states_by_state_2016.xls", cellrange(A5:N506)sheet("16tbl03")  clear
keep A B E K
rename E violent_crime
rename A state_name
rename K property_crime
gen year=2016

replace state_name=state_name[_n-1] if state_name==""

replace B="State Total" if state_name=="DISTRICT OF COLUMBIA4" & B=="Total"

keep if B=="State Total"
drop B

//Remove superscripts that were attached to some state names
replace state_name="DISTRICT OF COLUMBIA" if state_name=="DISTRICT OF COLUMBIA4"
replace state_name="GEORGIA" if state_name=="GEORGIA5"
replace state_name="INDIANA" if state_name=="INDIANA6"
replace state_name="MAINE" if state_name=="MAINE6"
replace state_name="MISSISSIPPI" if state_name=="MISSISSIPPI6"
replace state_name="NEBRASKA" if state_name=="NEBRASKA6"
replace state_name="NEW MEXICO" if state_name=="NEW MEXICO5"
replace state_name="NEW YORK" if state_name=="NEW YORK6"
replace state_name="NORTH CAROLINA" if state_name=="NORTH CAROLINA5"
replace state_name="NEW MEXICO" if state_name=="NEW MEXICO6"
replace state_name="NORTH CAROLINA" if state_name=="NORTH CAROLINA6"
replace state_name="OHIO" if state_name=="OHIO6"
replace state_name="OKLAHOMA" if state_name=="OKLAHOMA6"
replace state_name="OREGON" if state_name=="OREGON6"
replace state_name="RHODE ISLAND" if state_name=="RHODE ISLAND6"
replace state_name="SOUTH DAKOTA" if state_name=="SOUTH DAKOTA6"
replace state_name="UTAH" if state_name=="UTAH6"
replace state_name="WASHINGTON" if state_name=="WASHINGTON6"
replace state_name="WISCONSIN" if state_name=="WISCONSIN6"

gen state_code=""

replace state_code ="AK" if state_name=="ALASKA"
replace state_code ="AL" if state_name=="ALABAMA"
replace state_code ="AR" if state_name=="ARKANSAS"
replace state_code ="AS" if state_name=="AMERICAN SAMOA"
replace state_code ="AZ" if state_name=="ARIZONA"
replace state_code ="CA" if state_name=="CALIFORNIA"
replace state_code ="CO" if state_name=="COLORADO"
replace state_code ="CT" if state_name=="CONNECTICUT"
replace state_code ="DC" if state_name=="DISTRICT OF COLUMBIA"
replace state_code ="DC" if state_name=="D.C."
replace state_code ="DE" if state_name=="DELAWARE"
replace state_code ="FL" if state_name=="FLORIDA"
replace state_code ="GA" if state_name=="GEORGIA"
replace state_code ="GU" if state_name=="GUAM"
replace state_code ="HI" if state_name=="HAWAII"
replace state_code ="IA" if state_name=="IOWA"
replace state_code ="ID" if state_name=="IDAHO"
replace state_code ="IL" if state_name=="ILLINOIS"
replace state_code ="IN" if state_name=="INDIANA"
replace state_code ="KS" if state_name=="KANSAS"
replace state_code ="KY" if state_name=="KENTUCKY"
replace state_code ="LA" if state_name=="LOUISIANA"
replace state_code ="MA" if state_name=="MASSACHUSETTS"
replace state_code ="MD" if state_name=="MARYLAND"
replace state_code ="ME" if state_name=="MAINE"
replace state_code ="MI" if state_name=="MICHIGAN"
replace state_code ="MN" if state_name=="MINNESOTA"
replace state_code ="MO" if state_name=="MISSOURI"
replace state_code ="MS" if state_name=="MISSISSIPPI"
replace state_code ="MT" if state_name=="MONTANA"
replace state_code ="NC" if state_name=="NORTH CAROLINA"
replace state_code ="ND" if state_name=="NORTH DAKOTA"
replace state_code ="NE" if state_name=="NEBRASKA"
replace state_code ="NH" if state_name=="NEW HAMPSHIRE"
replace state_code ="NJ" if state_name=="NEW JERSEY"
replace state_code ="NM" if state_name=="NEW MEXICO"
replace state_code ="NV" if state_name=="NEVADA"
replace state_code ="NY" if state_name=="NEW YORK"
replace state_code ="OH" if state_name=="OHIO"
replace state_code ="OK" if state_name=="OKLAHOMA"
replace state_code ="OR" if state_name=="OREGON"
replace state_code ="PA" if state_name=="PENNSYLVANIA"
replace state_code ="PR" if state_name=="PUERTO RICO"
replace state_code ="RI" if state_name=="RHODE ISLAND"
replace state_code ="SC" if state_name=="SOUTH CAROLINA"
replace state_code ="SD" if state_name=="SOUTH DAKOTA"
replace state_code ="TN" if state_name=="TENNESSEE"
replace state_code ="TX" if state_name=="TEXAS"
replace state_code ="UT" if state_name=="UTAH"
replace state_code ="VA" if state_name=="VIRGINIA"
replace state_code ="VI" if state_name=="VIRGIN ISLANDS"
replace state_code ="VT" if state_name=="VERMONT"
replace state_code ="WA" if state_name=="WASHINGTON"
replace state_code ="WI" if state_name=="WISCONSIN"
replace state_code ="WV" if state_name=="WEST VIRGINIA"
replace state_code ="WY" if state_name=="WYOMING"

rename state_code state

gen StateFIPS=.					
replace StateFIPS=	15	if 	state=="HI"
replace StateFIPS=	1	if 	state=="AL"
replace StateFIPS=	2	if 	state=="AK"
replace StateFIPS=	4	if 	state=="AZ"
replace StateFIPS=	5	if 	state=="AR"
replace StateFIPS=	6	if 	state=="CA"
replace StateFIPS=	8	if 	state=="CO"
replace StateFIPS=	9	if 	state=="CT"
replace StateFIPS=	10	if 	state=="DE"
replace StateFIPS=	11	if 	state=="DC"
replace StateFIPS=	12	if 	state=="FL"
replace StateFIPS=	13	if 	state=="GA"
replace StateFIPS=	16	if 	state=="ID"
replace StateFIPS=	17	if 	state=="IL"
replace StateFIPS=	18	if 	state=="IN"
replace StateFIPS=	19	if 	state=="IA"
replace StateFIPS=	20	if 	state=="KS"
replace StateFIPS=	21	if 	state=="KY"
replace StateFIPS=	22	if 	state=="LA"
replace StateFIPS=	23	if 	state=="ME"
replace StateFIPS=	24	if 	state=="MD"
replace StateFIPS=	25	if 	state=="MA"
replace StateFIPS=	26	if 	state=="MI"
replace StateFIPS=	27	if 	state=="MN"
replace StateFIPS=	28	if 	state=="MS"
replace StateFIPS=	29	if 	state=="MO"
replace StateFIPS=	30	if 	state=="MT"
replace StateFIPS=	31	if 	state=="NE"
replace StateFIPS=	32	if 	state=="NV"
replace StateFIPS=	33	if 	state=="NH"
replace StateFIPS=	34	if 	state=="NJ"
replace StateFIPS=	35	if 	state=="NM"
replace StateFIPS=	36	if 	state=="NY"
replace StateFIPS=	37	if 	state=="NC"
replace StateFIPS=	38	if 	state=="ND"
replace StateFIPS=	39	if 	state=="OH"
replace StateFIPS=	40	if 	state=="OK"
replace StateFIPS=	41	if 	state=="OR"
replace StateFIPS=	42	if 	state=="PA"
replace StateFIPS=	44	if 	state=="RI"
replace StateFIPS=	45	if 	state=="SC"
replace StateFIPS=	46	if 	state=="SD"
replace StateFIPS=	47	if 	state=="TN"
replace StateFIPS=	48	if 	state=="TX"
replace StateFIPS=	49	if 	state=="UT"
replace StateFIPS=	50	if 	state=="VT"
replace StateFIPS=	51	if 	state=="VA"
replace StateFIPS=	53	if 	state=="WA"
replace StateFIPS=	54	if 	state=="WV"
replace StateFIPS=	55	if 	state=="WI"
replace StateFIPS=	56	if 	state=="WY"

rename state st_abbrv
drop state_name 
destring violent_crime, replace
destring property_crime, replace

sort StateFIPS year
compress
save "temp/temp_crime_data3.dta", replace


///// NOTE, DATA ONLY GOES TO 2014, SO MUST APPEND 2017 DATA

import excel "raw_data/crime/table-5.xls", cellrange(A5:N509)sheet("17tbl05")  clear
keep A B E J
rename E violent_crime
rename A state_name
rename J property_crime
gen year=2017

replace state_name=state_name[_n-1] if state_name==""

replace B="State Total" if state_name=="DISTRICT OF COLUMBIA3" & B=="Total"

keep if B=="State Total"
drop B
compress

//Remove superscripts that were attached to some state names
replace state_name="DISTRICT OF COLUMBIA" if state_name=="DISTRICT OF COLUMBIA3"
replace state_name="NORTH CAROLINA" if state_name=="NORTH CAROLINA4"


gen state_code=""

replace state_code ="AK" if state_name=="ALASKA"
replace state_code ="AL" if state_name=="ALABAMA"
replace state_code ="AR" if state_name=="ARKANSAS"
replace state_code ="AS" if state_name=="AMERICAN SAMOA"
replace state_code ="AZ" if state_name=="ARIZONA"
replace state_code ="CA" if state_name=="CALIFORNIA"
replace state_code ="CO" if state_name=="COLORADO"
replace state_code ="CT" if state_name=="CONNECTICUT"
replace state_code ="DC" if state_name=="DISTRICT OF COLUMBIA"
replace state_code ="DC" if state_name=="D.C."
replace state_code ="DE" if state_name=="DELAWARE"
replace state_code ="FL" if state_name=="FLORIDA"
replace state_code ="GA" if state_name=="GEORGIA"
replace state_code ="GU" if state_name=="GUAM"
replace state_code ="HI" if state_name=="HAWAII"
replace state_code ="IA" if state_name=="IOWA"
replace state_code ="ID" if state_name=="IDAHO"
replace state_code ="IL" if state_name=="ILLINOIS"
replace state_code ="IN" if state_name=="INDIANA"
replace state_code ="KS" if state_name=="KANSAS"
replace state_code ="KY" if state_name=="KENTUCKY"
replace state_code ="LA" if state_name=="LOUISIANA"
replace state_code ="MA" if state_name=="MASSACHUSETTS"
replace state_code ="MD" if state_name=="MARYLAND"
replace state_code ="ME" if state_name=="MAINE"
replace state_code ="MI" if state_name=="MICHIGAN"
replace state_code ="MN" if state_name=="MINNESOTA"
replace state_code ="MO" if state_name=="MISSOURI"
replace state_code ="MS" if state_name=="MISSISSIPPI"
replace state_code ="MT" if state_name=="MONTANA"
replace state_code ="NC" if state_name=="NORTH CAROLINA"
replace state_code ="ND" if state_name=="NORTH DAKOTA"
replace state_code ="NE" if state_name=="NEBRASKA"
replace state_code ="NH" if state_name=="NEW HAMPSHIRE"
replace state_code ="NJ" if state_name=="NEW JERSEY"
replace state_code ="NM" if state_name=="NEW MEXICO"
replace state_code ="NV" if state_name=="NEVADA"
replace state_code ="NY" if state_name=="NEW YORK"
replace state_code ="OH" if state_name=="OHIO"
replace state_code ="OK" if state_name=="OKLAHOMA"
replace state_code ="OR" if state_name=="OREGON"
replace state_code ="PA" if state_name=="PENNSYLVANIA"
replace state_code ="PR" if state_name=="PUERTO RICO"
replace state_code ="RI" if state_name=="RHODE ISLAND"
replace state_code ="SC" if state_name=="SOUTH CAROLINA"
replace state_code ="SD" if state_name=="SOUTH DAKOTA"
replace state_code ="TN" if state_name=="TENNESSEE"
replace state_code ="TX" if state_name=="TEXAS"
replace state_code ="UT" if state_name=="UTAH"
replace state_code ="VA" if state_name=="VIRGINIA"
replace state_code ="VI" if state_name=="VIRGIN ISLANDS"
replace state_code ="VT" if state_name=="VERMONT"
replace state_code ="WA" if state_name=="WASHINGTON"
replace state_code ="WI" if state_name=="WISCONSIN"
replace state_code ="WV" if state_name=="WEST VIRGINIA"
replace state_code ="WY" if state_name=="WYOMING"

rename state_code state

gen StateFIPS=.					
replace StateFIPS=	15	if 	state=="HI"
replace StateFIPS=	1	if 	state=="AL"
replace StateFIPS=	2	if 	state=="AK"
replace StateFIPS=	4	if 	state=="AZ"
replace StateFIPS=	5	if 	state=="AR"
replace StateFIPS=	6	if 	state=="CA"
replace StateFIPS=	8	if 	state=="CO"
replace StateFIPS=	9	if 	state=="CT"
replace StateFIPS=	10	if 	state=="DE"
replace StateFIPS=	11	if 	state=="DC"
replace StateFIPS=	12	if 	state=="FL"
replace StateFIPS=	13	if 	state=="GA"
replace StateFIPS=	16	if 	state=="ID"
replace StateFIPS=	17	if 	state=="IL"
replace StateFIPS=	18	if 	state=="IN"
replace StateFIPS=	19	if 	state=="IA"
replace StateFIPS=	20	if 	state=="KS"
replace StateFIPS=	21	if 	state=="KY"
replace StateFIPS=	22	if 	state=="LA"
replace StateFIPS=	23	if 	state=="ME"
replace StateFIPS=	24	if 	state=="MD"
replace StateFIPS=	25	if 	state=="MA"
replace StateFIPS=	26	if 	state=="MI"
replace StateFIPS=	27	if 	state=="MN"
replace StateFIPS=	28	if 	state=="MS"
replace StateFIPS=	29	if 	state=="MO"
replace StateFIPS=	30	if 	state=="MT"
replace StateFIPS=	31	if 	state=="NE"
replace StateFIPS=	32	if 	state=="NV"
replace StateFIPS=	33	if 	state=="NH"
replace StateFIPS=	34	if 	state=="NJ"
replace StateFIPS=	35	if 	state=="NM"
replace StateFIPS=	36	if 	state=="NY"
replace StateFIPS=	37	if 	state=="NC"
replace StateFIPS=	38	if 	state=="ND"
replace StateFIPS=	39	if 	state=="OH"
replace StateFIPS=	40	if 	state=="OK"
replace StateFIPS=	41	if 	state=="OR"
replace StateFIPS=	42	if 	state=="PA"
replace StateFIPS=	44	if 	state=="RI"
replace StateFIPS=	45	if 	state=="SC"
replace StateFIPS=	46	if 	state=="SD"
replace StateFIPS=	47	if 	state=="TN"
replace StateFIPS=	48	if 	state=="TX"
replace StateFIPS=	49	if 	state=="UT"
replace StateFIPS=	50	if 	state=="VT"
replace StateFIPS=	51	if 	state=="VA"
replace StateFIPS=	53	if 	state=="WA"
replace StateFIPS=	54	if 	state=="WV"
replace StateFIPS=	55	if 	state=="WI"
replace StateFIPS=	56	if 	state=="WY"

rename state st_abbrv
drop state_name 
destring violent_crime, replace
destring property_crime, replace

sort StateFIPS year

compress
save "temp/temp_crime_data4.dta", replace


///Append three data files

use "temp/temp_crime_data.dta"
destring year, replace
append using "temp/temp_crime_data2.dta"
append using "temp/temp_crime_data3.dta"
append using "temp/temp_crime_data4.dta"

sort st_abbrv year


bysort StateFIPS (year): gen ave_property_crime= (property_crime + property_crime[_n+1] ) / 2
		lab var ave_property_crime "Number of reported property crimes in state"

bysort StateFIPS (year): gen ave_violent_crime= (violent_crime + violent_crime[_n+1] ) / 2
		lab var ave_violent_crime "Number of reported violent crimes in state"


tostring year, replace
replace year="1999-2000" if year=="1999"
replace year="2000-2001" if year=="2000"
replace year="2001-2002" if year=="2001"
replace year="2002-2003" if year=="2002"
replace year="2003-2004" if year=="2003"
replace year="2004-2005" if year=="2004"
replace year="2005-2006" if year=="2005"
replace year="2006-2007" if year=="2006"
replace year="2007-2008" if year=="2007"
replace year="2008-2009" if year=="2008"
replace year="2009-2010" if year=="2009"
replace year="2010-2011" if year=="2010"
replace year="2011-2012" if year=="2011"
replace year="2012-2013" if year=="2012"
replace year="2013-2014" if year=="2013"
replace year="2014-2015" if year=="2014"
replace year="2015-2016" if year=="2015"
replace year="2016-2017" if year=="2016"

drop if year=="2017"

keep st_abbrv year StateFIPS ave_property_crime ave_violent_crime

sort StateFIPS year

compress
save "data_for_analysis/intermediate/crime_data.dta", replace

// Clean up
erase "temp/temp_crime_data.dta"
erase "temp/temp_crime_data2.dta"
erase "temp/temp_crime_data3.dta"
erase "temp/temp_crime_data4.dta"
!rmdir temp/__MACOSX

