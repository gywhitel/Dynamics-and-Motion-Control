    %Lab 1  Exercise 2

%%Speed as the output
num = [1,0];
den = [0.1,0.5,8];

G_v = tf(num,den)

%%%Bode diagram
bode(G_v);grid

%%%Step response
t = 0:0.02:2;
SR = step(G_v);
plot(SR);grid
xlabel('t/s'), title('Step Response')

%%% Pole, zero plot
pzmap(zpk(G_v));grid

%% postion as output
num_p = [1];
G_p = tf(num_p,den)

%%%Bode diagram
bode(G_v);grid

%%%Step response
t = 0:0.02:2;
SR = step(G_p);
plot(SR);grid
xlabel('t/s'), title('Step Response')

%%% Pole, zero plot
pzmap(zpk(G_p));grid
G = zpk(G_p)

% Gss = ss(G_v)
% gain = G.k