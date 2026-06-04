fp1 =1000;
fp2 = 4500;
fs1 = 2000;
fs2 = 3500;
Ap = 1;
As = 20;
Fs = 10000;

% 归一化数字频率 (0~1 对应 0~pi)
wp = [fp1 fp2] / (Fs/2);
ws = [fs1 fs2] / (Fs/2);

% 阶数与截止频率
[N, Wn] = cheb1ord(wp, ws, Ap, As);

% 切比雪夫 I 型带阻滤波器
[b, a] = cheby1(N, Ap, Wn, 'stop');

% 频率响应
[H, w] = freqz(b, a, 1024);
f = w / (2*pi) * Fs;

% 绝对幅频特性
figure;
subplot(2,1,1);
plot(f, abs(H), 'LineWidth', 1.2);
grid on;
xlabel('频率/Hz');
ylabel('|H(e^{j\omega})|');
title('绝对幅频特性');

% 相对幅频特性 (dB)
H_dB = 20*log10(abs(H)/max(abs(H)));
subplot(2,1,2);
plot(f, H_dB, 'LineWidth', 1.2);
grid on;
xlabel('频率/Hz');
ylabel('幅度/dB');
title('相对幅频特性');

% 相频特性
figure;
subplot(2,1,1);
plot(f, unwrap(angle(H)), 'LineWidth', 1.2);
grid on;
xlabel('频率/Hz');
ylabel('相位/rad');
title('相频特性');

% 零极点分布
subplot(2,1,2);
zplane(b, a);
title('零极点分布图');

% 传递函数
[z, p, k] = tf2zp(b, a);
disp('系统传递函数 H(z) = B(z)/A(z)');
disp('分子系数 b =');
disp(b);
disp('分母系数 a =');
disp(a);

