function [Pts] = KeypointsDetection(Img,Pts)
    gaussian_k_d = fspecial('gaussian', 2*ceil(3*sigma_d)+1, sigma_d);
    gaussian_derivative = gradient(gaussian_k_d);
    
    Ix = ImageFilter(Img, gaussian_derivative);
    Iy = ImageFilter(Img, gaussian_derivative');
    

end
        