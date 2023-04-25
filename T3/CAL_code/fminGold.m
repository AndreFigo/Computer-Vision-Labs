function f = fminGold(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error

xy_reproj = (P(1:2,:) * XYZ) ./ (P(3,:) * XYZ);


f = sum(sqrt(sum((xy(1:2,:)-xy_reproj).^2,1)));

end