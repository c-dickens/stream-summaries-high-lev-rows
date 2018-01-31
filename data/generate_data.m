%%% Generate and save some artificial random data
num_rows = 10 ; 
num_cols = 1 ; 
num_sparse_vectors = 1 ; 

block_sizes = 10000:10000:100000 ; 
pecentage_sparse_vecs_found = zeros(length(block_sizes),1) ;
error = zeros(length(block_sizes),1) ;

% R = sprandn(num_rows,num_cols,0.5) ; 
% 
% % Append an identity to the matrix
% I = speye(num_sparse_vectors) ; 

% Linear relationship
x = [linspace(-1,1)'] ;% linspace(10,15)'] ;
y = zeros(length(x),1) ; 
A = [x y] ; 
z = 2*x + normrnd(0,0.001,length(x),1) ; 
A = [x y z] ; 
A(1,1) = 0 ; % Append sparse vector
A(1,2) = 100 ; 
x_test_vals = [ones(length(linspace(min(x), max(x))),1) linspace(min(x), max(x))'] ;


[x_opt, f_approx] = ell_infinity_reg_solver(A(:,1:2),A(:,3)) ;
z_test = x_test_vals*x_opt ; 

B = A(2:end,:) ; 
[x_new, f_new] = ell_infinity_reg_solver(B(:,1:2), B(:,3)) ; 
z_new = x_test_vals*x_new ; 

scatter3(x,A(:,2),z, 'filled')
hold on
plot(x_test_vals, z_test)
plot(x_test_vals, z_new)


% 
% A = [zeros(num_sparse_vectors, num_cols) I ; R zeros(num_rows,...
%     num_sparse_vectors) ; ] ; 
% b = randn(length(A),1) ; 
% 
% % Permute the rows to shuffle the sparse vectors but keep indices to check
% % that they have been located
% % permutation = randperm(size(A,1)) ; 
% % A = A(permutation,:) ; 
% % [~,sparse_vector_locations] = intersect(permutation,1:num_sparse_vectors) ;  
% % sparse_vectors = A(sparse_vector_locations,:) ;
% % 
% % parfor idx = 1:length(block_sizes)
% %         block_size = block_sizes(idx)
% %         % can be adaptively set for p-norm by how much of index set to keep
% %         threshold = size(A,2) / (block_size) ;
% %         
% %         tic ; 
% %         [B, storage_used] = stream_hlr([A,b], block_size, 'orth', threshold) ;
% %    
% %         % Max storage used tbc
% %         storage(idx) = storage_used ;
% %         
% %         % Dimension check is just to grab the features
% %         tic
% %         [~, f_approx] = ell_infinity_reg_solver(B(:,1:size(A,2)),B(:,end)) ;
% %         approx_regression_time(idx) = toc ;
% %         error(idx) = f_approx ;
% %         total_time(idx) = toc ; 
% %         
% %         
% %         pecentage_sparse_vecs_found(idx) = (sum(ismember(sparse_vectors,...
% %             B(:, 1:end-1),'rows'))/num_sparse_vectors)*100
% %     end
% 
% 
% 
% [~, f_opt] = ell_infinity_reg_solver(A,b) 
% 
% figure
% hold on
% plot(block_sizes, error)
% plot(block_sizes, f_opt*ones(length(block_sizes),1))
% 
%  
% 
%       