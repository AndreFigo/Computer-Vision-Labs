
function [Match] = RatioFeatureMatcher(Dscpt1,Dscpt2,Tresh)
for i = 1:size(Dscpt1,1)
    diff = Dscpt1(i,:) - Dscpt2;
    diff = sqrt(sum(diff.^2,2));
    [val,ind] = min(diff);
    aux =  diff;
    aux(ind) = [];
    [val2,ind2] = min(aux);
    ratio = val/val2;
    if(ratio < Tresh)
        Match(i,:) = [i, ind, ratio];
    else
        Match(i,:) = [i, -1, -1];
    end
end
end