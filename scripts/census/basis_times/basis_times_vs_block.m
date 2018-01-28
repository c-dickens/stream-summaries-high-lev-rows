% Script to test ell_infinity regression with specified block size
number_of_samples = 1000000 ;
data = load('data/census_data.mat') ;
A = data.A(1:number_of_samples,:) ; 
%b = data.b(1:number_of_samples) ;
%X = [A, b] ; 
block_sizes = 1000:2000:1000000 ;
high_leverage_method = ["condition_spc3" ; "orth"] ;   
basis_times = zeros(length(block_sizes),2) ; 
number_for_average_time = 5 ; 

% independent variables
clear data ;

for method_index = 1:size(basis_times,2)
    high_lev_method = high_leverage_method(method_index) ;
    disp(high_lev_method) ; 
    for idx = 1:length(block_sizes)
        idx
        block_size = block_sizes(idx) ;
        tic ;
        compute_leverage_scores(A(1:block_size,:),high_lev_method) ; 
        basis_times(idx, method_index) = toc ; 
    end
    
end

figure
hold on
scatter(block_sizes, basis_times(:,1), 'filled', 'DisplayName', "ell_1 wcb") ; 
scatter(block_sizes, basis_times(:,2), 'filled', 'DisplayName', "Orth") ;
title("Time to compute local basis vs block size") ; 
legend('show')

% save the data for plotting
save(file_name, 'number_of_samples','block_sizes',...
        'threshold', 'error',  'storage', 'approx_regression_time',...
        'full_regression_time', 'total_time', 'exact_ell_inf_score') ; 




 
