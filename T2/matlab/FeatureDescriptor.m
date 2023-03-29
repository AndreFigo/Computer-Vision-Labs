function [Descriptors] = FeatureDescriptor(Img,Pts, Dscpt_type, Patch_size)
    if strcmp(Dscpt_type, 'SIMPLE')
        
        Descriptors = SimpleFeatureDescriptor(Img,Pts, 5);

    else if strcmp(Dscpt_type,'S-MOPS')
        Descriptors = MOPSFeaturesDescriptor(Img,Pts, 8);

    else
        disp('Unknown descriptor type');
    end 


end
        
        