function F = computeF(pts1, pts2)
% computeF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates

% Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'


[pts1_norm, pts2_norm, T_l, T_r] = normalize_points(pts1, pts2);



% Tl and Tr

% Tl = [1 0 mean(pts1(:,1)); 0 1 mean(pts1(:,2)); 0 0 1];
% Tr = [1 0 mean(pts2(:,1)); 0 1 mean(pts2(:,2)); 0 0 1];

% % Normalization

% pts1 = [pts1 ones(size(pts1,1),1)];
% pts2 = [pts2 ones(size(pts2,1),1)];

% pts1_norm = Tl*pts1';
% pts2_norm = Tr*pts2';


% Compute F

A = [];

for i = 1:size(pts1,1)

    A = [A;
    pts1_norm(i,1)*pts2_norm(i,1), pts1_norm(i,2)*pts2_norm(i,1), pts2_norm(i,1), pts1_norm(i,1)*pts2_norm(i,2), pts1_norm(i,2)*pts2_norm(i,2), pts2_norm(i,2), pts1_norm(i,1), pts1_norm(i,2), 1];
end

[~,~,V] = svd(A);
F = reshape(V(:,end),3,3)';
[U,S,V] = svd(F);
S(3,3) = 0;

F = U*S*V';

F = T_r * F * T_l';

F = refineF(F, pts1, pts2);


end


% function F = computeF(pts1, pts2, M)
%     %vamos começar por normalizar os pontos (por linha)
%     [pts1_norm, pts2_norm, T_l, T_r] = normalizacao(pts1, pts2);
    
%     %vamos criar a matriz A. Para esta consideramos os pontos pts1_norm correspondem aos
%     %pontos x e y e os pontos pts2_norm correspondem aos pontos x' e y'
%     A = [];
    
%     for i = 1:size(pts1,1)
%         A = [A;
%             %x*x',                          y*x',                          x',             x*y',                          y*y',                          y',             x,             y,             1
%             pts1_norm(i,1)*pts2_norm(i,1), pts1_norm(i,2)*pts2_norm(i,1), pts2_norm(i,1), pts1_norm(i,1)*pts2_norm(i,2), pts1_norm(i,2)*pts2_norm(i,2), pts2_norm(i,2), pts1_norm(i,1), pts1_norm(i,2), 1];
%     end
    
%     %vamos fazer a singular value decomposition e aproveitar a matriz V
%     %transposta
%     [U,S,V] = svd(A);
    
%     %vamos agora obter a solução, que corresponde à última coluna de V e
%     %transformá-la numa matriz 3x3
%     F = reshape(V(:,end), [3 3]);
    
%     %A matriz F tem de ser de rank 2, pelo que vamos forçar a que isto aconteça
%     [U,S,V] = svd(F);
%     S(3,3) = 0;
%     F = U * S * transpose(V);
    
%     %Por fim, normalizamos a matriz F recorrendo às matrizes T_l e T_r calculadas 
%     F = T_r * F * transpose(T_l);
    
%     F = refineF(F, pts1, pts2);
%     end
    
%     function [pts1_norm, pts2_norm, T_l, T_r] = normalizacao(pts1, pts2)
%     %vamos fazer agora a parte de 'Avoiding numerical problems'. Para isso
%     %vamos aplicar o mesmo algoritmo de normalização do último trabalho
%     %data normalization
%     %Caculamos os centroidoes de cada matriz
%     left_centroid = mean(pts1(1:end, :));
%     right_centroid = mean(pts2(1:end, :));
    
%     %vamos fazer a subtração de cada ponto com o seu centroide para o centroide
%     %ser a origem
%     for i=1:size(pts1,1)
%         sub_left_centroid(i,:) = pts1(i,:) - left_centroid;
%         sub_right_centroid(i,:) = pts2(i,:) - right_centroid;
%     end
    
%     %Calculamos a norma
%     for i=1:size(pts1,1)
%         norma_left(i) = norm(sub_left_centroid(i,:));
%         norma_right(i) = norm(sub_right_centroid(i,:));
%     end
    
%     %depois calculamos a média
%     media_left = mean(norma_left);
%     media_right = mean(norma_right);
    
%     %vamos agora dividir a média por raiz(2)
%     escala_left = media_left / sqrt(2);
%     escala_right = media_right / sqrt(2);
    
%     %vamos criar as matrizes T_l e T_r
%     T_l = eye(3) * escala_left;
%     T_r = eye(3) * escala_right;
    
%     %de seguida adicionamos os centroides na ultima coluna
%     T_l(:, 3) = [left_centroid 1]';
%     T_r(:, 3) = [right_centroid 1]';
    
%     T_l = transpose(T_l);
%     T_r = transpose(T_r);
    
%     pts1_1 = [pts1, ones([size(pts1, 1) 1])];
%     pts2_1 = [pts2, ones([size(pts1, 1) 1])];
    
%     %Por fim, normalizamos os pontos recorrendo às matrizes T e U calculadas 
%     pts1_norm = T_l * transpose(pts1_1);
%     pts2_norm = T_r * transpose(pts2_1);
    
%     pts1_norm = transpose(pts1_norm);
%     pts2_norm = transpose(pts2_norm);
    
%     end