%Constant
dm = 3.8e-6;
Jr = 0.746;
Jl = 3.6e-5;

Kt = 69.7e-3;
L = 11.4e-3;
R = 112;
n = 5;
Ke = Kt / 9.55;
J = n*(Jr + Jl);


%% State Space Model
% the outputs are the angular velocity and position of the 2nd
% flywheel(load)
A = [-n*dm/J,Kt/J,0;
     -n*Ke/L,-R/L,0;
     1,0,0];
B = [0;
     1/L;
     0];
C = [1,0,0;
     0,0,1];
D = [0;
     0];
 
M = ss(A,B,C,D)

%Poles&zeros
Mpz = zpk(M)
omega_pz = Mpz(1)
fei_pz = Mpz(2)

for i=1:2
    subplot(1,2,i)
    pzmap(Mpz(i))
end

%% StepResponse
t = 0:0.02:2;

    SR_omega = step(omega_pz,t);

subplot(2,2,1)
    plot(t,SR_omega);grid
    xlabel('t/s'),title('Step Response of Angular Velocity')
    

    
    SR_fei = step(fei_pz,t);

subplot(2,2,2)
    plot(t,SR_fei);grid
    xlabel('t/s'),title('Step Response of Position')

    %% Frequency response

subplot(2,2,3)
    bode(omega_pz); grid on,title('Bode Diagram of Angular Velocity')
    
subplot(2,2,4)
    bode(fei_pz); grid on,title('Bode Diagram of Position')
    
