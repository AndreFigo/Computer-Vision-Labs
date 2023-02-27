function [H, rhoScale, thetaScale] = HoughTransform(Im, threshold, rhoRes, thetaRes)

% HoughTransform - Hough transform of an edge image

% Usage: [H, rhoScale, thetaScale] = HoughTransform(Im, threshold, rhoRes, thetaRes) 

    im = double(Im)/255;
    [rows, cols] = size(im);
    maxRho = sqrt((rows-1)^2 + (cols-1)^2);
    %disp(maxRho)
    rhoScale = -maxRho:rhoRes:maxRho;
    %disp(rhoScale)
    thetaScale = 0:thetaRes:2*pi;	
    H = zeros(length(rhoScale), length(thetaScale));
    for i = 1:rows
        for j = 1:cols
            if im(i,j) < threshold
                continue;
            else
                for k = 1:length(thetaScale)
                    rho = j*cos(thetaScale(k)) + i*sin(thetaScale(k));
                    %disp(rho)
                    
                    rhoIndex = round(rho/rhoRes) + ceil(length(rhoScale)/2);
                    
                    %disp(rhoIndex)
                    H(rhoIndex, k) = H(rhoIndex, k) + 1;
                end
            end
        end
    end
    

    %count only positive rho

    H = H ( floor(length(rhoScale)/2): end, :);
    figure;
    imshow(uint8(H/ max(max(H) )* 255));




end
        
