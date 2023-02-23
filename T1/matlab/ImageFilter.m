function [img1] = ImageFilter(img0, h)
    dimensions = size(img0);

 
    img1 = zeros(dimensions(1),dimensions(2)); 
    img_aux = zeros(dimensions(1),dimensions(2));

    % Conv 2D 1D 1D
    [U,S,V] = svd(h);

    isSeperable = 1;
    % Check if it is Seperable

    eps = 0.000001;
    for i = 2:size(S)
        
        if S(i,i) > eps
            disp(S(i,i))
            isSeperable = 0;
        end
   
    end
    % Case it is seperable
    if isSeperable == 1
        y = sqrt(S(1,1))*U(:,1);
        x = sqrt(S(1,1))*transpose(V(:,1));
        

        x_size = size(x);
        y_size = size(y);
        % find center of both kernels
        kernelCenter_x = ceil(x_size(2)/2 );
        kernelCenter_y = ceil(y_size(1)/2);
        
        %padding array with close value
        pad_value = floor(x_size(2)/2);

        imgPadded = padarray(img0,[pad_value, pad_value]);

        
        for i = 1:dimensions(1) 
            for j = 1:dimensions(2) 
                for k = 1:x_size(2)  
                        ii = i+k -1;
                        jj = j + pad_value;
                        img_aux(i,j) = img_aux(i,j) + imgPadded(ii,jj)* x(1,k); 

                end 
            end 
        end
        img_aux = padarray(img_aux,[pad_value, pad_value] );
        for i = 1:dimensions(1) 
            for j = 1:dimensions(2)
        
                for l = 1:y_size(1)  
                        ii = i + pad_value; 
                        jj = j+l-1;
                        img1(i,j) = img1(i,j) + img_aux(ii,jj)* y(l,1); 
                end 
            end 
        end
       
    end
    %Todo Case not seperable
    
end 