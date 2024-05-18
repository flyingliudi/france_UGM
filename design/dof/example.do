cscript

do compile

// adopath ++ ../../src

local logs ../logs
local eps ../eps

/*-----------------------------------------------------------------------------
	Example 1: IV median regression	with IQR estimator
-----------------------------------------------------------------------------*/
					// import data
sjlog using `logs'/ex1_a, replace
use assets2, clear
sjlog close, replace
					// IQR
sjlog using `logs'/ex1_b, replace
ivqregress iqr assets (i.p401k = i.e401k) income age familysize		///
	i.married i.ira i.pension i.ownhome educ
estimates store est_iqr
sjlog close, replace
					// dualci
sjlog using `logs'/ex1_c, replace
estat dualci
sjlog close, replace
					// potential outcomes' conditional
					// quantile 
sjlog using `logs'/ex1_d, replace
margins i.p401k, at((mean) income age familysize educ 	///
	married = 1 ira = 1 pension = 1 ownhome = 1)
sjlog close, replace

/*-----------------------------------------------------------------------------
	Example 2: IV median regression	with SEE estimator
-----------------------------------------------------------------------------*/
					// SEE 
sjlog using `logs'/ex2_a, replace
ivqregress smooth assets (i.p401k = i.e401k) income age familysize		///
	i.married i.ira i.pension i.ownhome educ
estimates store est_smooth
sjlog close, replace

					// compare IQR with SEE
sjlog using `logs'/ex2_b, replace
estimates table est_iqr est_smooth, keep(i.p401k) se
sjlog close, replace
					// potential outcomes' conditional
					// quantile 
sjlog using `logs'/ex2_c, replace
margins i.p401k, at((mean) income age familysize educ 	///
	married = 1 ira = 1 pension = 1 ownhome = 1)
sjlog close, replace

/*-----------------------------------------------------------------------------
	Example 3: IVQR at different quantiles
-----------------------------------------------------------------------------*/
					// IQR
sjlog using `logs'/ex3_a, replace
ivqregress iqr assets (i.p401k = i.e401k) income age familysize		///
	i.married i.ira i.pension i.ownhome educ, quantile(10(10)90)
sjlog close, replace
					// coefplot
sjlog using `logs'/ex3_b, replace
estat coefplot 1.p401k
sjlog close, replace
graph export `eps'/ex3_coefplot1.png, replace

					// process test 
sjlog using `logs'/ex3_c, replace
estat endogeffects
sjlog close, replace
					// SEE
sjlog using `logs'/ex3_d, replace
ivqregress smooth assets (i.p401k = i.e401k) income age familysize	///
	i.married i.ira i.pension i.ownhome educ, quantile(10(10)90)
sjlog close, replace



/*-----------------------------------------------------------------------------
	Example 4: IQR diagnosis	
-----------------------------------------------------------------------------*/
					// waldplot
sjlog using `logs'/ex4_a, replace
estimates restore est_iqr
estat waldplot, name(a)
sjlog close, replace
graph export `eps'/ex4_waldplot1.png, replace

					// customized bound
sjlog using `logs'/ex4_b, replace
cap noi ivqregress iqr assets (i.p401k = i.e401k) income age familysize	 ///
	i.married i.ira i.pension i.ownhome educ, bound(3000 6000)
sjlog close, replace
					// diagonosis with waldplot
sjlog using `logs'/ex4_c, replace
estat waldplot, name(b)
sjlog close, replace
graph export `eps'/ex4_waldplot2.png, replace
					// increase upper bound
sjlog using `logs'/ex4_d, replace
cap noi ivqregress iqr assets (i.p401k = i.e401k) income age familysize	 ///
	i.married i.ira i.pension i.ownhome educ, bound(3000 8000)
sjlog close, replace
					// waldplot again
sjlog using `logs'/ex4_e, replace
estat waldplot, name(c)
sjlog close, replace
graph export `eps'/ex4_waldplot3.png, replace
