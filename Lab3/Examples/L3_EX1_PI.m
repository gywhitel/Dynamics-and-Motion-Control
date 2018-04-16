clear all
format compact
% DC_motor_Params
Vmax = 24;          %V
Vmin = -24;         %V
Imaxcont = 0.182;   %A
Istart = 0.43;      %A
R=112;              %Ohm
L=11.40e-3;         %H    
speedconst = 137;    %rpm/V
Kemf=1/speedconst*60/2/pi; %V/rad/s
Kt = 69.7e-3;       %Nm/A
 
%Workshop M4
Jtot = 2.1441e-05;   %kgm^2
dtot = 9.6328e-06;   %Nms/rad
Tc = 0.0016;         %Nm

a = (R*dtot + Kemf*Kt)/(R*Jtot);
b = Kt/(R*Jtot);
W_DCmot_noL = tf(b, [1 a]);

Wp = W_DCmot_noL;

%rlocus(Wp);
%P = rlocfind(Wp)


%% Define where we want to place the poles -- This is the difficult part
tau_orig = 1/a;
tau = tau_orig / 10;
alpha = 1/tau
beta = alpha

% tr = tau_orig / 10;
% wn = 1.8/tr;
% ksi = 1;
% r = roots([1 2*ksi*wn wn^2]);
% alfa = -r(1)
% beta = -r(2)

%% Model polynomials
syms s s0 s1 t0;
% s0 = I;
% s1 = P;
% Wc = P + 1/s*I
Acf = [1 a];
Bcf = b;
Scf = [s1 s0];
Rcf = [1 0];
Am = [1 alpha];
A0 = [1 beta];
Tcf = A0 .* t0;

%% Generate and solve the Diophantine eq
Ap = poly2sym(Acf,s);
Bp = poly2sym(Bcf,s);
Sp = poly2sym(Scf,s);
Rp = poly2sym(Rcf,s);
ARBS = coeffs(Ap*Rp+Bp*Sp,s, 'All');
ARBS = ARBS./ARBS(1);
% Adesired = PolyMul(Am, A0);
Adesired = poly2sym(Am,s) * poly2sym(A0,s);

sol = solve(ARBS == Adesired, [s0 s1]);
s0 = double(sol.s0);
s1 = double(sol.s1);
%%
% eqn = [a + b*s1 == alfa + beta ...
%        b*s0 == alfa*beta];
% sol = solve(eqn, [s0 s1]);
% 
% s0 = double(sol.s0)
% s1 = double(sol.s1)
%% Closed loop transfer function, bode plotting 
Scf = double(subs(Scf));
Rcf = double(subs(Rcf));
Wc = tf(Scf,Rcf)

Wcl_error = feedback(Wp*Wc,1);


Wff = tf(A0,Rcf);
Wcl_output = minreal(Wff*feedback(Wp, Wc));
[ycl,~] = step(Wcl_output);
t0 = 1/ycl(end)
Tcf = double(subs(Tcf));
Wff = tf(Tcf,Rcf);
Wcl_output = minreal(Wff*feedback(Wp, Wc))

%Wcl = feedback(Wc*Wp,1)
%Wcl = tf([b*s1 b*s0],[1 a+b*s1 a+s0])

sr = 3;
sc = 4;
subplot(sr,sc,1)
step(Wp)
legend("Wp")
subplot(sr,sc,[5 9])
step(Wcl_error, Wcl_output)
legend("Error feedback", "Output feedback")

subplot(sr,sc, 6)
pzmap(Wcl_error)
legend("Wcl with error feedback")
pzxlim = xlim;
pzylim = ylim;
subplot(sr,sc, 2)
pzmap(Wp)
legend("Wp")
xlim(pzxlim)
ylim(pzylim)
subplot(sr,sc, 10)
pzmap(Wcl_output)
legend("Wcl with output feedback")
xlim(pzxlim)
ylim(pzylim)

%% Check noise and disturbance rejection (Robustness)
Te = tf(double(PolyMul(Bcf,Scf)),double(Adesired)); %Te = BS/(AR+BS) = BS/Adesired
Se = tf(1,1)-Te;
NoiseGain50Hz = mag2db(evalfr(Te, 2*pi*50));
disp(['Noise to output gain at 50Hz' string(NoiseGain50Hz) ' dB']) 

subplot(sr,sc, [3 7 11])
bode(Wp, Wcl_error, Wcl_output)
legend("Wp", "Wcl with error feedback","Wcl with error feedback")
subplot(sr,sc, [4 8 12])
bode(Wcl_output, Te, Se)
legend("Wyr", "Wyn", "Wyv")
%format loose