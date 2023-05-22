function dispM = computeDisparity(im1, im2, maxDisp, windowSize)
% computeDisparity creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.


    halfWindow = floor(windowSize/2);
    dispM = zeros(size(im1));

    for i = 1+halfWindow:size(im1,1)-halfWindow
        for j = 1+halfWindow:size(im1,2)-halfWindow-maxDisp
            % compute the cost for each disparity
            costs = zeros(maxDisp,1);
            for d = 1:maxDisp
                % compute the sum of squared differences
                costs(d) = sum(sum((im1(i-halfWindow:i+halfWindow,j-halfWindow:j+halfWindow) - im2(i-halfWindow:i+halfWindow,j-halfWindow+d:j+halfWindow+d)).^2));
            end
            % find the disparity with the minimum cost
            [~, dispM(i,j)] = min(costs);
        end
    end

end