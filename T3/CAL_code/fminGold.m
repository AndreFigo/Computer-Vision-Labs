function f = fminGold(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error
xy_projected = ones(2, size(xy,2));

for i = 1:size(XYZ,2)
    xy_projected(:,i) = P*XYZ(:,i);
end

%compute cost function value
f = sum(sqrt(sum((xy-xy_projected).^2,1)).^2);

end