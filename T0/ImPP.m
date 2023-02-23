
close all
% read img
img_raw = imread('data/banana_slug.tiff');
img_raw = double(img_raw);

% 2856x4290 uint16
% olny uses 14 bits

[x, y] = size(img_raw);


% normalization
minn = 2047;
maxx = 15000;

img_norm = (img_raw - minn)/(maxx - minn);
%img_norm = max(0, min(img_norm, 1));
img_norm(img_norm<0)=0;
img_norm(img_norm>1)=1;


% same thing, different ways

%img2(img2<minn)=minn;
%img2(img2>maxx)=maxx;
%img_norm = rescale(img2);

%disp(all(all(img_norm==img)));

%imshow(img_norm);
%figure;
%imshow(min(1,img_norm*5));

c1=img_norm(1:2:end,1:2:end);
c2=img_norm(1:2:end,2:2:end);
c3=img_norm(2:2:end,1:2:end);
c4=img_norm(2:2:end,2:2:end);


grbg = cat(3, c2,c1,c3);
rggb = cat(3, c1,c2,c4);
bggr = cat(3, c4,c2,c1);
gbrg = cat(3, c3,c1,c2);


%{
figure;
imshow(min(1,grbg*5));
title("grbg pattern");
figure;
imshow(min(1,rggb*5));
title("rggb pattern");
figure;
imshow(min(1,bggr*5));
title("bggr pattern");
figure;
imshow(min(1,gbrg*5));
title("gbrg pattern");
%}


%%
% 
% 
%  RGGB seems to be the best pattern
% 
% 


%% 
% cat (3, r, g, b)


% rggb seems the best


red=img_norm(1:2:end,1:2:end);
green1=img_norm(1:2:end,2:2:end);
green2=img_norm(2:2:end,1:2:end);
blue=img_norm(2:2:end,2:2:end);

% grey 
r_avg = mean(red(:));
g_avg = mean([green1(:); green2(:)]);
b_avg = mean(blue(:));

%red = red * (g_avg/r_avg);
%blue = blue * (g_avg/b_avg);


% white
r_max = max(red(:));
g_max = max([green1(:); green2(:)]);
b_max = max(blue(:));

red = red * g_max / r_max;
blue = blue * g_max / b_max;


% red demosaicing
r_true = zeros(size(img_raw));
r_true(1:2:end, 1:2:end)= red;

[x_true, y_true] = meshgrid(1:2:y, 1:2:x);

ind = [2 1; 1 2; 2 2];

for i = 1:size(ind,1)
    a = ind(i,1):2:y;
    b = ind(i,2):2:x;
    [x_needed, y_needed] = meshgrid(a,b);
    r_true(ind(i,1):2:end,ind(i,2):2:end) = interp2(x_true,y_true, red, x_needed, y_needed);
end


 
% blue demosaicing
b_true = zeros(x,y);
b_true(2:2:end, 2:2:end)= blue;

[x_true, y_true] = meshgrid(2:2:y, 2:2:x);

ind = [1 1; 1 2; 2 1];

for i = 1:size(ind,1)
    a = ind(i,1):2:y;
    b = ind(i,2):2:x;
    [x_needed, y_needed] = meshgrid(a,b);
    b_true(ind(i,1):2:end,ind(i,2):2:end) = interp2(x_true,y_true, blue, x_needed, y_needed);
end



% green demosaicing
g_true = zeros(x,y);

g_true(1:2:end, 2:2:end)= green1;
g_true(2:2:end, 1:2:end)= green2;
[x1_true, y1_true] = meshgrid(1:2:y, 2:2:x);
[x2_true, y2_true] = meshgrid(2:2:y, 1:2:x);

ind = [1 1; 2 2];

for i = 1:size(ind,1)
    a = ind(i,1):2:y;
    b = ind(i,2):2:x;
    [x_needed, y_needed] = meshgrid(a,b);
    inter_1 = interp2(x1_true,y1_true, green1, x_needed, y_needed);
    inter_2 = interp2(x2_true,y2_true, green2, x_needed, y_needed);
    g_true(ind(i,1):2:end,ind(i,2):2:end) = (inter_1 + inter_2)/2;
end


img_rgb = cat(3, r_true ,g_true , b_true);

figure;
imshow(img_rgb);




