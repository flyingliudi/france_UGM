cscript smoothed gmm plot 


mata:
mata set matastrict on
					//----------------------------//
					// smoothed indicator function
					//----------------------------//
real colvector I_sgmm(		///
	real colvector	x)
{
	real colvector	idx
	real colvector	y

	y = J(rows(x), 1, .)
					// y = 1 if x<= -1
	idx = selectindex(x:<=-1)
	if (length(idx)) {
		y[idx] = J(length(idx), 1, 1)
	}
					// y = 0 if x >= 1
	idx = selectindex(x:>=1)
	if (length(idx)) {
		y[idx] = J(length(idx), 1, 0)
	}
					// y =(1-v)/2 if -1 < x < 1
	idx = selectindex((x:<1):*(x:>-1))
	if (length(idx)) {
		y[idx] = (1:-x[idx])/2
	}

	return(y)
}
					//----------------------------//
					// create dataset for sgmm
					//----------------------------//
void Isgmm_dta()
{
	real scalar	nobs, i
	real vector	h, x, idx
	real matrix	Y
					// set x
	nobs = 1000
	x = rangen(-1.5, 1.5, nobs)
					// set bandwidth
	h = rangen(1E-1, 1, 5)
					// init Y	
	Y = J(rows(x), length(h), .)

	for (i = 1; i<=length(h); i++) {
		Y[., i] = I_sgmm(x/h[i])
	}

	stata("clear")

	st_addobs(nobs)
	(void) st_addvar("double", "x")
	idx = st_addvar("double", ("y":+strofreal(1::length(h)))')
	st_store(., "x", x)
	st_store(., idx, Y)

	for (i=1; i<= length(h); i++) {
		st_varlabel("y"+ strofreal(i), sprintf("h = %f", h[i]))	
	}
}

end

mata:
Isgmm_dta()
end

forvalues i = 1/10 {
	local plist `plist' p`i'
}

twoway line y1 x, lpattern(longdash_dot) 	///
	|| line y2 x, lpattern(dash)		///
	|| line y3 x, lpattern(dash_dot) 	///
	|| line y4 x, lpattern(shortdash) 	///
	|| line y5 x, lpattern(longdash) 	///
	xline(0, lpattern("--.."))	
graph export ../eps/i_sgmm.eps, replace



