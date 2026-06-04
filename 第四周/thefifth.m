wp = [0.3*pi, 0.7*pi];  
ws = [0.1*pi, 0.9*pi];
Rp = 1;
As = 15;
Fs = 2000;
T = 1 / Fs;
Op = wp / T;
Os = ws / T;
[N, Wn] = buttord(Op, Os, Rp, As, 's');
% 设计模拟巴特沃斯滤波器
[B_s, A_s] = butter(N, Wn, 's');
% 模拟滤波器转换数字滤波器，用脉冲响应不变法
[b_z, a_z] = impinvar(B_s, A_s, Fs);
figure('Name', '脉冲响应不变法 - 带通滤波器设计', 'Position', [150, 150, 950, 450]);
% (1) 幅频特性
subplot(1, 2, 1);
[H, w] = freqz(b_z, a_z, 1024);
mag_dB = 20 * log10(abs(H));
plot(w/pi, mag_dB, 'b', 'LineWidth', 1.5); 
hold on;
ylim([-50, 5]);
title('数字带通滤波器幅频特性');
xlabel('归一化频率 (\times \pi rad/sample)');
ylabel('幅度 (dB)');
grid on;
b_z(abs(b_z) < 1e-6) = 0;
% (2) 零极点分布图
subplot(1, 2, 2);
zplane(b_z, a_z);
title('零极点分布图');
grid on;