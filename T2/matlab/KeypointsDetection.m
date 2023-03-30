function [Pts] = KeypointsDetection(Img,Pts)
    sigma = 2;
    hsize = 2*ceil(3*sigma)+1;
    gaussian_kernel = fspecial('gaussian',hsize,sigma);
    
    sobel_kernel = fspecial('sobel');
    img_smooth = ImageFilter(Img, gaussian_kernel);
    img_smooth_x = ImageFilter(img_smooth, sobel_kernel);    
    img_smooth_y = ImageFilter(img_smooth, sobel_kernel');


    directions = atan(double(img_smooth_y./img_smooth_x));

    for i = 1:size(Pts,1)
    
        Pts(i,3) = directions(Pts(i,1), Pts(i,2));
    end
    
    sigma0 = 0.5;
    num_filt = 10;
    i = 1:num_filt;
    sigma_l(i) = sqrt(2).^(i-1) * sigma0;
    h_size(i) = 2 * ceil(3 * sigma_l(i)) + 1; 

    for i=1:num_filt  
        filters(i).filter = fspecial('log',h_size(i),sigma_l(i));
        imgs(i).filtered = conv2(Img, filters(i).filter);
    end
    
    for p = 1:size(Pts,1)
        max_value = -255;
        for i = 1:num_filt
            if imgs(i).filtered(Pts(p,1), Pts(p,2)) > max_value
                max_value = imgs(i).filtered(Pts(p,1), Pts(p,2));
                Pts(p,4) = sigma_l(i);
            end
        end

        
    end

    ind_to_save = [];

    for p= 1:size(Pts,1)
        center = Pts(p,1:2);
        orientation = Pts(p,3);
        hsize = 2 * ceil(3 * Pts(p,4)) + 1;
    
        side_size = hsize/2;
        %disp(side_size)
        angle = orientation;
    
        rot_mat = [cos(angle) -sin(angle); sin(angle) cos(angle)];
        x_corners = [-side_size side_size side_size -side_size];
        y_corners = [-side_size -side_size side_size side_size];
    
        for i =1:4
            corners(:,i) = rot_mat * [x_corners(i); y_corners(i)];
        end
    
        x1 = center(1) + corners(1,1);
        y1 = center(2) + corners(2,1);
        x2 = center(1) + corners(1,2);
        y2 = center(2) + corners(2,2);
        x3 = center(1) + corners(1,3);
        y3 = center(2) + corners(2,3);
        x4 = center(1) + corners(1,4);
        y4 = center(2) + corners(2,4);
        xs = [x1 x2 x3 x4];
        ys = [y1 y2 y3 y4];
        %disp(min(xs));
        if ~(min(xs)<= 0 || max(xs) >= size(Img,1) || min(ys) <= 0 || max(ys) >= size(Img,2))
            ind_to_save = [ind_to_save p];
        end
    end
    %disp(size(ind_to_save));
    Pts = Pts(ind_to_save,:);
    
end