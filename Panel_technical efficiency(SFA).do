This code using to calculate technical efficiency using stochactic frontier analysis across different models. Then we conduct the technical efficiency score into second step to identify whether ESG performance affect firm technical efficiency for testing the existance of stakeholder and agnecy theories. 

***panel setting***
tsset code year

***output installation***
ssc install estout
ssc install asdoc

---------------SFA Panel----------------------------------- // belotti paper

***Panel time-varying inefficiency models*** 
-Lee and Schmidit (1993) // ls93 model
sfpanel gp ta cogs, model(fels)
estimates store fels
predict uhat_fels, u

-Cornwell, Schmidt, and Sickles (1990) // css90
sfpanel gp ta cogs, model(fecss)
estimates store fecss
predict uhat_fecss, u

***Panel time-invariant inefficiency models***
-Schmidt and Sickles (1984) // ss84
sfpanel gp ta cogs, model(fe)
estimates store fess_sf
predict uhat_fess, u

-other stata code for testing ss84
xtreg gp ta cogs, fe
estimates store fess_xt

***True FEM and REM** // the models allow to disentangle time-invariant heterogeneity from time-varying inefficiency
-Normal Exponential TFEM on TFE
sfpanel gp ta cogs, model(tfe) distribution(exp) rescale
estimate store tfe_c
predict u_tfe_c, u

-Normal Exponential TREM on TFE (tre1)
sfpanel gp ta cogs, model(tre) distribution(exp) rescale
estimate store tre_c
predict u_tre_c, u

-Normal Exponential TREM on TRE (tre2)
sfpanel gp ta cogs, model(tre) distribution(exp) rescale
estimate store tre_c
predict u_tre_c, u

-tim varying model
xtfrontier gp ta cogs, tvd
-tim varying model with constraints model
xtfrontier gp ta cogs, tvd constraints (1)
-half normal and exponential distribution for IE
regress gp ta cogs
frontier gp ta cogs
frontier gp ta cogs, distribution (exponential)
predict u_e, IE1
predict u_h, IE2
-when firm using constant return to scale
frontier gp ta cogs, vhet(size)
regress lgp lcogs lta




-----------------Testing ESG on TE--------------------
***desc.statistic***
asdoc su te esg tag roa dar gdpg

***Correlation test***
asdoc cor te esg tag roa dar gdpg

***stationary test***
xtunitroot llc te
xtunitroot llc esg
xtunitroot llc tag
xtunitroot llc roa
xtunitroot llc dar
xtunitroot llc gdpg

-----------------Static Panel--------------------------

***ESG***
reg te esg tag roa dar gdpg
eststo Model1
xtreg te esg tag roa dar gdpg, re
eststo Model2
est store random
xttest0
xtreg te esg tag roa dar gdpg, fe
eststo Model3
est store fixed
xtreg te esg tag roa dar gdpg, re
hausman fixed
xtreg te esg tag roa dar gdpg, fe vce(robust)
eststo Model4

-combine result Table ESG-
esttab Model1 Model2 Model3 Model4 using result1.rtf, replace star(* 0.1 ** 0.05 *** 0.01) b(4) scalar(N N_g r2)

---classical assumption ESG---
-Normality
xtreg te esg tag roa dar gdpg, fe
predict resid1
swilk resid1

-Heteroscedasticity
xtreg te esg tag roa dar gdpg, fe
xttest3

-Autocorrelation
xtserial te esg tag roa dar gdpg

-Crossectional depenence
xtreg te esg tag roa dar gdpg, fe
xtcsd, pesaran 