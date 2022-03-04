//Clear the memory
clear

//Set default "more" option off
set more off

//Load the data
use OECDar

//tsset the time variable
tsset year

//******************************
//******************************
//Set up United States variables
//******************************
//******************************

//Generate variables in per population terms
gen yy_us = y_us/pop15plus_us 
gen cc_us = c_us/pop15plus_us
gen gg_us = g_us/pop15plus_us
gen ii_us = i_us/pop15plus_us
gen nnx_us = (x_us - im_us)/pop15plus_us
gen hh_us = h_us/pop15plus_us

//Generate natural logarithm of variables
//(remember not to do so for net exports because
//this variable can be negative)
gen logyy_us = log(yy_us)
gen logcc_us = log(cc_us)
gen loggg_us = log(gg_us)
gen logii_us = log(ii_us)
gen loghh_us = log(hh_us)

//Generate cyclical components of the data
tsfilter hp logyy_us_cc = logyy_us, smooth(6.25)
tsfilter hp logcc_us_cc = logcc_us, smooth(6.25)
tsfilter hp loggg_us_cc = loggg_us, smooth(6.25)
tsfilter hp logii_us_cc = logii_us, smooth(6.25)
tsfilter hp nnx_us_cc = nnx_us, smooth(6.25)
tsfilter hp loghh_us_cc = loghh_us, smooth(6.25)

//**************************
//**************************
//Set up Australia variables
//**************************
//**************************

//Generate variables in per population terms
gen yy_aus = y_aus/pop15plus_aus 
gen cc_aus = c_aus/pop15plus_aus
gen gg_aus = g_aus/pop15plus_aus
gen ii_aus = i_aus/pop15plus_aus
gen nnx_aus = (x_aus - im_aus)/pop15plus_aus
gen hh_aus = h_aus/pop15plus_aus

//Generate natural logarithm of variables
//(remember not to do so for net exports because
//this variable can be negative)
gen logyy_aus = log(yy_aus)
gen logcc_aus = log(cc_aus)
gen loggg_aus = log(gg_aus)
gen logii_aus = log(ii_aus)
gen loghh_aus = log(hh_aus)

//Generate cyclical components of the data
tsfilter hp logyy_aus_cc = logyy_aus, smooth(6.25)
tsfilter hp logcc_aus_cc = logcc_aus, smooth(6.25)
tsfilter hp loggg_aus_cc = loggg_aus, smooth(6.25)
tsfilter hp logii_aus_cc = logii_aus, smooth(6.25)
tsfilter hp nnx_aus_cc = nnx_aus, smooth(6.25)
tsfilter hp loghh_aus_cc = loghh_aus, smooth(6.25)

//**************************
//**************************
//Set up France variables
//**************************
//**************************

//Generate variables in per population terms
gen yy_fra = y_fra/pop15plus_fra 
gen cc_fra = c_fra/pop15plus_fra
gen gg_fra = g_fra/pop15plus_fra
gen ii_fra = i_fra/pop15plus_fra
gen nnx_fra = (x_fra - im_fra)/pop15plus_fra
gen hh_fra = h_fra/pop15plus_fra

//Generate natural logarithm of variables
//(remember not to do so for net exports because
//this variable can be negative)
gen logyy_fra = log(yy_fra)
gen logcc_fra = log(cc_fra)
gen loggg_fra = log(gg_fra)
gen logii_fra = log(ii_fra)
gen loghh_fra = log(hh_fra)

//Generate cyclical components of the data
tsfilter hp logyy_fra_cc = logyy_fra, smooth(6.25)
tsfilter hp logcc_fra_cc = logcc_fra, smooth(6.25)
tsfilter hp loggg_fra_cc = loggg_fra, smooth(6.25)
tsfilter hp logii_fra_cc = logii_fra, smooth(6.25)
tsfilter hp nnx_fra_cc = nnx_fra, smooth(6.25)
tsfilter hp loghh_fra_cc = loghh_fra, smooth(6.25)

//**************************
//**************************
//Set up Switzerland variables
//**************************
//**************************

//Generate variables in per population terms
gen yy_swi = y_swi/pop15plus_swi 
gen cc_swi = c_swi/pop15plus_swi
gen gg_swi = g_swi/pop15plus_swi
gen ii_swi = i_swi/pop15plus_swi
gen nnx_swi = (x_swi - im_swi)/pop15plus_swi
gen hh_swi = h_swi/pop15plus_swi

//Generate natural logarithm of variables
gen logyy_swi = log(yy_swi)
gen logcc_swi = log(cc_swi)
gen loggg_swi = log(gg_swi)
gen logii_swi = log(ii_swi)
gen loghh_swi = log(hh_swi)

//Generate cyclical components of the data
tsfilter hp logyy_swi_cc = logyy_swi, smooth(6.25)
tsfilter hp logcc_swi_cc = logcc_swi, smooth(6.25)
tsfilter hp loggg_swi_cc = loggg_swi, smooth(6.25)
tsfilter hp logii_swi_cc = logii_swi, smooth(6.25)
tsfilter hp nnx_swi_cc = nnx_swi, smooth(6.25)
tsfilter hp loghh_swi_cc = loghh_swi, smooth(6.25)

//************************
//************************
//Generate IRFs and Graphs
//************************
//************************

//*******************
//Output AR processes
//*******************

//For the United States
//Run an AR process
quietly var logyy_us_cc
//Select the lag order
varsoc, maxlag(10)
//In all cases for simplicity we'll go with the shortest suggested lag
//Implement AR process with optimal lag
var logyy_us_cc, lag(1/3)
//Check for stability
varstable
//Generate IRF file
irf create L6US, set(L6yUS, replace) step(40)

//For Australia
//Run an AR process
quietly var logyy_aus_cc
//Select the lag order
varsoc, maxlag(10)
//In all cases for simplicity we'll go with the shortest suggested lag
//Implement AR process with optimal lag
var logyy_aus_cc, lag(1/7)
//Check for stability
varstable
//Generate IRF file
irf create L6Aus, set(L6yAus, replace) step(40)

//For France
//Run an AR process
quietly var logyy_fra_cc
//Select the lag order
varsoc, maxlag(10)
//Implement AR process with optimal lag
var logyy_aus_cc, lag(1/2)
//Check for stability
varstable
//Generate IRF file
irf create L6Fra, set(L6yFra, replace) step(40)

//For Switzerland
//Run an AR process
quietly var logyy_swi_cc
//Select the lag order
varsoc, maxlag(10)
//Implement AR process with optimal lag
var logyy_aus_cc, lag(1/5)
//Check for stability
varstable
//Generate IRF file
irf create L6Swi, set(L6ySwi, replace) step(40)

//*******************************
//Generate combined output graphs
//*******************************

clear
//Map Stata to where dataset is stored
* cd "/Users/rdogadin/Documents/Roman/JHU/Intl Finance/Lesson 5/HW 5/"
//Load the United States output IRF data
use L6yUS.irf
//Rename the United States IRF
rename irf US_yIRF
//Label the variable
label var US_yIRF "US_yIRF"
//Delete all data other than the IRF and the step
keep US_yIRF step
//Save the dataset
save yIRF.dta, replace

//Add on Australia's  IRF data
merge 1:1 step using L6yAus.irf
//Rename the Australia IRF
rename irf Aus_yIRF
//Label the variable
label var Aus_yIRF "Aus_yIRF"

//Delete all data other than the IRFs and the stop
keep US_yIRF Aus_yIRF step

//Add on France's  IRF data
merge 1:1 step using L6yFra.irf
//Rename the France IRF
rename irf Fra_yIRF
//Label the variable
label var Fra_yIRF "Fra_yIRF"

//Delete all data other than the IRFs and the stop
keep US_yIRF Aus_yIRF Fra_yIRF step

//Add on Swiss's  IRF data
merge 1:1 step using L6ySwi.irf
//Rename the Swiss IRF
rename irf Swi_yIRF
//Label the variable
label var Swi_yIRF "Swi_yIRF"

//Delete all data other than the IRFs and the stop
keep US_yIRF Aus_yIRF Fra_yIRF Swi_yIRF step

//Save the dataset
save yIRF.dta, replace

//Move on to combined output graph of output IRFs
tsset step
tsline US_yIRF Aus_yIRF Fra_yIRF Swi_yIRF, name(OutputIRFs, replace)
