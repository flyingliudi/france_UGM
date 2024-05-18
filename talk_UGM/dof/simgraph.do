local eps ../../talk_UGM/eps

set scheme stcolor
					//----------------------------//
					// d1
					//----------------------------//
cd ../../sim/15feb2022_iqr_see_d1
do graph

graph export `eps'/rej_d1.png, name(rej) replace

graph export `eps'/mbias_d1.png, name(mbias) replace

graph export `eps'/mbeta_d1.png, name(mbeta) replace
					//----------------------------//
					// d2
					//----------------------------//
cd ../16feb2022_see_d2/
do graph

graph export `eps'/rej_d2.png, name(rej) replace

graph export `eps'/mbias_d2.png, name(mbias) replace

graph export `eps'/mbeta_d2.png, name(mbeta) replace

					//----------------------------//
					// dula ci
					//----------------------------//
cd ../08mar2022_iqr_dualci/
do graph
graph export `eps'/dualci.png, name(cover) replace

cd ../../talk_UGM/dof
