# TimeSeries-STATA
The dataset arma.dta contains US macroeconomic indicators, such as the average product of labor, the level of unemployment, the level of the labor force, the level of vacancies, as well as a qrt time variable.

I generate autocorelation graphs for the level of unemployment for different scenarios: log, dlog, cyclical component. Then I model them as ARMA processes using
the Box Jenkins approach controling for ARCH and GARCH, modifying the specications as needed for heteroskedasticity.
