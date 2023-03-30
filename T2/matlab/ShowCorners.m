function ShowCorners(img, Pts, file)

    figure();
    if max(img(:)) > 1
        img = img/255;
    end
    imshow(img);
    hold on;
    axis on;
    for i =1:size(Pts,1)
        center = Pts(i,1:2);
        orientation = Pts(i,3);
        hsize = 2 * ceil(3 * Pts(i,4)) + 1;
    
    
        % Compute the endpoints of the line indicating the orientation
        side_size = hsize/2;
        % angle = orientation*pi/180;
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
        
        plot(Pts(:,2), Pts(:,1), '+', 'MarkerSize', 5, 'Color', 'r');
        patch('Vertices',[ y1 y2 y3 y4; x1 x2 x3 x4]','Faces',[1 2 3 4],'Edgecolor', 'g','Facecolor','none','Linewidth',1);
        axis equal;
        % xlim([0 size(img,2)]);
        % ylim([0 size(img,1)]);
    end

    saveas(gcf, file)

end
        