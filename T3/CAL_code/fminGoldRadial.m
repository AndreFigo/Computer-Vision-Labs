function f = fminGoldRadial(p, xy, XYZ, w)

    %reassemble P
    P = [p(1:4);p(5:8);p(9:12)];
    Kd = p(13:14);
    [K, R, C] = decomposeQR(P);
    t = -R*C;

    
    xyz_cam = [R t]*XYZ;
    xy_hat = xyz_cam(1:2,:)./xyz_cam(3,:);

    sxy_d = inv(K) * xy;
    %points with distortion 
    xy_d_or = sxy_d(1:2,:)./sxy_d(3,:);


    r = sqrt(xy_hat(1,:).^2 + xy_hat(2,:).^2);
    L = 1 + Kd(1)*r.^2 + Kd(2)*r.^4;
    
    xy_d = L.*xy_hat;

    f = sum(sqrt(sum((xy_d - xy_d_or).^2,1)));



    %compute cost function value
    end

