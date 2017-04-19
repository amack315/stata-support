# stata-support
This repository contains code files to facilitate use of the Fragile Families Challenge data files in Stata.

Credit to Jeremy Freese for providing these.

Please direct questions to fragilefamilieschallenge@gmail.com.

Repository contents:

1.  combine_ffc_data_files.do --> takes the FFC data and makes Stata .dta files that are easier to work with, for example handling the missing values.  ALSO, circumvents the 2048 limit of Stata/SE by chopping the data file into smaller files that can then be recombined using -ffadd-

2.  ffadd.ado --> add-on Stata command that allows users to add variables to a base dataset.  This solves the 2048 variable problem because users start with a short base dataset and then add variables of interest to it.

3.  simple_worked_example.do --> easy example of actually constructing variables

4.  predbundle.ado --> add-on Stata comamnd that makes it easy to generate the prediction bundle needed to upload for the competition

5.  prediction_bundle_example.do --> example of actually fitting a model, generating predictions, and uploading it to the site.  These predictions are the current predictions for "soc383" on the leaderboard.

For all this, we strongly recommend working from having all the files, including data and do files, in one directory. Experienced coders may prefer separate directories, but only those comfortable modifying the code to get it to work should consider using separate directories.
