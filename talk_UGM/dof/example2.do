cscript

set scheme stcolor

do compile

// adopath ++ ../../src

local logs ../logs
local eps ../eps

/*-----------------------------------------------------------------------------
	Example 1: IV median regression	with IQR estimator
-----------------------------------------------------------------------------*/
					// import data
use assets2, clear
global covariates income age familysize educ i.(married ira pension ownhome)

					// IQR
ivqregress iqr assets (i.p401k = i.e401k) $covariates, ngrid(60)

sjlog using `logs'/ex2_a, replace
estat waldplot
sjlog close, replace

graph export `eps'/waldplot.png, replace

sjlog using `logs'/ex2_b, replace
estat dualci
sjlog close, replace
