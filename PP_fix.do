Project Paper_Fix_Do File

***data set***
gen month = mofd(Date)
format %tm month
codebook month
tsset month, monthly
summarize

***unit root test***
dfuller JII
dfuller OIL
dfuller EXC
dfuller GOLD
pperron JII
pperron OIL
pperron EXC
pperron GOLD
gen ljii = ln(JII)
gen loil = ln(OIL)
gen lgold = ln(GOLD)
gen lexc = ln(EXC)
dfuller ljii
dfuller loil
dfuller lexc
dfuller lgold
pperron ljii
pperron loil
pperron lexc
pperron lgold
gen dljii = D.ljii
gen dloil = D.loil
gen dlexc = D.lexc
gen dlgold = D.lgold
dfuller dljii
dfuller dloil
dfuller dlexc
dfuller dlgold
pperron dljii
pperron dloil
pperron dlexc
pperron dlgold
varsoc dljii dloil lexc lgold

***ARDL Bound Test***
ardl dljii dloil lexc lgold, lags(1 1 1 1) bic ec regstore(res)
estat ectest
estimates restore res
estat bgodfrey
estat imtest, white
predict res_p, residual
sktest res_p

***ECM***
regress JII OIL GOLD EXC
predict ect, resid
dfuller ect
regress dljii dloil dlexc dlgold L1.ect
regress dljii dloil dlexc dlgold L1.ljii L1.loil L1.lexc L1.lgold
estat ovtest
estat dwatson
hettest
estat bgodfrey
predict res_p, residual
sktest res_p
