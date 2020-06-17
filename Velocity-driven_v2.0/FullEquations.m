clc; clear all;

v = 10;
n = 0.44;
k = 730;
eta_inf = 0;
alpha = 1;
L = 18.87;
D = .510;
d_p = 9.62;
P_amb = 101325;

%P = (alpha/d_p^2)*((8*v*L*(3*n+1)/n)*(2^n*k*(v*alpha/D)^(n-1)+eta_inf)+P_amb*D^2);
%P = ((128*L/(pi*alpha*D^4))*(k*(8*v*alpha/D)^(n-1)+eta_inf)*((3*n+1)/(4*n))*...
%    ((v*pi*alpha*D^2)/4)+P_amb)*(alpha*D^2)/(d_p^2);
P = (8*L*alpha*v/D^2)*(((3*n+1)/n)*(k*(alpha*v/D)^(n-1)+eta_inf))+P_amb;

fprintf('Piston pressure : %0.1f kPa \n', P/1000);

