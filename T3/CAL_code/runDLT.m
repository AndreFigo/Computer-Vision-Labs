function [K, R, t, error] = runDLT(xy, XYZ, Dec_type, img)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);


%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize camera matrix
M = T\ P_normalized * U;

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
XYZ(4,:) = 1;
xy(3,:) = 1;


xy_reproj = (M(1:2,:) * XYZ) ./ (M(3,:) * XYZ);
error = mean(sqrt(sum((xy(1:2,:)-xy_reproj).^2,1)));

disp("Error " +  error);

title_name = sprintf("Calibration with runDLT and %s decomposition type", Dec_type);
showResults(img, xy, xy_reproj, title_name, false, []);



end