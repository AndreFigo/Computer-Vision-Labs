function [H, rhoScale, thetaScale] = HoughTransform(Im, threshold, rhoRes, thetaRes)

% HoughTransform - Hough transform of an edge image

% Usage: [H, rhoScale, thetaScale] = HoughTransform(Im, threshold, rhoRes, thetaRes) 
    
    % im= Im;
    % disp(max(Im(:)))
    im = double(Im)/max(Im(:));
    %im = double(Im);
    [rows, cols] = size(im);
    maxRho = sqrt((rows)^2 + (cols)^2);
    rhoScale = 0:rhoRes:maxRho;

    thetaScale = 0:thetaRes:2*pi;	

    H = zeros(length(rhoScale)-1, length(thetaScale)-1);

    [Ys, Xs] = find(Im>threshold);

    for i = 1:length(thetaScale)
        rhos = Xs*cos(thetaScale(i)) + Ys*sin(thetaScale(i));
        thetas = ones(size(rhos)) * thetaScale(i);
        H = H + histcounts2(rhos, thetas , rhoScale, thetaScale);
        
    end
    
    % for i = 1:rows
    %     for j = 1:cols
    %         if im(i,j) < threshold
    %             continue;
    %         else
    %             for k = 1:length(thetaScale)
    %                 rho = j*cos(thetaScale(k)) + i*sin(thetaScale(k));
    %                 if rho > 0
    %                     rhoIndex = round(rho/rhoRes) + 1;
    %                     H(rhoIndex, k) = H(rhoIndex, k) + 1;
    %                 end
    %             end
    %         end
    %     end
    % end
    %count only positive rho

    % H = H ( floor(length(rhoScale)/2): end, :);
    % rhoScale = 0:rhoRes:maxRho;
    
    % disp(max(max(H)))

    
    % H = uint8(H/ max(max(H) )* 255);


end
        
