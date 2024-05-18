cscript


use sim_dualci, replace

collapse (mean) d1_r if est == "ivqreg_see", by(pd pz tau)

gen double coverage  = 1 - d1_r
label var coverage "Dual 95% CI coverage"
label var tau "Quantile"

twoway connected coverage tau if pd == 1 & pz == 1,	///
	yscale(range(0.92 0.98)) yline(0.95, lp(dash))

graph export ../eps/dualci.eps, replace
