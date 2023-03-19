function ShowMatching(MatchList,img1,img2,Dscpt1,Dscpt2)
% Show all matches by ploting the line that connects both matched keypoints. 
% Create a composed image with the original and query image to plot the connected points.
% Allow also the possibility to visualise the 8x8 (or 5x5) feature patches
% per matching.

figure(1); cla;
imshowpair([img1 img2], 'montage'); hold on;
for i=1:size(MatchList,1)
    figure(2)
    subplot(1,2,1)
    a = reshape(Dscpt1(MatchList(i,1),:),8,8);
    imshow(a,[]);
    subplot(1,2,2)
    b = reshape(Dscpt2(MatchList(i,2),:),8,8);
    imshow(b,[]);
    figure(1)
    pos1 = MatchList(i,3:4);
    pos2 = MatchList(i,5:6);
    pos2(1) = pos2(1) + size(img1,2);
    plot([pos1(1) pos2(1)],[pos1(2) pos2(2)],'r');
    line([pos1(1) pos2(1)],[pos1(2) pos2(2)],'color','r','LineStyle','-','LineWidth',1);
end

end
        