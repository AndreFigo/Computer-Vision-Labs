function [K, R, t, error] = runGold(xy, XYZ, Dec_type, img)

%normalize data points
[xy_normalized, XYZ_normalized, T, U ]= normalization(xy, XYZ);



%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

M_no = T\ P_normalized * U;

%minimize geometric error
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:100
    [pn] = fminsearch(@fminGold, pn, [], xy_normalized, XYZ_normalized);
end

Pn = reshape(pn, [4,3])'

%denormalize camera matrix
M = T\Pn*U;

%factorize camera matrix in to K, R and t
if (strcmp(Dec_type, 'QR'))
    [K, R, C] = decomposeQR(M);
elseif(strcmp(Dec_type, 'EXP'))
    [K, R, C] = decomposeEXP(M);
else
    disp("Invalid decomposition type");
end
t = -R*C;

% Visualize the reprojected points of all checkerboard corners


XYZ(4,:) = 1;
xy(3,:) = 1;


% _no = not optimized

xy_reproj_no = (M_no(1:2,:) * XYZ) ./ (M_no(3,:) * XYZ);



error_no = mean(sqrt(sum((xy_reproj_no - xy(1:2,:)).^2,1)));


xy_reproj = (M(1:2,:) * XYZ) ./ (M(3,:) * XYZ);

error = mean(sqrt(sum((xy_reproj - xy(1:2,:)).^2,1)));



disp("Error before optimization: " + error_no);
disp("Error after optimization: " + error);

title_name = sprintf("Calibration with runGOLD and %s decomposition type", Dec_type);
showResults(img, xy, xy_reproj_no, title_name, true, xy_reproj);







end