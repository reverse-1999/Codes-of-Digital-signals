clc; clear; close all;

%% ===================== (0) 参数设置 =====================
fs = 8000;              % 采样频率 (Hz)
tau1 = 0.02;            % 回声1延迟时间 (秒)
tau2 = 0.05;            % 回声2延迟时间 (秒)
alpha1 = 0.6;           % 回声1衰减系数
alpha2 = 0.3;           % 回声2衰减系数

K1 = round(tau1 * fs);  % 延迟点数1
K2 = round(tau2 * fs);  % 延迟点数2

fprintf('延迟点数: K1=%d, K2=%d\n', K1, K2);

%% ==================== (1) 读取音频 =====================
try
    [x_orig, fs_file] = audioread('guitartune.wav');
    fs = fs_file;
    fprintf('已读取 guitartune.wav，采样率 fs=%d Hz\n', fs);
catch
    fprintf('未找到 guitartune.wav，生成测试信号...\n');
    t = 0:1/fs:3;
    x_orig = 0.5*sin(2*pi*440*t') + 0.3*sin(2*pi*880*t') + 0.1*randn(length(t),1);
    x_orig = x_orig / max(abs(x_orig));
end

if size(x_orig, 2) == 2
    x_orig = mean(x_orig, 2);
end
x_orig = x_orig(:);
N = length(x_orig);
t_axis = (0:N-1)/fs;

%% =============== (1) 原始信号时域波形和频谱 ===============
figure('Name', '原始信号分析', 'Position', [100 100 1200 500]);

subplot(1, 2, 1);
plot(t_axis, x_orig, 'b', 'LineWidth', 0.5);
xlabel('时间 (秒)'); ylabel('幅度');
title('原始音频信号 - 时域波形');
grid on; xlim([0 t_axis(end)]);

subplot(1, 2, 2);
NFFT = 2^nextpow2(N);
f_axis = fs*(0:NFFT/2)/NFFT;
X_freq = fft(x_orig, NFFT);
plot(f_axis, 20*log10(abs(X_freq(1:NFFT/2+1)) + eps), 'b', 'LineWidth', 0.8);
xlabel('频率 (Hz)'); ylabel('幅度 (dB)');
title('原始音频信号 - 频谱');
grid on; xlim([0 fs/2]);

%% ========== (2) 生成混有回声的信号 ==========
x_delayed1 = [zeros(K1,1); x_orig(1:end-K1)] * alpha1;
x_delayed2 = [zeros(K2,1); x_orig(1:end-K2)] * alpha2;
y = x_orig + x_delayed1 + x_delayed2;
y = y / max(abs(y));

%% ====== (2) 混响信号时域波形和频谱 ======
figure('Name', '混响信号分析', 'Position', [100 100 1200 500]);

subplot(1, 2, 1);
plot(t_axis, y, 'r', 'LineWidth', 0.5);
xlabel('时间 (秒)'); ylabel('幅度');
title('混响音频信号 - 时域波形');
grid on; xlim([0 t_axis(end)]);

subplot(1, 2, 2);
Y_freq = fft(y, NFFT);
plot(f_axis, 20*log10(abs(Y_freq(1:NFFT/2+1)) + eps), 'r', 'LineWidth', 0.8);
xlabel('频率 (Hz)'); ylabel('幅度 (dB)');
title('混响音频信号 - 频谱');
grid on; xlim([0 fs/2]);

%% ========== (3) IIR 逆滤波消除回声（唯一方法）==========
% 时域递推：x_hat[n] = y[n] - alpha1*x_hat[n-K1] - alpha2*x_hat[n-K2]
x_hat = zeros(N, 1);
for n = 1:N
    x_hat(n) = y(n);
    if n > K1
        x_hat(n) = x_hat(n) - alpha1 * x_hat(n - K1);
    end
    if n > K2
        x_hat(n) = x_hat(n) - alpha2 * x_hat(n - K2);
    end
end
x_hat = x_hat / max(abs(x_hat));

%% ====== (3) 消除回声后时域波形和频谱 ======
figure('Name', '回声消除结果', 'Position', [100 100 1200 500]);

subplot(1, 2, 1);
plot(t_axis, x_hat, 'g', 'LineWidth', 0.5);
xlabel('时间 (秒)'); ylabel('幅度');
title('回声消除后信号 - 时域波形');
grid on; xlim([0 t_axis(end)]);

subplot(1, 2, 2);
Xhat_freq = fft(x_hat, NFFT);
plot(f_axis, 20*log10(abs(Xhat_freq(1:NFFT/2+1)) + eps), 'g', 'LineWidth', 0.8);
xlabel('频率 (Hz)'); ylabel('幅度 (dB)');
title('回声消除后信号 - 频谱');
grid on; xlim([0 fs/2]);

%% ========== 频谱对比图 ==========
figure('Name', '频谱对比', 'Position', [100 100 1200 600]);

subplot(3, 1, 1);
plot(f_axis, 20*log10(abs(X_freq(1:NFFT/2+1)) + eps), 'b', 'LineWidth', 0.8);
ylabel('幅度 (dB)'); title('原始信号频谱');
grid on; xlim([0 fs/2]);

subplot(3, 1, 2);
plot(f_axis, 20*log10(abs(Y_freq(1:NFFT/2+1)) + eps), 'r', 'LineWidth', 0.8);
ylabel('幅度 (dB)'); title('混响信号频谱');
grid on; xlim([0 fs/2]);

subplot(3, 1, 3);
plot(f_axis, 20*log10(abs(Xhat_freq(1:NFFT/2+1)) + eps), 'g', 'LineWidth', 0.8);
xlabel('频率 (Hz)'); ylabel('幅度 (dB)'); title('回声消除后频谱');
grid on; xlim([0 fs/2]);

%% ========== 输出滤波器系统函数 ==========
fprintf('\n========== 滤波器系统函数 ==========\n');
fprintf('回声叠加系统函数 H(z)：\n');
fprintf('  H(z) = 1 + %.3f·z^{-%d} + %.3f·z^{-%d}\n', alpha1, K1, alpha2, K2);
fprintf('\n回声消除逆系统函数 G(z)：\n');
fprintf('  G(z) = 1 / (1 + %.3f·z^{-%d} + %.3f·z^{-%d})\n', alpha1, K1, alpha2, K2);
fprintf('\n时域递推公式：\n');
fprintf('  x_hat[n] = y[n] - %.3f·x_hat[n-%d] - %.3f·x_hat[n-%d]\n', alpha1, K1, alpha2, K2);

%% ========== 保存音频文件 ==========
audiowrite('original.wav', x_orig, fs);
audiowrite('echo_signal.wav', y, fs);
audiowrite('echo_cancelled.wav', x_hat, fs);
fprintf('\n音频文件已保存：original.wav, echo_signal.wav, echo_cancelled.wav\n');
