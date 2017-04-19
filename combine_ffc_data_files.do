/*
JF 4/5/2017

This code:
1. 	merges the original data files
2. 	converts missing data to stata missing values (essential to avoid chaos)
3. 	creates a combined original data file (that file will be inside a folder
	called dta that is at the same folder level as the folder containing the
	data)

For this code to work, you need to:
1.  put the files from FF in a folder that's named and located in a place
	consistent with it being something you'll be using over the quarter
2.  change the cd line to the path containing your data

*/



** YOU NEED TO CHANGE THIS LINE TO THE PATH WHERE YOUR DATA IS
cd "/Users/jeremy/Dropbox/FFChallenge/dta/" 

** import and save csv datasets as stata datasets

	import delimited background.csv, clear
	saveold background, replace	

	import delimited train.csv, clear
	saveold train, replace 

	import delimited prediction.csv, clear
	saveold prediction, replace 

** merge datasets

	use background, clear

	merge 1:1 challengeid using train, nogenerate


** change missing value codes 

	* numeric missing values

	foreach var of varlist * {
		di "`var'"
		cap recode `var' (-1=.r) (-2=.d) (-3=.z) (-4=.z) (-5=.z) (-6=.i) ///
			(-7=.z) (-8=.z) (-9=.n) (-10/-14=.z)
			
			* string missing values
			
				if _rc != 0 {
					cap replace `var' = ".z" if `var' == "NA"
					cap destring `var', replace
				}
	}

	foreach var in gpa grit materialhardship eviction layoff jobtraining {

		* the .z is used to indicate cases that are in the training sample 
		* but missing on outcome
		* as opposed to . which indicates in the discovery sample 
		* replace `var' = ".z" if `var' == "NA"
		* destring `var', replace

		cap drop pred_`var'
		gen double pred_`var' = `var'

		replace pred_`var' = 0 if `var' == .z

	}

** create variable for whether observation is in training or prediction set	
	
	gen training = pred_eviction != .
	label variable training "part of training dataset?"
	
	gen prediction = pred_eviction >= .
	label variable prediction "part of prediction dataset?"

	saveold combined, replace 

	
** break into datasets with < 2048 variables
	
	use combined, clear
	
	drop gpa-prediction

	rename challengeid _challengeid
	foreach let in c h p m1 m2 m3 m4 m5 f1 f2 f3 f4 f5 ff {

		display "`let'"
		local before = c(k)
	
		preserve
	
			keep _challengeid `let'*
			rename _challengeid challengeid
			save background_`let', replace
	
		restore
	
			drop `let'*
	
	}
	rename _challengeid challengeid
	saveold background_other, replace

** generate base dataset with just challengeid and train/prediction variables
	
	use combined, clear
	
	keep challengeid gpa-prediction
	
	saveold base, replace


	
