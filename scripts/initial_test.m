% Script to test ell_infinity regression with specified block size
<<<<<<< HEAD
number_of_samples = 100000 ;
=======
number_of_samples = 1000 ;
>>>>>>> a4190f2c435156ad97bc04e42f6d911fe05eac35
data = load('data/census_data.mat') ;
A = data.A(1:number_of_samples,:) ; 
b = data.b(1:number_of_samples) ;
X = [A, b] ; 
<<<<<<< HEAD
block_sizes = 1000:1000:10000 ;


% independent variables
error = zeros(length(block_sizes),1) ; 
storage = zeros(length(block_sizes),1) ;
approx_regression_time = zeros(length(block_sizes),1) ; 
basis_time = zeros(length(block_sizes),1) ; 
clear data ;


for idx = 1:length(block_sizes)
    block_size = block_sizes(idx)
    % can be adaptively set for p-norm by how much of index set to keep
    threshold = size(A,2) / (block_size) ; 
    [B, storage_used] = stream_hlr(X, block_size, 2, threshold) ; 
    
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
plot(block_sizes, storage)
title("Max storage used vs Block Size") 

figure
scatter(storage, error)
title("Error vs max storage used")

figure
hold on
plot(block_sizes, approx_regression_time)
plot(block_sizes, full_regression_time) 
title("Time to solve regression vs block size")
 
=======
feature_idx = 1:size(A,2) ; 
block_size = 100 ;
end_point = block_size ; 
threshold = size(A,2) / (block_size) ; % can be adaptively set for p-norm by how much of index set to keep

clear data ; 


number_of_blocks = number_of_samples / block_size ;  % not robust to division

B = X(1:block_size,:) ; % initialise B as first block_size number of rows 
scores = compute_leverage_scores(B(:,feature_idx), 2) ; % compute score just on the columns of A
B = B(scores>threshold,:) ; 
% for block_number = 1:number_of_blocks
%     current_block = A((block_number-1)*block_size + 1:block_number*block_size,:) ;
%     if all(B==0)
%         B = current_block ; 
%     else
%         B = [B ; current_block] ; 
%     end
%     disp(block_number) ; 
%     scores = compute_leverage_scores(B, 2) ; 
%     disp(sum(scores)) ; 
% end
% 
start_point = end_point + 1 ;  % initialise for first loop
while end_point < size(A,1)
     rows_to_read = block_size - size(B,1) 
     
     %start_point = last_index+1  
     end_point = min(start_point+rows_to_read,size(A,1))   
     
     if rows_to_read > 0
         disp('normal reduction')
         new_block = X(start_point:end_point,:) ; 
         stream_block = [B ; new_block] ; 
         scores = compute_leverage_scores(stream_block(:,feature_idx),2) ; 
         heavy_list = find(scores>threshold) ; 
         B = stream_block(heavy_list,:) ; 
         disp('size(B)')
         size(B) 
         start_point = end_point + 1 ; 
         %last_index = last_index+1+rows_to_read ; 
         
     else
         disp('storage exceeded reduction') ; 
         scores = compute_leverage_scores(B(:,feature_idx), 2) ; % compute score just on the columns of A
         B = B(scores>2*threshold,:) ;
         size(B) ; 
     end
     
     %last_index = last_index + block_size ; 
     %last_index 
     end_point 
%     if rows_to_read == 0
%         %reduce(B)
%     else
%         end_index = last_index+1+rows_to_read ; 
%         if end_index > size(A,1)
%             end_index = size(A,1) ; 
%         end
%         B = [B ; A(last_index + 1: last_index+1+rows_to_read,:) ] ; 
%         last_index = last_index+1+rows_to_read ; 
%         disp(last_index) ; 
%     end
    
end


%[~, f_exact] = ell_infinity_reg_solver(A,b) ; 
[~, f_approx] = ell_infinity_reg_solver(B(:,feature_idx),B(:,end)) ;  
>>>>>>> a4190f2c435156ad97bc04e42f6d911fe05eac35
