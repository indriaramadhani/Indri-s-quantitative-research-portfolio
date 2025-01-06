This code used to examine the impact of average oil price uncertainty on profitability of banks in middle east using static and dynamic panel. We provide 5 models including POLS, RE, FE, 1st difference GMM, and System GMM to identify proper model to be choosen. 

***Panel Setting***
tsset code year

***generate new variable***
gen lta = log(ta)
gen lorent = log(orent)
gen loaopu = log(aopu)
gen daopu = (loaopu-l.loaopu)*100
reg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc
gen yo8 = abs(year-2008)<1
gen yo9 = abs(year-2009)<1
gen gfc = yo8+yo9

***pre-testing***
sum roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc
asdoc sum roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc
corr roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc
asdoc corr roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc
dfuller roa
dfuller daopu
dfuller l.lta
dfuller l.eta
dfuller l.lqta
dfuller l.cir''
dfuller l.nonii
dfuller gdpg
dfuller infdef
dfuller lorent
dfuller gfc

***POLS regression model and robustness***
reg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc
eststo pols
reg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, vce (robust)


***RE Model and robustness***
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc,re
eststo re
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc,re vce (robust)
 

***FE Model and robustness***
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc,fe
eststo fe
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc,fe vce (robust)
eststo ferobust

***model selection (POLS vs RE vs FE)***
reg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, re 
xttest0 
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, re
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, fe  
hausman fe 

***classical assumption test based on selected model (FE)***
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, fe
xttext0
xtserial roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc
xtreg roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, fe
xtcsd, pesaran

**1st difference GMM model and robustness ***
xtabond2 roa l.roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, gmm(l.roa) iv(daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, eq(dif)) twostep h(2) nolevel
xtabond2 roa l.roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, gmm(l.roa) iv(daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, eq(dif)) twostep h(2) nolevel robust
xtabond2 roa l.roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc if year > 2009, gmm(l.roa) iv(daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, eq(dif)) twostep h(2) nolevel robust
xtabond2 roa l.roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc if year > 2009, gmm(l.roa, lag (1 2)) iv(daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, eq(dif)) twostep h(2) nolevel robust
eststo diffgmm

***System GMM model and robustness***
xtabond2 roa l.roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc if year > 2009, gmm(l.roa, lag (1 4)) iv(daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, eq(dif)) twostep h(2) robust
xtabond2 roa l.roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc if year > 2009, gmm(l.roa, lag (1 3)) iv(daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, eq(dif)) twostep h(2) robust
eststo sysgmm
xtabond2 roa l.roa daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc if year > 2009, gmm(l.roa, collapse) iv(daopu l.lta l.eta l.lqta l.cir l.nonii gdpg infdef lorent gfc, eq(dif)) twostep h(2) robust

***Combine result***
esttab pols re fe ferobust using table1.rtf, replace star(* 0.1 ** 0.05 *** 0.01) b(4) scalar(N N_g r2_o)
esttab diffgmm sysgmm, star (* 0.1 ** 0.05 *** 0.01) nogap nonum compress scalars (N N_g j hansenp ar1p ar2p)


