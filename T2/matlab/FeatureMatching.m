function [Match] = FeatureMatching(Dscpt1,Dscpt2,Tresh,Metric_TYPE)
    Match = zeros(size(Dscpt1,1), 7);
    if(strcmp(Metric_TYPE, 'SSD'))
        Match = SSDFeatureMatcher(Dscpt1,Dscpt2,Tresh);
    elseif (strcmp(Metric_TYPE, 'RATIO'))
        Match = RatioFeatureMatcher(Dscpt1,Dscpt2,Tresh);
    else 
        disp('Error: Metric type not recognized');
    end
    
end
        
        