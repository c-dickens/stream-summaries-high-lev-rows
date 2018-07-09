% Main script with parameters(1) to choose the census dataset.
% Test the ell_infty regression problem with uniform sampling

load('parameters.mat') ; 
name = parameters(1).name ; 
data = load(parameters(1).data_path) ;
number_of_samples = parameters(1).number_samples ; 
file_name = parameters(1).name + "_" + "uniform_sampling.mat" ;
rng(100)

A = data.A(1:number_of_samples,:) ; 
b = data.b(1:number_of_samples) ;
X = [A, b] ; 
block_sizes = parameters(1).window_size:parameters(1).window_size:parameters(1).largest_block ;

% independent variables
num_trials = 5 ; 
error = zeros(length(block_sizes),1) ;
approx_regression_time = zeros(length(block_sizes),1) ;
clear data ;


for idx = 1:length(block_sizes)
    block_size = block_sizes(idx) ; 
    for trial = 1:num_trials
            tic
            f_approx = random_sample_rows_ell_inf_regression(A,b, block_size) ;
            trial_regression_time = toc ; 
            %approx_regression_time(idx) = toc ;
            approx_regression_time(idx) = approx_regression_time(idx) + trial_regression_time ;  
            error(idx) = error(idx) + f_approx ;
            fprintf("Trial %f error: %f\n", trial, 1-f_approx/parameters(1).exact_ell_inf_score) ; 
    end
    approx_regression_time(idx) = approx_regression_time(idx) / num_trials ;
    error(idx) = error(idx) / num_trials ; 
end

error = 1 - error./parameters(1).exact_ell_inf_score ;
block_sizes = parameters(1).window_size:parameters(1).window_size:parameters(1).largest_block ;
% save the data for plotting
save(file_name, 'number_of_samples','block_sizes',...
        'error', 'approx_regression_time') ; 
    
    