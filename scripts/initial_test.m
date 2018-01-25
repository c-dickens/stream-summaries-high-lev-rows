% Script to test ell_infinity regression with specified block size
number_of_samples = 5000000 ;
data = load('data/census_data.mat') ;
A = data.A(1:number_of_samples,:) ; 
b = data.b(1:number_of_samples) ;
X = [A, b] ; 
feature_idx = 1:size(A,2) ; 
block_size = 10000 ;
last_index = block_size ; 
threshold = size(A,2) / (2*block_size) ; % can be adaptively set for p-norm by how much of index set to keep

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
while last_index < size(A,1)
     rows_to_read = block_size - size(B,1) 
     
     endpoint = min(last_index+1+rows_to_read,size(A,1))   
     
     if rows_to_read > 0
         new_block = X(last_index + 1:endpoint,:) ; 
         stream_block = [B ; new_block] ; 
         scores = compute_leverage_scores(stream_block(:,feature_idx),2) ; 
         B = stream_block(scores>threshold,:) ; 
         size(B) ; 
         last_index = last_index+1+rows_to_read ; 
         
     else
         scores = compute_leverage_scores(B(:,feature_idx), 2) ; % compute score just on the columns of A
         B = B(scores>2*threshold,:) ; 
     end
     
     last_index = last_index + block_size ; 
     last_index 
     endpoint 
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