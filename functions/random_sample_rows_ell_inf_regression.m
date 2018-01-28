function approx = random_sample_rows_ell_inf_regression(A, b, num_of_rows_to_sample)
%  Given a matrix A, randomly sample r = num_of_rows_to_sample rows from A
%  uniformly without replacement.  On this random sample perform
%  ell_infinity regression with target b on the same subset of rows.
n = size(A,1) ;  
r = num_of_rows_to_sample ;
rand_rows = unique(randsample(n, r, false)) ;
[~, approx] = ell_infinity_reg_solver(A(rand_rows,:), b(rand_rows)) ;
% temp_score = zeros(ceil(log(r)),1) ; 
% 
% for i=1:10
%     rand_rows = unique(randsample(n, r, false)) ;
%     %disp(length(unique(rand_rows))) ;
%     [~, temp_score(i)] = ell_infinity_reg_solver(A(rand_rows,:), b(rand_rows)) ;   
% end
% approx = min(temp_score) ; 

end

