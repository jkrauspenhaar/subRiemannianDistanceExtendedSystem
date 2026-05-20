clear all;
close all;

syms z1 z2 z3 z4 u1 u2 alpha

r1 = 1;
r2 = 1;
r3 = 2;
r4 = 4;

s1 = 1;
s2 = 1;

%% original system
a = 1/(cos(z2)+1);

f_orig = u1 * [cos(0.5*(z2-z3)); 0; -2*a*sin(z2); 2*sin(0.5*(z2-z3))-2*a*sin(z2)] +...
         u2 * [0; 1; 1-2*a; 1-2*a];

h = u1 * [1; 0; -z2; -z3] + u2 * [0; 1; 0; -0.25*z2^2];

res = f_orig-h;

res_check = subs(res,[z1, z2, z3, z4, u1, u2], [alpha^r1*z1, alpha^r2*z2, alpha^r3*z3, alpha^r4*z4, alpha^s1*u1, alpha^s2*u2]);

%% res
res1 = res_check(1);
res2 = res_check(2);
res3 = res_check(3);
res4 = res_check(4);

taylor(2*sin((alpha*z2)/2 - (alpha^2*z3)/2), [z1 z2 z3 z4],[0 0 0 0],'Order', 1)