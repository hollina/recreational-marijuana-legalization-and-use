// Import excel sheet
import excel "temp/closest_pre_period_match_storage.xlsx", sheet("Sheet1") clear

// drop first row
drop in 1

// label variables
label var A ""
gen y = "\emph{" + A + "}"
replace y = "" if B !="12 to 17"
drop A 
order y
label var y "Substance"

rename B age_label
label var age_label "Age group"

gen state_list = substr(C,2,172)
drop C
order y age_label state_list
label var state_list "Set of closest states"

foreach x in D E F {
	destring `x', replace
	
	gen double round_`x' = round(`x',.01)
	format round_`x' %04.2f
	gen str5 str_round_`x' = string(round_`x',"%04.2f")

}
rename str_round_D pretreat_mean_rec
drop *D*
label var pretreat_mean_rec "Pre-treatment mean recreational states"

rename str_round_E pretreat_mean_match
drop *E*
label var pretreat_mean_match "Pre-treatment mean match states"


rename str_round_F pretreat_mean_non_match
drop *F*
label var pretreat_mean_non_match "Pre-treatment mean non-match states"

					
order y age_label state_list pretreat_mean_rec pretreat_mean_match pretreat_mean_non_match

// Load texsave fragment.
do "code/02-analysis/17.1-nsduh-texsave-fragment.do"
	
alex_texsave ///
	y age_label state_list pretreat_mean_rec pretreat_mean_match pretreat_mean_non_match ///
	using "output/tables/pretreat_match_list_mj.tex" in 1/15, ///
		frag ///
		replace ///
		varlabels ///
		nofix ///
		total_frag
				
alex_texsave ///
	y age_label state_list pretreat_mean_rec pretreat_mean_match pretreat_mean_non_match ///
	using "output/tables/pretreat_match_list_oth.tex" in 16/30, ///
		frag ///
		replace ///
		varlabels ///
		nofix ///
		total_frag
		
// Clean up
!rm temp/closest_pre_period_match_storage.xlsx
