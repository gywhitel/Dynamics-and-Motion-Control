%% Data from Continuous time Velocity control

% Motor specifications

J = 2.37e-5;
dm = 2.96e-5;
R = 112;
L = 11.4e-3;
Kt = 69.7e-3;
sc = 137;
Ke = 1 / sc * 60 / 2 / pi;
Kp = 0.1;
Tc = 1e-3;


% PI controller

c = 10;

P = 0.1;

Kp = (2*c-1)*(Ke*Kt+R*dm)/Kt + 2*c*P;

Ki = c*c*(Ke*Kt+R*dm+P*Kt)^2 / Kt/J/R;

t0 = J*R*(Kt*Ke+R*dm+Kt*Ki)/(Kt*c*(Ke*Kt+R*dm+P*Kt));

G = tf(Kt,[J*R, Ke*Kt + R*dm]);

G_pio = tf([t0*Kt, t0*Kt*c*(Ke*Kt+R*dm+P*Kt)/J/R], [J*R, Kp*Kt+Ke*Kt+R*dm, Ki*Kt]);