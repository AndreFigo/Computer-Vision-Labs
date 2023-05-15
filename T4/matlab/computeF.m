function F = computeF(pts1, pts2)
% computeF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates

% Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'


% Tl and Tr

Tl = [1 0 mean(pts1(:,1)); 0 1 mean(pts1(:,2)); 0 0 1];
Tr = [1 0 mean(pts2(:,1)); 0 1 mean(pts2(:,2)); 0 0 1];

% Normalization

pts1 = [pts1 ones(size(pts1,1),1)];
pts2 = [pts2 ones(size(pts2,1),1)];

pts1_norm = Tl*pts1';
pts2_norm = Tr*pts2';


% Compute F

A = [pts1_norm(1,:)'.*pts2_norm(1,:)' pts1_norm(1,:)'.*pts2_norm(2,:)' pts1_norm(1,:)' pts1_norm(2,:)'.*pts2_norm(1,:)' pts1_norm(2,:)'.*pts2_norm(2,:)' pts1_norm(2,:)' pts2_norm(1,:)' pts2_norm(2,:)' ones(size(pts1,1),1)];
[~,~,V] = svd(A);
F = reshape(V(:,end),3,3)';
[U,S,V] = svd(F);
S(3,3) = 0;

F = U*S*V';

% Denormalization
%TODO F tem til eq a baixo esta errada
F = Tr'*F*Tl;

end