function [ scores ] = compute_leverage_scores(X, p_norm)
% compute_leverage_scores:
% inputs: X - matrix
%         p - the norm to compute the leverage scores with.
%         varargin - optional arguments to be added later
% Output: vector containing all of the leverage scores

switch p_norm
    case 2
        disp('compute orthonormal basis') ;
        [Q,~] = qr(X,0) ; 
        scores = sum(Q.^2,2) ; % sums the squred entries along rows
 
end

