format compact
%% Parameters
dataEx1;

% Sampling time

Ts1 = 0.02;
Ts2 = 0.002;

G_pi = G_pio;
%% Approximation

% Zero Order Hold Convertion

Gpi_zoh = c2d(G_pi,Ts1,'zoh')
subplot(2,2,1)
pzmap(Gpi_zoh);grid
title('pole of ZOH convertion, Ts1')

subplot(2,2,2)
pzmap(c2d(G_pi,Ts2,'zoh'));grid
title('pole of ZOH convertion, Ts2')

% Tustin convertion

subplot(2,2,3)
Gpi_t = c2d(G_pi, Ts1, 'tustin')
pzmap(Gpi_t);
title('pole of Tustin convertion,Ts1')

subplot(2,2,4)

Gd_pi = c2d(G_pi,Ts2,'tustin')
pzmap(Gd_pi);grid
title('pole of Tustin convertion,Ts2')
%% Discrete time design

% Desired poles in continuous time domain

[num,den] = tfdata(G_pi,'v')
Acl = poly2sym(den)
poles = pole(G_pi)
p1 = poles(1)
p2 = poles(2)

% Desired poles in discrete time domain
z1 = exp(p1*Ts2)
z2 = exp(p2*Ts2)

% ------------------------Polynomials building-------------------------
syms z
% Desired polynomials
A0 = poly2sym([1,-z1],z)
Am = poly2sym([1,-z2],z)

% design by polynomials instead of tf
Gd_p = c2d(G,Ts2,'zoh')
[b,a] = tfdata(Gd_p,'v');
B = poly2sym(b,z)
A = poly2sym(a,z)

% PI Controller
syms P I
% Gc = tf([P,I],1)
% Scft = [P,I]
S = poly2sym([P,I],z)
R = poly2sym([1,-1],z)

% Feed forward
syms t0
T = t0 * A0

% ---------------------System design-------------------------------
% Only coefficients equal, instead of polynomials

para = solve(coeffs(A*R + B*S,z) == coeffs(Am*A0,z))
% substitute nomial variable by real values

% P = double(subs(P,para.P))
% I = double(subs(para.I))
Scft = [para.P, para.I];

num = double(coeffs(A0*B,z));
den = double(coeffs(A*R + B*poly2sym(Scft,z),z));
Gd_pio0 = tf(num,den,Ts2);

[y,~] = step(Gd_pio0');

% -----------------------The Transfer function in discrete time domain------------------
Gd_pio = tf(double(y(end)*coeffs(A0*B,z)),double(coeffs(A*R + B*poly2sym(Scft,z),z)),Ts2)

pzmap(Gd_pio)

