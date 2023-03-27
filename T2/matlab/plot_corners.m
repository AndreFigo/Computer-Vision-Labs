close all;
sigma_d  = 1;                  % Recommended. Adjust if needed.
sigma_i  = 2;                  % Recommended. Adjust if needed.
Tresh_R = 5;                   % Set as example. Adjust if needed.
NMS_size = 10;                 % Recommended. Adjust if needed.
Patchsize  = 40;               % Set as example. Will depends on the scale.
Tresh_Metric = 10 ;            % Set as example. Minimum distance metric error for matching
Descriptor_type  = 'S-MOPS';   % SIMPLE -> Simple 5x5 patch ; S-MOPS -> Simplified MOPS
Metric_type = 'SSD'; 


    % I am using the following code to plot the corners. I am not sure how to plot the scale and orientation of the corners. I am using the following code to plot the corners. I am not sure how to plot the scale and orientation of the corners.


Pts_1 = HarrisCorner(img1,Tresh_R,sigma_d,sigma_i,NMS_size); 

figure();
imshow(img);
hold on;
axis on;
plot(Pts_1(:,2), Pts_1(:,1), 'o');

%I am using the following code to plot the corners. I am not sure how to plot the scale and orientation of the corners.
Pts_N1 = KeypointsDetection(img1,Pts_1);
figure();
imshow(img);
hold on;
axis on;
% Pts(:,3) is the orientation of the keypoint and Pts(:,4) is the scale

for i =1:size(Pts_N1,1)
    center = Pts_N1(i,1:2);
    orientation = Pts_N1(i,3);
    hsize = 2 * ceil(3 * Pts_N1(i,4)) + 1;


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

    patch('Vertices',[ y1 y2 y3 y4; x1 x2 x3 x4]','Faces',[1 2 3 4],'Edgecolor', 'g','Facecolor','none','Linewidth',1);
    axis equal;
    % xlim([0 size(img,2)]);
    % ylim([0 size(img,1)]);
    

end

