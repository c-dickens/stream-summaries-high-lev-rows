% main script with parameters(3)
load('parameters.mat') ; 
name = parameters(2).name ; 
data = load(parameters(2).data_path) ;
number_of_samples = parameters(2).number_samples ; 
file_name = parameters(2).name + "_" + "uniform_sampling.mat" ;


A = data.A(1:number_of_samples,:) ; 
b = data.b(1:number_of_samples) ;
X = [A, b] ; 
block_sizes = parameters(2).window_size:parameters(2).window_size:parameters(2).largest_block ;

% independent variables
error = zeros(length(block_sizes),1) ;
approx_regression_time = zeros(length(block_sizes),1) ;
clear data ;


for idx = 1:length(block_sizes)
        block_size = block_sizes(idx)
        tic
        f_approx = random_sample_rows_ell_inf_regression(A,b, block_size) ;
        approx_regression_time(idx) = toc ;
        error(idx) = f_approx ;
end

error = 1 - error./parameters(2).exact_ell_inf_score ; 

% save the data for plotting
save(file_name, 'number_of_samples','block_sizes', ...
        'error', 'approx_regression_time') ; 
    
    