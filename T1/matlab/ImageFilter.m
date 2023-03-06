function [img1] = ImageFilter(img0, h)
    img0=double(img0);
    dimensions = size(img0);

 
    img1 = zeros(dimensions(1),dimensions(2)); 
    img_aux = zeros(dimensions(1),dimensions(2));

    % Conv 2D 1D 1D
    [U,S,V] = svd(h);
    eps = 0.0000001;
    isSeparable = 0;

    % check rank
    if S(1,1) < eps
        isSeparable = 1;
    end
    % Check if it is Seperable

    for i = 2:size(S)
        if S(i,i) > eps
            %disp(S(i,i))
            isSeparable = 0;
        end
   
    end
    % Case it is seperable
    if isSeparable == 1
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
                img_aux(i,j) = sum(imgPadded(i:i+x_size(2)-1,j).* x, "all");

                % for k = 1:x_size(2)  
                %         ii = i+k -1;
                %         jj = j + pad_value;
                %         img_aux(i,j) = img_aux(i,j) + imgPadded(ii,jj)* x(1,k); 

                % end 
            end 
        end
        img_aux = padarray(img_aux,[pad_value, pad_value] );
        for i = 1:dimensions(1) 
            for j = 1:dimensions(2)
                img1(i,j) = sum(img_aux(i,j:j+y_size(1)-1).* y, "all");
                % for l = 1:y_size(1)  
                %         ii = i + pad_value; 
                %         jj = j+l-1;
                %         img1(i,j) = img1(i,j) + img_aux(ii,jj)* y(l,1); 
                % end 
            end 
        end
    

    else 
        k_size = size(h);
        pad_value = floor(k_size(2)/2);
        imgPadded = padarray(img0,[pad_value, pad_value]);
        for i = 1:dimensions(1) 
            for j = 1:dimensions(2)
            %    img1(i,j) =  sum(imgPadded(i:i+k_size(2)-1,j:j+k_size(1)-1).* h, "all");
                for k = 1:k_size(2) 
                    ii = i + k - 1; 
                    for l = 1:k_size(1) 
                        jj = j + l - 1;
                        img1(i,j) = img1(i,j) + imgPadded(ii,jj)* h(l,k); 
                    end 
                end
            end 
        end
    end


    % img1 = uint8(img1);
    
end 