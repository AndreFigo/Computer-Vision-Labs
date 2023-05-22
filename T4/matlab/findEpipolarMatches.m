function [pts2] = findEpipolarMatches(im1, im2, F, pts1)
% findEpipolarMatches:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%

windowSize = 15;
halfWindowSize = floor(windowSize/2);


    for i= 1:size(pts1,1)

        % get the point in image 1
        x1 = pts1(i,1);
        y1 = pts1(i,2);

        % get the line in image 2
        line = F * [x1; y1; 1];
        a = line(1);
        b = line(2);
        c = line(3);

        line = line / sqrt(a^2 + b^2);

        window = im1(y1-halfWindowSize:y1+halfWindowSize, x1-halfWindowSize:x1+halfWindowSize);
        window = normalize(double(reshape(window, [1, windowSize^2])));

        min_dist = inf;
        minIndex = 0;

        for j = 1 + halfWindowSize : size(im2,2) - halfWindowSize

            y2 = round((-c - a * j) / b);

            if y2 < 1 + halfWindowSize || y2 > size(im2,1) - halfWindowSize
                continue;
            end

            window2 = im2(y2-halfWindowSize:y2+halfWindowSize, j-halfWindowSize:j+halfWindowSize);
            window2 = normalize(double(reshape(window2, [1, windowSize^2])));


            man_dist = mandist(window, window2');

            if man_dist < min_dist
                min_dist = man_dist;
                minIndex = j;
            end

        end 

        pts2(i,1) = minIndex;
        pts2(i,2) = round((-c - a * minIndex) / b);


    end

end

