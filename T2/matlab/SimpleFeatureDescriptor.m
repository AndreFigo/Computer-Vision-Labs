function [Descriptors] = SimpleFeatureDescriptor(Img,Pts, Patch_size)

    Descriptors = zeros(size(Pts,1),Patch_size*Patch_size);
    [ rows, cols] = size(Img);

    for i = 1:size(Pts,1)
        dim = 5;
        dim = floor(Patch_size/2); % 2 for each side
        x = Pts(i,1);
        y = Pts(i,2);
        % img_reshaped = reshape(Img(min(y-dim,1):max(y+dim,rows),min(x-dim,1):max(x+dim,cols)),1,Patch_size*Patch_size);
        img_reshaped = reshape(Img(x-dim:x+dim,y-dim:y+dim),1,Patch_size*Patch_size);
        
        Descriptors(i,:) = normalize(img_reshaped);
    end
end