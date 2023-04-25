function [Pts] = HarrisCorner(img0,thresh,sigma_d,sigma_i,NMS_size)


    % Harris Corner Detector
    % img0: input image
    % thresh: threshold for corner strength in percentage
    % sigma_d: standard deviation of the derivative of Gaussian
    % sigma_i: standard deviation of the Gaussian used for smoothing the image
    % NMS_size: size of the non-maximum suppression window
    
    % Pts: a matrix of size 3xN, where N is the number of detected corners
    
    % img_smooth = ImageFilter(img0, guassian_k_i);
    
    % compute the derivatives of the image in the x and y directions
    gaussian_k_d = fspecial('gaussian', 2*ceil(3*sigma_d)+1, sigma_d);
    gaussian_derivative = gradient(gaussian_k_d);
    
    Ix = ImageFilter(img0, gaussian_derivative);
    Iy = ImageFilter(img0, gaussian_derivative');
    
    
    % gradients = sqrt(double(Ix.^2 + Iy.^2));
    k_size = 2*ceil(3*sigma_i)+1;
    gaussian_k_i = fspecial('gaussian', k_size, sigma_i);
    
    % create a gaussian mask to calculte the sum of the squares of the gradients
    
    
    
    size_x = size(img0,1);
    size_y = size(img0,2);
    
    pad_value = floor(k_size/2);
    
    Ix_padded = padarray(Ix,[pad_value, pad_value]);
    Iy_padded = padarray(Iy,[pad_value, pad_value]);
    
    % Ix2 = Ix .^ 2;
    % Iy2 = Iy .^ 2;
    % Ixy = Ix .* Iy;
    H = zeros(size_x, size_y, 2,2);
    
    for i = 1:size_x
        for j = 1:size_y 
            ix = Ix_padded(i:i+k_size-1,j:j+k_size-1);
            iy = Iy_padded(i:i+k_size-1,j:j+k_size-1);
            %disp(gaussian_k_i.* ix.*ix);
            aux1 = gaussian_k_i.* ix.*ix;
            aux2 = gaussian_k_i.* iy.*iy;
            aux3 = gaussian_k_i.* ix.*iy;
           
            %disp(size(ix))
            ix2 =  sum(aux1, "all");
            iy2 = sum(aux2, "all");
            ixy = sum(aux3, "all");
            H(i,j,:,:) = [ix2, ixy; ixy, iy2];
        end
    end
    
    c = zeros(size_x, size_y);
    
    
    dets = H(:,:,1,1) .* H(:,:,2,2) - H(:,:,2,1) .* H(:,:,1,2);
    traces = H(:,:,1,1) + H(:,:,2,2);
    c = dets - 0.1 * traces.^2;
    
    c(c< thresh/100 * max(c(:))) = 0;
    % find local maxima in a 7x7 window
    window = ones (NMS_size);
    window(ceil(NMS_size/2), ceil(NMS_size/2))= 0 ;
    c_max = ordfilt2(c, NMS_size^2-1, window);
    
    % find the coordinates of the local maxima
    
    % Pts = [x y c] where x and y are the coordinates of the corners and c is
    % the corner strength
    [rows, cols] = find(c_max < c);
    Pts = [rows, cols];
    
    
    
    end
        
                    
            
            
    