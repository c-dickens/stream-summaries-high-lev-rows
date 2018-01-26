function [B, max_storage_seen] = stream_hlr(input_matrix, block_size, hlr_method, threshold)
% stream_hlr finds rows of high leverage (> threshold) in input_matrix by 
%using storage not excedding block size.
% Input: input_matrix (must be of the form [features, target] to remain
% consistent for the ell_infinity solver later to avoidtracking row
% indices.  Assume final column is target vector. so X = [A,b]
%        block_size (memory constraint), 
%        hlr_method (string to denote which basis to compute) - "orth",
%        "condition_spc3" or "spc1++"
%        threshold - bounds the leverge at which to delete rows
% Output: B - submatrix of input matrix with only high leverage rows.
X = input_matrix ; 
feature_idx = 1:size(X,2)-1 ;
end_index = block_size % initialise for iteration
% initialise two entries to avoid issues in if statement
max_storage_seen = [block_size; 0 ] ; 

%% Base case of iteration
B = X(1:block_size,:) ; % initialise B as first block_size number of rows 
scores = compute_leverage_scores(B(:,feature_idx), hlr_method) ; % compute score just on the columns of A
B = B(scores>threshold,:) ; 

%% iteration proper
while end_index < size(X,1)
    start_index = end_index + 1 
    end_index = end_index + block_size 
    
    if end_index > size(X,1)
        end_index = size(X,1) ; 
    end
    
    new_block = X(start_index:end_index,:) ; 
    stream_block = [B ; new_block] ; 
    scores = compute_leverage_scores(stream_block(:,feature_idx),hlr_method) ;
    heavy_list = find(scores>threshold) ;
    length(heavy_list)
    
    
    
    % Deal with case if heavy_list exceeds memory bound
    if length(heavy_list) >= block_size
        error("Storage bound broken - increase threshold as it is too low") ; 
    end
    
    B = stream_block(heavy_list,:) ;
    size(B)
    
    % See if new local heavy set is larger or smaller to track size
    if  size(B,1) > max_storage_seen(2)
        max_storage_seen(2) = size(B,1) ; 
    end
end
max_storage_seen = max_storage_seen(2) ; 


end

