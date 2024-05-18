
**ivqregress** updates based on the group meeting
=================================================
Date: Mar 24 2022



ivqregress 
----------

1. **DONE** In -ivqregress iqr-, -varlist2- become -varname2-.

2. **DONE** -varlist1- become optional.

3. **DONE** -ivqregress see- becomes -ivqregress smooth-.

4. **DONE** Undocument -noadaptive- in -ivqregress iqr-.

5. **DONE** In -ivqregress smooth-, -seebwidth()- becomes -bwidth()-.

6. **DONE** In -ivqregress smooth-, -nosearchband- becomes -nosearchbwidth-
without abbreviation.

7. **DONE** In -ivqregress smooth-, add -tolerance()- and -ztolerance()-.

8. **DONE** Investigate to use the standard tools to display the coefficient
table header (squezzing some extra spaces).  -efsee peruout out4dev-

9. **DONE** When -ivqregress iqr- fails to converge, make the error message
explict about using -estat waldplot- for diagnosis.


estat coefplot
--------------

1. **DONE** Display the 2SLS estimates as a benchmark.

2. **DONE** -varlist- becomes -varname-. The default is the first endogenous
variable specified in the model.

3. **DONE** Add -95% pointwise CI- in the legend.

4. **DONE** Take -scatter_options- out of -cscatter()-. For an example, see
-lpoly-.

5. **DONE** Add -lineopts-.

6. **DONE** Change -cibands()- to -ciopts()-.

7. **DONE** Add option -no2sls- to suppress the 2SLS reference line.


estat endogeffects
------------------

1. **DONE** Change -estat proctest- to -estat endogeffects-, abbreviated as
-estat endogef- 

2. **DONE** Add option -all-, which implies all four hypotheses testing. -all-
is the default.

3. **DONE** Abbreviate -level()-, -noeffect-, and -constant-.

4. **DONE** -seed()- becomes -rseed()-.

5. **DONE** Add footnote:
If KS statistic < critial value, there is no sufficient evidence to reject the
null hypothesis.

6. **DONE** Add title: tests for endogenous effects.

7. **DONE** Abbreviate the KS statistic in the coef-table

8. **DONE** Fix Spacing between -replications- and the equal sign.

9. **DONE** Maybe add an clickable link for the definitions of different
hypotheses. Or add an option for more verbose display. Try both.


estat waldplot
--------------

1. **DONE** Abbreviate -level()-.

2. **DONE** Add graph title "Convergence diagnosis plot" with subtitle "tau = #"

3. **DONE** Lowercase the -statistic- in the y-axis title.

4. **DONE** Add twoway options.

5. **DONE** Add scatter options.

6. **DONE** Add ci options.

7. **DONE** If -quantile()- not specified, the quantile in the first equation is
implied.


estat dualci
------------

1. **DONE** Add title -Dual Confidence Interval- in the output.


predict
-------

1. **DONE** Abbreviate -residuals- as -res-.



