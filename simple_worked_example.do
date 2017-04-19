
/*
If you have the combined dataset (and can use > 2048 variables), uncomment
out the lines that refer to ffadd and change "use base" to "use combined"
*/

program drop _all

use base, clear // may need to set path depending on where .do file is

** this line is commented out as it is assumed ffadd.ado is installed
** do ffadd.do // set path to where this .do file is 

** child sex (jeremy)
	ffadd cm1bsex
	recode cm1bsex (1=1) (2=0) (*=.), gen(boy)
	label variable boy "child is boy?"
	label define boy 1 "yes" 0 "no"
	label values boy boy
	recode cm1bsex (1=0) (2=1) (*=.), gen(girl)
	label variable girl "child is girl?"
	label define girl 1 "yes" 0 "no"
	label values boy boy
	
** vocabulary test score (jeremy)
	ffadd hv5_ppvtss
	gen vocab = (hv5_ppvtss) if hv5_ppvtss < .		
	replace vocab = (vocab - 100) / 15
	label variable vocab "verbal test score"
	notes vocab: converted to standard deviations per test norms

** mother's age (jeremy)
	ffadd cm1age
	gen mom_age = cm1age if cm1age < .	
	label variable mom_age "mother's age at child's birth"	

** primary caregiver (jeremy)
	ffadd pcg5idstat
	recode pcg5idstat (61=1) (62=2) (63=3), gen(caregiver9)
	label variable caregiver9 "who was primary caregiver for age 9 survey?"
	label values caregiver9 1 "mom" 2 "dad" 3 "other"
	label values caregiver9 caregiver9
	notes caregiver9: this person is referent for items regarding primary caregiver
	
** material hardship at age 9 (jeremy)

	** economic hardship
	ffadd m5f23* f5f23* n5g1*	

	foreach pair in "a freefood" "b hungry" "c missrent" "d eviction" ///
		"e fullbill" "f turnedoff" "g borrow" "h movedin" "i shelter" ///
		"j doctor" "k phone" {
		
		tokenize `pair'
		
		gen hardship9_`2' = m5f23`1' if caregiver9 == 1
		gen hardship9_`2' = f5f23`1' if caregiver9 == 2
		gen hardship9_`2' = n5g1`1' if caregiver9 == 3
		
	}
	drop m5f23* f5f23* n5g1* // drop to keep dataset smaller
		
	label variable hardship9_freefood "past year: receive free food or meals?"
	label variable hardship9_hungry ///
		"past year: any time hungry but could not afford food?"
	label variable hardship9_missrent ///
		"past year: any time could not pay full rent or mortgage?"
	label variable hardship9_eviction "past year: evicted?"
	label variable hardship9_fullbill "past year: not pay full utility bill?"
	label variable hardship9_turnedoff "past year: utility turned off?"
	label variable hardship9_borrow "past year: borrow to help pay bills?"
	label variable hardship9_movedin "past year: had to moved in with others?"
	label variable hardship9_shelter "past year: any time stayed in shelter?"
	label variable hardship9_doctor "past year: could not go to doctor?"
	label variable hardship9_phone "past year: phone disconnected?"
	
save ffc_analysis, replace // can change path to where file saves

tab boy girl, m
su vocab
su mom_age
regress gpa vocab girl

