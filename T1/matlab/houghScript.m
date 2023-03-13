clear;
close all;

datadir     = '../data';    %the directory containing the images
resultsdir  = '../results'; %the directory for dumping results

%parameters
sigma     = 2;
threshold = 0.07;
rhoRes    = 5;
thetaRes  = pi/60;
nLines    = 50;
%end of parameters

MinLength = 10;

resultsdir = sprintf('%s/%.2f_%.3f_%.2f_%.4f_%d_%.2ff',resultsdir,sigma, threshold, rhoRes, thetaRes, nLines, MinLength);
mkdir(resultsdir);
imglist = dir(sprintf('%s/*.jpg', datadir));

for i = 1:numel(imglist)
    
    %read in images%
    [path, imgname, dummy] = fileparts(imglist(i).name);
    img = imread(sprintf('%s/%s', datadir, imglist(i).name));
    
    if (ndims(img) == 3)
        img = rgb2gray(img);
    end
    
    img = double(img) / 255;
   
    %actual Hough line code function calls%  
    [Im] = EdgeFilter(img, sigma);   
    [H,rhoScale,thetaScale] = HoughTransform(Im, threshold, rhoRes, thetaRes);
    [rhos, thetas] = HoughLines(H, nLines);
    lines = houghlines(Im>threshold, 180*(thetaScale/pi), rhoScale, [rhos,thetas],'FillGap',5,'MinLength',MinLength);
    %everything below here just saves the outputs to files%
    fname = sprintf('%s/%s_01edge.png', resultsdir, imgname);
    imwrite(sqrt(Im/max(Im(:))), fname);
    fname = sprintf('%s/%s_02threshold.png', resultsdir, imgname);
    imwrite(Im > threshold, fname);
    fname = sprintf('%s/%s_03hough.png', resultsdir, imgname);
    imwrite(H/max(H(:)), fname);
    fname = sprintf('%s/%s_04lines.png', resultsdir, imgname);
    
    img2 = img;
    for j=1:numel(lines)
       img2 = drawLine(img2, lines(j).point1, lines(j).point2); 
    end     
    imwrite(img2, fname);
end
    
