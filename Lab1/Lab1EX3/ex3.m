% Exercise 3
G1 = tf(8,[0.1,0.5,8]);
G2 = tf(1,[0.1,0.5]);
G3 = tf([0.1,0.5,8],[0.8,4]);
G = [G1,G2,G3]
for i=1:1:3
    i
    fprintf('\n')
    %Bode diagram
    bode(G(i));grid on

    %Step response
    t = 0:0.02:2;
    SR = step(G(i),t);
    plot(t,SR);grid
    xlabel('t/s'),ylabel('Reponse'),title('Response of Gi')
    

    %pole,zero plot
    G_zp(i) = zpk(G(i));
%     zero = G_zp(i).z;
%     pole = G_zp(i).p;
%     gain = G_zp(i).k;
    pzmap(G_zp(i));grid
end