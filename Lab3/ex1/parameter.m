%Constant
%{  
---------------------Motor specification in Lab 2----------------------
dm = 3.8e-6;
Jr = 0.746e-6;
Jl = 3.6e-5;
n = 5;
J = (n*n*Jr + Jl) / n;
L = 11.4e-3;
R = 112;

Kt = 69.7e-3;
sc = 137;
Ke = 1 / sc * 60 / 2 / pi;
Tc = 1e-3
% Kemf(V/(rad/s) = 1/SpeedConstant(rpm/V) =1/ (60/2PI * SpeedConstant)
% (V/(rad/s))


% K = P;
% Ti = 
 %}

% -------------------------Real Motor specificaiton-------------------
J = 2.37e-5;
dm = 2.96e-5;
R = 112;
L = 11.4e-3;
Kt = 69.7e-3;
sc = 137;
Ke = 1 / sc * 60 / 2 / pi;
Kp = 0.1;
Tc = 1e-3;