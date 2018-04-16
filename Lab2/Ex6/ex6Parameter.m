%% Parameters of Hydraulic system

Ps = 20e6;
Fe = 0;
Xv = 1e-2;
r = 2.5e-2;
A1 = pi*r*r;
A2 = A1 - pi*1e-4;
A = (A1 + A2) / 2;
Stroke = 0.7;
V = Stroke * A;
Bulk = 2e9;
Cf = V / Bulk;
Rv = 1e-4;
df = 200;
M = 100;


%% Solve the equilibrium values

% Looks the same with Simscape
%??? -------------Positive/negative velocity----------???

Veq1 = -(Rv*Xv*((8*Ps*A^4 - 8*Fe*A^3 + Rv^2*Xv^2*df^2)^(1/2) + Rv*Xv*df))/(4*A^3);
Veq2 = (Rv*Xv*((8*Ps*A^4 - 8*Fe*A^3 + Rv^2*Xv^2*df^2)^(1/2) - Rv*Xv*df))/(4*A^3);

Veq = select(Veq1, Veq2)

P1eq = Ps - (A*Veq/Rv/Xv)^2
P2eq = (A*Veq/Rv/Xv)^2


%% State space model of Linearized model

a = [-df/M, A/M, -A/M;
     -A/Cf, -Rv*Xv/2/Cf/sqrt(Ps-P1eq),0;
     A/Cf, 0, -Rv*Xv/2/Cf/sqrt(P2eq)];
 
b = [-1/M; 0; 0];

% y = [V, P1, P2]
c = [1,0,0;
     0,1,0;
     0,0,1];

d = [0;0;0];

