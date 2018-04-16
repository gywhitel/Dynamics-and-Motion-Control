%Constant
dm = 3.8e-6;
Jr = 0.746;
Jl = 3.6e-5;
n = 5;
J = (n*n*Jr + Jl) / n;
L = 0;
R = 112;

Kt = 69.7e-3;
Ke = Kt / 9.55;%not found


%% State Space Model

% the outputs are the position and angular velocity of the 2nd 
% flywheel(load)
% [fei;omega]

% Voltage as input
A = [0, 1;
     0, -(n * Ke * Kt) / R/J - n * dm / J]

B = [0;
     Kt/ R / J]

C = [1, 0;
     0, 1]

D = [0;0];

MV = ss(A,B,C,D)

%Poles&zeros
Mpz = zpk(MV)

fei_pz = Mpz(1)
omega_pz = Mpz(2)

figure(1)
for i=1:2
    subplot(2,2,i)
    pzmap(Mpz(i))
end

% Current as Input
a = [0, 1;
     0, -dm / (Jr + Jl)]

b = [0;
     n * Kt / (Jr + Jl)]

c = [1, 0;
     0, 1]
 
d = [0;
     0]

MC = ss(a,b,c,d)

for i = 1:2
    subplot(2,2,i+2)
    pzmap(zpk(MC))
end
%% StepResponse

% Voltage as input
t = 0:0.02:2;

    SR_omega = step(omega_pz,t);
figure(2)
subplot(2,2,1)
    plot(t,SR_omega);grid
    xlabel('t/s'),title('Step Response of Angular Velocity')
    

    
    SR_fei = step(fei_pz,t);

subplot(2,2,2)
    plot(t,SR_fei);grid
    xlabel('t/s'),title('Step Response of Position')
    
% Current as input
   SRF = step(MC(1),t);
   subplot(2,2,3)
        plot(t,SRF);grid
        xlabel('t/s'),title('Step Response of Position')
    

    
    SRO = step(MC(2),t);

subplot(2,2,4)
    plot(t,SRO);grid
    xlabel('t/s'),title('Step Response of Angular Velocity')

    %% Frequency response

    %voltage as Input
subplot(2,2,1)
    bode(fei_pz); grid on,title('Bode Diagram of Position')
    
subplot(2,2,2)
    bode(omega_pz); grid on,title('Bode Diagram of Angular Velocity')
    
    
    %Current as Input
    
    subplot(2,2,3)
    bode(MC(1)); grid on,title('Bode Diagram of Position')
    
subplot(2,2,4)
    bode(MC(2)); grid on,title('Bode Diagram of Angular Velocity')
