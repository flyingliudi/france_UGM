cscript 

set scheme stcolor

do compile

// adopath ++ ../../src

local logs ../logs
local eps ../eps

/*-----------------------------------------------------------------------------
	utility	
-----------------------------------------------------------------------------*/
program mydgp, rclass
	syntax, nobs(string) 	///
		px(string) 	///
		pd(string) 	///
		pz(string)	///
		alpha(string) 	///	coef for d
		beta(string)	///	coef for x
		gamma(string)	///	coef for z
		tau(string)	///
		[integerx	///
		lo]

	clear
	qui set obs `nobs'

					// generate u
	qui gen u = runiform(0, 1)
					// generate x and xb
	tempvar xb
	qui gen double `xb' = 0
	forvalues i = 1/`px' {

		if (`"`integerx'"' != "") {
			qui gen double x`i' = runiformint(0, 6)
		}
		else {
			qui gen double x`i' = rnormal()
		}

		if (`"`lo'"' == "") {
			qui replace `xb' = x`i'*(`beta' + u) + `xb'
		}
		else {
			qui replace `xb' = x`i'*`beta' + `xb'
		}
	}
	local beta_true = `beta' + `tau'

					// generate z and zr
	tempvar zr
	qui gen double `zr' = 0
	forvalues i = 1/`pz' {
		qui gen double z`i' = rnormal()
		qui replace `zr' = `zr' + z`i'*`gamma'
	}

					// generate d and da
	qui gen double v = runiform(0, 1)

	tempvar da
	qui gen double `da' = 0
	forvalues i = 1/`pd' {
		qui gen double d`i' = `zr'*( v + runiform(-0.5, 0.5) < u) + u
		qui replace `da' = `da' + d`i'*(`alpha' + u)
	}
	local alpha_true = `alpha' + `tau'

					// generate y
	local df = 15
	qui gen y = `xb' + `da' + (invchi2(`df', u) - `df')/sqrt(2*`df')
	local cons_true = (invchi2(`df', `tau')-`df')/sqrt(2*`df')

	ret scalar alpha_true = `alpha_true'
	ret scalar beta_true = `beta_true'
	ret scalar cons_true = `cons_true'


end
					//----------------------------//
					//  graph 
					//----------------------------//
program mygraph
	syntax [, *]

	tab x1, matrow(xlist)
	mat li xlist
	local k : rowsof xlist
	
	gen fyx_y = 0 if x1 == 0
	
	gen fyx_lb = .
	
	forvalues i = 1/`k' {
		local aa = xlist[`i', 1]
		qui kdensity y if x1 == `aa', gen(kx_`i' kk1_`i') nodraw
	
		local shift = `aa'/`k'
		qui gen kk0_`i' = `shift'
		qui replace kk1_`i' = kk1_`i' + `shift'
	
		label define lb_fyx `i' "f(y|x=`aa')", modify
		qui replace fyx_lb = `i' if x1 == `aa'
	
		if (`i' > 1) {
			qui replace fyx_y = `shift' if x1 == `aa'
		}
	
		local ra`i' rarea kk1_`i' kk0_`i' kx_`i',	///
			fcolor(%30) 				///
			legend(off) 				///
			ytitle("")				///
			xtitle("") 				///
			lw(vthin)				
		
		local gr `ra`i'' || `gr'
	}
	
	label values fyx_lb lb_fyx
	
	sum y
	gen fyx_x = r(max)-1 
	twoway `gr' || scatter fyx_y fyx_x , 		///
		msymbol(none) 				///
		mlabel(fyx_lb) 				///
		mlabsize(*1.5) ||			///
		, ylabel(, nolabels noticks nogrid) 	///
		yscale(noline) 				///
		ytitle("") 				///
		xtitle("outcome") 			///
		legend(off)				///
		`options'
end

/*-----------------------------------------------------------------------------
	test	
-----------------------------------------------------------------------------*/
set seed 123456871

local nobs = 50000
local px = 1
local pz = 0
local pd = 0
local alpha = 1
local beta = 1
local gamma = 1 
local tau = 0.6
local cov = 0.5


mydgp, 			///
	nobs(`nobs') 	///
	px(`px') 	///
	pd(`pd') 	///
	pz(`pz')	///
	gamma(`gamma')	///
	alpha(`alpha')	///
	beta(`beta')	///
	tau(`tau')	///
	integerx	///
	lo
	
mygraph, title(location shift: y = {&beta}{sub:0}(u) + x{&beta}{sub:1}) ///
	name(loc_only)


mydgp, 			///
	nobs(`nobs') 	///
	px(`px') 	///
	pd(`pd') 	///
	pz(`pz')	///
	gamma(`gamma')	///
	alpha(`alpha')	///
	beta(`beta')	///
	tau(`tau')	///
	integerx	
	
mygraph, title(location-scale: y = {&beta}{sub:0}(u) + x{&beta}{sub:1}(u))  ///
	name(loc_scale)

graph combine loc_only loc_scale, name(beyondm) ycommon xcommon altshrink
graph export `eps'/beyondm.png, replace

