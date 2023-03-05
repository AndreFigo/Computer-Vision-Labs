function [img1] = EdgeFilter(img0, sigma)


    hsize = 2*ceil(3*sigma)+1;
    gaussian_kernel = fspecial('gaussian',hsize,sigma);
    
    sobel_kernel = fspecial('sobel');


    img_smooth = ImageFilter(img0, gaussian_kernel);

    
    img_smooth_x = ImageFilter(img_smooth, sobel_kernel);
   
    
    img_smooth_y = ImageFilter(img_smooth, sobel_kernel');

    
    gradients = sqrt(double(img_smooth_x.^2 + img_smooth_y.^2));

    % calculate gradient direction

    directions = atan(double(img_smooth_y./img_smooth_x));

    % round to 0, 45, 90, 135 in radians


    directions = round((directions + pi/2) * 4 / pi) * pi / 4;



    g_size = size(gradients);
    r = g_size(1);
    c = g_size(2);

    
    img1 = gradients; 
    
    img1(gradients<0.2) = 0;


    for i = 1:r
        for j = 1: c

        if (directions(i,j) == 0 || directions(i,j) == pi)
            if (i == 1 || i == r)
                img1(i,j) = 0;
            elseif (gradients(i,j) < gradients(i-1,j) || gradients(i,j) < gradients(i+1,j))
                img1(i,j) = 0;
            end
        elseif (directions(i,j) ==  pi/4)
            if (i == 1 || i ==r || j == 1 || j == c)
                img1(i,j) = 0;
            elseif (gradients(i,j) < gradients(i+1,j-1) || gradients(i,j) < gradients(i-1,j+1))
                img1(i,j) = 0;
            end
            
        elseif (directions(i,j) == pi/2)
            if (j == 1 || j == c)
                img1(i,j) = 0;
            elseif (gradients(i,j) < gradients(i,j-1) || gradients(i,j) < gradients(i,j+1))
                img1(i,j) = 0;
            end
        elseif (directions(i,j) == 3*pi/4)
                if (i == 1 || i == r || j == 1 || j == c)
                    img1(i,j) = 0;
                elseif (gradients(i,j) < gradients(i-1,j-1) || gradients(i,j) < gradients(i+1,j+1))
                    img1(i,j) = 0;
                end
            end

        end
    end
    % figure;
    % imshow(img1)
    
    
    % apply threshold to img1 to avoid noise 

end
    
                
        
        
