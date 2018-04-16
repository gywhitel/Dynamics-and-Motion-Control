% Run parameter script
parameter


% 
%% P control

P = 0.1

% After test the model with/without(simplified) control, simulate the
% complexer model in simulink

% -------------------Simplify the _motor model to 1st-order(neglect L, Coulomb friction)

G = tf(Kt,[J*R, Ke*Kt + R*dm])

figure(1)
subplot(2,2,1)
pzmap(G);grid on
title('Without control')    

%----------------Add a P-controller to control the simplified model

G_p = tf(P*Kt, [J*R, Kt*(Ke+P)+R*dm])



subplot(2,2,2)
pzmap(G_p);grid on
title('P control')

% -------------------Step response of with/without P control 

t = 0:0.2:2
subplot(2,2,3)
step(t,G);grid on
title('Step response of original system')

subplot(2,2,4);
step(t,G_p);grid on
title('Step response of P control')
%}
%{
subplot(2,2,3)
bode(G);grid on
title('Without control')

subplot(2,2,4)
bode(G_p);grid on
title('P Control')
%}
%% PI control

% To increase the response speed, let p = c * desired pole

c = 10;

Kp = (2*c-1)*(Ke*Kt+R*dm)/Kt + 2*c*P

Ki = c*c*(Ke*Kt+R*dm+P*Kt)^2 / Kt/J/R

P_design = -c*(Ke*Kt+R*dm+P*Kt)/J/R

% -----------------Error feedback control--------------------------
% 
% G_pie= zpk(-Kt, [-c*(Ke*Kt + R*dm + P*Kt)/J/R,-c*(Ke*Kt + R*dm + P*Kt)/J/R],Kt);
    G_pie = tf([Kt*Kp,Ki*Kt], [J*R, Ke*Kt+Kp*Kt+R*dm, Ki*Kt]);

% -----------------Output feedback control----------------------
% choose G_feedForward = t0 * G_pi
  %/(Ke*Kt + R*dm)

%     t0 = c* (Ke*Kt+P*Kt+R*dm)/J/R/Kt;
t0 = J*R*(Kt*Ke+R*dm+Kt*Ki)/(Kt*c*(Ke*Kt+R*dm+P*Kt))

% Kp = t0;
% Ki = t0*(Ke*Kt+Kp*Kt+R*dm)/J/R

% G_pio= zpk(-Kt, [-c*(Ke*Kt + R*dm + P*Kt)/J/R,-c*(Ke*Kt + R*dm + P*Kt)/J/R],t0)
    G_pio = tf([t0*Kt, t0*Kt*c*(Ke*Kt+R*dm+P*Kt)/J/R], [J*R, Kp*Kt+Ke*Kt+R*dm, Ki*Kt]);

    figure(2)  

    subplot(2,2,1)
    pzmap(G_pie);grid on
    title('Error feedback control')

    subplot(2,2,2)
    pzmap(G_pio);grid on
    title('Output feedback control')
% ----------------------Step response


    t = 0:0.2:4;
subplot(2,2,3)
% step(t,G_pie);
step(G_pie);
grid on
title('Step response of Error feedback control')

subplot(2,2,4)
step(G_pio);grid on
title('Step response of Output feedback control')


%}
% rlocus(G_e)