% zestaw b
%% Zapisanie uk�adu w przestrzeni stanu
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
title('Odpowied� uk�adu otwartego na wymuszenie skokowe')
figure(2)
pzmap(sys)
xlabel('O� rzeczywista');ylabel('O� urojona');
title('Mapa zer i biegun�w uk�adu otwartego')
%% sterowalno�c i obserwowalno�� uk�adu 
rank(A)
S=ctrb(sys)
ster=rank(S)
O=obsv(A,C)
obser=rank(O)
%% regulator od stanu// przesuwanie biegun�w
%p=[-0.2+2.5i -0.2-2.5i -2]
%p=[-0.5+1i -0.5-1i -2]
%p=[-0.2+1i -0.2-1i -2]
%p=[-0.5+3.5i -0.5-3.5i -2]
p=[-0.5+2.5i -0.5-2.5i -2 ]; %wektor po�z�danych biegun�w, tyle ile jest w uk�adzie
K=place(A,B,p); % macierz wzmocnie� albo polecenie acker dla siso place dla mimo
Ac=A-(B*K); %nowa macierz A uk�adu z regulatorem
%Cc=C-D*K
sys_c1=ss(Ac,B,C,D) %uk�ad w przestrzeni stanu z regulatorem
figure(3)
step(sys_c1)
xlabel('Czas [s]');ylabel('Amplituda');
title('Odpowied� uk�adu zamkni�tego na wymuszenie skokowe')
figure(4)
pzmap(sys_c1)
xlabel('O� rzeczywista');ylabel('O� urojona');
title('Mapa zer i biegun�w uk�adu zamkni�tego');
% N prekompensator, filtr
%% Wyznaczenie macierzy wzmocnie� N
h1=[A B; C D];
h2=[0;0;0;1] % pod wymiar h1
h1_1=inv(h1)
Npom=h1_1*h2 %%3.27 instrukcja
Nx=Npom(1:3,1);%rozmiar wekotra stanu uk�adu
Nu=Npom(4,1);%rozmiar wekotra wej��
N=K*Nx+Nu;%zgodnie z 3.29 instrukcja
sys_c2=ss(Ac,B*N,C,D);
figure(5)
step(sys_c2,'r');
xlabel('Czas [s]');ylabel('Amplituda');
title('Odpowied� uk�adu zamkni�tego z kompensacj� uchybu na wymuszenie skokowe')
figure(6)
pzmap(sys_c2,'r');
xlabel('O� rzeczywista');ylabel('O� urojona');
title('Mapa zer i biegun�w uk�adu zamkni�tego z kompensacj� uchybu')
%% wyznaczenie macierzy wzmocnie� regulatora stanu K oraz
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
%% Uk�ad z regulatorem od stanu K i ca�kuj�cym Ki oraz....
Az3=[ A-B*KK -B*Ki;
    -(C-D*KK) D*Ki];%%3.37
Bz3=[B*N;1-D*N];
Az33=A1-(B1*K1)
sys_c3=ss(Az33,Bz3,-Cpom,D)
figure(7)
step(sys_c3,'r');
xlabel('Czas [s]');ylabel('Amplituda');
title('Odpowied� uk�adu zamkni�tego z regulatorem ca�kuj�cym i kompensacj� uchybu na wymuszenie skokowe')
figure(8)
pzmap(sys_c3,'r');
xlabel('O� rzeczywista');ylabel('O� urojona');
title('Mapa zer i biegun�w uk�adu zamkni�tego z regulatorem ca�kuj�cym i kompensacj� uchybu')
%% Zapas modu�u i fazy
[Gm,Pm] = margin(sys) %uk�ad otwarty
[Gm1,Pm1] = margin(sys_c1)
[Gm2,Pm2] = margin(sys_c2)
[Gm3,Pm3] = margin(sys_c3)
figure(15)
margin(sys)
figure(16)
margin(sys_c3)
%% Warto�ci w�asne, t�umienie i cz�stotliwo�ci w�asne
[wn,z,P]=damp(sys)
[wn1, z1,P1] = damp(sys_c1) 
[wn2, z2,P2] = damp(sys_c2)
[wn3, z3,P3] = damp(sys_c3)
%%
figure(9)
pzmap(sys,sys_c1,sys_c2,sys_c3)
xlabel('O� rzeczywista');ylabel('O� urojona');
title('Mapa zer i biegun�w')
legend('Uk�ad otwarty', 'uk�. zam. K', 'uk�. zam. K,N', 'uk�. zam. K,Ki,N')
%%
figure(10)
subplot(3,1,1)
plot(u.Time,u.Data,z.Time,z.Data,y1.Time,y1.Data,'k',y2.Time,y2.Data,'g')
xlabel('Czas [s]');ylabel('Amplituda')
title('Odpowied� uk�adu z regulatorem stanu K')
legend('warto�� zadana','zak��cenie','odpowied� bez zak��cenia','odpowied� z zak��ceniem')
subplot(3,1,2)
plot(u.Time,u.Data,z.Time,z.Data,y3.Time,y3.Data,'k',y4.Time,y4.Data,'g')
xlabel('Czas [s]');ylabel('Amplituda')
title('Odpowied� uk�adu z regulatorem stanu K i kompensatorem N')
legend('warto�� zadana','zak��cenie','odpowied� bez zak��cenia','odpowied� z zak��ceniem')
subplot(3,1,3)
plot(u.Time,u.Data,z.Time,z.Data,y5.Time,y5.Data,'k',y6.Time,y6.Data,'g')
xlabel('Czas [s]');ylabel('Amplituda')
title('Odpowied� uk�adu z regulatorem stanu K, kompensatorem N i kompensatorem ca�kuj�cym Ki')
legend('warto�� zadana','zak��cenie','odpowied� bez zak��cenia','odpowied� z zak��ceniem')