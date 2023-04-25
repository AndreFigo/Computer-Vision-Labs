function f = fminGold(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error

x_reproj = (P(1,:) * XYZ) ./ (P(3,:) * XYZ);
y_reproj = (P(2,:) * XYZ) ./ (P(3,:) * XYZ);


% xy_projected = [x_reproj; y_reproj; ones(1,size(x_reproj,2))];

% disp(size(xy_projected));
% disp(size(xy));

err_mat = [x_reproj - xy(1,:); y_reproj - xy(2,:)];
for i=1:size(xy,2)
    norms(i) = norm(err_mat(:,i));
end

error = mean(norms);

%compute cost function value
% f = sum(sqrt(sum((xy-xy_projected).^2,1)).^2);

f= error;

end