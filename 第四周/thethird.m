fp = 300;
fs = 150;
Ap = 1;
As = 20;
Fs = 1000; % 采样频率
Rp = Ap;
%双线性变换法
wp = 2*pi*fp/Fs;
ws = 2*pi*fs/Fs;
T = 2;
Omigap = 2/T*tan(wp/2);
Omigas = 2/T*tan(ws/2);
lamdap = 1;
lamdas = Omigap/Omigas;
lamdasp = lamdas/lamdap;
ksp = sqrt((10^(0.1*As)-1)/(10^(0.1*Rp)-1));
N = ceil(log(ksp)/log(lamdasp));
lamdaC = lamdas*(10^(0.1*As)-1)^(-1/2/N);
k=0:N-1;
pk=exp(1j*pi*(0.5+(2*k+1)/2/N));
syms p s z
Gp=prod(1./(p-pk));

Hps = subs(Gp, p, lamdaC/s);


s1 = 2/T * (z-1)/(z+1);
Hz = subs(Hps, s, s1);

% 频率响应
w = linspace(0.01*pi, pi, 800);
z = exp(1j*w);
Hz1 = eval(Hz);
Hz1_dB = 20*log10(abs(Hz1)/max(abs(Hz1)));

figure;
plot(w/pi, Hz1_dB, 'LineWidth', 1.2);
grid on;
xlabel('角频率/\pi');
ylabel('幅度/dB');
title('数字高通幅频响应');

