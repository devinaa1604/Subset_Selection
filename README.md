# Subset Selection
This aims to run a subset selection process on the data set. The target variable is TOTAL.VALUE. We partition the data on a 60:40 ratio.


## R2 Plot
R2 plot for different dimension sizes. Notice it is monotonically increasing and cannot be used to pick dimension size.

<img src="Images/R-Square_Values.png" width="600" height="450">

## Dimensions Selection
The plots of RSS, Adjusted RSq, Cp and BIC as a function of dimension.
The optimal dimension for the adjr2 model is 12.  

<img src="Images/Adjusted_R-Square.png" width="500" height="500">

The optimal dimension for the Cp model is 10.

<img src="Images/Cp.png" width="500" height="500">

The optimal dimension for the BIC model is 9.

<img src="Images/BIC.png" width="500" height="500">

## Variable Selection
The variable selection plots for the adjr2, Cp, and BIC models

<img src="Images/Variables_Chosen_By_AdjR2.png" width="500" height="500">

<img src="Images/Variables_Chosen_By_Cp.png" width="500" height="500">

<img src="Images/Variables_Chosen_By_BIC.png" width="500" height="500">

## Results

The adjr2 model drops the variables Bedrooms. 
The Cp model drops the variables Rooms, Bedrooms, Remodelold. 
The BIC model drops the variables Rooms, Bedrooms, Kitchen, Remodelold.

## Results for various models

<img src="Images/Results_for_lmfull_model.png" width="500" height="500">

<img src="Images/Results_for_lmadjr2_model.png" width="500" height="500">

<img src="Images/Results_for_lmcp_model.png" width="500" height="500">

<img src="Images/Results_for_lmbic_model.png" width="500" height="500">

## Final Prediction using the validation dataset

<img src="Images/Prediction_Results.png" width="500" height="500">

Therefore the best subset model is the Cp model. It has the lowest RMSE, MAE, and MAPE. It contains the explanatory variables LOT.SQRT, YR.BUILD, GROSS.AREA, LIVING.AREA, FLOORS, FULL.BATH, HALF.BATH, KITCHEN, FIREPLACE, REMODELRecent(i.e. leaves out ROOMS, BEDROOMS, REMODELOld). 
