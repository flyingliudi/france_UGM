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
sjlog using `logs'/ex1_a, replace
describe
global covariates income age familysize educ i.(married ira pension ownhome)
sjlog close, replace

					// IQR
sjlog using `logs'/ex1_b, replace
ivqregress iqr assets (i.p401k = i.e401k) $covariates, quantile(10(10)90)
estimates  store iqr
sjlog close, replace
					// SEE
sjlog using `logs'/ex1_c, replace
ivqregress smooth assets (i.p401k = i.e401k) $covariates, quantile(10(10)90)
estimates  store smooth
sjlog close, replace

					// estat coefplot
sjlog using `logs'/ex1_d, replace
estimates restore iqr
estat coefplot 1.p401k, name(iqr) title("IQR") legend(off)

estimates restore smooth
estat coefplot 1.p401k, name(smooth) title("SEE") legend(off)
sjlog close, replace

graph combine iqr smooth, name(g2)
graph export `eps'/coefplot2.png,  replace

					// estat endogeffects
sjlog using `logs'/ex1_e, replace
estimates restore iqr
estat endogeffects

estimates restore smooth
estat endogeffects
sjlog close, replace
