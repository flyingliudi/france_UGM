*! version 1.0.0  02aug2021
program moment_ivqreg, rclass
	syntax [if] [in], 	///	
		alpha(string)	///
		beta(string)	///
		cons(string)	///
		depvar(string)	///
		tau(string)	///
		[xvars(string)	///
		dvars(string)	///
		zvars(string)]

	marksample touse

	mata: moment_ivqreg(	///
		`tau',		///
		`cons',		///
		`alpha', 	///
		`beta', 	///
		`"`touse'"',	///
		`"`depvar'"',	///
		`"`xvars'"', 	///
		`"`dvars'"', 	///
		`"`zvars'"')
end

/*-----------------------------------------------------------------------------
	mata utilities		
-----------------------------------------------------------------------------*/
mata:
mata set matastrict on

void moment_ivqreg(			///
	real scalar	_tau,		///
	real scalar	_cons,		///
	real scalar	_alpha, 	///
	real scalar	_beta, 		///
	string scalar 	_touse,		///
	string scalar 	_depvar,	///
	string scalar 	_xvars, 	///
	string scalar 	_dvars, 	///
	string scalar 	_zvars)
{
	real colvector	y, u, ones, ghat
	real matrix	X, D, Z, alpha, beta, Psi, Omega
	real scalar	N, obj, quasi_ll

	y = st_data(., _depvar, _touse)
	N = length(y)
	ones = J(N, 1, 1)
	
	if (_xvars != "") {
		X = st_data(., _xvars, _touse)
	}
	else {
		X = J(N, 1, 0)
	}

	if (_dvars != "") {
		D = st_data(., _dvars, _touse)
	}
	else {
		D = J(N, 0, 0)
	}

	Z = st_data(., _zvars, _touse)
	u = _tau :- ((y - rowsum(D*_alpha:+X*_beta):-_cons):<= 0)

	Psi = ones, Z

	ghat = colsum(u:*Psi)'/N
	Omega = invsym(cross(Psi, Psi)/N)/(_tau*(1-_tau))

	obj = N*ghat'*Omega*ghat/2
	quasi_ll = exp(-obj)

	st_numscalar("return(ivqreg_obj)", obj)
	st_numscalar("return(quasi_ll)", quasi_ll)
}

end
