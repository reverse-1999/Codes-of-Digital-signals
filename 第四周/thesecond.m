fp = 3500;
fs = 6000;
Ap = 1;
As = 40;
%切比雪夫
wp = 2 * pi * fp; % 通带角频率
ws = 2 * pi * fs; % 阻带角频率
[n,wn] = cheb1ord(wp,ws,Ap,As, 's');
[B,A] = cheby1(n,Ap,wn,'s');
figure;%原始
subplot(2,1,1);

H = freqs(B, A);
plot(abs(H), 'm', 'LineWidth', 1.5);
xlabel('频率/Hz');
ylabel('幅度/dB');
title('原始切比雪夫滤波器的幅频特性');
subplot(2,1,2);
plot(angle(H), 'm', 'LineWidth', 1.5);
xlabel('频率/Hz');
ylabel('相位/radians');
title('原始切比雪夫滤波器的相频特性');
figure;%归一化
subplot(2,1,1);
H = H / max(abs(H)); % 归一化
plot(abs(H), 'm', 'LineWidth', 1.5);
xlabel('频率/Hz');  
ylabel('幅度/dB');
title('归一化切比雪夫滤波器的幅频特性');
subplot(2,1,2);
plot(angle(H), 'm', 'LineWidth', 1.5);
xlabel('频率/Hz');
ylabel('相位/radians');
title('归一化切比雪夫滤波器的相频特性');

% [n,~] = cheb1ord(wp,ws,Ap,As, 's');
% [z,p,k] = cheby1(n,Ap,wn,'s');
% b =  k*real(poly(z));
% a = real(poly(p));
% figure;
% H = freqs(b, a);
% plot(abs(H), 'm', 'LineWidth', 1.5);
% title('切比雪夫滤波器的幅频特性');
