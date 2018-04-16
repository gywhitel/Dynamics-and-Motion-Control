%% Continuous time Position control(U -> Position)
parameter;

% Plant model
Gp = tf(Kt,[R*J,R*dm + Ke*Kt,0])
% pzmap(Gp)

% Desired poles(PID)
p1 = -10
p2 = -10
p3 = 
p4 = 

syms s
Am = poly2sym([1,-p1-p2,p1*p2],s);
A0 = poly2sym([1,-p3-p4,p3*p4],s);

% Closed-loop characteristic polynomial
syms P I D %propotional coefficient
Scoef = [D, P, I];
Rcoef = [1,a,0];
B = [
Acl = cov(poly2sym([1,(R*dm+Ke*Kt)/R/J,P],s),

% Solve the dio equation
para = solve(coeffs(Am,s) == coeffs(Acl,s))
