function [K, R, t, Kd, error] = runGoldRadial(xy, XYZ, Dec_type, img)

    %normalize data points

    [xy_normalized, XYZ_normalized, T, U ]= normalization(xy, XYZ);
    
    %compute DLT
    [Pn] = dlt(xy_normalized, XYZ_normalized);
    
    % Distortion Coeficient Initial Values
    Kd= [0 0];
    
    %minimize geometric error
    pn = [Pn(1,:) Pn(2,:) Pn(3,:) Kd];
    for i=1:20
        [pn] = fminsearch(@fminGoldRadial, pn, [], xy_normalized, XYZ_normalized);
    end
    
    %denormalize camera matrix
    Pn = [pn(1:4); pn(5:8); pn(9:12)];
    Kd = pn(13:14);
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
    

%     %compute reprojection error
%     xyz = [R t]*[XYZ; ones(1, size(XYZ,2))];
%     xy_p = xyz(1:2,:)./xyz(3,:);

%     r = sqrt(xy_p(1,:).^2 + xy_p(2,:).^2);
%     L = 1 + Kd(1)*r.^2 + Kd(2)*r.^4;
    
%     xy_d = L.*xy_p;
%     % xy_d_h = [xy_d; ones(1,size(XYZ,2))];

    
% x_reproj_optimal = (M(1,:) * xy_d) ./ (M(3,:) * xy_d);
% y_reproj_optimal = (M(2,:) * xy_d) ./ (M(3,:) * xy_d);

% %compute reprojection error
% err_mat = [x_reproj_optimal - xy_d(1,:); y_reproj_optimal - xy_d(2,:)];
% for i=1:size(xy_d,2)
%     norms(i) = norm(err_mat(:,i));
% end

% error = mean(norms);



    XYZ(4,:) = 1;
    xy(3,:) = 1;


    x_reproj = (M(1,:) * XYZ) ./ (M(3,:) * XYZ);
    y_reproj = (M(2,:) * XYZ) ./ (M(3,:) * XYZ);


    err_mat = [x_reproj - xy(1,:); y_reproj - xy(2,:)];
    for i=1:size(xy,2)
        norms(i) = norm(err_mat(:,i));
    end
    error = mean(norms);


    title_name = sprintf("Calibration with runGoldRadial and %s decomposition type", Dec_type);
    showResults(img, xy, [x_reproj; y_reproj], title_name, false, []);



    end