*! version 1.0.0  02aug2021
program dgp_ivqreg, rclass
	syntax, nobs(string) 	///
		px(string) 	///
		pd(string) 	///
		pz(string)	///
		alpha(string) 	///	coef for d
		beta(string)	///	coef for x
		gamma(string)	///	coef for z
		tau(string)	//

	clear
	qui set obs `nobs'

					// generate u
	qui gen u = runiform(0, 1)
					// generate x and xb
	tempvar xb
	qui gen double `xb' = 0
	forvalues i = 1/`px' {
		qui gen double x`i' = rnormal()
		qui replace `xb' = x`i'*(`beta' + u) + `xb'
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
		qui gen double d`i' = `zr'*( v < u) + u
		qui replace `da' = `da' + d`i'*(`alpha'*u)
	}
	local alpha_true = `alpha'*`tau'

					// generate y
	local df = 15
	qui gen y = `xb' + `da' + (invchi2(`df', u) - `df')/sqrt(2*`df')
	local cons_true = (invchi2(`df', `tau')-`df')/sqrt(2*`df')

	ret scalar alpha_true = `alpha_true'
	ret scalar beta_true = `beta_true'
	ret scalar cons_true = `cons_true'


end
