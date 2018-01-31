% main script with parameters(2)
% load('parameters.mat') ; 
% name = parameters(2).name ; 
% data = load('../../../data/YearPredictionMSD.mat') ;  %YearPredictionsMSD ; % load(parameters(2).data_path) ;
% number_of_samples = parameters(2).number_samples ; 
% 
% 
% A = data.YearPredictionsMSD(:,1:90) ; 
% b = data.YearPredictionsMSD(:,91) ;
% X = [A, b] ; 
block_sizes = 1000:1000:10000 ; 
full_regression_time = zeros(length(1000:10000)) ; 
exact_vals = zeros(length(1000:10000),1) ; 


for ii=100:1000
    tic
    [~, f_exact] = ell_infinity_reg_solver(A(1:ii,:),b(1:ii)) ;
    full_regression_time = toc ; 
    full_regression_time(ii) = full_regression_time ; 
    exact_vals(ii) = f_exact 
end


