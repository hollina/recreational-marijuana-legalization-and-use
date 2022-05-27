// Clear memory
clear all

////////////////////////////////////////////////////////////////////////////////
////////////////////////       QUEST DIAGNOSTICS      //////////////////////////
////////////////////////////////////////////////////////////////////////////////

import excel "raw_data/quest/marijuana_by_state_year.xlsx", sheet("Sheet1") firstrow clear
rename StateAbbreviation state 
keep year* FIPS* state 

reshape long year_@, i(FIPSCode) j(year)
rename year_ percent_mj_positive

destring percent_mj_positive, replace
rename FIPSCode StateFIPS 

compress 
save "data_for_analysis/intermediate/percent_testing_positive_for_marijuana_by_state_year.dta", replace




	
////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////    SEER    //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
clear  

!unzip "raw_data/seer/us.1990_2018.19ages.adjusted.txt.zip" -d temp

infix year 1-4 str st 5-6 StateFIPS 7-8 countyfips 9-11 race 14 ///
   origin 15 sex 16 pop 19-27 ///
   using  "temp/us.1990_2018.19ages.adjusted.txt", clear
   

gen white = . 
replace white = pop if race == 1 & origin == 0

gen male = . 
replace male = pop if sex == 1 

gcollapse (sum) white male pop, by(StateFIPS year)

replace white = white/pop
replace male = male/pop

sort StateFIPS year

compress
save "data_for_analysis/intermediate/pop_male_white.dta", replace

!rm "temp/us.1990_2018.19ages.adjusted.txt"
	
////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////    MERGING    ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//Importing cannabis data 
use "data_for_analysis/intermediate/medical_marijuana_status_single_year.dta", clear
merge 1:1 StateFIPS year using "data_for_analysis/intermediate/unemployment_rate_by_year.dta" , keep(3) nogen
merge 1:1 StateFIPS year using "data_for_analysis/intermediate/median_income_by_year.dta",  keep(3) nogen
merge 1:1 StateFIPS year using "data_for_analysis/intermediate/pop_male_white.dta" , keep(3) nogen
merge 1:1 StateFIPS year using "data_for_analysis/intermediate/percent_testing_positive_for_marijuana_by_state_year.dta" , keep(3) nogen

* Add region 
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

* Add log
gen ln_percent_mj_positive  = ln(percent_mj_positive)

* Save
compress
save "data_for_analysis/quest_data.dta", replace

* Clean up
!rmdir temp/__MACOSX


