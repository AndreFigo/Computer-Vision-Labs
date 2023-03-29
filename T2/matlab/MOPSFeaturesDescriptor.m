function [Descriptors] = MOPSFeaturesDescriptor(Img,Pts, Patch_size)


    Descriptors = zeros(size(Pts,1),Patch_size*Patch_size);
    for i = 1:size(Pts,1)
        scale = 2*ceil(3* Pts(i,4)) +1;
        N = floor(2*sqrt(2)* scale);
        if N < Patch_size + 4
            N = Patch_size + 4;
        end
        dim = floor(N/2);
        x = Pts(i,1);
        y = Pts(i,2);
        % img_reshaped = Img(x-dim:x+dim,y-dim:y+dim),1,Patch_size*Patch_size;
        theta = Pts(i,3);
        T = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
        Tform = affine2d(T);
        if x - dim < 1|| y - dim < 1 || x + dim > size(Img,1) || y + dim > size(Img,2)
            continue;
        end
        % disp(Img(x-dim:x+dim,y-dim:y+dim));
        B = imwarp(Img(x-dim:x+dim,y-dim:y+dim),Tform);
        center = [round(size(B,1)/2), round(size(B,2)/2)];
        img_patch = imresize(B(center(1)-floor(Patch_size/2):center(1)+floor(Patch_size/2),center(2)-floor(Patch_size/2):center(2)+floor(Patch_size/2)),[Patch_size,Patch_size]);
        Descriptors(i,:) = normalize(reshape(img_patch,1,Patch_size*Patch_size));           
    end

        

end