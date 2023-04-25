function f = fminGoldRadial(p, xy, XYZ, w)

    %reassemble P
    P = [p(1:4);p(5:8);p(9:12)];
    Kd = p(13:14);
    [K, R, C] = decomposeQR(P);
    t = -R*C;
    % disp(K)
    % disp(C)
    % disp(R)
    % disp(t)
    % disp(XYZ)
    XYZ_cam = [R t]*XYZ;
    
    %compute squared geometric error with radial distortion
    xy_p = XYZ_cam(1:2,:)./XYZ_cam(3,:);
    

    r = sqrt(xy_p(1,:).^2 + xy_p(2,:).^2);
    L = 1 + Kd(1)*r.^2 + Kd(2)*r.^4;
    
    xy_d = L.*xy_p;
    % xy_d_h = [xy_d; ones(1,size(xy_d,2))];
    
    error = sum(sqrt(sum((xy_d(1:2,:)-xy_p(1:2,:)).^2,1)).^2);

    %compute cost function value
    f = error;
    end

   