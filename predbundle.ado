
capture program drop predbundle
program define predbundle

	syntax name(name=name) [, do(string)]
	
** 1.  save pred as pred.csv

	keep ///
		challengeid pred_gpa pred_grit pred_materialhardship ///
		pred_eviction pred_layoff pred_jobtraining
	order ///
		challengeid pred_gpa pred_grit pred_materialhardship ///
		pred_eviction pred_layoff pred_jobtraining

** 2.  substitute the mean if possible for any remaining predictions

	foreach var in gpa grit materialhardship eviction layoff jobtraining {

		cap sum `var'
		if _rc == 0 {
			qui replace pred_`var' = r(mean) if pred_`var' >= .
		}
		* otherwise replace with 0
		qui replace pred_`var' = 0 if pred_`var' >= .
	}		
	
** 3.  make variable names compatible	
	
	rename challengeid challengeID
	rename pred_gpa gpa
	rename pred_grit grit
	rename pred_materialhardship materialHardship
	rename pred_eviction eviction
	rename pred_layoff layoff
	rename pred_jobtraining jobTraining	

	* cap rmdir pred/`name'
	cap mkdir ${name}
	
	export delimited using `"`name'/prediction.csv"', replace nolabel
	
** 4.  save your code

	copy ${dofilename}.do ${name}/model.do, replace
	
** 5.  Create a narrative explanation of your study in a text editor. Save it as narrative.txt.
	* make text file from input named narrative.text
	
	capture : file close myfile 
	file open myfile using "${name}/narrative.txt", write replace	
	file write myfile `"${narrative}"' _n
	file close myfile
		
end


