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
    
    XYZ(4,:) = 1;
    xy(3,:) = 1;

%     %compute reprojection error

    %! use this line when using normalized points
    % xyz_cam = [R t]*XYZ_normalized;
    xyz_cam = [R t]*XYZ;
    xy_hat = xyz_cam(1:2,:)./xyz_cam(3,:);

    %! use this line when using normalized points
    % sxy_d = inv(K) * xy_normalized;
    sxy_d = inv(K) * xy;
    %points with distortion 
    xy_d_or = sxy_d(1:2,:)./sxy_d(3,:);


    r = sqrt(xy_hat(1,:).^2 + xy_hat(2,:).^2);
    L = 1 + Kd(1)*r.^2 + Kd(2)*r.^4;
    
    xy_d = L.*xy_hat;

    error = mean(sqrt(sum((xy_d - xy_d_or).^2,1)));
    
    
    
    % Reprojection points for ploting
    xyz_cam = [R t]*XYZ;
    xy_hat = xyz_cam(1:2,:)./xyz_cam(3,:);

    r = sqrt(xy_hat(1,:).^2 + xy_hat(2,:).^2);
    L = 1 + Kd(1)*r.^2 + Kd(2)*r.^4;

    xy_d = L.*xy_hat;
    xy_d = [xy_d; ones(1,size(XYZ,2))];
    xy_reproj = K * xy_d;
    xy_reproj = xy_reproj./xy_reproj(3,:);
    

    disp("Error " +  error);

    
    % disp( mean(sqrt(sum((xy - xy_reproj).^2,1))));
    title_name = sprintf("Calibration with runGoldRadial and %s decomposition type", Dec_type);
    showResults(img, xy, xy_reproj, title_name, false, []);



    end