function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization
%first compute centroid
xy_centroid = [];
XYZ_centroid = [];

p = [xy; ones(1, size(xy,2))];
% p(3,:) = 1;

P = [XYZ; ones(1, size(XYZ,2))];
% P(4,:) = 1;

%then, compute scale
xy_centroid = mean(xy,2);
XYZ_centroid = mean(XYZ,2);

xy_centered = xy - xy_centroid;
XYZ_centered = XYZ - XYZ_centroid;

scale_xy = mean(sqrt(xy_centered(1,:).^2 + xy_centered(2,:).^2))./sqrt(2);
scale_XYZ = mean(sqrt(XYZ_centered(1,:).^2 +XYZ_centered(2,:).^2 + XYZ_centered(3,:).^2))./sqrt(3);

%create T and U transformation matrices
T = inv([scale_xy, 0, xy_centroid(1); 0, scale_xy, xy_centroid(2); 0, 0, 1]);
U = inv([scale_XYZ, 0 ,0, XYZ_centroid(1);  0, scale_XYZ, 0, XYZ_centroid(2); 0, 0, scale_XYZ, XYZ_centroid(3); 0, 0, 0, 1 ]);

%and normalize the points according to the transformations
xyn = T * p;
XYZn = U * P;

end