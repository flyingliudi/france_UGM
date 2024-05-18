cscript

do compile

// adopath ++ ../../src

local logs ../logs/
/*-----------------------------------------------------------------------------
	DGP	
-----------------------------------------------------------------------------*/
					//----------------------------//
					//  parameter set up	
					//----------------------------//
local seed 1234567
set seed `seed'
local nobs = 1000
local px = 2
local pz = 2
local pd = 1
local alpha = 1
local beta = 1
local gamma = 1
local tau = 0.6
					//----------------------------//
					// true alpha and beta	
					//----------------------------//
dgp_ivqreg, 		///
	nobs(`nobs') 	///
	px(`px') 	///
	pd(`pd') 	///
	pz(`pz')	///
	alpha(`alpha') 	///
	beta(`beta')	///
	gamma(`gamma')	///
	tau(`tau')

/*-----------------------------------------------------------------------------
	wald plot	
-----------------------------------------------------------------------------*/
sjlog using `logs'/log_wald1, replace
ivqregress iqr y x1 x2 (d1 = z1 z2),  quantile(40) noadaptive
sjlog close, replace

sjlog using `logs'/log_wald2, replace
estat waldplot
sjlog close, replace

graph export ../eps/waldplot.png, replace

sjlog using `logs'/log_wald3, replace
estat dualci
sjlog close, replace

/*-----------------------------------------------------------------------------
	adaptive grid search	
-----------------------------------------------------------------------------*/
sjlog using `logs'/log_wald4, replace
use assets2, clear

ivqregress iqr assets (i.p401k = i.e401k) income age familysize	///
	i.married i.ira i.pension i.ownhome educ, quantile(50) noadaptive

estat waldplot, name(a)
sjlog close, replace

graph export ../eps/waldplot_asset.png, replace


sjlog using `logs'/log_wald5, replace
use assets2, clear

ivqregress iqr assets (i.p401k = i.e401k) income age familysize	///
	i.married i.ira i.pension i.ownhome educ, quantile(50) 

estat waldplot, name(b)
sjlog close, replace

graph export ../eps/waldplot_asset2.png, replace

graph combine a b
graph export ../eps/waldplot_asset3.png, replace


