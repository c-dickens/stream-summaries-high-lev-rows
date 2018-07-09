rng(10)
load('parameters.mat') ; 
name = parameters(1).name ; 
data = load(parameters(1).data_path) ;
number_of_samples = parameters(1).number_samples ; 


A = data.A(1:number_of_samples,:) ; 
block_sizes = parameters(1).window_size ;
start_index = 1 ; 
num_blocks = number_of_samples/block_sizes; 
sum = 0 ; 

start = 0 ; 


for idx = 1:num_blocks
        last_index = start+block_sizes ; 
        fprintf("start index %f\n", start)
        %block = A((idx-1)*block_sizes+1:idx*block_sizes,:) ;
        block = A(start+1:last_index,:) ;
        [U,R] = condition_spc3(block) ; 
        [flag,~,~] = ell_1_wcb_check(U) ;
        fprintf("idx %f, flag %f\n", idx, flag)
        sum = sum + flag ;
        fprintf("last index %f\n", last_index)
        start = last_index ; 
end
    
fprintf("Percentage correct wcb: %f\n ", 100*sum/num_blocks)