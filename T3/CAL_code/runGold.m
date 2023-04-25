function [K, R, t, error] = runGold(xy, XYZ, Dec_type, img)

%normalize data points
[xy_normalized, XYZ_normalized, T, U ]= normalization(xy, XYZ);



%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

M_not_optimal = T\ P_normalized * U;

%minimize geometric error
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:100
    [pn] = fminsearch(@fminGold, pn, [], xy_normalized, XYZ_normalized);
end

Pn = reshape(pn, [4,3] )'

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



% xy_projected = ones(2, size(xy,2));

% for i = 1:size(XYZ,2)
%     xy_projected(:,i) = M*XYZ(:,i);
% end

x_reproj = (M_not_optimal(1,:) * XYZ) ./ (M_not_optimal(3,:) * XYZ);
y_reproj = (M_not_optimal(2,:) * XYZ) ./ (M_not_optimal(3,:) * XYZ);

err_mat_not_opt = [x_reproj - xy(1,:); y_reproj - xy(2,:)];
for i=1:size(xy,2)
    norms_not_opt(i) = norm(err_mat_not_opt(:,i));
end

error_not_opt = mean(norms_not_opt);



x_reproj_optimal = (M(1,:) * XYZ) ./ (M(3,:) * XYZ);
y_reproj_optimal = (M(2,:) * XYZ) ./ (M(3,:) * XYZ);

%compute reprojection error
err_mat = [x_reproj_optimal - xy(1,:); y_reproj_optimal - xy(2,:)];
for i=1:size(xy,2)
    norms(i) = norm(err_mat(:,i));
end

error = mean(norms);

disp("Error before optimization: " + error_not_opt);
disp("Error after optimization: " + error);

title_name = sprintf("Calibration with runGOLD and %s decomposition type", Dec_type);
showResults(img, xy, [x_reproj; y_reproj], title_name, true, [x_reproj_optimal; y_reproj_optimal]);







end