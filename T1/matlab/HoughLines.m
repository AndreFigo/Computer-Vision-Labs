function [rhos, thetas] = HoughLines(H, nLines)


    [rows, cols] = size(H);
    
    h_size = size(H);
    
    supp = 20;
    
    [H_sorted, ind ] = sort(H(:), 'descend');
    [rho_ind, theta_ind] = ind2sub([rows, cols], ind);
    % use at most 4 times the number of lines requested
    % assume that the best lines are not too close to each other when using 4 
    %times the number of lines requested
    

    for i = 2:nLines * 4
        for j = 1: i-1
            rho_diff = abs(rho_ind(i) - rho_ind(j));
            theta_diff = abs(theta_ind(i) - theta_ind(j));
            if rho_diff < supp && theta_diff < supp
                H(ind(i)) = 0;
                break;
            end
        end
    end
    [H_sorted_with_sup, ind_sup ] = sort(H(:), 'descend');
    [rho_ind, theta_ind] = ind2sub([rows, cols], ind_sup);
    rhos = rho_ind(1:nLines);
    thetas = theta_ind(1:nLines);




% for i =1:h_size(1)
%     for j = 1:h_size(2)
%         i_begin = i-1;
%         if i_begin < 1
%             i_begin=1;
%         end
%         i_end = i+1;
%         if i_end> h_size(1)
%             i_end = h_size(1);
%         end

%         j_begin = i-1;
%         if j_begin < 1
%             j_begin=1;
%         end
%         j_end = i+1;
%         if j_end> h_size(2)
%             j_end = h_size(2);
%         end

%         max_val = max(max_H(i_begin:i_end, j_begin:j_end),[], "all");
%         n_maxs = sum(max_val == max_H(i_begin:i_end, j_begin:j_end), "all");
%         if max_val == max_H(i,j) & n_maxs == 1
%             max_H(i,j) = max_H(i,j);
%         else
%             max_H(i,j) = 0;
%         end

%     end
% end


% loop to find the top nLines peaks in H



% max_rho = sqrt((rows-1)^2 + (cols-1)^2);
% rho_range = linspace(0, max_rho, rows);
% theta_range = linspace(0, 2*pi, cols);
% rhos = rho_range(rhos_ind);
% thetas = theta_range(thetas_ind);

end
