%%% Script to clean household data by removing rows with nans
% Assume that first 8 columns are the features to predict the final 
% column of electric water heater and air dryer

load('householdpowerconsumption.mat') ; 

data = householdpowerconsumption(:,3:9) ; 
data(any(isnan(data), 2), :) = [];
A = data(:,1:end-1) ;
b = data(:,end) ;
save('clean_household_data.mat','data','A', 'b') ; 