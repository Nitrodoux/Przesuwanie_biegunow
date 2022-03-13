% zestaw b
%% Zapisanie uk³adu w przestrzeni stanu
A=[2 -4 -1;
   4 -2 -1;
   -4 0 -1];
B=[0;0;-2];
C=[0 1 0];
D=[0]
u=[0,1,0];
sys=ss(A,B,C,D);
figure(1)
step(sys)
xlabel('Czas [s]');ylabel('Amplituda');
title('OdpowiedŸ uk³adu otwartego na wymuszenie skokowe')
figure(2)
pzmap(sys)
xlabel('Oœ rzeczywista');ylabel('Oœ urojona');
title('Mapa zer i biegunów uk³adu otwartego')
%% sterowalnoœc i obserwowalnoœæ uk³adu 
rank(A)
S=ctrb(sys)
ster=rank(S)
O=obsv(A,C)
obser=rank(O)
%% regulator od stanu// przesuwanie biegunów
%p=[-0.2+2.5i -0.2-2.5i -2]
%p=[-0.5+1i -0.5-1i -2]
%p=[-0.2+1i -0.2-1i -2]
%p=[-0.5+3.5i -0.5-3.5i -2]
p=[-0.5+2.5i -0.5-2.5i -2 ]; %wektor po¿z¹danych biegunów, tyle ile jest w uk³adzie
K=place(A,B,p); % macierz wzmocnieñ albo polecenie acker dla siso place dla mimo
Ac=A-(B*K); %nowa macierz A uk³adu z regulatorem
%Cc=C-D*K
sys_c1=ss(Ac,B,C,D) %uk³ad w przestrzeni stanu z regulatorem
figure(3)
step(sys_c1)
xlabel('Czas [s]');ylabel('Amplituda');
title('OdpowiedŸ uk³adu zamkniêtego na wymuszenie skokowe')
figure(4)
pzmap(sys_c1)
xlabel('Oœ rzeczywista');ylabel('Oœ urojona');
title('Mapa zer i biegunów uk³adu zamkniêtego');
% N prekompensator, filtr
%% Wyznaczenie macierzy wzmocnieñ N
h1=[A B; C D];
h2=[0;0;0;1] % pod wymiar h1
h1_1=inv(h1)
Npom=h1_1*h2 %%3.27 instrukcja
Nx=Npom(1:3,1);%rozmiar wekotra stanu uk³adu
Nu=Npom(4,1);%rozmiar wekotra wejœæ
N=K*Nx+Nu;%zgodnie z 3.29 instrukcja
sys_c2=ss(Ac,B*N,C,D);
figure(5)
step(sys_c2,'r');
xlabel('Czas [s]');ylabel('Amplituda');
title('OdpowiedŸ uk³adu zamkniêtego z kompensacj¹ uchybu na wymuszenie skokowe')
figure(6)
pzmap(sys_c2,'r');
xlabel('Oœ rzeczywista');ylabel('Oœ urojona');
title('Mapa zer i biegunów uk³adu zamkniêtego z kompensacj¹ uchybu')
%% wyznaczenie macierzy wzmocnieñ regulatora stanu K oraz
Apom=A;
Apom(:,4)=0;
Cpom=-C;
Cpom(1,4)=0;
A1=[Apom;Cpom]; %% 3.37 instrukcja
B1=[B;-D];
p1=[-0.5+2.5i -0.5-2.5i -2 -3];
K1=acker(A1,B1,p1)
Ki=K1(1,4)
KK=K1(1,1:3)
%% Uk³ad z regulatorem od stanu K i ca³kuj¹cym Ki oraz....
Az3=[ A-B*KK -B*Ki;
    -(C-D*KK) D*Ki];%%3.37
Bz3=[B*N;1-D*N];
Az33=A1-(B1*K1)
sys_c3=ss(Az33,Bz3,-Cpom,D)
figure(7)
step(sys_c3,'r');
xlabel('Czas [s]');ylabel('Amplituda');
title('OdpowiedŸ uk³adu zamkniêtego z regulatorem ca³kuj¹cym i kompensacj¹ uchybu na wymuszenie skokowe')
figure(8)
pzmap(sys_c3,'r');
xlabel('Oœ rzeczywista');ylabel('Oœ urojona');
title('Mapa zer i biegunów uk³adu zamkniêtego z regulatorem ca³kuj¹cym i kompensacj¹ uchybu')
%% Zapas modu³u i fazy
[Gm,Pm] = margin(sys) %uk³ad otwarty
[Gm1,Pm1] = margin(sys_c1)
[Gm2,Pm2] = margin(sys_c2)
[Gm3,Pm3] = margin(sys_c3)
figure(15)
margin(sys)
figure(16)
margin(sys_c3)
%% Wartoœci w³asne, t³umienie i czêstotliwoœci w³asne
[wn,z,P]=damp(sys)
[wn1, z1,P1] = damp(sys_c1) 
[wn2, z2,P2] = damp(sys_c2)
[wn3, z3,P3] = damp(sys_c3)
%%
figure(9)
pzmap(sys,sys_c1,sys_c2,sys_c3)
xlabel('Oœ rzeczywista');ylabel('Oœ urojona');
title('Mapa zer i biegunów')
legend('Uk³ad otwarty', 'uk³. zam. K', 'uk³. zam. K,N', 'uk³. zam. K,Ki,N')
%%
figure(10)
subplot(3,1,1)
plot(u.Time,u.Data,z.Time,z.Data,y1.Time,y1.Data,'k',y2.Time,y2.Data,'g')
xlabel('Czas [s]');ylabel('Amplituda')
title('OdpowiedŸ uk³adu z regulatorem stanu K')
legend('wartoœæ zadana','zak³ócenie','odpowiedŸ bez zak³ócenia','odpowiedŸ z zak³óceniem')
subplot(3,1,2)
plot(u.Time,u.Data,z.Time,z.Data,y3.Time,y3.Data,'k',y4.Time,y4.Data,'g')
xlabel('Czas [s]');ylabel('Amplituda')
title('OdpowiedŸ uk³adu z regulatorem stanu K i kompensatorem N')
legend('wartoœæ zadana','zak³ócenie','odpowiedŸ bez zak³ócenia','odpowiedŸ z zak³óceniem')
subplot(3,1,3)
plot(u.Time,u.Data,z.Time,z.Data,y5.Time,y5.Data,'k',y6.Time,y6.Data,'g')
xlabel('Czas [s]');ylabel('Amplituda')
title('OdpowiedŸ uk³adu z regulatorem stanu K, kompensatorem N i kompensatorem ca³kuj¹cym Ki')
legend('wartoœæ zadana','zak³ócenie','odpowiedŸ bez zak³ócenia','odpowiedŸ z zak³óceniem')