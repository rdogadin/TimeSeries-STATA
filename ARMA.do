* Clear all variables
clear 

* disable the pause
set more off

* load dataset
use arma.dta

* label variables
label variable u "US Unemployment"
label variable apl "US Avg product of labor"
label variable lf "US Labor force"
label variable v "US Open Vacancies"
label variable quarter "Quarter time period"

* set time variable
tsset quarter

* Generate a log of u to stabilize the variance
g logu = ln(u)
label variable logu "Ln of Unemployment"

* Generate partial-autocorrlation and autocorrelation graphs
ac logu, name(aclogu, replace) nodraw
pac logu, name(paclogu, replace) nodraw

* Combine PAC/AC graphs
graph combine paclogu aclogu, name(combineu1,replace)

/*
 The results of autocorrelation show that the time series is
 non-stationary, because the graph reveals autocorrelation with slow
 linear convergence to zero. I am seeing 18 observations outside the 95%
 interval that decline lineary before they enter the band. 
*/

* Generate a log of u
g dlogu = d.logu
label variable dlogu "Unemployment growth rate"

* Generate PAC and AC graphs for the growth rate
ac dlogu, name(acdlogu, replace) nodraw
pac dlogu, name(pacdlogu, replace) nodraw

* Combine PAC/AC graphs
graph combine pacdlogu acdlogu, name(combineu2,replace)

* tsline dlogu
* tsline logu
/*
 The AC graph is now showing stationary time series after I applied 
 the differencing technique. The series collapses
 into the 95% band after a second observation and then strictly stays in
 the interval. We are not observing any slow linear convergence to 0, instead
 it is quick and instant. We can also confirm our findings by eyeballing 
 the graphs of logu and dlog. The former has an obvious trend, where the latter
 series is detrended.
*/

* Extract the cyclical component from the log
* by applying the filtering technique
tsfilter hp Clogu = logu, smooth(1600)
label variable Clogu "Cyclical component of log u"

* Generate PAC and AC graphs for the cyclical component
ac Clogu, name(acClogu, replace) nodraw
pac Clogu, name(pacClogu, replace) nodraw

* Combine PAC/AC graphs for Clogu
graph combine pacClogu acClogu, name(combineu3,replace)

/*
 The AC graph for the cyclical component is also showing stationary time series 
 after I applied smoothing technique. It is stationary because the series collapses
 into the 95% band after the a third observation. It then stays in
 the interval for a few observations and starts to stick out again for 5 observations,
 but I consider it spurious. The autocorrelation of the series dies out right away
 without any linear decline
*/

* Extract the cyclical component from the log
* by applying the filtering technique
tsfilter hp C2logu = logu, smooth(100000)
label variable C2logu "Cyclical component of log u - 100000"

* Generate PAC and AC graphs for the cyclical component
ac C2logu, name(acC2logu, replace) nodraw
pac C2logu, name(pacC2logu, replace) nodraw

* Combine PAC/AC graphs for Clogu
graph combine pacC2logu acC2logu, name(combineu4,replace)

/*
 As the smoothing parameter increases in value the cycle assumes higher frequency.
 We can see that on the acC2logu graph where the time series is still stationary,
 but the autocorrelation declines a lot more lineary with first 6 observations away 
 away from the 95% band. A comparison of standard deviation shows that the 1600 
 smoothing suggests a potentially better fit with smaller deviation of 0.13, 
 compared to 0.2 of the 100000 smoothing
*/

/*
ARMA Considerations:

- logu is non-stationary time series and ARMA cannot be used unless we USE ARIMA to 
	difference it first

- dlogu: I would start with ARMA(1,2) since the first observation is sticking out 
	in the PAC and the first two in the AC graphs

 - Clogu: ARMA(2,3) would be my first choice because first 2 observations lie oustide 
	of the 95% interval on the PAC graph and 3 on the AC graph

- C2logu: I would go with ARMA(2,6) since first 2 observations lie oustide 
	of the band on the PAC graph and 6 on the AC graph
*/

* Apply parsimony to the dlogu model
arima dlogu, arima(1,0,2) nolog

/* The result of the arima(1,0,2) looks not so good, because the coefficient is 
 insignificant and both lags in the MA component are insignificant; the AR(1) 
 component is significant at the 1% level */
 
* Chop off the second lag of MA component
arima dlogu, arima(1,0,1) nolog 
* The AR component is now even more signofocant and the MA(1) became significant
* at the 5% level; the coefficient is still insignificant
* Although this result is satisfactory, let so ahead and try to chop off the entire MA component

arima dlogu, arima(1,0,0) nolog 
* no gains here: the same insignificant coefficient and very significant AR component

* Let's now try to be persiomonious with the AR component and chop the only one we have
arima dlogu, arima(0,0,2) nolog
* The result looks pretty good: the coefficient is still insignificant, but both MA lags are 
* signinificant at the 1% level

* For dlogu my working models are AR(1,1) and MA(2)
* Let's now try and overfit them
* Add 1 lag to the AR component of AR(1,1) 
arima dlogu, arima(2,0,1) nolog 
* Great success! All our lags are now significant, including the new one and the model has improved
* Add one more
arima dlogu, arima(3,0,1) nolog 
* This is no good: broke the MA and added an insignificant AR. Rolling back to the previous one

* Let's now experiment with the second model MA(2) and add an extra lag
arima dlogu, arima(0,0,3) nolog 
* this is great: all three lags are very significant at the 1% level, but the coefficient is still not
* let's add one more
arima dlogu, arima(0,0,4) nolog 
* this is even better than the previous one with an additional significant lag
* keep going
arima dlogu, arima(0,0,5) nolog 
* another significant lag
arima dlogu, arima(0,0,6) nolog 
* this one is also good, but I have a feeling this is going to be the last one, because the last lag 
* is on the edge with 5%. One more...
arima dlogu, arima(0,0,7) nolog 
* Yep. this one is no good, because it insignified some of the previous lags, so we are sticking with 
* MA(6) and ARMA(2,1) as my final working models for dlogu

* Let's now apply the same technique to Clogu
* Initially I have concluded to start out with ARMA(2,3)
arima Clogu, arima(2,0,3) nolog
* the results of ARIMA look really bad with the coefficiant and all MA lags being very insignificant

* Let's first apply persimony to the MA component and start choping off some of that junk - one at a time
arima Clogu, arima(2,0,2) nolog
* this is not any better - all MAs are still insignificant. Let's keep going
arima Clogu, arima(2,0,1) nolog
* both - the coefficient and MA(1) - are still insignificant. Let's remove the entire MA component
arima Clogu, arima(2,0,0) nolog
* Alright, the entore MA component was redundunt, so we could easily get rid off it and it didn't 
* affect the AR component. The coefficient have stayed pretty much the same 

* Let's now try to be persiomonious with the AR component
arima Clogu, arima(1,0,3) nolog
* Very nice! all the lags in both components became very signinificant at the 1% level. The coefficiant 
* hasn't changed, but that's okay

* Although this result is satisfactory already, and I feel like stopping, but let's see what happens if I 
* chop off the last one
arima Clogu, arima(0,0,3) nolog
* That didn't change a thing so we should really go back to the previous model

* For now we have two workable models ARMA(1,3) and AR(2)
* Let' now try and OVERFIT them by adding one to the MA component of ARMA(1,3) -> ARMA(1,4)
arima Clogu, arima(1,0,4) nolog
* this added another significant lag to the MA part, but broke the AR component, so I am not going to use it

* Let's now overfit the AR(2) by adding 1 to test AR(3)
arima Clogu, arima(3,0,0) nolog
* this is added an insignificant third lag - not good
* we confirm that our final working models for Clogu are ARMA(1,3) and AR(2)

* Let's do residual test for all 4 models to check for white noise
* dlogu: MA(6) and ARMA(2,1) 
* Clogu: ARMA(1,3) and AR(2)
quietly arima Clogu, arima(1,0,3) nolog
predict CloguArma13_e, resid
label variable CloguArma13_e "Clogu ARMA(1,3)"
wntestq CloguArma13_e
* 37% - looks good

quietly arima Clogu, arima(2,0,0) nolog
predict CloguAr2_e, resid
label variable CloguAr2_e "Clogu AR(2)"
wntestq CloguAr2_e
* 3% - very close to a failure, but still significant at 1% level - will keep it

quietly arima dlogu, arima(0,0,6) nolog
predict dloguMa6_e, resid
label variable dloguMa6_e "dlogu MA(6)"
wntestq dloguMa6_e
* 87% - white noise confirmed

quietly arima dlogu, arima(2,0,1) nolog
predict dloguArma21_e, resid
label variable dloguArma21_e "dlogu ARMA(2,1)"
wntestq dloguArma21_e
* 23% - looks good

* We can now compare standard deviations of the residuals and decided which models are better
sum CloguArma13_e CloguAr2_e dloguMa6_e dloguArma21_e
* The Std Dev for all 4 are super close to each other, but the lowest standard 
* deviation for Clogu of 0.46 belongs to ARMA(1,3)
* and the lowest st dev for dlogu is MA(6)

* We can now test our ARMA(1,3) model using ARCH/GARCH technique. I am going
* to start out with arch(1/5)
arch Clogu, arima(1,0,3) arch(1/5) nolog
* Only the first two effects of ARCH look significant. Let's go ahead and trim the rest
arch Clogu, arima(1,0,3) arch(1/2) nolog
* Looks even better and we can now use GARCH 
arch Clogu, arima(1,0,3) arch(1/2) garch(1/2) nolog
* the second garch effect is insignificant so we can drop it
arch Clogu, arima(1,0,3) arch(1/2) garch(1) nolog
* the model looks perfect now with both arch effects being signinificant as well as 
* the garch effect

* Test MA(6) using ARCH/GARCH
* Start out from arch(1/5)
* arch dlogu, arima(0,0,6) arch(1/5) nolog
* I am getting the "flat log likelihood encountered, cannot find uphill direction" error
* when use 4 or 5 effects. Only 3 effects provide an output, so I am going to start there
arch dlogu, arima(0,0,6) arch(1/3) nolog
* The third effect is insignificant, so I am going to drop it 
arch dlogu, arima(0,0,6) arch(1/2) nolog
* Both arch are very significant so I am keeping it and moving onto GARCH
* I am going to start with two GARCH terms since this is how many we have in the ARCH model
arch dlogu, arima(0,0,6) arch(1/2) garch(1) nolog
* The garch effect is insignificant and can be dropped
arch dlogu, arima(0,0,6) arch(1/2) nolog
* All looks good execept a few MA lags that turned insignificant
* Drop the last lag to see if it fixes the issue
arch dlogu, arima(0,0,5) arch(1/2) nolog
* L5 is still insignificant; go ahead and drop that one as well
arch dlogu, arima(0,0,4) arch(1/2) nolog
* looks perfect now with all four MA lags being very significant at 1% level, both ARCH effects
* being significant and the coefficient being significant at 10% level
/*
I would prefer to use arch dlogu, arima(0,0,4) arch(1/2) nolog, because the coefficient is significant at 10% level,
the MA lags are all very significant at 1% level and the ARCH effects and the coefficient are also siginificant at 1%.
This is provides a better fit than the arch Clogu, arima(1,0,3) arch(1/2) garch(1) nolog, that has an insufficient 
ARMA and ARCH coefficients
*/
