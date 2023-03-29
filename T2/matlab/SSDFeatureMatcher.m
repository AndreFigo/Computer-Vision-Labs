function [Match] = SSDFeatureMatcher(Dscpt1,Dscpt2,Tresh)
    for i = 1:size(Dscpt1,1)
        diff = Dscpt1(i,:) - Dscpt2;
        % disp(size(diff));
        diff = sqrt(sum(diff.^2,2));
        [val,ind] = min(diff)
        if(val < Tresh)
            Match(i,:) = [i, ind, val];
        else
            Match(i,:) = [i, -1, -1];
        end
    end
end