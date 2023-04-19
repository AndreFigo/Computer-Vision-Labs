function [ K, R, C ] = decomposeEXP(P)
%decompose P into K, R and t
A = P(1:3,1:3);
b = P(1:3,end);

a1 = A(1, :);
a2 = A(2, :);
a3 = A(3, :);

b1 = b(1);
b2 = b(2);
b3 = b(3);

epsilon = 1;

rho = epsilon/norm(a3);

r3 = rho*a3;
u0 = rho^2*dot(a1, a3);
v0 = rho^2*dot(a2, a3);


cos_theta = - (dot(cross(a1,a3), cross(a2,a3)) / (norm(cross(a1,a3)) * norm(cross(a2,a3))));
%  theta always has a positive sin
sin_theta = sqrt(1 - cos_theta^2);
alpha = rho^2 * norm(cross(a1,a3)) * sin_theta;
beta = rho^2 * norm(cross(a2,a3)) * sin_theta;

r1 = cross(a2,a3)/ norm(cross(a2,a3));
r2 = cross(r3,r1);

cot_theta = cos_theta / sin_theta;

tz =  b3 / rho;
ty = (b2/rho - v0*tz) * sin_theta / beta;
tx = (b1/rho - u0*tz + alpha*cot_theta*ty)/alpha;

t = [tx ty tz]';
R = [r1; r2; r3];
K = [alpha, -alpha*cot_theta, u0;
     0, beta, v0;
     0, 0, 1];

end