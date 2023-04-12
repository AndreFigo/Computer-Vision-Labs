function [K, R, t, error] = runDLT(xy, XYZ, Dec_type)

%normalize data points
xy_normalized = [];
XYZ_normalized = [];

[xyn, XYZn, T, U] = normalization(xy, XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize camera matrix
M = inv(T) * P_normalized * U;

%factorize camera matrix in to K, R and t
if (strcmp(Dec_type, 'QR'))
    [K, R, C] = decomposeQR(M);
elseif(strcmp(Dec_type, 'EXP'))
    [K, R, C] = decomposeEXP(M);
else
    disp("Invalid decomposition type");
end
t = -R*C;
%compute reprojection error

end