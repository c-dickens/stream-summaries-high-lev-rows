function [ scores ] = compute_leverage_scores(X, method)
% compute_leverage_scores:
% inputs: X - matrix
%         method - string to determine which method to use. Should be one
%         of "orth", "condition_spc3", "spc1++"
% Output: vector containing all of the leverage scores

switch method
    case "orth"
        disp('compute orthonormal basis') ;
        [Q,~] = qr(X,0) ; 
        scores = sum(Q.^2,2) ; % sums the squred entries along rows
        
    case "condition_spc3"
        disp("ell_1 wcb")
        [U,~] = condition_spc3(X) ; 
        scores = sum(abs(U),2) ; 
    
    case "identity"
        disp("identity")
        scores = sum(X.^2,2) ; 
        scores = scores./norm(X,'fro')^2 ; % puts scores into (0,1) ; 
 
end

