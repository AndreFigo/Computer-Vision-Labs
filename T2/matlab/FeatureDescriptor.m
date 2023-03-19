function [Descriptors] = FeatureDescriptor(Img,Pts,Dscpt_type,Patch_size)
    if strcmp(Dscpt_type, 'SIMPLE')
        Descriptors = zeros(size(Pts,1),Patch_size*Patch_size);
        for i = 1:size(Pts,1)
            dim = 5;
            x = Pts(i,1);
            y = Pts(i,2);
            Descriptors(i,:) = reshape(Img(y-dim:y+dim,x-dim:x+dim),1,Patch_size*Patch_size);
        end

    elseif strcmp(Dscpt_type,'S-MOPS')
        Descriptors = zeros(size(Pts,1),Patch_size*Patch_size);
        for i = 1:size(Pts,1)
            N = 2*sqrt(2)*Pts(i,4);
            if N < Patch_size + 4
                N = Patch_size + 4;
            end
            dim = round(N/2);
            x = Pts(i,1);
            y = Pts(i,2);
            Descriptors(i,:) = reshape(Img(y-dim:y+dim,x-dim:x+dim),1,Patch_size*Patch_size);
            theta = Pts(i,3);
            T = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
            Tform = affine2d(T);
            B = imwarp(Descriptors(i,:),Tform);
            center = [round(size(B,1)/2), round(size(B,2)/2)];
            img_norm = normalize(imresize(B(center(1)-round(Patch_size/2):center(1)+round(Patch_size/2),center(2)-round(Patch_size/2):center(2)+round(Patch_size/2)),[Patch_size,Patch_size]));
            Descriptors(i,:) = reshape(img_norm,1,Patch_size*Patch_size);           
        end
    end if

end
        
        