% main script with parameters(1)
load('parameters.mat') ; 
name = parameters(1).name ; 
data = load(parameters(1).data_path) ;
number_of_samples = parameters(1).number_samples ; 


A = data.A(1:number_of_samples,:) ; 
b = data.b(1:number_of_samples) ;
X = [A, b] ; 
block_sizes = parameters(1).window_size:parameters(1).window_size:parameters(1).largest_block ;


tic
[~, f_exact] = ell_infinity_reg_solver(A,b) ;
full_regression_time = toc ; 
full_regression_time = full_regression_time.*ones(length(block_sizes),1) ;



for method_number = 1:length(parameters(1).hlr_methods)
    high_leverage_method = parameters(1).hlr_methods(method_number) ; 
    file_name = parameters(1).name + "_" + high_leverage_method + ".mat" ; 
    % Dealing with the wcb exponent
    if high_leverage_method == "condition_spc3" ;
        q = 1.5
    else
        q = 1
    end
    
    % independent variables
    error = zeros(length(block_sizes),1) ;
    storage = zeros(length(block_sizes),1) ;
    approx_regression_time = zeros(length(block_sizes),1) ;
    total_time = zeros(length(block_sizes),1) ; 
    clear data ;
    
    
    
    for idx = 1:length(block_sizes)
        block_size = block_sizes(idx)
        % can be adaptively set for p-norm by how much of index set to keep
        threshold = size(A,2)^q / (block_size) ;
        
        tic ; 
        [B, storage_used] = stream_hlr(X, block_size, high_leverage_method, threshold) ;
   
        % Max storage used tbc
        storage(idx) = storage_used ;
        
        % Dimension check is just to grab the features
        tic
        [~, f_approx] = ell_infinity_reg_solver(B(:,1:size(X,2)-1),B(:,end)) ;
        approx_regression_time(idx) = toc ;
        error(idx) = f_approx ;
        total_time(idx) = toc ; 
    end
    
    
    % full regression
    error = error./f_exact ;
    error = 1 - error ; % puts error in range (0,1) ;
    exact_ell_inf_score  = f_exact ; 
    
    % save the data for plotting
    save(file_name, 'number_of_samples','block_sizes',...
        'threshold', 'error',  'storage', 'approx_regression_time',...
        'full_regression_time', 'total_time', 'exact_ell_inf_score') ; 
end