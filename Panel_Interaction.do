This code used to identify the impact of techincal effiicency (using Stochastic Frontier Analysis) on market performance (Tobin's Q) when its moderating by ESG performance of company.

tsset code year

sum tq esg te ta roa dar gdpgusd covid
asdoc sum tq esg te ta roa dar gdpgusd covid
cor tq esg te ta roa dar gdpgusd covid
asdoc cor tq esg te ta roa dar gdpgusd covid


***generate interaction variable***
gen esg_te = esg*te // esg act as moderating effect


***equation 1 impact of te on tq***
regress tq te ta roa dar gdpgusd covid
xtreg tq te ta roa dar gdpgusd covid, re
est store re
xttest0
xtreg tq te ta roa dar gdpgusd covid, fe
est store fe
xtreg tq te ta roa dar gdpgusd covid, re
est store re
hausman fixed
xtreg tq te ta roa dar gdpgusd covid, fe
eststo model01
xtreg tq te ta roa dar gdpgusd covid, fe vce(robust)

-Heteroscedasticity
xtreg tq te ta roa dar gdpgusd covid, fe
xttest3

-Autocorrelation
xtserial tq te ta roa dar gdpgusd covid

-Crossectional depenence
xtreg tq te ta roa dar gdpgusd covid, fe
xtcsd, pesaran 


***equation 2 impact of esg on tq***
regress tq esg ta roa dar gdpgusd covid
xtreg tq esg ta roa dar gdpgusd covid, re
est store re
xttest0
xtreg tq esg ta roa dar gdpgusd covid, fe
est store fe
xtreg tq esg ta roa dar gdpgusd covid, re
est store re
hausman fixed
xtreg tq esg ta roa dar gdpgusd covid, fe
eststo model02
xtreg tq esg ta roa dar gdpgusd covid, fe vce(robust)

-Heteroscedasticity
xtreg tq esg ta roa dar gdpgusd covid, fe
xttest3

-Autocorrelation
xtserial tq esg ta roa dar gdpgusd covid

-Crossectional depenence
xtreg tq esg ta roa dar gdpgusd covid, fe
xtcsd, pesaran 


***equation 3 impact of te and esg with interaction on tq***
regress tq esg te esg_te ta roa dar gdpgusd covid
xtreg tq esg te esg_te ta roa dar gdpgusd covid, re
est store re
xttest0
xtreg tq esg te esg_te ta roa dar gdpgusd covid, fe
est store fe
xtreg tq esg te esg_te ta roa dar gdpgusd covid, re
est store re
hausman fixed
xtreg tq esg te esg_te ta roa dar gdpgusd covid, fe
eststo model03
xtreg tq esg te esg_te ta roa dar gdpgusd covid, fe vce(robust)
eststo model04

-Heteroscedasticity
xtreg tq te esg esg_te ta roa dar gdpgusd, fe
xttest3

-Autocorrelation
xtserial tq te esg esg_te ta roa dar gdpgusd

-Crossectional depenence
xtreg tq te esg esg_te ta roa dar gdpgusd, fe
xtcsd, pesaran 


***combine result***
esttab model01 model02 model03 model04 using result1.rtf, replace star(* 0.1 ** 0.05 *** 0.01) b(4) scalar(N N_g r2)


***identify marginal effect on interaction model***
sum te // check min and max value
lincom esg +0.142*esg_te //lincom= linear combination, insert min value, identify again min and max 
lincom esg +0.836*esg_te // insert max value. identify again min and max

#delimit ;
set more off;

set obs 10000;

matrix b=e(b); 
matrix V=e(V);
scalar b1=b[1,3]; //2=variable that we want to compute the marginal effect
scalar b3=b[1,4]; //4= for interaction model
scalar varb1=V[3,3];
scalar varb3=V[4,4];
scalar covb1b3=V[3,4];
scalar list b1 b3 varb1 varb3 covb1b3;

generate MVZ=((_n+7.16)/1); // 1 express increment/denominator _n+7.16 means what value do we need to get the minimum value of interaction variable, when _n=1 and min infdef =8.16
replace  MVZ=. if _n>81; // how many marginal effects need to be check from 8.16 to 88.86 divided by 1
gen conbx=b1+b3*MVZ if _n<82; 
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<82; // compute marginal effect
gen ax=1.96*consx; // compute the significant, suign z-score normal distribution table 0.96 for 95% confident interval
gen upperx=conbx+ax;
gen lowerx=conbx-ax;

gen where=-0.045; //how to create the graph 
gen pipe = "|";
egen tag_esg_te = tag(esg_te);

gen yline=0;

graph twoway hist esg_te, width(5) percent color(gs14) yaxis(2)
	||   scatter where esg_te if tag_esg_te, plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off)
      ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
      ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
      ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
      ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
      ||   ,
           xlabel(8 16 24 32 40 48 56 64 72 80, nogrid labsize(2))
	     ylabel(-50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 , axis(1) nogrid labsize(2))
	     ylabel(0 2 4 6 8 10 12 14 16, axis(2) nogrid labsize(2))
           yscale(noline alt)
	     yscale(noline alt axis(2))	
           xscale(noline)
           legend(off)
           xtitle("esg" , size(2.5)  )
           ytitle("Marginal Effect" , axis(1) size(2.5))
           ytitle("Percentage of Observations" , orientation(rvertical) margin(small) axis(2) size(2.5))

           xsca(titlegap(2))
           ysca(titlegap(2))
      	 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

drop MVZ conbx consx ax upperx lowerx where pipe tag_esg_te yline;


