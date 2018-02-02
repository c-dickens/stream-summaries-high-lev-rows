% main script with parameters(3)
load('parameters.mat') ; 
name = parameters(3).name ; 
data = load(parameters(3).data_path) ;
number_of_samples = parameters(3).number_samples ; 


A = data.A(1:number_of_samples,:) ; 
b = data.b(1:number_of_samples) ;
X = [A, b] ; 
block_sizes = parameters(3).window_size:parameters(3).window_size:parameters(3).largest_block ;


% tic
% [~, f_exact] = ell_infinity_reg_solver(A,b) ;
% full_regression_time = toc ; 
% full_regression_time = full_regression_time.*ones(length(block_sizes),1) ;



for method_number = 3 %1:length(parameters(1).hlr_methods)
    high_leverage_method = parameters(1).hlr_methods(method_number) ; 
    file_name = parameters(3).name + "_" + high_leverage_method + ".mat" ; 
    % Dealing with the wcb exponent
    switch high_leverage_method
        case "orth"
            threshold_exponent = 1 ; 
        case "condition_spc3"
            threshold_exponent = 1.5 ; 
        case "identity"
            threshold_exponent = 0 ; % to set numerator to 1.  Doesn't ac
                                     % actually matter as threshold is 
                                     %overwritten in the stream_hlr part
                                     % anyway.
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
        threshold = size(A,2)^threshold_exponent / (block_size) ;
        
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
%     error = error./f_exact ;
%     error = 1 - error ; % puts error in range (0,1) ;
%     exact_ell_inf_score  = f_exact ; 
    
    % save the data for plotting
    save(file_name, 'number_of_samples','block_sizes',...
        'threshold', 'error',  'storage', 'approx_regression_time', 'total_time') ; ,...
        %'full_regression_time', 'total_time', 'exact_ell_inf_score') ; 
end