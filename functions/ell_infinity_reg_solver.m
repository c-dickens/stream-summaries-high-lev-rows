function [ x_opt, f_opt ] = ell_infinity_reg_solver( A, b )
% Solves the ell_infinity regression problem ||Ax - b||_inf.  That is finds
% the least t for which Ax - b < t.ones and Ax - b > -t.ones.
[n,d] = size(A) ;  
if n == 0
    f_opt  = 0 ;
    x_opt = zeros(d,1) ;
    return
end
% infinity norm
f = [ zeros(d,1); 1 ];
A = sparse([ A, -ones(n,1) ; -A, -ones(n,1) ]);
b = [ b; -b ];
[xt, f_opt] = linprog(f,A,b);
x_opt = xt(1:d,:);


end

