function [Match] = FeatureMatching(Dscpt1,Dscpt2,Tresh,Metric_TYPE)
    Match = zeros(size(Dscpt1,1), 7);
    if(strcmp(Metric_TYPE, 'SSD'))
        for i = 1:size(Dscpt1,1)
            diff = Dscpt1(i,:) - Dscpt2;
            diff = sqrt(sum(diff.^2,2));
            [val,ind] = min(diff)
            if(val < Tresh)
                Match(i,:) = [i, ind, val, 0, 0, 0, 0];
            end
        end
    elseif (strcmp(Metric_TYPE, 'RATIO'))
        for i = 1:size(Dscpt1,1)
            diff = Dscpt1(i,:) - Dscpt2;
            diff = sqrt(sum(diff.^2,2));
            [val,ind] = sort(diff);
            ratio = val(1)/val(2);
            if(ratio < Tresh)
                Match(i,:) = [i, ind(1), val(1), val(2), ratio, 0, 0];
            end
        end
        
    end if
end
        
        