function showResults(img, xy, xy_reproj,  title)
    %vamos mostrar os resultados
        figure()
        imshow(img)
        hold on
        scatter(xy(1,:), xy(2,:), 25, 'g*', 'DisplayName', 'Calibration points')
        scatter(xy_reproj(1,:), xy_reproj(2,:), 25, 'rO', 'DisplayName', 'Reprojection points')
        
        hold off
        legend
        title(title)
end