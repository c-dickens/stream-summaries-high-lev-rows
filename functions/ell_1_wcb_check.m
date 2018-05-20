function [flag, critical_z,critical_val] = ell_1_wcb_check(U)
% Given a candidate ell_1 well-conditioned basis U and a threshold beta, output 
% the flag = 0 if Uz ever exceeds 1 or 1 if it is always bounded by 1.
% This is the test condition on the second requirement of wcb from Mahoney
% paper - https://arxiv.org/pdf/1305.0087.pdf
% Checks that the distortion of a vector under the action of U is bounded
% by the correct parameter beta.
% output the value and the z for which the exception is found.
% The problem is to maximis ||z||_1 / ||Uz||_q
% Input: Matrix U (candidate ell1_wcb)
% Output: Flag 1 - Pass, U is WCB, 0 Fail, U not a WCB

    function N = norm_ratio(z)
        N = -norm(z,'Inf') / norm(U*z,1) ; 
    end

[n,d] =size(U) ; 
z0 = zeros(d,1) ; 
z0(1) = 1 ; 

[critical_z, critical_val] = fminsearch(@norm_ratio, z0) ;
critical_val = -critical_val ;

flag = critical_val <= 1   ; %&& norm(U(:),1) > d^2.5  ; 
 



end
