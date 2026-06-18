clc; clear; close all;


[filename, pathname] = uigetfile('*.wma', '请选择音频文件');
if isequal(filename, 0)
    disp('用户取消选择');
    return;
end

[audio, fs] = audioread(fullfile(pathname, filename));

% 转为单声道处理
if size(audio, 2) == 2
    audio = audio(:, 1);
end

% 截取20秒片段（从第30秒开始）
time_pro  = 20;
time_shift = 30;
audio = audio(time_shift*fs+1 : (time_shift+time_pro)*fs, 1);

N = length(audio);           % 采样点数
t = (0:N-1) / fs;            % 时间轴
fprintf('采样频率: %d Hz\n', fs);
fprintf('采样点数: %d\n', N);


X = fft(audio);              % 快速傅里叶变换
f_axis = (0:N-1) * (fs/N);   % 频率轴
mag_X = abs(X);              % 幅度谱
half = floor(N/2);           % 单边谱截断点

figure;
subplot(2,1,1);
plot(t, audio, 'b');
title('原始语音信号时域波形');
xlabel('时间 (s)'); ylabel('幅度');
xlim([0 0.1]);              

subplot(2,1,2);
plot(f_axis(1:half), mag_X(1:half), 'b');
title('原始语音信号幅频特性');
xlabel('频率'); ylabel('幅度');
xlim([0 5000]);

% -------------------- (1) 低通滤波器 --------------------
fp_lp = 500;  fst_lp = 800;  Ap_lp = 1;  As_lp = 20;

% --- IIR 椭圆滤波器 ---
wp_lp = fp_lp / (fs/2);
ws_lp = fst_lp / (fs/2);
[n_iir_lp, Wn_iir_lp] = ellipord(wp_lp, ws_lp, Ap_lp, As_lp);
[b_iir_lp, a_iir_lp] = ellip(n_iir_lp, Ap_lp, As_lp, Wn_iir_lp, 'low');

% --- FIR Kaiser窗滤波器 ---
dev_p_lp = 10^(Ap_lp/20) - 1;        % 通带偏差
dev_s_lp = 10^(-As_lp/20);           % 阻带偏差
[n_fir_lp, Wn_fir_lp, beta_lp] = kaiserord( ...
    [fp_lp, fst_lp], [1 0], [dev_p_lp, dev_s_lp], fs);
b_fir_lp = fir1(n_fir_lp, Wn_fir_lp, 'low', ...
    kaiser(n_fir_lp+1, beta_lp), 'noscale');

% 滤波
y_fir_lp = filter(b_fir_lp, 1, audio);
y_iir_lp = filter(b_iir_lp, a_iir_lp, audio);
Y_fir_lp = abs(fft(y_fir_lp));
Y_iir_lp = abs(fft(y_iir_lp));

% 低通 — 时域+频域对比（figure 1）
figure;
subplot(2,1,1);
plot(t, audio, 'b'); hold on;
plot(t, y_fir_lp, 'g');
plot(t, y_iir_lp, 'r');
title('低通滤波 — 时域波形对比');
xlabel('时间 (s)'); ylabel('幅度');
legend('原始信号', 'FIR滤波', 'IIR滤波'); xlim([0 0.1]);

subplot(2,1,2);
plot(f_axis(1:half), mag_X(1:half), 'b'); hold on;
plot(f_axis(1:half), Y_fir_lp(1:half), 'g');
plot(f_axis(1:half), Y_iir_lp(1:half), 'r');
title('低通滤波 — 频谱对比');
xlabel('频率'); ylabel('幅度');
legend('原始信号', 'FIR滤波', 'IIR滤波'); xlim([0 2000]);

% 低通 — 滤波器频率响应（figure 2）
figure;
[H_iir_lp, w_lp] = freqz(b_iir_lp, a_iir_lp, 1024, fs);
[H_fir_lp, ~]    = freqz(b_fir_lp, 1, 1024, fs);
subplot(2,1,1);
plot(w_lp, 20*log10(abs(H_iir_lp)), 'r');
title('IIR椭圆低通滤波器频率响应');
xlabel('频率'); ylabel('幅度'); ylim([-80 5]); grid on;
subplot(2,1,2);
plot(w_lp, 20*log10(abs(H_fir_lp)), 'g');
title('FIR Kaiser低通滤波器频率响应');
xlabel('频率'); ylabel('幅度'); ylim([-80 5]); grid on;

% -------------------- (2) 高通滤波器 --------------------
fst_hp = 1200;  fp_hp = 2000;  Ap_hp = 1;  As_hp = 20;

% --- IIR ---
wp_hp = fp_hp / (fs/2);
ws_hp = fst_hp / (fs/2);
[n_iir_hp, Wn_iir_hp] = ellipord(wp_hp, ws_hp, Ap_hp, As_hp);
[b_iir_hp, a_iir_hp] = ellip(n_iir_hp, Ap_hp, As_hp, Wn_iir_hp, 'high');

% --- FIR ---
dev_p_hp = 10^(Ap_hp/20) - 1;
dev_s_hp = 10^(-As_hp/20);
[n_fir_hp, Wn_fir_hp, beta_hp] = kaiserord( ...
    [fst_hp, fp_hp], [0 1], [dev_s_hp, dev_p_hp], fs);
if mod(n_fir_hp, 2) == 1       % 高通需要偶数阶
    n_fir_hp = n_fir_hp + 1;
end
b_fir_hp = fir1(n_fir_hp, Wn_fir_hp, 'high', ...
    kaiser(n_fir_hp+1, beta_hp), 'noscale');

% 滤波
y_fir_hp = filter(b_fir_hp, 1, audio);
y_iir_hp = filter(b_iir_hp, a_iir_hp, audio);
Y_fir_hp = abs(fft(y_fir_hp));
Y_iir_hp = abs(fft(y_iir_hp));

% 高通 — 时域+频域对比
figure;
subplot(2,1,1);
plot(t, audio, 'b'); hold on;
plot(t, y_fir_hp, 'g');
plot(t, y_iir_hp, 'r');
title('高通滤波 — 时域波形对比');
xlabel('时间 (s)'); ylabel('幅度');
legend('原始信号', 'FIR滤波', 'IIR滤波'); xlim([0 0.1]);
subplot(2,1,2);
plot(f_axis(1:half), mag_X(1:half), 'b'); hold on;
plot(f_axis(1:half), Y_fir_hp(1:half), 'g');
plot(f_axis(1:half), Y_iir_hp(1:half), 'r');
title('高通滤波 — 频谱对比');
xlabel('频率'); ylabel('幅度');
legend('原始信号', 'FIR滤波', 'IIR滤波'); xlim([0 4000]);

% 高通 — 滤波器频率响应
figure;
[H_iir_hp, w_hp] = freqz(b_iir_hp, a_iir_hp, 1024, fs);
[H_fir_hp, ~]    = freqz(b_fir_hp, 1, 1024, fs);
subplot(2,1,1);
plot(w_hp, 20*log10(abs(H_iir_hp)), 'r');
title('IIR椭圆高通滤波器频率响应');
xlabel('频率'); ylabel('幅度'); ylim([-80 5]); grid on;
subplot(2,1,2);
plot(w_hp, 20*log10(abs(H_fir_hp)), 'g');
title('FIR Kaiser高通滤波器频率响应');
xlabel('频率'); ylabel('幅度'); ylim([-80 5]); grid on;

% -------------------- (3) 带通滤波器 --------------------
fsl_bp = 1000;  fpl_bp = 1200;  fpu_bp = 3000;  fsu_bp = 3200;
Ap_bp = 1;  As_bp = 15;

% --- IIR ---
wp_bp = [fpl_bp, fpu_bp] / (fs/2);
ws_bp = [fsl_bp, fsu_bp] / (fs/2);
[n_iir_bp, Wn_iir_bp] = ellipord(wp_bp, ws_bp, Ap_bp, As_bp);
[b_iir_bp, a_iir_bp] = ellip(n_iir_bp, Ap_bp, As_bp, Wn_iir_bp, 'bandpass');

% --- FIR ---
dev_p_bp = 10^(Ap_bp/20) - 1;
dev_s_bp = 10^(-As_bp/20);
[n_fir_bp, Wn_fir_bp, beta_bp] = kaiserord( ...
    [fsl_bp, fpl_bp, fpu_bp, fsu_bp], [0 1 0], ...
    [dev_s_bp, dev_p_bp, dev_s_bp], fs);
b_fir_bp = fir1(n_fir_bp, Wn_fir_bp, 'bandpass', ...
    kaiser(n_fir_bp+1, beta_bp), 'noscale');

% 滤波
y_fir_bp = filter(b_fir_bp, 1, audio);
y_iir_bp = filter(b_iir_bp, a_iir_bp, audio);
Y_fir_bp = abs(fft(y_fir_bp));
Y_iir_bp = abs(fft(y_iir_bp));

% 带通 — 时域+频域对比
figure;
subplot(2,1,1);
plot(t, audio, 'b'); hold on;
plot(t, y_fir_bp, 'g');
plot(t, y_iir_bp, 'r');
title('带通滤波 — 时域波形对比');
xlabel('时间 (s)'); ylabel('幅度');
legend('原始信号', 'FIR滤波', 'IIR滤波'); xlim([0 0.1]);
subplot(2,1,2);
plot(f_axis(1:half), mag_X(1:half), 'b'); hold on;
plot(f_axis(1:half), Y_fir_bp(1:half), 'g');
plot(f_axis(1:half), Y_iir_bp(1:half), 'r');
title('带通滤波 — 频谱对比');
xlabel('频率'); ylabel('幅度');
legend('原始信号', 'FIR滤波', 'IIR滤波'); xlim([0 4000]);

% 带通 — 滤波器频率响应
figure;
[H_iir_bp, w_bp] = freqz(b_iir_bp, a_iir_bp, 1024, fs);
[H_fir_bp, ~]    = freqz(b_fir_bp, 1, 1024, fs);
subplot(2,1,1);
plot(w_bp, 20*log10(abs(H_iir_bp)), 'r');
title('IIR椭圆带通滤波器频率响应');
xlabel('频率'); ylabel('幅度'); ylim([-80 5]); grid on;
subplot(2,1,2);
plot(w_bp, 20*log10(abs(H_fir_bp)), 'g');
title('FIR Kaiser带通滤波器频率响应');
xlabel('频率'); ylabel('幅度'); ylim([-80 5]); grid on;

%变声处理
disp('===== 变声处理 =====');
disp('提示：男声基频 80-400Hz，女声 150-1100Hz，童声 250-1300Hz');
disp('变声方法：STFT + imresize时间轴缩放 + ISTFT + resample恢复时长');

% 选择原始音频类型
fprintf('\n请选择原始音频的类型：\n');
fprintf('  1 - 男声（默认）\n');
fprintf('  2 - 女声\n');
fprintf('  3 - 童声\n');
choice = input('输入选择 (1/2/3): ');

switch choice
    case 2
        original_type = 'female';
        fprintf('原始音频类型：女声\n');
    case 3
        original_type = 'child';
        fprintf('原始音频类型：童声\n');
    otherwise
        original_type = 'male';
        fprintf('原始音频类型：男声\n');
end

audio_norm = audio / max(abs(audio));

% 根据原始类型进行变声
switch original_type
    case 'male'
        female_voice = vc_imresize(audio_norm, fs, 1.8,   '男声→女声');
        child_voice  = vc_imresize(audio_norm, fs, 2.2,   '男声→童声');
        male_voice   = audio_norm;
    case 'female'
        male_voice   = vc_imresize(audio_norm, fs, 0.55,  '女声→男声');
        child_voice  = vc_imresize(audio_norm, fs, 2.2/1.8, '女声→童声');
        female_voice = audio_norm;
    case 'child'
        male_voice   = vc_imresize(audio_norm, fs, 0.45,  '童声→男声');
        female_voice = vc_imresize(audio_norm, fs, 0.8,   '童声→女声');
        child_voice  = audio_norm;
end

% ===== 保存 =====
audiowrite('male_voice.wav',   male_voice,   fs);
audiowrite('female_voice.wav', female_voice, fs);
audiowrite('child_voice.wav',  child_voice,  fs);
fprintf('\n已保存:\n  male_voice.wav\n  female_voice.wav\n  child_voice.wav\n');

% ===== 绘图（时域+频谱+语谱图） =====
figure;

Nm=length(male_voice);   Nf=length(female_voice);   Nc=length(child_voice);

% 时域
subplot(3,3,1); plot((0:Nm-1)/fs, male_voice,'b'); title('男声—时域'); xlim([0 .05]); grid on;
subplot(3,3,4); plot((0:Nf-1)/fs, female_voice,'r'); title('女声—时域'); xlim([0 .05]); grid on;
subplot(3,3,7); plot((0:Nc-1)/fs, child_voice,'g');  title('童声—时域'); xlim([0 .05]); grid on;

% 频谱
Fm=abs(fft(male_voice));   Ff=abs(fft(female_voice));   Fc=abs(fft(child_voice));
fm=(0:floor(Nm/2))*(fs/Nm);  ff=(0:floor(Nf/2))*(fs/Nf);  fc=(0:floor(Nc/2))*(fs/Nc);
subplot(3,3,2); plot(fm(1:min(end,3000*Nm/fs)),Fm(1:min(end,3000*Nm/fs)),'b'); title('男声—频谱'); xlim([0 3000]); grid on;
subplot(3,3,5); plot(ff(1:min(end,3000*Nf/fs)),Ff(1:min(end,3000*Nf/fs)),'r'); title('女声—频谱'); xlim([0 3000]); grid on;
subplot(3,3,8); plot(fc(1:min(end,3000*Nc/fs)),Fc(1:min(end,3000*Nc/fs)),'g'); title('童声—频谱'); xlim([0 3000]); grid on;

% ===== 播放菜单 =====
fprintf('\n[1]男声 [2]女声 [3]童声 [4]全部 [0]退出\n');
play_choice = input('选择播放: ');
while ~isempty(play_choice) && play_choice ~= 0
    switch play_choice
        case 1, soundsc(male_voice,fs); pause(length(male_voice)/fs+.5);
        case 2, soundsc(female_voice,fs); pause(length(female_voice)/fs+.5);
        case 3, soundsc(child_voice,fs); pause(length(child_voice)/fs+.5);
        case 4
            soundsc(male_voice,fs); pause(length(male_voice)/fs+1);
            soundsc(female_voice,fs); pause(length(female_voice)/fs+1);
            soundsc(child_voice,fs); pause(length(child_voice)/fs+1);
    end
    play_choice = input('继续播放(0/1/2/3/4): ');
end
disp('===== 变声处理完成 =====');

%% ============ 变声核心函数（imresize方案） ============
function y = vc_imresize(x, fs, scale, label)
    N = length(x);
    wlen = 1024;  hop = wlen/4;  nfft = wlen;
    win  = hanning(wlen);
    
    % STFT
    [S,~,~] = spectrogram(x, win, wlen-hop, nfft, fs);
    [nf, nt] = size(S);
    
    % 对复频谱沿时间轴 imresize
    new_nt = max(round(nt / scale), 1);
    S_real = imresize(real(S), [nf, new_nt], 'bilinear');
    S_imag = imresize(imag(S), [nf, new_nt], 'bilinear');
    S_resized = S_real + 1i * S_imag;
    
    % ISTFT 重构
    y_tmp = istft_simple(S_resized, win, hop, nfft);
    
    % ===== 修复：用 interp1 替代 resample =====
    t_old = linspace(0, 1, length(y_tmp))';
    t_new = linspace(0, 1, N)';
    y = interp1(t_old, y_tmp, t_new, 'linear', 0)';
    y = y(:) / max(abs(y(:)));
    
    fprintf('  %s: scale=%.2f, 输出长度=%d\n', label, scale, length(y));
end


%% ============ ISTFT 辅助函数 ============
function y = istft_simple(S, win, hop, nfft)
    win = win(:);
    nh = round(hop);
    nf = size(S,2);
    ylen = (nf-1)*nh + nfft;
    y = zeros(ylen,1);
    wsum = zeros(ylen,1);
    for k = 1:nf
        idx = (k-1)*nh + (1:nfft);
        frame = real(ifft(S(:,k), nfft));
        y(idx) = y(idx) + frame .* win;
        wsum(idx) = wsum(idx) + win.^2;
    end
    wsum(wsum < 1e-10) = 1;
    y = y ./ wsum;
end
