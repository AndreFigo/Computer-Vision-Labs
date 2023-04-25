function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function

w = ones(1,size(xy,2));
A = zeros(2*size(xy,2),12);

for i = 1:size(xy,2) 
    A(2 * i - 1, :) = [w(i)*XYZ(:,i)', 0, 0, 0, 0, -xy(1,i)*XYZ(:,i)'];
    A(2 * i, :) = [0, 0, 0, 0, w(i)*XYZ(:,i)', -xy(2,i)*XYZ(:,i)'];
end

[U,S,V] = svd(A);

P = reshape( V(:,end), [4,3])';
end