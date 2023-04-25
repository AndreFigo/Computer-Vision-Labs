function [xy XYZ] = GetPointsHarris(img)
    
    % Initially, the list of points is empty.
    xy = [];
    XYZ = [];
    n = 0;
    % Loop, picking up the points.
    Tresh_R = 0.2;
    NMS_size = 30;
    sigma_d = 2;
    sigma_i = 4;
    
    cols = size(img,2);
    rows = size(img,1);

    if (ndims(img) == 3)
        img = rgb2gray(img);
    end
    img = double(img) / 255;
    Pts = HarrisCorner(img,Tresh_R,sigma_d,sigma_i,NMS_size);
    %disp(Pts)
    
    %ShowCorners(img,Pts, "corners");
    
    n_corners = size(Pts,1);
    n=1;

    for i =1:n_corners

        xi = Pts(i,1);
        yi = Pts(i,2);
        hold on;
        % plot(xi, yi, 'ro')
        plot(yi, xi, '+', 'MarkerSize', 5, 'Color', 'r');
        hold off;

        input = inputdlg('[X Y Z] (write "pass" if invalid point and "stop" to exit)'); % show input dialog
        if(strcmp(input,'pass'))
            continue;
        elseif(strcmp(input,'stop'))
            break;
        else
            xy(:, n) = [yi; xi]; % add a new column with the current values
            XYZi = str2num(input{1}); % convert to number
            XYZ(:, n) = XYZi; % add a new column with the current values
            n = n+1;
        end
    end
    end