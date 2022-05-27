///////////////////////////////////////////////////////////////////////////////
// First use R to convert 1999 to 2015 NSDUH data from SAS to Stata format. 
///////////////////////////////////////////////////////////////////////////////

	// Call R script (requires packages pacman and haven)
	shell $r_path --vanilla < code/01-build/02.1.convert_nsduh_sas_data_to_dta_format.R 


///////////////////////////////////////////////////////////////////////////////
// Next make SAE data from the 2015-2016 wave
///////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////////
	// Create Marijuana Use in Past Year By Age (Table 1)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 9/77

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B mj_use_365_12_y_8
	label var  mj_use_365_12_y_8 "Marijuana Use in Past Year, 12+, 2008/2009 NSDUH"

	rename C mj_use_365_12_y_15
	label var  mj_use_365_12_y_15 "Marijuana Use in Past Year, 12+, 2015/2016 NSDUH"

	rename D mj_8_15_use_365_12_diff
	label var  mj_8_15_use_365_12_diff "P-value on difference in marijuana use in past year, 12+"

	rename E mj_use_365_12_17_y_8
	label var  mj_use_365_12_17_y_8 "Marijuana Use in Past Year, 12-17, 2008/2009 NSDUH"

	rename F mj_use_365_12_17_y_15
	label var  mj_use_365_12_17_y_15 "Marijuana Use in Past Year, 12-17, 2015/2016 NSDUH"

	rename G mj_8_15_use_365_12_17_diff
	label var  mj_8_15_use_365_12_17_diff "P-value on difference in marijuana use in past year, 12-17"

	rename H mj_use_365_18_25_y_8
	label var  mj_use_365_18_25_y_8 "Marijuana Use in Past Year, 18-25, 2008/2009 NSDUH"

	rename I mj_use_365_18_25_y_15
	label var  mj_use_365_18_25_y_15 "Marijuana Use in Past Year, 18-25, 2015/2016 NSDUH"

	rename J mj_8_15_use_365_18_25_diff
	label var  mj_8_15_use_365_18_25_diff "P-value on difference in marijuana use in past year, 18-25"


	rename K mj_use_365_26_y_8
	label var  mj_use_365_26_y_8 "Marijuana Use in Past Year, 26+, 2008/2009 NSDUH"

	rename L mj_use_365_26_y_15
	label var  mj_use_365_26_y_15 "Marijuana Use in Past Year, 26+, 2015/2016 NSDUH"

	rename M mj_8_15_use_365_26_diff
	label var  mj_8_15_use_365_26_diff "P-value on difference in marijuana use in past year, 26+"

	rename N mj_use_365_18_y_8
	label var  mj_use_365_18_y_8 "Marijuana Use in Past Year, 18+, 2008/2009 NSDUH"

	rename O mj_use_365_18_y_15
	label var  mj_use_365_18_y_15 "Marijuana Use in Past Year, 18+, 2015/2016 NSDUH"

	rename P mj_8_15_use_365_18_diff
	label var  mj_8_15_use_365_18_diff "P-value on difference in marijuana use in past year, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Save file
	save "temp/marijuana_use_in_past_365_days.dta", replace


	///////////////////////////////////////////////////////////////////////////////
	// Create Marijuana Use in Past 30 Days By Age (Table 2)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 98/157

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B mj_use_30_12_y_8
	label var  mj_use_30_12_y_8 "Marijuana Use in Past 30 days, 12+, 2008/2009 NSDUH"

	rename C mj_use_30_12_y_15
	label var  mj_use_30_12_y_15 "Marijuana Use in Past 30 days, 12+, 2015/2016 NSDUH"

	rename D mj_8_15_use_30_12_diff
	label var  mj_8_15_use_30_12_diff "P-value on difference in marijuana use in past 30 days, 12+"

	rename E mj_use_30_12_17_y_8
	label var  mj_use_30_12_17_y_8 "Marijuana Use in Past 30 days, 12-17, 2008/2009 NSDUH"

	rename F mj_use_30_12_17_y_15
	label var  mj_use_30_12_17_y_15 "Marijuana Use in Past 30 days, 12-17, 2015/2016 NSDUH"

	rename G mj_8_15_use_30_12_17_diff
	label var  mj_8_15_use_30_12_17_diff "P-value on difference in marijuana use in past 30 days, 12-17"

	rename H mj_use_30_18_25_y_8
	label var  mj_use_30_18_25_y_8 "Marijuana Use in Past 30 days, 18-25, 2008/2009 NSDUH"

	rename I mj_use_30_18_25_y_15
	label var  mj_use_30_18_25_y_15 "Marijuana Use in Past 30 days, 18-25, 2015/2016 NSDUH"

	rename J mj_8_15_use_30_18_25_diff
	label var  mj_8_15_use_30_18_25_diff "P-value on difference in marijuana use in past 30 days, 18-25"

	rename K mj_use_30_26_y_8
	label var  mj_use_30_26_y_8 "Marijuana Use in Past 30 days, 26+, 2008/2009 NSDUH"

	rename L mj_use_30_26_y_15
	label var  mj_use_30_26_y_15 "Marijuana Use in Past 30 days, 26+, 2015/2016 NSDUH"

	rename M mj_8_15_use_30_26_diff
	label var  mj_8_15_use_30_26_diff "P-value on difference in marijuana use in past 30 days, 26+"

	rename N mj_use_30_18_y_8
	label var  mj_use_30_18_y_8 "Marijuana Use in Past v, 18+, 2008/2009 NSDUH"

	rename O mj_use_30_18_y_15
	label var  mj_use_30_18_y_15 "Marijuana Use in Past 30 days, 18+, 2015/2016 NSDUH"

	rename P mj_8_15_use_30_18_diff
	label var  mj_8_15_use_30_18_diff "P-value on difference in marijuana use in past 30 days, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Save file
	save "temp/marijuana_use_in_past_30_days.dta", replace




	///////////////////////////////////////////////////////////////////////////////
	// Create First Marijuana Use Percent By Age (Table 3)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 178/237

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B mj_first_use_12_y_8
	label var  mj_first_use_12_y_8 "First use of marijuana, 12+, 2008/2009 NSDUH"

	rename C mj_first_use_12_y_15
	label var  mj_first_use_12_y_15 "First use of marijuana, 12+, 2015/2016 NSDUH"

	rename D mj_8_15_first_use_12_diff
	label var  mj_8_15_first_use_12_diff "P-value on difference in First use of marijuana, 12+"

	rename E mj_first_use_12_17_y_8
	label var  mj_first_use_12_17_y_8 "First use of marijuana, 12-17, 2008/2009 NSDUH"

	rename F mj_first_use_12_17_y_15
	label var  mj_first_use_12_17_y_15 "First use of marijuana, 12-17, 2015/2016 NSDUH"

	rename G mj_8_15_first_use_12_17_diff
	label var  mj_8_15_first_use_12_17_diff "P-value on difference in First use of marijuana, 12-17"

	rename H mj_first_use_18_25_y_8
	label var  mj_first_use_18_25_y_8 "First use of marijuana, 18-25, 2008/2009 NSDUH"

	rename I mj_first_use_18_25_y_15
	label var  mj_first_use_18_25_y_15 "First use of marijuana, 18-25, 2015/2016 NSDUH"

	rename J mj_8_15_first_use_18_25_diff
	label var  mj_8_15_first_use_18_25_diff "P-value on difference in First use of marijuana, 18-25"

	rename K mj_first_use_26_y_8
	label var  mj_first_use_26_y_8 "First use of marijuana, 26+, 2008/2009 NSDUH"

	rename L mj_first_use_26_y_15
	label var  mj_first_use_26_y_15 "First use of marijuana, 26+, 2015/2016 NSDUH"

	rename M mj_8_15_first_use_26_diff
	label var  mj_8_15_first_use_26_diff "P-value on difference in First use of marijuana, 26+"

	rename N mj_first_use_18_y_8
	label var  mj_first_use_18_y_8 "Marijuana Use in Past v, 18+, 2008/2009 NSDUH"

	rename O mj_first_use_18_y_15
	label var  mj_first_use_18_y_15 "First use of marijuana, 18+, 2015/2016 NSDUH"

	rename P mj_8_15_first_use_18_diff
	label var  mj_8_15_first_use_18_diff "P-value on difference in First use of marijuana, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Save file
	save "temp/marijuana_first_use.dta", replace
	///////////////////////////////////////////////////////////////////////////////
	// Create Cocaine Use in Past Year By Age (Table 4)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 262/321

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B coke_use_365_12_y_8
	label var  coke_use_365_12_y_8 "Cocaine Use in Past Year, 12+, 2008/2009 NSDUH"

	rename C coke_use_365_12_y_15
	label var  coke_use_365_12_y_15 "Cocaine Use in Past Year, 12+, 2015/2016 NSDUH"

	rename D coke_8_15_use_365_12_diff
	label var  coke_8_15_use_365_12_diff "P-value on difference in Cocaine use in past year, 12+"

	rename E coke_use_365_12_17_y_8
	label var  coke_use_365_12_17_y_8 "Cocaine Use in Past Year, 12-17, 2008/2009 NSDUH"

	rename F coke_use_365_12_17_y_15
	label var  coke_use_365_12_17_y_15 "Cocaine Use in Past Year, 12-17, 2015/2016 NSDUH"

	rename G coke_8_15_use_365_12_17_diff
	label var  coke_8_15_use_365_12_17_diff "P-value on difference in Cocaine use in past year, 12-17"

	rename H coke_use_365_18_25_y_8
	label var  coke_use_365_18_25_y_8 "Cocaine Use in Past Year, 18-25, 2008/2009 NSDUH"

	rename I coke_use_365_18_25_y_15
	label var  coke_use_365_18_25_y_15 "Cocaine Use in Past Year, 18-25, 2015/2016 NSDUH"

	rename J coke_8_15_use_365_18_25_diff
	label var  coke_8_15_use_365_18_25_diff "P-value on difference in Cocaine use in past year, 18-25"


	rename K coke_use_365_26_y_8
	label var  coke_use_365_26_y_8 "Cocaine Use in Past Year, 26+, 2008/2009 NSDUH"

	rename L coke_use_365_26_y_15
	label var  coke_use_365_26_y_15 "Cocaine Use in Past Year, 26+, 2015/2016 NSDUH"

	rename M coke_8_15_use_365_26_diff
	label var  coke_8_15_use_365_26_diff "P-value on difference in Cocaine use in past year, 26+"

	rename N coke_use_365_18_y_8
	label var  coke_use_365_18_y_8 "Cocaine Use in Past Year, 18+, 2008/2009 NSDUH"

	rename O coke_use_365_18_y_15
	label var  coke_use_365_18_y_15 "Cocaine Use in Past Year, 18+, 2015/2016 NSDUH"

	rename P coke_8_15_use_365_18_diff
	label var  coke_8_15_use_365_18_diff "P-value on difference in Cocaine use in past year, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Save file
	save "temp/cocaine_use_in_past_365_days.dta", replace

	///////////////////////////////////////////////////////////////////////////////
	// Create Alcohol Use in Past 30 Days By Age (Table 5)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 342/401

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B alc_use_30_12_y_8
	label var  alc_use_30_12_y_8 "Alcohol Use in Past 30 days, 12+, 2008/2009 NSDUH"

	rename C alc_use_30_12_y_15
	label var  alc_use_30_12_y_15 "Alcohol Use in Past 30 days, 12+, 2015/2016 NSDUH"

	rename D alc_8_15_use_30_12_diff
	label var  alc_8_15_use_30_12_diff "P-value on difference in Alcohol use in past 30 days, 12+"

	rename E alc_use_30_12_17_y_8
	label var  alc_use_30_12_17_y_8 "Alcohol Use in Past 30 days, 12-17, 2008/2009 NSDUH"

	rename F alc_use_30_12_17_y_15
	label var  alc_use_30_12_17_y_15 "Alcohol Use in Past 30 days, 12-17, 2015/2016 NSDUH"

	rename G alc_8_15_use_30_12_17_diff
	label var  alc_8_15_use_30_12_17_diff "P-value on difference in Alcohol use in past 30 days, 12-17"

	rename H alc_use_30_18_25_y_8
	label var  alc_use_30_18_25_y_8 "Alcohol Use in Past 30 days, 18-25, 2008/2009 NSDUH"

	rename I alc_use_30_18_25_y_15
	label var  alc_use_30_18_25_y_15 "Alcohol Use in Past 30 days, 18-25, 2015/2016 NSDUH"

	rename J alc_8_15_use_30_18_25_diff
	label var  alc_8_15_use_30_18_25_diff "P-value on difference in Alcohol use in past 30 days, 18-25"

	rename K alc_use_30_26_y_8
	label var  alc_use_30_26_y_8 "Alcohol Use in Past 30 days, 26+, 2008/2009 NSDUH"

	rename L alc_use_30_26_y_15
	label var  alc_use_30_26_y_15 "Alcohol Use in Past 30 days, 26+, 2015/2016 NSDUH"

	rename M alc_8_15_use_30_26_diff
	label var  alc_8_15_use_30_26_diff "P-value on difference in Alcohol use in past 30 days, 26+"

	rename N alc_use_30_18_y_8
	label var  alc_use_30_18_y_8 "Alcohol Use in Past v, 18+, 2008/2009 NSDUH"

	rename O alc_use_30_18_y_15
	label var  alc_use_30_18_y_15 "Alcohol Use in Past 30 days, 18+, 2015/2016 NSDUH"

	rename P alc_8_15_use_30_18_diff
	label var  alc_8_15_use_30_18_diff "P-value on difference in Alcohol use in past 30 days, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Save file
	save "temp/alcohol_use_in_past_30_days.dta", replace

	///////////////////////////////////////////////////////////////////////////////
	// Create Alcohol Use in Past 30 Days By Aged 12 to 20 (Table 6)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 422/481

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B alc_use_30_12_20_y_8
	label var  alc_use_30_12_20_y_8 "Alcohol Use in Past 30 days, 12-20, 2008/2009 NSDUH"

	rename C alc_use_30_12_20_y_15
	label var  alc_use_30_12_20_y_15 "Alcohol Use in Past 30 days, 12-20, 2015/2016 NSDUH"

	rename D alc_8_15_use_30_12_20_diff
	label var  alc_8_15_use_30_12_20_diff "P-value on difference in Alcohol use in past 30 days, 12+"


	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Drop if missing variable
	missings dropvars, force
	// Save file
	save "temp/alcohol_use_in_past_30_days_12_20.dta", replace

	///////////////////////////////////////////////////////////////////////////////
	// Create Tobacco Use in Past 30 Days By Age (Table 7)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 502/561

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B tob_use_30_12_y_8
	label var  tob_use_30_12_y_8 "Tobacco Use in Past 30 days, 12+, 2008/2009 NSDUH"

	rename C tob_use_30_12_y_15
	label var  tob_use_30_12_y_15 "Tobacco Use in Past 30 days, 12+, 2015/2016 NSDUH"

	rename D tob_8_15_use_30_12_diff
	label var  tob_8_15_use_30_12_diff "P-value on difference in Tobacco use in past 30 days, 12+"

	rename E tob_use_30_12_17_y_8
	label var  tob_use_30_12_17_y_8 "Tobacco Use in Past 30 days, 12-17, 2008/2009 NSDUH"

	rename F tob_use_30_12_17_y_15
	label var  tob_use_30_12_17_y_15 "Tobacco Use in Past 30 days, 12-17, 2015/2016 NSDUH"

	rename G tob_8_15_use_30_12_17_diff
	label var  tob_8_15_use_30_12_17_diff "P-value on difference in Tobacco use in past 30 days, 12-17"

	rename H tob_use_30_18_25_y_8
	label var  tob_use_30_18_25_y_8 "Tobacco Use in Past 30 days, 18-25, 2008/2009 NSDUH"

	rename I tob_use_30_18_25_y_15
	label var  tob_use_30_18_25_y_15 "Tobacco Use in Past 30 days, 18-25, 2015/2016 NSDUH"

	rename J tob_8_15_use_30_18_25_diff
	label var  tob_8_15_use_30_18_25_diff "P-value on difference in Tobacco use in past 30 days, 18-25"

	rename K tob_use_30_26_y_8
	label var  tob_use_30_26_y_8 "Tobacco Use in Past 30 days, 26+, 2008/2009 NSDUH"

	rename L tob_use_30_26_y_15
	label var  tob_use_30_26_y_15 "Tobacco Use in Past 30 days, 26+, 2015/2016 NSDUH"

	rename M tob_8_15_use_30_26_diff
	label var  tob_8_15_use_30_26_diff "P-value on difference in Tobacco use in past 30 days, 26+"

	rename N tob_use_30_18_y_8
	label var  tob_use_30_18_y_8 "Tobacco Use in Past v, 18+, 2008/2009 NSDUH"

	rename O tob_use_30_18_y_15
	label var  tob_use_30_18_y_15 "Tobacco Use in Past 30 days, 18+, 2015/2016 NSDUH"

	rename P tob_8_15_use_30_18_diff
	label var  tob_8_15_use_30_18_diff "P-value on difference in Tobacco use in past 30 days, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Save file
	save "temp/tobacco_use_in_past_30_days.dta", replace

	///////////////////////////////////////////////////////////////////////////////
	// Create Cigarette Use in Past 30 Days By Age (Table 8)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 583/642

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B cig_use_30_12_y_8
	label var  cig_use_30_12_y_8 "Cigarette Use in Past 30 days, 12+, 2008/2009 NSDUH"

	rename C cig_use_30_12_y_15
	label var  cig_use_30_12_y_15 "Cigarette Use in Past 30 days, 12+, 2015/2016 NSDUH"

	rename D cig_8_15_use_30_12_diff
	label var  cig_8_15_use_30_12_diff "P-value on difference in Cigarette use in past 30 days, 12+"

	rename E cig_use_30_12_17_y_8
	label var  cig_use_30_12_17_y_8 "Cigarette Use in Past 30 days, 12-17, 2008/2009 NSDUH"

	rename F cig_use_30_12_17_y_15
	label var  cig_use_30_12_17_y_15 "Cigarette Use in Past 30 days, 12-17, 2015/2016 NSDUH"

	rename G cig_8_15_use_30_12_17_diff
	label var  cig_8_15_use_30_12_17_diff "P-value on difference in Cigarette use in past 30 days, 12-17"

	rename H cig_use_30_18_25_y_8
	label var  cig_use_30_18_25_y_8 "Cigarette Use in Past 30 days, 18-25, 2008/2009 NSDUH"

	rename I cig_use_30_18_25_y_15
	label var  cig_use_30_18_25_y_15 "Cigarette Use in Past 30 days, 18-25, 2015/2016 NSDUH"

	rename J cig_8_15_use_30_18_25_diff
	label var  cig_8_15_use_30_18_25_diff "P-value on difference in Cigarette use in past 30 days, 18-25"

	rename K cig_use_30_26_y_8
	label var  cig_use_30_26_y_8 "Cigarette Use in Past 30 days, 26+, 2008/2009 NSDUH"

	rename L cig_use_30_26_y_15
	label var  cig_use_30_26_y_15 "Cigarette Use in Past 30 days, 26+, 2015/2016 NSDUH"

	rename M cig_8_15_use_30_26_diff
	label var  cig_8_15_use_30_26_diff "P-value on difference in Cigarette use in past 30 days, 26+"

	rename N cig_use_30_18_y_8
	label var  cig_use_30_18_y_8 "Cigarette Use in Past v, 18+, 2008/2009 NSDUH"

	rename O cig_use_30_18_y_15
	label var  cig_use_30_18_y_15 "Cigarette Use in Past 30 days, 18+, 2015/2016 NSDUH"

	rename P cig_8_15_use_30_18_diff
	label var  cig_8_15_use_30_18_diff "P-value on difference in Cigarette use in past 30 days, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Save file
	save "temp/cigarette_use_in_past_30_days.dta", replace
	///////////////////////////////////////////////////////////////////////////////
	// Create Alcohol Use Disorder Use in past 365 days By Age (Table 9)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeLongTermCHG2016.xlsx", sheet("PDFTables.com")

	// Keep only the section for this table
	keep in 663/722

	// Rename columns in logical way
	rename A state
	label var state "State Name"

	rename B aud_use_365_12_y_8
	label var  aud_use_365_12_y_8 "Alcohol Use Disorder Use in past 365 days, 12+, 2008/2009 NSDUH"

	rename C aud_use_365_12_y_15
	label var  aud_use_365_12_y_15 "Alcohol Use Disorder Use in past 365 days, 12+, 2015/2016 NSDUH"

	rename D aud_8_15_use_365_12_diff
	label var  aud_8_15_use_365_12_diff "P-value on difference in Alcohol Use Disorder use in past 365 days, 12+"

	rename E aud_use_365_12_17_y_8
	label var  aud_use_365_12_17_y_8 "Alcohol Use Disorder Use in past 365 days, 12-17, 2008/2009 NSDUH"

	rename F aud_use_365_12_17_y_15
	label var  aud_use_365_12_17_y_15 "Alcohol Use Disorder Use in past 365 days, 12-17, 2015/2016 NSDUH"

	rename G aud_8_15_use_365_12_17_diff
	label var  aud_8_15_use_365_12_17_diff "P-value on difference in Alcohol Use Disorder use in past 365 days, 12-17"

	rename H aud_use_365_18_25_y_8
	label var  aud_use_365_18_25_y_8 "Alcohol Use Disorder Use in past 365 days, 18-25, 2008/2009 NSDUH"

	rename I aud_use_365_18_25_y_15
	label var  aud_use_365_18_25_y_15 "Alcohol Use Disorder Use in past 365 days, 18-25, 2015/2016 NSDUH"

	rename J aud_8_15_use_365_18_25_diff
	label var  aud_8_15_use_365_18_25_diff "P-value on difference in Alcohol Use Disorder use in past 365 days, 18-25"

	rename K aud_use_365_26_y_8
	label var  aud_use_365_26_y_8 "Alcohol Use Disorder Use in past 365 days, 26+, 2008/2009 NSDUH"

	rename L aud_use_365_26_y_15
	label var  aud_use_365_26_y_15 "Alcohol Use Disorder Use in past 365 days, 26+, 2015/2016 NSDUH"

	rename M aud_8_15_use_365_26_diff
	label var  aud_8_15_use_365_26_diff "P-value on difference in Alcohol Use Disorder use in past 365 days, 26+"

	rename N aud_use_365_18_y_8
	label var  aud_use_365_18_y_8 "Alcohol Use Disorder Use in Past v, 18+, 2008/2009 NSDUH"

	rename O aud_use_365_18_y_15
	label var  aud_use_365_18_y_15 "Alcohol Use Disorder Use in past 365 days, 18+, 2015/2016 NSDUH"

	rename P aud_8_15_use_365_18_diff
	label var  aud_8_15_use_365_18_diff "P-value on difference in Alcohol Use Disorder use in past 365 days, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}

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

	// Save file
	save "temp/alcohol_use_disorder_use_in_past_365_days.dta", replace

	// Display Change by Drug by Use
	use "temp/marijuana_use_in_past_365_days.dta", clear
	merge 1:1 StateFIPS using "temp/alcohol_use_disorder_use_in_past_365_days.dta", nogen
	merge 1:1 StateFIPS using "temp/cocaine_use_in_past_365_days.dta", nogen
	merge 1:1 StateFIPS using "temp/alcohol_use_in_past_30_days.dta", nogen
	merge 1:1 StateFIPS using "temp/cigarette_use_in_past_30_days.dta", nogen
	merge 1:1 StateFIPS using "temp/marijuana_use_in_past_30_days.dta", nogen
	merge 1:1 StateFIPS using "temp/tobacco_use_in_past_30_days.dta", nogen
	merge 1:1 StateFIPS using "temp/marijuana_first_use.dta", nogen
	merge 1:1 StateFIPS using "temp/alcohol_use_in_past_30_days_12_20.dta", nogen

	erase "temp/marijuana_use_in_past_365_days.dta"
	erase "temp/alcohol_use_disorder_use_in_past_365_days.dta"
	erase "temp/cocaine_use_in_past_365_days.dta"
	erase "temp/alcohol_use_in_past_30_days.dta"
	erase "temp/cigarette_use_in_past_30_days.dta"
	erase "temp/marijuana_use_in_past_30_days.dta"
	erase "temp/marijuana_first_use.dta"
	erase "temp/alcohol_use_in_past_30_days_12_20.dta"

	// Merge in state population in 2013
	merge 1:1 StateFIPS using "data_for_analysis/intermediate/state_population_2013.dta", nogen


	// Apply treatment variable
	gen recreational_marijuana = 0
	replace recreational_marijuana =1 if state=="District of Columbia"
	replace recreational_marijuana =1 if state=="Washington"
	replace recreational_marijuana =1 if state=="Oregon"
	replace recreational_marijuana =1 if state=="Alaska"
	replace recreational_marijuana =1 if state=="Colorado"


	// Generate Marijuana intensity change. 
	local age_list  12 12_17 18 18_25 26
	foreach age in `age_list' {
		gen mj_use_ratio_`age'_y_8 = (mj_use_30_`age'_y_8/mj_use_365_`age'_y_8)*100
		gen mj_use_ratio_`age'_y_15 = (mj_use_30_`age'_y_15/mj_use_365_`age'_y_15)*100
	} 


	// Create local macro 
	reshape long ///
		mj_use_365_12_y_@ ///
		mj_use_365_18_y_@ ///
		mj_use_365_26_y_@ ///
		mj_use_365_12_17_y_@ ///
		mj_use_365_18_25_y_@ ///
		aud_use_365_12_y_@ ///
		aud_use_365_18_y_@ ///
		aud_use_365_26_y_@ ///
		aud_use_365_12_17_y_@ ///
		aud_use_365_18_25_y_@ ///
		coke_use_365_12_y_@ ///
		coke_use_365_18_y_@ ///
		coke_use_365_26_y_@ ///
		coke_use_365_12_17_y_@ ///
		coke_use_365_18_25_y_@ ///
		mj_use_30_12_y_@ ///
		mj_use_30_18_y_@ ///
		mj_use_30_26_y_@ ///
		mj_use_30_12_17_y_@ ///
		mj_use_30_18_25_y_@ ///		
		tob_use_30_12_y_@ ///
		tob_use_30_18_y_@ ///
		tob_use_30_26_y_@ ///
		tob_use_30_12_17_y_@ ///
		tob_use_30_18_25_y_@ ///		
		cig_use_30_12_y_@ ///
		cig_use_30_18_y_@ ///
		cig_use_30_26_y_@ ///
		cig_use_30_12_17_y_@ ///
		cig_use_30_18_25_y_@ ///
		alc_use_30_12_y_@ ///
		alc_use_30_18_y_@ ///
		alc_use_30_26_y_@ ///
		alc_use_30_12_17_y_@ ///
		alc_use_30_18_25_y_@ ///	
		alc_use_30_12_20_y_@ ///	
		mj_first_use_12_y_@ ///
		mj_use_ratio_12_y_@ ///
		mj_first_use_18_y_@ ///
		mj_use_ratio_18_y_@ ///
		mj_first_use_26_y_@ ///
		mj_use_ratio_26_y_@ ///
		mj_first_use_12_17_y_@ ///
		mj_use_ratio_12_17_y_@ ///
		mj_first_use_18_25_y_@ ///
		mj_use_ratio_18_25_y_@ ///
		, i(StateFIPS) j(year)
		
		
	// Clean up variable names
	rename *_y_ *

	// Drop what we don't need
	drop *diff

	// Clean up year 
	replace year = 2000+ year

	// Keep only 2015-2016
	keep if year==2015

	drop recreational_marijuana
	*rename *_ *
	drop year 
	drop pop*
	gen year = "2015-2016"

	// Save file
	compress
	save "temp/nsduh_15_16.dta", replace
	
///////////////////////////////////////////////////////////////////////////////
// Next make SAE data from the 2016-2017 wave
///////////////////////////////////////////////////////////////////////////////

	// Create Marijuana Use in Past Year By Age (Table 2)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 2") cellrange(B11:Q61)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C mj_use_365_12
	label var  mj_use_365_12 "Marijuana Use in Past Year, 12+"

	rename F mj_use_365_12_17
	label var  mj_use_365_12_17 "Marijuana Use in Past Year, 12-17"

	rename I mj_use_365_18_25
	label var  mj_use_365_18_25"Marijuana Use in Past Year, 18-25"

	rename L mj_use_365_26
	label var  mj_use_365_26 "Marijuana Use in Past Year, 26+"

	rename O mj_use_365_18
	label var  mj_use_365_18 "Marijuana Use in Past Year, 18+"

	drop D E G H J K M N P Q

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"



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

	drop _merge

	///Turning percents into 1-100
	replace mj_use_365_12=mj_use_365_12*100
	replace mj_use_365_12_17=mj_use_365_12_17*100
	replace mj_use_365_18_25=mj_use_365_18_25*100
	replace mj_use_365_26=mj_use_365_26*100
	replace mj_use_365_18=mj_use_365_18*100

	// Save file
	save "temp/marijuana_use_in_past_365_days_17.dta", replace


	///////////////////////////////////////////////////////////////////////////////
	// Create Marijuana Use in Past 30 Days By Age (Table 3)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 3") cellrange(B11:Q61)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C mj_use_30_12
	label var  mj_use_30_12 "Marijuana Use in Past 30 Days, 12+"

	rename F mj_use_30_12_17
	label var  mj_use_30_12_17 "Marijuana Use in Past 30 Days, 12-17"

	rename I mj_use_30_18_25
	label var  mj_use_30_18_25"Marijuana Use in Past 30 Days, 18-25"

	rename L mj_use_30_26
	label var  mj_use_30_26 "Marijuana Use in Past 30 Days, 26+"

	rename O mj_use_30_18
	label var  mj_use_30_18 "Marijuana Use in Past 30 Days, 18+"

	drop D E G H J K M N P Q
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"

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


	///Turning percents into 1-100
	replace mj_use_30_12=mj_use_30_12*100
	replace mj_use_30_12_17=mj_use_30_12_17*100
	replace mj_use_30_18_25=mj_use_30_18_25*100
	replace mj_use_30_26=mj_use_30_26*100
	replace mj_use_30_18=mj_use_30_18*100


	// Save file
	save "temp/marijuana_use_in_past_30_days_17.dta", replace



	///////////////////////////////////////////////////////////////////////////////
	// Create First Marijuana Use Percent By Age (Table 5)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 5") cellrange(B12:Q62)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C mj_first_use_12
	label var  mj_first_use_12 "First use of marijuana, 12+"

	rename F mj_first_use_12_17
	label var  mj_first_use_12_17 "First use of marijuana, 12-17"

	rename I mj_first_use_18_25
	label var  mj_first_use_18_25"First use of marijuana, 18-25"

	rename L mj_first_use_26
	label var  mj_first_use_26 "First use of marijuana, 26+"

	rename O mj_first_use_18
	label var  mj_first_use_18 "First use of marijuana, 18+"

	drop D E G H J K M N P Q

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


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


	///Turning percents into 1-100
	replace mj_first_use_12=mj_first_use_12*100
	replace mj_first_use_12_17=mj_first_use_12_17*100
	replace mj_first_use_18_25=mj_first_use_18_25*100
	replace mj_first_use_26=mj_first_use_26*100
	replace mj_first_use_18=mj_first_use_18*100


	// Save file
	save "temp/marijuana_first_use_17.dta", replace


	///////////////////////////////////////////////////////////////////////////////
	// Create Cocaine Use in Past Year By Age (Table 7)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 7") cellrange(B11:Q61)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C coke_use_365_12
	label var  coke_use_365_12 "Cocaine use in past year, 12+"

	rename F coke_use_365_12_17
	label var  coke_use_365_12_17 "Cocaine use in past year, 12-17"

	rename I coke_use_365_18_25
	label var  coke_use_365_18_25"Cocaine use in past year, 18-25"

	rename L coke_use_365_26
	label var  coke_use_365_26 "Cocaine use in past year, 26+"

	rename O coke_use_365_18
	label var  coke_use_365_18 "Cocaine use in past year, 18+"

	drop D E G H J K M N P Q


	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"

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

	///Turning percents into 1-100
	replace coke_use_365_12=coke_use_365_12*100
	replace coke_use_365_12_17=coke_use_365_12_17*100
	replace coke_use_365_18_25=coke_use_365_18_25*100
	replace coke_use_365_26=coke_use_365_26*100
	replace coke_use_365_18=coke_use_365_18*100

	// Save file
	save "temp/cocaine_use_in_past_365_days_17.dta", replace

	///////////////////////////////////////////////////////////////////////////////
	// Create Alcohol Use in Past 30 Days By Age (Table 13)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 13") cellrange(B11:Q61)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C alc_use_30_12
	label var  alc_use_30_12 "Alcohol use in past 30 days, 12+"

	rename F alc_use_30_12_17
	label var  alc_use_30_12_17 "Alcohol use in past 30 days, 12-17"

	rename I alc_use_30_18_25
	label var  alc_use_30_18_25"Alcohol use in past 30 days, 18-25"

	rename L alc_use_30_26
	label var  alc_use_30_26 "Alcohol use in past 30 days, 26+"

	rename O alc_use_30_18
	label var  alc_use_30_18 "Alcohol use in past 30 days, 18+"

	drop D E G H J K M N P Q
	 
	///Turning percents into 1-100
	replace alc_use_30_12=alc_use_30_12*100
	replace alc_use_30_12_17=alc_use_30_12_17*100
	replace alc_use_30_18_25=alc_use_30_18_25*100
	replace alc_use_30_26=alc_use_30_26*100
	replace alc_use_30_18=alc_use_30_18*100


	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


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


	// Save file
	save "temp/alcohol_use_in_past_30_days_17.dta", replace

	///////////////////////////////////////////////////////////////////////////////
	// Create Alcohol Use and Binge Alcohol Use in Past 30 Days By Aged 12 to 20 (Table 16)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 16") cellrange(B12:H62)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C alc_use_30_12_20
	label var  alc_use_30_12_20 "Alcohol use in past 30 days, 12-20"

	keep state alc_use_30_12_20
	 
	///Turning percents into 1-100
	replace alc_use_30_12_20=alc_use_30_12_20*100


	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"

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


	// Save file
	save "temp/alcohol_use_in_past_30_days_12_20_17.dta", replace

	///////////////////////////////////////////////////////////////////////////////
	// Create Tobacco Use in Past 30 Days By Age (Table 17)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 17") cellrange(B12:Q62)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C tob_use_30_12
	label var  tob_use_30_12 "Tobacco use in past 30 days, 12+"

	rename F tob_use_30_12_17
	label var  tob_use_30_12_17 "Tobacco use in past 30 days, 12-17"

	rename I tob_use_30_18_25
	label var  tob_use_30_18_25"Tobacco use in past 30 days, 18-25"

	rename L tob_use_30_26
	label var  tob_use_30_26 "Tobacco use in past 30 days, 26+"

	rename O tob_use_30_18
	label var  tob_use_30_18 "Tobacco use in past 30 days, 18+"

	drop D E G H J K M N P Q
	 
	///Turning percents into 1-100
	replace tob_use_30_12=tob_use_30_12*100
	replace tob_use_30_12_17=tob_use_30_12_17*100
	replace tob_use_30_18_25=tob_use_30_18_25*100
	replace tob_use_30_26=tob_use_30_26*100
	replace tob_use_30_18=tob_use_30_18*100
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


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

	// Save file
	save "temp/tobacco_use_in_past_30_days_17.dta", replace

	///////////////////////////////////////////////////////////////////////////////
	// Create Cigarette Use in Past 30 Days By Age (Table 18)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 18") cellrange(B11:Q61)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C cig_use_30_12
	label var  cig_use_30_12 "Cigarette use in past 30 days, 12+"

	rename F cig_use_30_12_17
	label var  cig_use_30_12_17 "Cigarette use in past 30 days, 12-17"

	rename I cig_use_30_18_25
	label var  cig_use_30_18_25"Cigarette use in past 30 days, 18-25"

	rename L cig_use_30_26
	label var  cig_use_30_26 "Cigarette use in past 30 days, 26+"

	rename O cig_use_30_18
	label var  cig_use_30_18 "Cigarette use in past 30 days, 18+"

	drop D E G H J K M N P Q
	 
	///Turning percents into 1-100
	replace cig_use_30_12=cig_use_30_12*100
	replace cig_use_30_12_17=cig_use_30_12_17*100
	replace cig_use_30_18_25=cig_use_30_18_25*100
	replace cig_use_30_26=cig_use_30_26*100
	replace cig_use_30_18=cig_use_30_18*100
	 

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"

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

	// Save file
	save "temp/cigarette_use_in_past_30_days_17.dta", replace


	///////////////////////////////////////////////////////////////////////////////
	// Create Alcohol Use Disorder Use in past 365 days By Age (Table 22)

	// Clear memory
	clear all

	// Import Excel Sheet
	import excel "raw_data/nsduh/NSDUHsaeExcelTabs2017.xls", sheet("Table 22") cellrange(B12:Q62)


	// Rename columns in logical way
	rename B state
	label var state "State Name"

	rename C aud_use_365_12
	label var  aud_use_365_12 "Alcohol Use Disorder use in past 365 days, 12+"

	rename F aud_use_365_12_17
	label var  aud_use_365_12_17 "Alcohol Use Disorder use in past 365 days, 12-17"

	rename I aud_use_365_18_25
	label var  aud_use_365_18_25"Alcohol Use Disorder use in past 365 days, 18-25"

	rename L aud_use_365_26
	label var  aud_use_365_26 "Alcohol Use Disorder use in past 365 days, 26+"

	rename O aud_use_365_18
	label var  aud_use_365_18 "Alcohol Use Disorder use in past 365 days, 18+"

	drop D E G H J K M N P Q
	 
	///Turning percents into 1-100
	replace aud_use_365_12=aud_use_365_12*100
	replace aud_use_365_12_17=aud_use_365_12_17*100
	replace aud_use_365_18_25=aud_use_365_18_25*100
	replace aud_use_365_26=aud_use_365_26*100
	replace aud_use_365_18=aud_use_365_18*100

	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"

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

	// Save file
	save "temp/alcohol_use_disorder_use_in_past_365_days_17.dta", replace


	// Display Change by Drug by Use
	use  "temp/marijuana_use_in_past_365_days_17.dta", clear
	merge 1:1 StateFIPS using "temp/alcohol_use_disorder_use_in_past_365_days_17.dta", nogen
	merge 1:1 StateFIPS using "temp/cocaine_use_in_past_365_days_17.dta", nogen
	merge 1:1 StateFIPS using "temp/alcohol_use_in_past_30_days_17.dta", nogen
	merge 1:1 StateFIPS using "temp/cigarette_use_in_past_30_days_17.dta", nogen
	merge 1:1 StateFIPS using "temp/marijuana_use_in_past_30_days_17.dta", nogen
	merge 1:1 StateFIPS using "temp/tobacco_use_in_past_30_days_17.dta", nogen
	merge 1:1 StateFIPS using "temp/marijuana_first_use_17.dta", nogen
	merge 1:1 StateFIPS using "temp/alcohol_use_in_past_30_days_12_20_17.dta", nogen

	erase "temp/marijuana_use_in_past_365_days_17.dta"
	erase "temp/alcohol_use_disorder_use_in_past_365_days_17.dta"
	erase "temp/cocaine_use_in_past_365_days_17.dta"
	erase "temp/alcohol_use_in_past_30_days_17.dta"
	erase "temp/cigarette_use_in_past_30_days_17.dta"
	erase "temp/marijuana_use_in_past_30_days_17.dta"
	erase "temp/marijuana_first_use_17.dta"
	erase "temp/alcohol_use_in_past_30_days_12_20_17.dta"
	erase "temp/tobacco_use_in_past_30_days.dta"
	erase "temp/tobacco_use_in_past_30_days_17.dta"


	gen year = "2016-2017"

	// Save file
	save "temp/nsduh_16_17.dta", replace
	
///////////////////////////////////////////////////////////////////////////////
// Clearn up 1999 to 2015 NSDUH data to match other two waves
///////////////////////////////////////////////////////////////////////////////


	// Clear memory
	clear all

	// Import Data File
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae

	// Rename columns in logical way
	rename state StateFIPS
	rename stname state
		label var state "State Name"

	///NOTE: (MRJYR available for 2002-2003 and beyond, but small area estimates were not produced for this outcome in prior years),
	gen mj_use_365_12=0
		replace mj_use_365_12=bsae if outcome=="MRJYR" & agegrp==0
		label var  mj_use_365_12 "Marijuana Use in Past Year, 12+"

	gen mj_use_365_12_17=0
		replace mj_use_365_12_17=bsae if outcome=="MRJYR" & agegrp==1
		label var  mj_use_365_12_17 "Marijuana Use in Past Year, 12-17"

	gen mj_use_365_18_25=0
		replace mj_use_365_18_25=bsae if outcome=="MRJYR" & agegrp==2
		label var  mj_use_365_18_25 "Marijuana Use in Past Year, 18-25"

	gen mj_use_365_26=0
		replace mj_use_365_26=bsae if outcome=="MRJYR" & agegrp==3
		label var  mj_use_365_26 "Marijuana Use in Past Year, 26+"

	gen mj_use_365_18=0
		replace mj_use_365_18=bsae if outcome=="MRJYR" & agegrp==4
		label var  mj_use_365_18 "Marijuana Use in Past Year, 18+"


	// Merge in state abbreviation information (Should be 51)
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/


	bysort state pyear: egen mj_use_365_12_1=max(mj_use_365_12)
	bysort state pyear: egen mj_use_365_12_17_1=max(mj_use_365_12_17)
	bysort state pyear: egen mj_use_365_18_25_1=max(mj_use_365_18_25)
	bysort state pyear: egen mj_use_365_26_1=max(mj_use_365_26)
	bysort state pyear: egen mj_use_365_18_1=max(mj_use_365_18)

	replace mj_use_365_12=mj_use_365_12_1
	replace mj_use_365_12_17=mj_use_365_12_17_1
	replace mj_use_365_18_25=mj_use_365_18_25_1
	replace mj_use_365_26=mj_use_365_26_1
	replace mj_use_365_18=mj_use_365_18_1

	drop mj_use_365_12_1 mj_use_365_12_17_1 mj_use_365_18_25_1 mj_use_365_26_1 mj_use_365_18_1

	bysort state pyear: keep if _n==1

	sort state pyear

	// Save file
	save "temp/marijuana_use_in_past_365_days2.dta", replace


	////////////////////////////////////////////////////////////////////////////////
	////////////Create Marijuana Use in Past 30 Days By Age  ///////////////
	////////////////////////////////////////////////////////////////////////////////


	// Clear memory
	clear all

	// Import NSDUH data
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae

	gen mj_use_30_12=0
		replace mj_use_30_12=bsae if outcome=="MRJMON" & agegrp==0
		label var  mj_use_30_12 "Marijuana Use in Past 30 days, 12+"

	gen mj_use_30_12_17=0
		replace mj_use_30_12_17=bsae if outcome=="MRJMON" & agegrp==1
		label var  mj_use_30_12_17 "Marijuana Use in Past 30 days, 12-17"

	gen mj_use_30_18_25=0
		replace mj_use_30_18_25=bsae if outcome=="MRJMON" & agegrp==2
		label var  mj_use_30_18_25 "Marijuana Use in Past 30 days, 18-25"

	gen mj_use_30_26=0
		replace mj_use_30_26=bsae if outcome=="MRJMON" & agegrp==3
		label var  mj_use_30_26 "Marijuana Use in Past 30 days, 26+"

	gen mj_use_30_18=0
		replace mj_use_30_18=bsae if outcome=="MRJMON" & agegrp==4
		label var  mj_use_30_18 "Marijuana Use in Past 30 days, 18+"


	// Merge in state abbreviation information (Should be 51)
	rename state fips
	rename stname state
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"
	rename fips  StateFIPS		

	// Remove leading/lagging spaces
	compress

	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/

	bysort state pyear: egen mj_use_30_12_1=max(mj_use_30_12)
	bysort state pyear: egen mj_use_30_12_17_1=max(mj_use_30_12_17)
	bysort state pyear: egen mj_use_30_18_25_1=max(mj_use_30_18_25)
	bysort state pyear: egen mj_use_30_26_1=max(mj_use_30_26)
	bysort state pyear: egen mj_use_30_18_1=max(mj_use_30_18)

	replace mj_use_30_12=mj_use_30_12_1
	replace mj_use_30_12_17=mj_use_30_12_17_1
	replace mj_use_30_18_25=mj_use_30_18_25_1
	replace mj_use_30_26=mj_use_30_26_1
	replace mj_use_30_18=mj_use_30_18_1

	drop mj_use_30_12_1 mj_use_30_12_17_1 mj_use_30_18_25_1 mj_use_30_26_1 mj_use_30_18_1

	bysort state pyear: keep if _n==1

	sort state pyear

	// Save file
	save "temp/marijuana_use_in_past_30_days2.dta", replace


	////////////////////////////////////////////////////////////////////////////////
	/////////////Create First Marijuana Use Percent By Age  ////////////////
	////////////////////////////////////////////////////////////////////////////////

	// Import NSDUH data
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae

	gen mj_first_use_12=0
		replace mj_first_use_12=bsae if outcome=="INCIDENCE" & agegrp==0
		label var  mj_first_use_12 "First use of marijuana, 12+"

	gen mj_first_use_12_17=0
		replace mj_first_use_12_17=bsae if outcome=="INCIDENCE" & agegrp==1
		label var  mj_first_use_12_17 "First use of marijuana, 12-17"

	gen mj_first_use_18_25=0
		replace mj_first_use_18_25=bsae if outcome=="INCIDENCE" & agegrp==2
		label var  mj_first_use_18_25 "First use of marijuana, 18-25"

	gen mj_first_use_26=0
		replace mj_first_use_26=bsae if outcome=="INCIDENCE" & agegrp==3
		label var  mj_first_use_26 "First use of marijuana, 26+"

	gen mj_first_use_18=0
		replace mj_first_use_18=bsae if outcome=="INCIDENCE" & agegrp==4
		label var  mj_first_use_18 "First use of marijuana, 18+"


	// Merge in state abbreviation information (Should be 51)
	rename state fips
	rename stname state
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge
	rename fips StateFIPS				


	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress


	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/

	bysort state pyear: egen mj_first_use_12_1=max(mj_first_use_12)
	bysort state pyear: egen mj_first_use_12_17_1=max(mj_first_use_12_17)
	bysort state pyear: egen mj_first_use_18_25_1=max(mj_first_use_18_25)
	bysort state pyear: egen mj_first_use_26_1=max(mj_first_use_26)
	bysort state pyear: egen mj_first_use_18_1=max(mj_first_use_18)

	replace mj_first_use_12=mj_first_use_12_1
	replace mj_first_use_12_17=mj_first_use_12_17_1
	replace mj_first_use_18_25=mj_first_use_18_25_1
	replace mj_first_use_26=mj_first_use_26_1
	replace mj_first_use_18=mj_first_use_18_1

	drop mj_first_use_12_1 mj_first_use_12_17_1 mj_first_use_18_25_1 mj_first_use_26_1 mj_first_use_18_1

	bysort state pyear: keep if _n==1

	sort state pyear

	// Save file
	save "temp/marijuana_first_use2.dta", replace
	////////////////////////////////////////////////////////////////////////////////
	//////////////Create Cocaine Use in Past Year By Age //////////////////
	////////////////////////////////////////////////////////////////////////////////


	// Import NSDUH data
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae

	gen coke_use_365_12=0
		replace coke_use_365_12=bsae if outcome=="COCYR" & agegrp==0
		label var  coke_use_365_12 "Cocaine Use in Past Year, 12+"

	gen coke_use_365_12_17=0
		replace coke_use_365_12_17=bsae if outcome=="COCYR" & agegrp==1
		label var  coke_use_365_12_17 "Cocaine Use in Past Year, 12-17"

	gen coke_use_365_18_25=0
		replace coke_use_365_18_25=bsae if outcome=="COCYR" & agegrp==2
		label var  coke_use_365_18_25 "Cocaine Use in Past Year, 18-25"

	gen coke_use_365_26=0
		replace coke_use_365_26=bsae if outcome=="COCYR" & agegrp==3
		label var  coke_use_365_26 "Cocaine Use in Past Year, 26+"

	gen coke_use_365_18=0
		replace coke_use_365_18=bsae if outcome=="COCYR" & agegrp==4
		label var  coke_use_365_18 "Cocaine Use in Past Year, 18+"


	// Merge in state abbreviation information (Should be 51)
	rename state fips
	rename stname state
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge
	rename fips StateFIPS	

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/

	bysort state pyear: egen coke_use_365_12_1=max(coke_use_365_12)
	bysort state pyear: egen coke_use_365_12_17_1=max(coke_use_365_12_17)
	bysort state pyear: egen coke_use_365_18_25_1=max(coke_use_365_18_25)
	bysort state pyear: egen coke_use_365_26_1=max(coke_use_365_26)
	bysort state pyear: egen coke_use_365_18_1=max(coke_use_365_18)

	replace coke_use_365_12=coke_use_365_12_1
	replace coke_use_365_12_17=coke_use_365_12_17_1
	replace coke_use_365_18_25=coke_use_365_18_25_1
	replace coke_use_365_26=coke_use_365_26_1
	replace coke_use_365_18=coke_use_365_18_1

	drop coke_use_365_12_1 coke_use_365_12_17_1 coke_use_365_18_25_1 coke_use_365_26_1 coke_use_365_18_1
	bysort state pyear: keep if _n==1

	sort state pyear

	// Save file
	save "temp/cocaine_use_in_past_365_days2.dta", replace

	////////////////////////////////////////////////////////////////////////////////
	/////////////Create Alcohol Use in Past 30 Days By Age  ////////////////
	////////////////////////////////////////////////////////////////////////////////


	// Import NSDUH data
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae


	gen alc_use_30_12=0
		replace alc_use_30_12=bsae if outcome=="ALCMON" & agegrp==0
		label var  alc_use_30_12 "Alcohol Use in Past 30 days, 12+"

	gen alc_use_30_12_17=0
		replace alc_use_30_12_17=bsae if outcome=="ALCMON" & agegrp==1
		label var  alc_use_30_12_17 "Alcohol Use in Past 30 days, 12-17"

	gen alc_use_30_18_25=0
		replace alc_use_30_18_25=bsae if outcome=="ALCMON" & agegrp==2
		label var  alc_use_30_18_25 "Alcohol Use in Past 30 days, 18-25"

	gen alc_use_30_26=0
		replace alc_use_30_26=bsae if outcome=="ALCMON" & agegrp==3
		label var  alc_use_30_26 "Alcohol Use in Past 30 days, 26+"

	gen alc_use_30_18=0
		replace alc_use_30_18=bsae if outcome=="ALCMON" & agegrp==4
		label var  alc_use_30_18 "Alcohol Use in Past 30 days, 18+"
	 

	// Merge in state abbreviation information (Should be 51)
	rename state fips
	rename stname state
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge
	rename fips StateFIPS	

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/

	bysort state pyear: egen alc_use_30_12_1=max(alc_use_30_12)
	bysort state pyear: egen alc_use_30_12_17_1=max(alc_use_30_12_17)
	bysort state pyear: egen alc_use_30_18_25_1=max(alc_use_30_18_25)
	bysort state pyear: egen alc_use_30_26_1=max(alc_use_30_26)
	bysort state pyear: egen alc_use_30_18_1=max(alc_use_30_18)

	replace alc_use_30_12=alc_use_30_12_1
	replace alc_use_30_12_17=alc_use_30_12_17_1
	replace alc_use_30_18_25=alc_use_30_18_25_1
	replace alc_use_30_26=alc_use_30_26_1
	replace alc_use_30_18=alc_use_30_18_1

	drop alc_use_30_12_1 alc_use_30_12_17_1 alc_use_30_18_25_1 alc_use_30_26_1 alc_use_30_18_1
	bysort state pyear: keep if _n==1

	sort state pyear

	// Save file
	save "temp/alcohol_use_in_past_30_days2.dta", replace

	////////////////////////////////////////////////////////////////////////////////
	/////////Create Alcohol Use in Past 30 Days By Aged 12 to 20  //////////
	////////////////////////////////////////////////////////////////////////////////


	// Import NSDUH data
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae

	gen alc_use_30_12_20=0
		replace alc_use_30_12_20=bsae if outcome=="U_ALCMON" & agegrp==5
		label var  alc_use_30_12_20 "Alcohol Use in Past 30 days, 12-20"

	// Merge in state abbreviation information (Should be 51)
	rename state fips
	rename stname state
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge
	rename fips StateFIPS	

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/

	bysort state pyear: egen alc_use_30_12_20_1=max(alc_use_30_12_20)
	replace alc_use_30_12_20=alc_use_30_12_20_1
	drop alc_use_30_12_20_1 
	bysort state pyear: keep if _n==1

	sort state pyear


	// Drop if missing variable
	*missings dropvars, force

	sort state pyear

	// Save file
	save "temp/alcohol_use_in_past_30_days_12_20_2.dta", replace

	////////////////////////////////////////////////////////////////////////////////
	//////////////Create Tobacco Use in Past 30 Days By Age  ///////////////
	////////////////////////////////////////////////////////////////////////////////


	// Import NSDUH data
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae

	gen tob_use_30_12=0
		replace tob_use_30_12=bsae if outcome=="TOBMON" & agegrp==0
		label var  tob_use_30_12 "Tobacco Use in Past 30 days, 12+"

	gen tob_use_30_12_17=0
		replace tob_use_30_12_17=bsae if outcome=="TOBMON" & agegrp==1
		label var  tob_use_30_12_17 "Tobacco Use in Past 30 days, 12-17"

	gen tob_use_30_18_25=0
		replace tob_use_30_18_25=bsae if outcome=="TOBMON" & agegrp==2
		label var  tob_use_30_18_25 "Tobacco Use in Past 30 days, 18-25"

	gen tob_use_30_26=0
		replace tob_use_30_26=bsae if outcome=="TOBMON" & agegrp==3
		label var  tob_use_30_26 "Tobacco Use in Past 30 days, 26+"

	gen tob_use_30_18=0
		replace tob_use_30_18=bsae if outcome=="TOBMON" & agegrp==4
		label var  tob_use_30_18 "Tobacco Use in Past 30 days, 18+"


	// Merge in state abbreviation information (Should be 51)
	rename state fips
	rename stname state
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge
	rename fips StateFIPS	

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/


	bysort state pyear: egen tob_use_30_12_1=max(tob_use_30_12)
	bysort state pyear: egen tob_use_30_12_17_1=max(tob_use_30_12_17)
	bysort state pyear: egen tob_use_30_18_25_1=max(tob_use_30_18_25)
	bysort state pyear: egen tob_use_30_26_1=max(tob_use_30_26)
	bysort state pyear: egen tob_use_30_18_1=max(tob_use_30_18)

	replace tob_use_30_12=tob_use_30_12_1
	replace tob_use_30_12_17=tob_use_30_12_17_1
	replace tob_use_30_18_25=tob_use_30_18_25_1
	replace tob_use_30_26=tob_use_30_26_1
	replace tob_use_30_18=tob_use_30_18_1

	drop tob_use_30_12_1 tob_use_30_12_17_1 tob_use_30_18_25_1 tob_use_30_26_1 tob_use_30_18_1
	bysort state pyear: keep if _n==1

	sort state pyear

	// Save file
	save "temp/tobacco_use_in_past_30_days2.dta", replace

	////////////////////////////////////////////////////////////////////////////////
	//////////////Create Cigarette Use in Past 30 Days By Age  /////////////
	////////////////////////////////////////////////////////////////////////////////


	// Import NSDUH data
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae

	gen cig_use_30_12=0
		replace cig_use_30_12=bsae if outcome=="CIGMON" & agegrp==0
		label var  cig_use_30_12 "Cigarette Use in Past 30 days, 12+"

	gen cig_use_30_12_17=0
		replace cig_use_30_12_17=bsae if outcome=="CIGMON" & agegrp==1
		label var  cig_use_30_12_17 "Cigarette Use in Past 30 days, 12-17"

	gen cig_use_30_18_25=0
		replace cig_use_30_18_25=bsae if outcome=="CIGMON" & agegrp==2
		label var  cig_use_30_18_25 "Cigarette Use in Past 30 days, 18-25"

	gen cig_use_30_26=0
		replace cig_use_30_26=bsae if outcome=="CIGMON" & agegrp==3
		label var  cig_use_30_26 "Cigarette Use in Past 30 days, 26+"

	gen cig_use_30_18=0
		replace cig_use_30_18=bsae if outcome=="CIGMON" & agegrp==4
		label var  cig_use_30_18 "Cigarette Use in Past 30 days, 18+"

	// Merge in state abbreviation information (Should be 51)
	rename state fips
	rename stname state
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge
	rename fips StateFIPS

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/

	bysort state pyear: egen cig_use_30_12_1=max(cig_use_30_12)
	bysort state pyear: egen cig_use_30_12_17_1=max(cig_use_30_12_17)
	bysort state pyear: egen cig_use_30_18_25_1=max(cig_use_30_18_25)
	bysort state pyear: egen cig_use_30_26_1=max(cig_use_30_26)
	bysort state pyear: egen cig_use_30_18_1=max(cig_use_30_18)

	replace cig_use_30_12=cig_use_30_12_1
	replace cig_use_30_12_17=cig_use_30_12_17_1
	replace cig_use_30_18_25=cig_use_30_18_25_1
	replace cig_use_30_26=cig_use_30_26_1
	replace cig_use_30_18=cig_use_30_18_1

	drop cig_use_30_12_1 cig_use_30_12_17_1 cig_use_30_18_25_1 cig_use_30_26_1 cig_use_30_18_1
	bysort state pyear: keep if _n==1

	sort state pyear

	// Save file
	save "temp/cigarette_use_in_past_30_days2.dta", replace

	////////////////////////////////////////////////////////////////////////////////
	////////Create Alcohol Use Disorder Use in past 365 days By Age  ///////
	////////////////////////////////////////////////////////////////////////////////

	// Import NSDUH data
	use "temp/nsduh_panel_1999_2015.dta"

	// rename a variable to be lower case
	rename BSAE bsae

	gen aud_use_365_12=0
		replace aud_use_365_12=bsae if outcome=="ABODALC" & agegrp==0
		label var  aud_use_365_12 "Alcohol Use Disorder Use in past 365 days, 12+"

	gen aud_use_365_12_17=0
		replace aud_use_365_12_17=bsae if outcome=="ABODALC" & agegrp==1
		label var  aud_use_365_12_17 "Alcohol Use Disorder Use in past 365 days, 12-17"

	gen aud_use_365_18_25=0
		replace aud_use_365_18_25=bsae if outcome=="ABODALC" & agegrp==2
		label var  aud_use_365_18_25 "Alcohol Use Disorder Use in past 365 days, 18-25"

	gen aud_use_365_26=0
		replace aud_use_365_26=bsae if outcome=="ABODALC" & agegrp==3
		label var  aud_use_365_26 "Alcohol Use Disorder Use in past 365 days, 26+"

	gen aud_use_365_18=0
		replace aud_use_365_18=bsae if outcome=="ABODALC" & agegrp==4
		label var  aud_use_365_18 "Alcohol Use Disorder Use in past 365 days, 18+"


	// Merge in state abbreviation information (Should be 51)
	rename state fips
	rename stname state
	merge m:1 state using "raw_data/state-abbreviation/state_abbrv.dta"
	drop _merge
	rename fips StateFIPS

	// DC did not merge, so add that in
	replace st_abbrv = "DC" if state=="District of Columbia"

	// Keep only those variables that matched. This is all our states (note: we are dropping US and regional data)
	drop if missing(st_abbrv)

	// Label state abbreviation
	label var st_abbrv "State Abbreviation"


	// Remove leading/lagging spaces
	compress

	/*
	// Remove non-numeric characters from survey response data then destring
	qui ds state st_abbrv, not
	foreach x in `r(varlist)' {
		replace `x' = subinstr(`x',"a","",.)
		replace `x' = subinstr(`x',"b","",.)
		replace `x' = trim(`x')

		destring `x', replace

	}
	*/

	bysort state pyear: egen aud_use_365_12_1=max(aud_use_365_12)
	bysort state pyear: egen aud_use_365_12_17_1=max(aud_use_365_12_17)
	bysort state pyear: egen aud_use_365_18_25_1=max(aud_use_365_18_25)
	bysort state pyear: egen aud_use_365_26_1=max(aud_use_365_26)
	bysort state pyear: egen aud_use_365_18_1=max(aud_use_365_18)

	replace aud_use_365_12=aud_use_365_12_1
	replace aud_use_365_12_17=aud_use_365_12_17_1
	replace aud_use_365_18_25=aud_use_365_18_25_1
	replace aud_use_365_26=aud_use_365_26_1
	replace aud_use_365_18=aud_use_365_18_1

	drop aud_use_365_12_1 aud_use_365_12_17_1 aud_use_365_18_25_1 aud_use_365_26_1 aud_use_365_18_1
	bysort state pyear: keep if _n==1

	sort state pyear

	// Save file
	save "temp/alcohol_use_disorder_use_in_past_365_days2.dta", replace


	clear
	// Display Change by Drug by Use
	use "temp/marijuana_use_in_past_365_days2.dta", clear
	merge 1:1 StateFIPS pyearnm using "temp/alcohol_use_disorder_use_in_past_365_days2.dta", nogen
	merge 1:1 StateFIPS pyearnm using "temp/cocaine_use_in_past_365_days2.dta", nogen
	merge 1:1 StateFIPS pyearnm using "temp/alcohol_use_in_past_30_days2.dta", nogen
	merge 1:1 StateFIPS pyearnm using "temp/cigarette_use_in_past_30_days2.dta", nogen
	merge 1:1 StateFIPS pyearnm using "temp/marijuana_use_in_past_30_days2.dta", nogen
	merge 1:1 StateFIPS pyearnm using "temp/tobacco_use_in_past_30_days2.dta", nogen
	merge 1:1 StateFIPS pyearnm using "temp/marijuana_first_use2.dta", nogen
	merge 1:1 StateFIPS pyearnm using "temp/alcohol_use_in_past_30_days_12_20_2.dta", nogen



	// Clean up by deleting datasets we no longer need.
	erase "temp/marijuana_use_in_past_365_days2.dta"
	erase "temp/alcohol_use_disorder_use_in_past_365_days2.dta"
	erase "temp/cocaine_use_in_past_365_days2.dta"
	erase "temp/alcohol_use_in_past_30_days2.dta"
	erase "temp/cigarette_use_in_past_30_days2.dta"
	erase "temp/marijuana_use_in_past_30_days2.dta"
	erase "temp/marijuana_first_use2.dta"
	erase "temp/alcohol_use_in_past_30_days_12_20_2.dta"
	erase "temp/tobacco_use_in_past_30_days2.dta"

	// Drop variables that are "vestigal" and have incorrect meaning 
	drop outname area outcome pyear est_total low_total up_total group nsel ncomp wtintrr pop bsae low_sae up_sae ste_total ste_sae gen_corr

	/////Dropping one of the 2010-2011 years, I went with "updated" but can change later if I need to 
	drop if pyearnm=="2010-2011 (published)"
	rename pyearnm year
	replace year="2010-2011" if year=="2010-2011 (updated)"

	rename state State


	global varlist "mj_use_365_12 mj_use_365_12_17 mj_use_365_18_25 mj_use_365_26 mj_use_365_18 aud_use_365_12 aud_use_365_12_17 aud_use_365_18_25 aud_use_365_26 aud_use_365_18 coke_use_365_12 coke_use_365_12_17 coke_use_365_18_25 coke_use_365_26 coke_use_365_18 alc_use_30_12 alc_use_30_12_17 alc_use_30_18_25 alc_use_30_26 alc_use_30_18 cig_use_30_12 cig_use_30_12_17 cig_use_30_18_25 cig_use_30_26 cig_use_30_18 mj_use_30_12 mj_use_30_12_17 mj_use_30_18_25 mj_use_30_26 mj_use_30_18 tob_use_30_12 tob_use_30_12_17 tob_use_30_18_25 tob_use_30_26 tob_use_30_18 mj_first_use_12 mj_first_use_12_17 mj_first_use_18_25 mj_first_use_26 mj_first_use_18 alc_use_30_12_20"



	// Turn use variables into percentages [0-100]
	local sub_list mj_use_365_12 mj_use_365_12_17 mj_use_365_18_25 mj_use_365_26 mj_use_365_18 aud_use_365_12 aud_use_365_12_17 aud_use_365_18_25 aud_use_365_26 aud_use_365_18 coke_use_365_12 coke_use_365_12_17 coke_use_365_18_25 coke_use_365_26 coke_use_365_18 alc_use_30_12 alc_use_30_12_17 alc_use_30_18_25 alc_use_30_26 alc_use_30_18 cig_use_30_12 cig_use_30_12_17 cig_use_30_18_25 cig_use_30_26 cig_use_30_18 mj_use_30_12 mj_use_30_12_17 mj_use_30_18_25 mj_use_30_26 mj_use_30_18 tob_use_30_12 tob_use_30_12_17 tob_use_30_18_25 tob_use_30_26 tob_use_30_18 mj_first_use_12 mj_first_use_12_17 mj_first_use_18_25 mj_first_use_26 mj_first_use_18 alc_use_30_12_20
	foreach sub in `sub_list' { 
		replace `sub'=`sub'*100
		}


	rename State state
	
///////////////////////////////////////////////////////////////////////////////
// Merge with other two waves
///////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////////
	// add 2015-2016 data
	append using "temp/nsduh_15_16.dta"

	// add 2015-2016 data
	append using "temp/nsduh_16_17.dta"	

///////////////////////////////////////////////////////////////////////////////
// Add in control data
///////////////////////////////////////////////////////////////////////////////


	// Merge in control data
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/population_data.dta", nogen
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/median_income.dta", nogen
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/unemployment_rate.dta", nogen
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/race_data.dta", nogen
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/sex_data.dta", nogen
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/age_data.dta", nogen
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/crime_data.dta", nogen
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/ethnicity_data.dta", nogen
	merge 1:1 StateFIPS year using "data_for_analysis/intermediate/medical_marijuana_status.dta", nogen

	/////SINCE 2013 IS MISSING FOR MED INC, I FILLED THAT ROW IN WITH THE AVERAGE OF THE YEAR BEFORE AND AFTER. Note by Ashley.
	bysort StateFIPS (year): replace ave_median_income= (ave_median_income[_n-1] + ave_median_income[_n+1] ) / 2 if year=="2013-2014"

	///Turn number of crime into rate 
	gen property_crime_rate=(ave_property_crime/ave_pop)*1000000
	gen violent_crime_rate=(ave_violent_crime/ave_pop)*1000000

	// Drop last year and years before 2002-2003
	drop if year=="1999-2000" | year=="2000-2001" | year=="2001-2002" | year=="2016" 
	drop if StateFIPS==99
	drop if missing(state)

	order state st_abbrv StateFIPS year ave_median_income ave_pop ave_unemp_rate ave_male ave_white ave_black hispanic age15_24 age25_44 age45_64 age65up ave_property_crime ave_violent_crime  mj_use_365_12 mj_use_365_12_17 mj_use_365_18_25 mj_use_365_26 mj_use_365_18 aud_use_365_12 aud_use_365_12_17 aud_use_365_18_25 aud_use_365_26 aud_use_365_18 coke_use_365_12 coke_use_365_12_17 coke_use_365_18_25 coke_use_365_26 coke_use_365_18 alc_use_30_12 alc_use_30_12_17 alc_use_30_18_25 alc_use_30_26 alc_use_30_18 cig_use_30_12 cig_use_30_12_17 cig_use_30_18_25 cig_use_30_26 cig_use_30_18 mj_use_30_12 mj_use_30_12_17 mj_use_30_18_25 mj_use_30_26 mj_use_30_18 tob_use_30_12 tob_use_30_12_17 tob_use_30_18_25 tob_use_30_26 tob_use_30_18 mj_first_use_12 mj_first_use_12_17 mj_first_use_18_25 mj_first_use_26 mj_first_use_18 alc_use_30_12_20 mj_use_ratio_12 mj_use_ratio_12_17 mj_use_ratio_18 mj_use_ratio_18_25 mj_use_ratio_26


	// Clean up 
	erase temp/nsduh_15_16.dta
	erase temp/nsduh_16_17.dta
	erase temp/nsduh_panel_1999_2015.dta

	save data_for_analysis/nsduh_1999_2016_state_comparison_data.dta, replace

///////////////////////////////////////////////////////////////////////////////
// Reshape, add logs, add age labels.
///////////////////////////////////////////////////////////////////////////////

	// Organize
	sort state year
	drop if missing(state)

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

	label define label_age_category 1 "12 to 17"  2 "12 to 20" 3 "18 to 25" ///
		 4 "12 and up"  5 "18 and up"  6 "26 and up"

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
	label var mj_first_use "Marijuana first use in past 365 days"
	label var mj_use_ratio "Marijuana use ratio"


	// Generate year indicator
	sort StateFIPS year
	egen year_group_id = group(year)

	// Generate "ever" medical, "ever" recreational, "post" variables
	bysort StateFIPS: egen ever_mm = max(mm)
	bysort StateFIPS: egen ever_rm = max(rm)
	bysort StateFIPS: egen ever_disp = max(disp)


	///////////////////////////////////////////////////////////////////////////////
	// Generate a natural log of each variable

	// Create local macro of all y variables
	qui ds *use*
	foreach y in `r(varlist)' {
		gen ln_`y' = ln(`y') //There are no zeros. So it's a straight log. 
	}

		  
	// Add census regions and divisions
	gen division =.
	replace division = 0  if StateFIPS==00
	replace division = 1  if StateFIPS==00
	replace division = 1  if StateFIPS==09
	replace division = 1  if StateFIPS==23
	replace division = 1  if StateFIPS==25
	replace division = 1  if StateFIPS==33
	replace division = 1  if StateFIPS==44
	replace division = 1  if StateFIPS==50
	replace division = 2  if StateFIPS==00
	replace division = 2  if StateFIPS==34
	replace division = 2  if StateFIPS==36
	replace division = 2  if StateFIPS==42
	replace division = 0  if StateFIPS==00
	replace division = 3  if StateFIPS==00
	replace division = 3  if StateFIPS==17
	replace division = 3  if StateFIPS==18
	replace division = 3  if StateFIPS==26
	replace division = 3  if StateFIPS==39
	replace division = 3  if StateFIPS==55
	replace division = 4  if StateFIPS==00
	replace division = 4  if StateFIPS==19
	replace division = 4  if StateFIPS==20
	replace division = 4  if StateFIPS==27
	replace division = 4  if StateFIPS==29
	replace division = 4  if StateFIPS==31
	replace division = 4  if StateFIPS==38
	replace division = 4  if StateFIPS==46
	replace division = 0  if StateFIPS==00
	replace division = 5  if StateFIPS==00
	replace division = 5  if StateFIPS==10
	replace division = 5  if StateFIPS==11
	replace division = 5  if StateFIPS==12
	replace division = 5  if StateFIPS==13
	replace division = 5  if StateFIPS==24
	replace division = 5  if StateFIPS==37
	replace division = 5  if StateFIPS==45
	replace division = 5  if StateFIPS==51
	replace division = 5  if StateFIPS==54
	replace division = 6  if StateFIPS==00
	replace division = 6  if StateFIPS==01
	replace division = 6  if StateFIPS==21
	replace division = 6  if StateFIPS==28
	replace division = 6  if StateFIPS==47
	replace division = 7  if StateFIPS==00
	replace division = 7  if StateFIPS==05
	replace division = 7  if StateFIPS==22
	replace division = 7  if StateFIPS==40
	replace division = 7  if StateFIPS==48
	replace division = 0  if StateFIPS==00
	replace division = 8  if StateFIPS==00
	replace division = 8  if StateFIPS==04
	replace division = 8  if StateFIPS==08
	replace division = 8  if StateFIPS==16
	replace division = 8  if StateFIPS==30
	replace division = 8  if StateFIPS==32
	replace division = 8  if StateFIPS==35
	replace division = 8  if StateFIPS==49
	replace division = 8  if StateFIPS==56
	replace division = 9  if StateFIPS==00
	replace division = 9  if StateFIPS==02
	replace division = 9  if StateFIPS==06
	replace division = 9  if StateFIPS==15
	replace division = 9  if StateFIPS==41
	replace division = 9  if StateFIPS==53

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

	// Save dataset for analysis
	compress
	save data_for_analysis/rml_panel_data.dta, replace
