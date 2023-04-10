function [ K, R, C ] = decomposeEXP(P)
%decompose P into K, R and t
A = P(1:3,1:3);
b = P(1:3,end);

a1 = A(1, :);
a2 = A(2, :);
a3 = A(3, :);

alpha = 
beta = 

end