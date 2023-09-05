# MichaelisMenten_fit
This repository holds the code for a R ShinyApp to fit non-linear models to the Michaelis-Menten equation (u ~ Vmax*S/(Km + S)). Where, u represents the reaction rate, Vmax is the maximum velocity of the reaction, Km is the Michaelis constant, and S is the substrate concentration. It outputs, model parameters and standard errors of the estimation.

For working properly, the Rstudio must be installed, along with the 'shiny', 'ggplot2' and 'dplyr' packages. If new to R, remove the '#' at the beginning for each line and run the first 3 lines of code. 

On the left side panel, the user has six fields to enter information.
'Assay Temperature (C)' and 'Replicate' are optional, they do not interfere with the analysis. Both provide extra information of the particular assay. They can be left blank or as NA. 
'Substrate concentrations' and 'Reaction rates' correspond to the data that will be plotted and analyzed using the Michaelis-Menten equation. Please enter data separated by spaces or copy and paste the data as a column directly from Excel. 'Substrate concentrations' (x axis) corresponds to the concentration of the substrate for each reaction, usually in mM. 'Reaction rates' (y axis) corresponds to the specific activity or rate of the reaction of the enzyme for the given substrate concentration.  
The plot on the right will automatically populate as that are entered.
'Starting value for Vmax' is a best guess the user can provide for Vmax based on the data. It corresponds with the asymptote of the graph. Add the (y-axis) value of the plateau, or the maximum rate.
'Starting value for Km' is a best guess the user can provide for Km based on the data. It corresponds with the asymptote of the graph. Add the (x-axis) value that visually corresponds with 50% of the plateau.
The final estimations of the parameters or quality of the fit are independent of the starting values.

Upon completion of these fields, the user clicks on the 'Fit' button for the App to run the analysis.
If the fit was successful, the plot on the right will show the non-linear fitted line, a summary table of the fit appears below the graph, and a 'Copy Fit' button appears below the table.
The summary table presents the Michaelis-Menten parameter estimations, with 'Km' and 'Vmax' as separate rows. The table has eight columns ('Temperature',	'Rep',	'Parameter',	'Estimate',	'SE',	'LowerLimit_95CI',	'UpperLimit_95CI',	'p.value'). The first two ('Temperature' and	'Rep') match the user data entered on 'Assay Temperature (C)' and 'Replicate'. 'Estimate',	'SE',	'LowerLimit_95CI',	'UpperLimit_95CI',	'p.value', are all estimated after running the nonlinear model fit using the nls() function in R. 'Estimate' and 'SE' corresponds with the parameter estimate and standard error, respectably. 'LowerLimit_95CI',	'UpperLimit_95CI' are the lower and upper limits of the 95% confidence interval around the parameter estimate. 'p.value' is the probability associated with the parameter estimation being equal to zero. This is, if p > 0.05, then the parameter is not statistically different from zero.
If the user is satisfied with the model and out, then s/he may click on 'Copy Fit' to copy the summary table and paste elsewhere (preferentially Excel for best formatting, then copy to Word if needed).

If the model doesn't fit, the summary table won't appear and an 'Error:' statement will appear. The best action is to try again with better starting points for Km and Vmax.

In case of questions, don't hesitate to contact Mauricio Tejera-Nieves (mauri@msu.edu) or Berkley Walker (Berkley@msu.edu)
