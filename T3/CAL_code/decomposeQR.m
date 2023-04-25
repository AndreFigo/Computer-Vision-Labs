function [ K, R, C ] = decomposeQR(P)
%decompose P into K, R and t

M = P(1:3,1:3);

[Q, R] = qr(inv(M));

[U, S, V] = svd(P);
C = V(:,end);
C = C / C(end);
C = C(1:3);

K = inv(R);
K = K./ K(end,end);
R = inv(Q);
end