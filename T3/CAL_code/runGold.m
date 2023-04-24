function [K, R, t, error] = runGold(xy, XYZ, Dec_type)

%normalize data points
xy_normalized, XYZ_normalized, T, U = normalize(xy, XYZ);


%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGold, pn, [], xy_normalized, XYZ_normalized);
end

Pn = reshape(pn, [3 4]);

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


x_reproj = (M(1,:) * XYZ) ./ (M(3,:) * XYZ);
y_reproj = (M(2,:) * XYZ) ./ (M(3,:) * XYZ);

%compute reprojection error
err_mat = [x_reproj - xy(1,:); y_reproj - xy(2,:)];
for i=1:size(xy,2)
    norms(i) = norm(err_mat(:,i));
end
error = mean(norms);









end