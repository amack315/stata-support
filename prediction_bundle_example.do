
/*
This is an example that goes from the variables that we have constructed
to a fully-fledged prediction bundle that one could submit for the
FFChallenge Leaderboard.

This example assumes a few things.  Short version: Easiest thing is to have
all the files in the current working directory.  Otherwise you can adjust
names and paths below.

In particular, you need:

1.  The predbundle.ado file in a place where Stata will find it.  If you know
	how to install .ado files, great.  But also can just have it in the current
	working directory.

2.  The data file you are analyzing is called ffc_analysis.dta.  This is
	the name I used for dat created from the shared_variable_construction folder.  
	You can change this below, and adjust the file path as needed.  But easiest
	have ffc_analysis.dta in the current working directory.

The bundle:

1.  The bundle will be a folder whose name you will set below.  If that folder
	exists the results will be overwritten.	

Uploading the bundle to the FF site:	

1.  You should be able to zip the contents of the folder and upload to the FF
	site. 
	
2.	The FF website has different instructions on how to zip for Mac and PC.
	The big thing is that the zip has to be just the files, it can't be a
	folder with the files inside or it will fail on their site.  On Mac, you
	have to highlight the three files in Finder and then choose compress from 
	the menu.	
	
3.	There is a non-zero (say 5-10%) chance the upload will fail even if 
	you've got everything right.  I would try it again, but then if it doesn't
	work, the problem is on our end.	

Missing predictions:

We cannot submit a file with any missing predictions, and -predict- 
in Stata will generate missing predictions for any observations
that have missing values for explanatory variables in a model

We could address the problem in various ways, and indeed part of what
may make some predictions better than others for the challenge may be
how they address this issue.  This file just substitutes the mean, which
is not optimal but works for now.
*/	
	

program drop _all

* insert the short name for your model here (NO SPACES)
global name "your_model_name"

* insert the narrative description of your model here (required by challenge)
global narrative "Insert the text here that provides the narrative description of the model you have fit."

* insert path and the name of your do file here (don't include the .do)
global dofilename "prediction_bundle_example" 

use "ffc_analysis.dta", clear // you may have to fix path

capture drop pred_* // removes any existing pred_* variables

regress gpa vocab girl
predict double pred_gpa // double here means double-precision, the most precise variable format

regress grit vocab girl
predict double pred_grit

regress materialhardship vocab girl
predict double pred_materialhardship

logit eviction vocab girl
predict double pred_eviction

logit jobtraining vocab girl
predict double pred_jobtraining

logit layoff vocab girl
predict double pred_layoff

/*
* Here is a much better way of doing the above, but not as easy to understand
if you are a stata novice.

local right_hand_side "vocab girl"
foreach var in gpa grit materialhardship {
	regress `var' `right_hand_side'
	predict double pred_`var'
}
foreach var in eviction layoff jobtraining {
	regress `var' `right_hand_side'
	predict double pred_`var'
}	
*/

** substitute the mean for missing predictions	

foreach var in gpa grit materialhardship eviction layoff jobtraining {

	summarize `var'
	replace pred_`var' = r(mean) if pred_`var' >= .

}

** this will work if you have the predbundle.ado file installed somewhere that
** stata can locate it

predbundle ${name}, do(${dofilename})





