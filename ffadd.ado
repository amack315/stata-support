** v1 as .ado - jeremy - last updated 4/18/2017

/*

	Put this file in a place where Stata will find .ado files.  The current
	working directory is a simple option, especially if you have all your
	other FFC files in one place.  Just put this with them, set that to be
	the current working directory, and you should be good to go.
	
	The command -ffadd- adds variables from the smaller datasets to the data 
	in memory.  You can add multiple variables with one command, including 
	using wildcard operators. Or separate calls to the ffadd will keep adding 
	variables.
	
	The program assumes the data are in the current working directory.
*/


** global ffdatapath = "." // change to working directory where data files are

capture program drop ffadd
program define ffadd

	syntax anything
	tokenize `"`anything'"'
	foreach var in `anything' {
		
		local let = substr("`var'", 1, 1)
		local let2 = substr("`var'", 1, 2)
		if "`let'" == "c" | "`let'" == "h" | "`let'" == "p" {
			local file = "background_`let'"
		}
		else if "`let2'" == "m1" | "`let2'" == "m2" | "`let2'" == "m3" | ///
				"`let2'" == "m4" | "`let2'" == "m5" | "`let2'" == "f1" | ///
				"`let2'" == "f2" | "`let2'" == "f3" | "`let2'" == "f4" | ///
				"`let2'" == "f5" | "`let2'" == "ff" ///
		{
			local file = "background_`let2'"			
		}		
		else {
			local file = "background_other"
		}
		qui merge 1:1 challengeid using "`file'", ///
			keepusing(`var') nogenerate
	}
	
	display "Added. " c(k) " total variables in dataset."

end





