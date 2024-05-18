cscript quantile regression

set scheme stcolor

/*-----------------------------------------------------------------------------
	initialization	
-----------------------------------------------------------------------------*/
					//----------------------------//
					//  parameter set up	
					//----------------------------//
local seed 1234567
set seed `seed'
local nobs = 100
local px = 0
local pz = 1
local pd = 1
local alpha = 0
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

local cons = r(cons_true)
local frname moment_obj
local frdta mooment_dta
frame create `frname' alpha obj ll

/*-----------------------------------------------------------------------------
	graph	
-----------------------------------------------------------------------------*/
forvalues a=-2(0.02)2 {
	moment_ivqreg, tau(`tau') alpha(`a') beta(`beta') 	///
		cons(`cons') depvar(y) dvars(d*) zvars(z*)
	local obj = r(ivqreg_obj)
	local ll = r(quasi_ll)

	frame post `frname' (`a') (`obj') (`ll')
}

frame `frname' : save `frdta', replace

use `frdta', clear
line obj alpha, ytitle("Criterion") xtitle("{&alpha}")	///
	title("IVQREG criterion function")
graph export ../eps/ivqreg_obj.eps, replace



