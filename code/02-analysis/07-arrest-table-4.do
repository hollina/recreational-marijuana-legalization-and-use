// Open data
use data_for_analysis/arrest_data.dta, clear

// Set controls
global list_of_controls male_percent white_percent unemployment_rate median_income percent_adult percent_juv

// Run analyses
ppmlhdfe poss_cannabis_juv $list_of_controls ///
		i.mm i.rm i.disp i.rm_disp, ///
		absorb(StateFIPS year i.region#i.year) ///
		vce(cluster StateFIPS)  ///
		exposure(pop_juv)
	
		
		// Store the Recreational legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

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
			
		// Store the Medical legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_rounded_estimate = round(b,.01)
		local mm_rounded_estimate : di %3.2f mm_rounded_estimate
		scalar mm_string_estimate = "`mm_rounded_estimate'"

		// Round Standard Errors
		scalar mm_rounded_se = round(se_v2,.01)
		local mm_rounded_se : di %3.2f mm_rounded_se
		scalar mm_string_se = "("+"`mm_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_string_estimate = mm_string_estimate 
		}			
			
		// Add the results
		estadd local mm_b_str =mm_string_estimate
		estadd local mm_se_str =mm_string_se	
				

		// Store the dispensary + medical effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.disp]+_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_disp_rounded_estimate = round(b,.01)
		local  mm_disp_rounded_estimate : di %3.2f mm_disp_rounded_estimate
		scalar mm_disp_string_estimate = "`mm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar mm_disp_rounded_se = round(se_v2,.01)
		local  mm_disp_rounded_se : di %3.2f mm_disp_rounded_se
		scalar mm_disp_string_se = "("+"`mm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_disp_string_estimate = mm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local mm_disp_b_str = mm_disp_string_estimate
		estadd local mm_disp_se_str= mm_disp_string_se
		
		// Store the rec dispensary + rec effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm_disp]+_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar rm_disp_rounded_estimate = round(b,.01)
		local  rm_disp_rounded_estimate : di %3.2f rm_disp_rounded_estimate
		scalar rm_disp_string_estimate = "`rm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar rm_disp_rounded_se = round(se_v2,.01)
		local  rm_disp_rounded_se : di %3.2f rm_disp_rounded_se
		scalar rm_disp_string_se = "("+"`rm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar rm_disp_string_estimate = rm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local rm_disp_b_str = rm_disp_string_estimate
		estadd local rm_disp_se_str= rm_disp_string_se
				
		// Add indicators for state and year fixed-effects.
		estadd local state_fe "Yes"
		estadd local year_fe "Yes"
		estadd local region_by_year_fe "No"
		estadd local controls "Yes"
	
		// Store the model
		est sto m1_juv
		
ppmlhdfe sale_cannabis_juv $list_of_controls ///
		i.mm i.rm i.disp i.rm_disp, ///
		absorb(StateFIPS year i.region#i.year) ///
		vce(cluster StateFIPS)  ///
		exposure(pop_juv)
	
		
		// Store the Recreational legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

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
			
		// Store the Medical legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_rounded_estimate = round(b,.01)
		local mm_rounded_estimate : di %3.2f mm_rounded_estimate
		scalar mm_string_estimate = "`mm_rounded_estimate'"

		// Round Standard Errors
		scalar mm_rounded_se = round(se_v2,.01)
		local mm_rounded_se : di %3.2f mm_rounded_se
		scalar mm_string_se = "("+"`mm_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_string_estimate = mm_string_estimate 
		}			
			
		// Add the results
		estadd local mm_b_str =mm_string_estimate
		estadd local mm_se_str =mm_string_se	
				

		// Store the dispensary + medical effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.disp]+_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_disp_rounded_estimate = round(b,.01)
		local  mm_disp_rounded_estimate : di %3.2f mm_disp_rounded_estimate
		scalar mm_disp_string_estimate = "`mm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar mm_disp_rounded_se = round(se_v2,.01)
		local  mm_disp_rounded_se : di %3.2f mm_disp_rounded_se
		scalar mm_disp_string_se = "("+"`mm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_disp_string_estimate = mm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local mm_disp_b_str = mm_disp_string_estimate
		estadd local mm_disp_se_str= mm_disp_string_se
		
		// Store the rec dispensary + rec effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm_disp]+_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar rm_disp_rounded_estimate = round(b,.01)
		local  rm_disp_rounded_estimate : di %3.2f rm_disp_rounded_estimate
		scalar rm_disp_string_estimate = "`rm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar rm_disp_rounded_se = round(se_v2,.01)
		local  rm_disp_rounded_se : di %3.2f rm_disp_rounded_se
		scalar rm_disp_string_se = "("+"`rm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar rm_disp_string_estimate = rm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local rm_disp_b_str = rm_disp_string_estimate
		estadd local rm_disp_se_str= rm_disp_string_se
				
		// Add indicators for state and year fixed-effects.
		estadd local state_fe "Yes"
		estadd local year_fe "Yes"
		estadd local region_by_year_fe "No"
		estadd local controls "Yes"
	
		// Store the model
		est sto m2_juv

ppmlhdfe poss_cannabis_adult $list_of_controls ///
		i.mm i.rm i.disp i.rm_disp, ///
		absorb(StateFIPS year i.region#i.year) ///
		vce(cluster StateFIPS)  ///
		exposure(pop_adult)
	
		
		// Store the Recreational legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

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
			
		// Store the Medical legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_rounded_estimate = round(b,.01)
		local mm_rounded_estimate : di %3.2f mm_rounded_estimate
		scalar mm_string_estimate = "`mm_rounded_estimate'"

		// Round Standard Errors
		scalar mm_rounded_se = round(se_v2,.01)
		local mm_rounded_se : di %3.2f mm_rounded_se
		scalar mm_string_se = "("+"`mm_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_string_estimate = mm_string_estimate 
		}			
			
		// Add the results
		estadd local mm_b_str =mm_string_estimate
		estadd local mm_se_str =mm_string_se	
				

		// Store the dispensary + medical effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.disp]+_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_disp_rounded_estimate = round(b,.01)
		local  mm_disp_rounded_estimate : di %3.2f mm_disp_rounded_estimate
		scalar mm_disp_string_estimate = "`mm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar mm_disp_rounded_se = round(se_v2,.01)
		local  mm_disp_rounded_se : di %3.2f mm_disp_rounded_se
		scalar mm_disp_string_se = "("+"`mm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_disp_string_estimate = mm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local mm_disp_b_str = mm_disp_string_estimate
		estadd local mm_disp_se_str= mm_disp_string_se
		
		// Store the rec dispensary + rec effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm_disp]+_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar rm_disp_rounded_estimate = round(b,.01)
		local  rm_disp_rounded_estimate : di %3.2f rm_disp_rounded_estimate
		scalar rm_disp_string_estimate = "`rm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar rm_disp_rounded_se = round(se_v2,.01)
		local  rm_disp_rounded_se : di %3.2f rm_disp_rounded_se
		scalar rm_disp_string_se = "("+"`rm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar rm_disp_string_estimate = rm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local rm_disp_b_str = rm_disp_string_estimate
		estadd local rm_disp_se_str= rm_disp_string_se
				
		// Add indicators for state and year fixed-effects.
		estadd local state_fe "Yes"
		estadd local year_fe "Yes"
		estadd local region_by_year_fe "No"
		estadd local controls "Yes"
	
		// Store the model
		est sto m1_adult
		
ppmlhdfe sale_cannabis_adult $list_of_controls ///
		i.mm i.rm i.disp i.rm_disp, ///
		absorb(StateFIPS year i.region#i.year) ///
		vce(cluster StateFIPS)  ///
		exposure(pop_adult)
	
		
			// Store the Recreational legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

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
			
		// Store the Medical legal effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_rounded_estimate = round(b,.01)
		local mm_rounded_estimate : di %3.2f mm_rounded_estimate
		scalar mm_string_estimate = "`mm_rounded_estimate'"

		// Round Standard Errors
		scalar mm_rounded_se = round(se_v2,.01)
		local mm_rounded_se : di %3.2f mm_rounded_se
		scalar mm_string_se = "("+"`mm_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_string_estimate = mm_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_string_estimate = mm_string_estimate 
		}			
			
		// Add the results
		estadd local mm_b_str =mm_string_estimate
		estadd local mm_se_str =mm_string_se	
				

		// Store the dispensary + medical effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.disp]+_b[1.mm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar mm_disp_rounded_estimate = round(b,.01)
		local  mm_disp_rounded_estimate : di %3.2f mm_disp_rounded_estimate
		scalar mm_disp_string_estimate = "`mm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar mm_disp_rounded_se = round(se_v2,.01)
		local  mm_disp_rounded_se : di %3.2f mm_disp_rounded_se
		scalar mm_disp_string_se = "("+"`mm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar mm_disp_string_estimate = mm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar mm_disp_string_estimate = mm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local mm_disp_b_str = mm_disp_string_estimate
		estadd local mm_disp_se_str= mm_disp_string_se
		
		// Store the rec dispensary + rec effect
		//Evaluate Effect using nlcom. Since we will do a tranform of the log results  
		nlcom 100*(exp(_b[1.rm_disp]+_b[1.rm])-1)
		mat b = r(b)
		mat V = r(V)

		scalar b = b[1,1]
		scalar se_v2 = sqrt(V[1,1])
		scalar p_val = 2*ttail(`e(df)',abs(b/se_v2))

		// Round Estimates to Whatever place we need
		scalar rm_disp_rounded_estimate = round(b,.01)
		local  rm_disp_rounded_estimate : di %3.2f rm_disp_rounded_estimate
		scalar rm_disp_string_estimate = "`rm_disp_rounded_estimate'"

		// Round Standard Errors
		scalar rm_disp_rounded_se = round(se_v2,.01)
		local  rm_disp_rounded_se : di %3.2f rm_disp_rounded_se
		scalar rm_disp_string_se = "("+"`rm_disp_rounded_se'"+")"

		//Add Stars for Significance 
		if p_val <= .01	{
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{3}"
		}	

		if p_val>.01 & p_val<=.05 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{2}"

		}

		if  p_val>.05 & p_val<=.1 {
			scalar rm_disp_string_estimate = rm_disp_string_estimate + "\nlsym{1}"

		}
		else {
			scalar rm_disp_string_estimate = rm_disp_string_estimate 
		}	
		
		// Add the results
		estadd local rm_disp_b_str = rm_disp_string_estimate
		estadd local rm_disp_se_str= rm_disp_string_se
				
		// Add indicators for state and year fixed-effects.
		estadd local state_fe "Yes"
		estadd local year_fe "Yes"
		estadd local region_by_year_fe "No"
		estadd local controls "Yes"
	
		// Store the model
		est sto m2_adult
		
		
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////    TABLE    ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Make table for adults 
	esttab  m1_adult  ///
			  m2_adult ///
		using "output/tables/mj_full_table_add_rm_disp_crime.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
		stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str  ///
			mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str ///
				, fmt(0 0 0 0 0 0 0) ///
			layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
			label("\emph{Adult Arrests} &\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{7cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{7cm}{Medical legal and medical dispensary open}}" "~")) ///
		drop(*) se b(%9.2f) booktabs ///
		f replace  ///
		mtitles("Possession"  ///
				 "Sales")

		
// Make table for juveniles 
	esttab  m1_juv  ///
		  m2_juv  ///
		using "output/tables/mj_full_table_add_rm_disp_crime.tex" ///
		,star(* 0.10 ** 0.05 *** .01) ///
	stats(rm_b_str rm_se_str rm_disp_b_str rm_disp_se_str  ///
			mm_b_str mm_se_str mm_disp_b_str mm_disp_se_str ///
			 controls state_fe  region_by_year_fe N ///
			, fmt(0 0 0 0 0  0 ///
			0 0 0 0 0) ///
		layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  ///
			"\multicolumn{1}{c}{@}"  ///
			"\multicolumn{1}{c}{@}") ///
		label("\emph{Juvenile Arrests} &\\ \addlinespace  \hspace{0.5cm}Recreational legal" "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{7cm}{Recreational legal and recreational dispensary open}}" "\vspace{.25cm}~" "\hspace{0.5cm}Medical legal"  "\vspace{.25cm}~" "\hspace{0.5cm}\multirow{2}{*}{\parbox{7cm}{Medical legal and medical dispensary open}}" "~" ///
				" \addlinespace \hline Controls" "State fixed-effects"  "Region-by-year fixed-effects" "Observations")) ///
		drop(*) se b(%9.2f) booktabs ///
		f append    ///
		nomtitles noline nonumbers
