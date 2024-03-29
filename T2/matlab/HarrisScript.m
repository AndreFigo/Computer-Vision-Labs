clear;
close all;

data_folder ='wall';

datadir     = '../datasets';    %the directory containing the images
datadir = sprintf('%s/%s',datadir, data_folder);
%parameters
sigma_d  = 1;                  % Recommended. Adjust if needed.
sigma_i  = 2;                  % Recommended. Adjust if needed.
Tresh_R = 0.2;                   % Set as example. Adjust if needed.
NMS_size = 10;                 % Recommended. Adjust if needed.
Patchsize  = 8;               % Set as example. Will depends on the scale.
Tresh_Metric = 0.6 ;            % Set as example. Minimum distance metric error for matching
Descriptor_type  = 'S-MOPS';   % SIMPLE -> Simple 5x5 patch ; S-MOPS -> Simplified MOPS
Metric_type = 'SSD';           % RATIO -> Ratio test ; SSD -> Sum Square Distance

Min_Query_features = 50;  % minimum number of 50 Harris points in Query image
%end of parameters

resultsdir  = sprintf('../results/exp_%s_%.2f_%.2f_%.2f_%.2f_%.2f_%.2f_%s_%s_%d',data_folder, sigma_d, sigma_i, Tresh_R, NMS_size, Patchsize, Tresh_Metric, Descriptor_type, Metric_type, Min_Query_features); %the directory for dumping results
mkdir(resultsdir);

%----------------------------------------------------------------------------
% Read list of Files with Homography matrices
list = dir(sprintf('%s/*.txt',datadir));

% Read QUERY Image - IMAGE 1

if strcmp(data_folder,'yosemite')
    imglist = dir(sprintf('%s/*.jpg', datadir));
else
    imglist = dir(sprintf('%s/*.ppm', datadir));
end
[path1, imgname1, dummy1] = fileparts(imglist(1).name);
img1 = imread(sprintf('%s/%s', datadir, imglist(1).name));

if (ndims(img1) == 3)
        img1 = rgb2gray(img1);
    end
    
img1 = double(img1) / 255;
   
% Detect Harris Corners %  
Pts_1 = HarrisCorner(img1,Tresh_R,sigma_d,sigma_i,NMS_size); 
% Detect Keypoints 
Pts_N1 = KeypointsDetection(img1,Pts_1);


file_name = sprintf('%s/%s.png', resultsdir, imgname1);
ShowCorners(img1,Pts_N1, file_name);


% Extract keypoints descriptors 
Dscrpt1 = FeatureDescriptor(img1,Pts_N1,Descriptor_type,Patchsize);

%---------------------------------------------------------------
% PERFORM FEATURE MATCHING between QUERY and TEST images

% Check Minumum number of Query features

if size(Dscrpt1,1) > Min_Query_features

% Performs Feature Matching between MASTER image and a set of SLAVE images
    
  for i = 2:numel(imglist)
    
    % Read TEST images %
    [path2, imgname2, dummy2] = fileparts(imglist(i).name);
    img2 = imread(sprintf('%s/%s', datadir, imglist(i).name));
    
    if (ndims(img2) == 3)
        img2 = rgb2gray(img2);
    end
    
    img2 = double(img2) / 255;
   
    %actual Harris Conners code function calls%  
    Pts_2 = HarrisCorner(img2,Tresh_R,sigma_d,sigma_i,NMS_size);   
    Pts_N2 = KeypointsDetection(img2,Pts_2);

    file_name = sprintf('%s/%s.png', resultsdir, imgname2);
    ShowCorners(img2,Pts_N2, file_name);
    
    %actual feature descritor 
    
    [Dscrpt2] = FeatureDescriptor(img2,Pts_N2,Descriptor_type,Patchsize);
    
    %actual feature matching
    
    MatchList = FeatureMatching(Dscrpt1, Dscrpt2, Tresh_Metric, Metric_type);
    
    %Show matched keypoints and keypoint's feature patches

    file_name = sprintf('%s/%s_%s.png', resultsdir, imgname1, imgname2);
    
    ShowMatching(MatchList,img1,img2,Dscrpt1,Dscrpt2, Pts_N1, Pts_N2, file_name);
    
  end
else
    disp('Not enough features');
  
end
    
