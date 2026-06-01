% Insert your code here
clc;clear all;close all;
fp=300;fs=150;Fs=1000;
wp=2*pi*fp/Fs;ws=2*pi*fs/Fs;
Rp=1;As=20;T=2;
Omigap=2/T*tan(wp/2);Omigas=2/T*tan(ws/2);
lamdap=1;lamdas=Omigap/Omigas;  %%%低通滤波器指标。
lamdasp=lamdas/lamdap;
ksp=sqrt((10^(0.1*As)-1)/(10^(0.1*Rp)-1));
N_frac=log(ksp)/log(lamdasp);
N=ceil(N_frac)
lamdaC2=lamdas*(10^(0.1*As)-1).^(-1/2/N);
% N=1
k=0:N-1;
pk=exp(1j*pi*(0.5+(2*k+1)/2/N));
syms p p2 s z
Gp=prod(1./(p-pk));
omiga=linspace(0,lamdasp,1000);
s_value=1j*omiga;
p_value2=s_value/lamdaC2;
Hs2=subs(Gp,p,p_value2);
Hs2_dB=20*log10(abs(Hs2)/max(abs(Hs2)));
figure;
plot(omiga,Hs2_dB)
p1=p2/lamdaC2;
Qp=subs(Gp,p,p1);
p3=lamdap*Omigap/s;
Hps=subs(Qp,p2,p3);
s1=2/T*((z-1)/(z+1));
Hz=subs(Hps,s,s1);
w=linspace(0.01*pi,pi,500);
z=exp(1j*w);
% Hz1=subs(Hz,z,z1);
Hz1=eval(Hz);
Hz1_dB=20*log10(abs(Hz1)/max(abs(Hz1)));
figure;
plot(w/pi,Hz1_dB)
grid on;xlabel('角频率/\pi')
