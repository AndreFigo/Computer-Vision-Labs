function [] = showPointsInImage( Im1, Im2, pts1, pts2 )
    figure();
    subplot(1,2,1);
    imshow(Im1);
    hold on;
    plot( pts1(:,1), pts1(:,2), '*' );

    subplot(1,2,2);
    imshow(Im2);
    hold on;
    plot( pts2(:,1), pts2(:,2), '*' );
end