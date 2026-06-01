%%%%%(1)%%%%
fp = 6000;
fs = 15000;
Ap = 1;
As = 30;
%巴特沃斯
Wp = 2 * pi * fp; % 通带角频率
Ws = 2 * pi * fs; % 阻带角频率
ksp = Ws / Wp; % 频率比
lamdasp = sqrt((10^(As / 10) - 1) / (10^(Ap / 10) - 1)); % 衰减比
N = ceil(abs(log10(lamdasp) / log10(ksp))); % 滤波器阶数
Wcp = 1/Wp * (10^(Ap / 10) - 1)^(1 / (2 * N)); % 通带截止角频率
Wcs = 1/Ws * (10^(As / 10) - 1)^(1 / (2 * N)); % 阻带截止角频率
disp(['巴特沃斯滤波器的阶数N: ', num2str(N)]);
disp(['通带截止角频率Wcp: ', num2str(Wcp)]);
disp(['阻带截止角频率Wcs: ', num2str(Wcs)]);
[B1,A1] = butter(N, Wcp, 's'); 
[B2,A2] = butter(N, Wcs, 's');
%归一化幅频特性曲线(dB),0到2pi
figure;
w = linspace(0, 2*pi, 32);
H1 = freqs(B1, A1);
H2 = freqs(B2, A2);
H1 = H1 / max(abs(H1)); % 归一化
H2 = H2 / max(abs(H2)); 
plot(20 * log10(abs(H1)), 'b', 'LineWidth', 1.5);
hold on;
plot(20 * log10(abs(H2)), 'r', 'LineWidth', 1.5);
xlabel('频率/Hz');

ylabel('幅度/dB');
title('巴特沃斯滤波器的幅频特性');
legend('通带截止频率', '阻带截止频率');

%%%%(2)%%%%
%库函数
[N0, Wn] = buttord(Wp, Ws, Ap, As, 's');
[B0, A0] = butter(N0, Wn, 's');
%归一化幅频特性曲线(dB),0到2pi
figure;
subplot(2,1,1);
H0 = freqs(B0, A0);
H0 = H0 / max(abs(H0)); % 归一化
plot(20 * log10(abs(H0)), 'g', 'LineWidth', 1.5);
xlabel('频率/Hz');
ylabel('幅度/dB');
title('库函数设计的巴特沃斯滤波器的幅频特性');
subplot(2,1,2);
%相频特性
plot(angle(H0), 'g', 'LineWidth', 1.5);
xlabel('频率/Hz');
ylabel('相位/radians');
title('库函数设计的巴特沃斯滤波器的相频特性');
figure;
%极零点分布图
zplane(B0, A0);
title('库函数设计的巴特沃斯滤波器的极零点分布图');
grid on;
%传递函数表达式
syms s;
H_s = poly2sym(B0, s) / poly2sym(A0, s);
disp('库函数设计的巴特沃斯滤波器的传递函数表达式:');
disp(H_s);
