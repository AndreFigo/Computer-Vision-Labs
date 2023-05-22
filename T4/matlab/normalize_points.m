function [pts1_norm, pts2_norm, T_l, T_r] = normalize_points(pts1, pts2)

centroid1 = [];
centroid2 = [];

p1 = [pts1, ones(size(pts1,1),1)];
p2 = [pts2, ones(size(pts2,1),1)];

centroid1 = mean(pts1(1:end,:));
centroid2 = mean(pts2(1:end,:));

centered1 = pts1 - centroid1;
centered2 = pts2 - centroid2;

scale1 = mean(sqrt(centered1(:,1).^2 + centered1(:,2).^2))./sqrt(2);
scale2 = mean(sqrt(centered2(:,1).^2 + centered2(:,2).^2))./sqrt(2);

T_l = transpose([scale1, 0, centroid1(1); 0, scale1, centroid1(2); 0, 0, 1]);
T_r = transpose([scale2, 0, centroid2(1); 0, scale2, centroid2(2); 0, 0, 1]);

% disp(size(T_l));
% disp(size(T_r));
% disp(size(p1));

% disp(size(p2));

pts1_norm = T_l * p1';
pts2_norm = T_r * p2';

pts1_norm = pts1_norm';
pts2_norm = pts2_norm';

end