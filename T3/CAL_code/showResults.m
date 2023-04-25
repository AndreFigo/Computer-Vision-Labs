function showResults(img, xy, xy_reproj,  title_name, xy_optimal, xy_reproj_optimal)
    %vamos mostrar os resultados
        figure()
        imshow(img)
        hold on
        scatter(xy(1,:), xy(2,:), 25, 'g*', 'DisplayName', 'Calibration points')
        scatter(xy_reproj(1,:), xy_reproj(2,:), 25, 'rO', 'DisplayName', 'Reprojection points')
        if xy_optimal
            scatter(xy_reproj_optimal(1,:), xy_reproj_optimal(2,:), 25, 'b+', 'DisplayName', 'Optimal reprojection points')
        end
        legend
        title(title_name)
        hold off
end