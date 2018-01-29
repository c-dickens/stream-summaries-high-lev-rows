% Script to test time vs block size
load('parameters.mat') ; 
%name = parameters(2).name ; 
%data = load(parameters(2).data_path) ;
data = YearPredictionsMSD ; 
number_of_samples = parameters(2).number_samples ; 
number_for_average_time = 5 ;
 
A = data(1:number_of_samples,1:90) ; 
block_sizes = parameters(2).window_size:parameters(2).window_size:parameters(2).largest_block_for_basis ;


for method_number = 1:length(parameters(2).hlr_methods)
    high_leverage_method = parameters(2).hlr_methods(method_number) ; 
    file_name = parameters(2).name + "_" + high_leverage_method + "_basis_times.mat" ; 
    
    % independent variables
    time_for_basis = zeros(length(block_sizes),1) ;

    clear data ;
    
    
    
        for idx = 1:length(block_sizes)
            idx
            block_size = block_sizes(idx)
            time_count = 0 ; 
            for iter_number = 1:number_for_average_time
                time = 0 ; 
                tic ;
                compute_leverage_scores(A(1:block_size,:),high_leverage_method) ;
                time = toc ; 
                time_count = time_count + time ;
            end
            time_for_basis(idx) = time_count / number_for_average_time ; 
        end
    
 
    
    % save the data for plotting
    save(file_name, 'number_of_samples','block_sizes', 'time_for_basis') ; 
end