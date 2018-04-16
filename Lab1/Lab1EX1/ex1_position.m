%mass
m = 0.1;
%damping
d = 0.5;
%transfer function
den = [m,d,0];
num = [0,0,1];
G = tf(num,den)
%G would immediately display without the;
G_ss = ss(G)

%Bode diagram
bode(G);grid on

%Step response
t = 0:0.02:2;
SR = step(G,t);
plot(t,SR);grid
xlabel('t/s'),ylabel('Response')
%there should be oscillation, but NO!

%pole,zero plot


G_zp = zpk(G);
zero = G_zp.z;
pole = G_zp.p;
gain = G_zp.k;
pzmap(G_zp);grid

