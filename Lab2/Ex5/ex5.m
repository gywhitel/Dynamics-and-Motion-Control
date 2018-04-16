%Constant
dr = 3.8e-6;%dm
Jr = 0.746;
Jl = 1.8e-5;
Jg = 0%not found
Kt = 69.7e-3;
L = 0;
R = 112;
n = 5;
Ke = Kt / 9.55% to be derived by Kt
J = (n*n * Jr + Jl) / n;
Kf = 0.05
df = 0.0001
dl = 0

%% State Space Model - Flexible shaft

% [Fei1, Fei2, Omega1, Omega2]
A = [0,0,1,0;
     0,0,0,1;
     Kf/Jl,-Kf/Jl,-((n*n*dr+dr+df)/n*J+n*Ke/R),df/n*J;
     Kf/Jl,-Kf/Jl,df/Jl,-(df+dl)/Jl];

B = [0;
     0;
     1/R;
     0];

%  y = [Omega_r, Omega_L2]
 
C = [0,0,n,0;
     0,0,0,1]

D = [0;
     0]

M = ss(A,B,C,D)
% Angular velocity of rotor,
% Angular velocity of 2nd load

%% Poles and zeros
M_pz = zpk(M)

figure(1)

subplot(2,2,1)
pzmap(M_pz(1));grid on

subplot(2,2,2)
pzmap(M_pz(2));grid on

%% Step response
t = 0:0.02:2;

subplot(2,2,3)
SR1 = step(M_pz(1),t);grid on
xlabel('t/s'),title('Step response rotors velocity')

subplot(2,2,4)
SR2 = step(M_pz(2),t);grid on
xlabel('t/s'),title('Step response of 2nd loads velocity')

%% Frequency response
figure(2)

subplot(1,2,1)
bode(M_pz(1));grid on,title('Bode diagram of rotor')

subplot(1,2,2)
bode(M_pz(2));grid on,title('Bode diagram of 2nd load')



