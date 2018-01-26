function [B_hat, R] = condition_spc3(A)

    % Comments added by C Dickens April 2017.
    % condition_spc3 takes input matrix A of full column rank and outputs a
    % well-conditioned basis B = AR^{-1}

    [m, n] = size(A);

    %t = min(m, ceil(2*n^2*(log(n))^2));
    t  = ceil(2*n^2*(log(n))^2);
    Pi = sparse(ceil(t*rand(m, 1)), 1:m, caurnd([m, 1]));
    A1 = full(Pi*A);

    [Q, R1] = qr(A1, 0);

    v = sum(abs(A/R1), 2);
    sum_v = sum(v);

    s = 2*n^3*(log(n))^2;

    p  = min(s*v/sum_v, 1.0);
    ii = rand(m, 1) < p;
    S  = diag(sparse(1./p(ii)));
    

    As = S * A(ii, :);
    [Q, R] = qr(As, 0);
    B = A/R;
    
    % added by c dickens - rescaling to ensure leverage part works.
    % A form of normalising the wcb
    factor = sum(sum(abs(B))) / n^1.5 ;  % 1.5 comes from the alpha in definition
    B_hat = B ./ factor ; 

end