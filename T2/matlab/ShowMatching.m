function ShowMatching(MatchList,img1,img2,Dscpt1,Dscpt2, Pts1, Pts2)
% Show all matches by ploting the line that connects both matched keypoints. 
% Create a composed image with the original and query image to plot the connected points.
% Allow also the possibility to visualise the 8x8 (or 5x5) feature patches
% per matching.

feat_size = sqrt(size(Dscpt1,2));
close all;
figure(); 
imshowpair(img1, img2, 'montage'); hold on;
for i=1:size(MatchList,1)
% for i=1:2
    figure(1);
    pos1 = Pts1(i,1:2);
    if MatchList(i,2) == -1
        % disp('No match found')
        continue;
    end
    pos2 = Pts2(MatchList(i,2),1:2);
    pos2(2) = pos2(2) + size(img1,2);
    plot([pos1(2) pos2(2)],[pos1(1) pos2(1)],'r*');
    line([pos1(2) pos2(2)],[pos1(1) pos2(1)],'color','c','LineStyle','-','LineWidth',1);
    hold on;
    % figure(2)
    % subplot(1,2,1)
    % a = reshape(Dscpt1(MatchList(i,1),:),feat_size,feat_size);
    % imshow(a,[]);
    % subplot(1,2,2)
    % b = reshape(Dscpt2(MatchList(i,2),:),feat_size,feat_size);
    % imshow(b,[]);
    % break;
end

end
        