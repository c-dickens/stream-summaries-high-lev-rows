% Script to test ell_infinity regression with specified block size
number_of_samples = 1000000 ;
data = load('data/census_data.mat') ;
A = data.A(1:number_of_samples,:) ; 
b = data.b(1:number_of_samples) ;
X = [A, b] ; 
block_sizes = 1000:10000:100000 ;
high_leverage_method = "condition_spc3" ; 


% independent variables
error = zeros(length(block_sizes),1) ; 
storage = zeros(length(block_sizes),1) ;
approx_regression_time = zeros(length(block_sizes),1) ; 
basis_time = zeros(length(block_sizes),1) ; 
total_stream_time = zeros(length(block_sizes,1)) ;
%local_basis_times = zeros(length(block_sies,1))) ; 
clear data ;


for idx = 1:length(block_sizes)
    block_size = block_sizes(idx)
    % can be adaptively set for p-norm by how much of index set to keep
    threshold = size(A,2)^1.5 / (block_size) ; 
    
    [B, storage_used] = stream_hlr(X, block_size, high_leverage_method, threshold) ; 
    
    % Max storage used tbc
    storage(idx) = storage_used ; 
     
    % Dimension check is just to grab the features
    tic
    [~, f_approx] = ell_infinity_reg_solver(B(:,1:size(X,2)-1),B(:,end)) ;
    approx_regression_time(idx) = toc ; 
    error(idx) = f_approx ; 
end


% full regression
tic
[~, f_exact] = ell_infinity_reg_solver(A,b) ;
full_regression_time = toc ; 
full_regression_time = full_regression_time.*ones(length(block_sizes),1) ; 
error = error./f_exact ; 
error = 1 - error ; % puts error in range (0,1) ; 

figure
plot(block_sizes, error)
title("Error vs block size")

figure
scatter(block_sizes, storage, 'filled')
title("Max storage used vs Block Size") 

figure
scatter(storage, error, 'filled')
title("Error vs max storage used")

figure
hold on
plot(block_sizes, approx_regression_time)
plot(block_sizes, full_regression_time) 
title("Time to solve regression vs block size")
 
