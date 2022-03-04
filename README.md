# TimeSeries-STATA
1. The dataset arma.dta contains US macroeconomic indicators, such as the average product of labor, the level of unemployment, the level of the labor force, the level of vacancies, as well as a qrt time variable. I generate autocorelation graphs for the level of unemployment for different scenarios: log, dlog, cyclical component. Then I model them as ARMA processes using
the Box Jenkins approach controling for ARCH and GARCH, modifying the specications as needed for heteroskedasticity.

2. The OECDar.dta dataset contains GDP data for US, France, Switzerland, and Australia. The univariate time series process is modeled as an autoregressive (AR) process. I give a one-unit shock to each country's output and construct impulse response functions to demonstrate how it returns to steady state.
