% A test script using coords.mat
%
% Write your code here
%

clear all;
close all;

im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

load('../data/correspondences.mat');

F = computeF( pts1 , pts2 );

displayEpipolar(im1, im2, F);

load('../data/coords.mat');

pts2 = findEpipolarMatches( im1 , im2 , F , pts1 );
disp(1)
[coords_im1, coords_im2] = epipolarMatchGUI(im1, im2, F);
disp(2)
showPointsInImage( im1, im2, pts1, pts2 );
disp(3)

load('../data/intrinsics.mat');

E = computeE( F , K1 , K2 );

E1 = [eye(3), zeros(3, 1)];
E2 = camera2(E);
disp(4)
for i=1:size(E2,3)

    P1 = K1 * E1;
    P2 = K2 * E2(:,:,i);
    pts_3d = triangulation3D(P1, pts1, P2, pts2);

    if all(pts_3d(:,3) > 0)
        R2 = E2(:,1:3,i);
        t2 = E2(:,4,i);
        break;
    end
end
disp(5)
figure;
plot3(pts_3d(:,1),pts_3d(:,2),pts_3d(:,3),'*'); axis([-1 1 -1 1 0 8])

R1 = E1(:,1:3);
t1 = E1(:,4);

disp(6)
% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');

