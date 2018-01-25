% Script to test ell_infinity regression with specified block size
data = load('data/census_data.mat') ; 
number_of_samples = 10000 ;
block_size = 1000 ;
threshold = size(A,2) / block_size ; % can be adaptively set for p-norm by how much of index set to keep
A = data.A(1:number_of_samples,:) ; 
b = data.b(1:number_of_samples) ;
clear data ; 


number_of_blocks = number_of_samples / block_size ;  % not robust to division

B = zeros(block_size,size(A,2)) ; 
for block_number = 1:number_of_blocks
    current_block = A((block_number-1)*block_size + 1:block_number*block_size,:) ;
    if all(B==0)
        B = current_block ; 
    else
        B = [B ; current_block] ; 
    end
    disp(block_number) ; 
    scores = compute_leverage_scores(B, 2) ; 
    disp(sum(scores)) ; 
end
    