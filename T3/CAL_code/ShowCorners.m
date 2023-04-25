function ShowCorners(img, Pts, file)

    figure();
    if max(img(:)) > 1
        img = img/255;
    end
    imshow(img);
    hold on;
    axis on;
    for i =1:size(Pts,1)
        plot(Pts(:,2), Pts(:,1), '+', 'MarkerSize', 5, 'Color', 'r');

    end

    saveas(gcf, file)

end
        