clc; clear; close all;
[filename,pathname] = uigetfile('*.wma','选择一个音频文件');
[y,Fs] = audioread(fullfile(pathname,filename));
%单声道
if size(y,2) == 2
    y = y(:,1);
end

startTime = 65; % 起始时间（秒）
endTime = 75;   % 结束时间（秒）
startSample = round(startTime * Fs); % 起始样本
endSample = round(endTime * Fs);     % 结束样本
y = y(startSample:endSample);
t = (startTime + (0:length(y)-1)/Fs);
%播放
%sound(y,Fs);

%fft
N = length(y);
Y = fft(y);
figure;
subplot(2,1,1);
plot((0:N-1)*Fs/N,abs(Y));
xlabel('频率/Hz');
ylabel('幅值');
subplot(2,1,2);
plot((0:N-1)*Fs/N,angle(Y));
xlabel('频率/Hz');
ylabel('相位/弧度');

%设计数字滤波器
%低通设计
fp1 = 500;
fs1 = 800;
Ap1 = 1;
As1 = 20;
%IIR
wp1 = 2*pi*fp1;
ws1 = 2*pi*fs1;
ksp1 = ws1/wp1;
lamdasp1 = sqrt((10^(As1/10)-1)/(10^(Ap1/10)-1));
NIIR1 = ceil(abs(log10(lamdasp1)/log10(ksp1)));
wc1 = wp1/(10^(Ap1/10)-1)^(1/(2*NIIR1));
[A1,B1] = butter(NIIR1,wc1/(Fs/2));
%FIR
NFIR1 =  ceil((As1-8)/(2.285*(ws1-wp1)/Fs)); %阻带衰减20，采用hanning
b1 = fir1(NFIR1,wp1/(Fs/2),hanning(NFIR1+1));
%绘制滤波器频率响应、滤波前后的波形，时域一张图、频域一张图
%时域
y_lowpass_IIR = filter(A1,B1,y);
y_lowpass_FIR = filter(b1,1,y);
figure;
subplot(2,1,1);
plot(t,y,'Color','b');
hold on;
plot(t,y_lowpass_IIR,'Color','r');
plot(t,y_lowpass_FIR,'Color','g');
xlabel('时间/s');
ylabel('幅值');
legend('原始信号','IIR低通滤波后','FIR低通滤波后');
title('低通滤波器的时域响应');
%频域
Y_lowpass_IIR = fft(y_lowpass_IIR);
Y_lowpass_FIR = fft(y_lowpass_FIR);
subplot(2,1,2);
plot((0:N-1)*Fs/N,abs(Y),'Color','b');
hold on;
plot((0:N-1)*Fs/N,abs(Y_lowpass_IIR),'Color','r');
plot((0:N-1)*Fs/N,abs(Y_lowpass_FIR),'Color','g');
xlabel('频率/Hz');
ylabel('幅值');
legend('原始信号','IIR低通滤波后','FIR低通滤波后');
title('低通滤波器的频域响应');
%高通设计
fs2 = 1200;
fp2 = 2000;
Ap2 = 1;
As2 = 20;
%IIR
%FIR
%带通设计
fpl=1200;
fpu=3000;
fsl=1000;
fsu=3200;
As3=15;
Ap3=1;
%IIR
%FIR

%变声，男声的基频一般在80-400Hz，女声在150-1100Hz，童声在250-1300Hz
% 使用相位声码器(Phase Vocoder)实现变调不变速

y_voice = double(y(:));
origLen = length(y_voice);

% 选择变声类型
choice = menu('选择变声类型','保留原音','提高音高(女声/童声)','降低音高(男声)','自定义因子');
if choice == 0 || choice == 1
    y_voice_out = y_voice;
    p = 1;
else
    switch choice
        case 2 % 提高音高
            sub = menu('提高程度','轻微(x1.3)','中等(x1.8)','明显(x2.5)');
            if sub==1,      p = 1.3;
            elseif sub==2,  p = 1.8;
            elseif sub==3,  p = 2.5;
            else,           p = 1.8;
            end
        case 3 % 降低音高
            sub = menu('降低程度','轻微(x0.75)','中等(x0.55)','明显(x0.35)');
            if sub==1,      p = 0.75;
            elseif sub==2,  p = 0.55;
            elseif sub==3,  p = 0.35;
            else,           p = 0.55;
            end
        case 4 % 自定义
            ansdlg = inputdlg({'变调因子 (>1提高, <1降低)：'},'自定义',1,{'1.5'});
            if isempty(ansdlg), p = 1; else, p = str2double(ansdlg{1}); end
            if isnan(p) || p<=0, p = 1; end
        otherwise
            p = 1;
    end

    if abs(p - 1) < 1e-6
        y_voice_out = y_voice;
    else
        % 时域OLA变调
        y_voice_out = lpc_pitch_shift(y_voice, p, Fs);
    end
end

% 处理可能出现的NaN
if any(isnan(y_voice_out)) || isempty(y_voice_out)
    warning('变声处理异常，回退到原始信号。');
    y_voice_out = y_voice;
end

% 去直流并归一化
y_voice_out = y_voice_out - mean(y_voice_out);
y_voice_out = y_voice_out / (max(abs(y_voice_out)) + eps) * 0.9;

% 播放变声结果
fprintf('变调因子: %.2f, 原始长度: %d, 输出长度: %d\n', p, origLen, length(y_voice_out));
sound(y_voice_out, Fs);
pause(length(y_voice_out)/Fs + 0.5);

% 绘图对比
figure;
subplot(2,1,1);
plot(t, y_voice, 'b'); hold on;
plot(t, y_voice_out, 'r');
legend('原始信号','变声后');
title(sprintf('变声时域对比 (因子=%.2f)', p));
xlabel('时间/s'); ylabel('幅值');

% 频谱对比
Nfft = origLen;
Y1_voice = fft(y_voice, Nfft);
Y2_voice = fft(y_voice_out, Nfft);
f_voice = (0:Nfft-1)*Fs/Nfft;
subplot(2,1,2);
plot(f_voice(1:floor(Nfft/2)), abs(Y1_voice(1:floor(Nfft/2))), 'b'); hold on;
plot(f_voice(1:floor(Nfft/2)), abs(Y2_voice(1:floor(Nfft/2))), 'r');
legend('原始频谱','变声后频谱');
xlabel('频率/Hz'); ylabel('幅值');
title(sprintf('变声频域对比 (因子=%.2f)', p));

% 保存选项
saveChoice = questdlg('是否保存变声后的音频？','保存','是','否','否');
if strcmp(saveChoice,'是')
    [outFile,outPath] = uiputfile('*.wav','保存为');
    if outFile
        audiowrite(fullfile(outPath,outFile), y_voice_out, Fs);
        msgbox('保存完成');
    end
end


% ========== LPC变调函数 ==========
function y = lpc_pitch_shift(x, factor, Fs)
    % 基于LPC的变声：分离声源与声道，只改声源音高
    % x: 输入信号 (列向量)
    % factor: 变调因子 (>1升高, <1降低)
    % Fs: 采样率
    
    % LPC阶数：语音通常 Fs/1000 + 2~4
    p = round(Fs / 1000) + 2;
    
    % 帧参数
    frameLen = round(Fs * 0.025);        % 25ms 帧长
    hopAnalysis = round(frameLen / 2);   % 分析跳距（50%重叠）
    hopSynthesis = round(hopAnalysis / factor);  % 合成跳距
    
    win = hann(frameLen, 'periodic');
    
    nFrames = floor((length(x) - frameLen) / hopAnalysis) + 1;
    outLen = (nFrames - 1) * hopSynthesis + frameLen;
    
    y = zeros(outLen, 1);
    wsum = zeros(outLen, 1);
    
    for i = 1:nFrames
        idx = (i-1)*hopAnalysis + (1:frameLen);
        frame = x(idx) .* win;
        
        % LPC 分析：获得声道滤波器系数
        [a, ~] = lpc(frame, p);
        
        % 逆滤波得到残差（声门激励）
        residual = filter(a, 1, frame);
        
        % 对残差做变速变调（纯音高变换）
        [Pr, Qr] = rat(1/factor, 1e-4);
        Pr = max(Pr, 1); Qr = max(Qr, 1);
        res_shifted = resample(residual, Pr, Qr);
        
        % 通过原声道滤波器合成（保留共振峰特征）
        frame_out = filter(1, a, res_shifted);
        frame_out = frame_out .* hann(length(frame_out), 'periodic');
        
        % 重叠相加（用调整后的合成跳距）
        out_start = (i-1) * hopSynthesis + 1;
        out_end = out_start + length(frame_out) - 1;
        if out_end <= outLen
            y(out_start:out_end) = y(out_start:out_end) + frame_out;
            wsum(out_start:out_end) = wsum(out_start:out_end) + hann(length(frame_out), 'periodic');
        end
    end
    
    % 归一化
    y = y ./ (wsum + eps);
    y(isnan(y)) = 0;
    
    % 重采样恢复原始长度
    [P, Q] = rat(length(x) / length(y), 1e-4);
    P = max(P, 1); Q = max(Q, 1);
    y = resample(y, P, Q);
    
    if length(y) > length(x)
        y = y(1:length(x));
    elseif length(y) < length(x)
        y(length(x)) = 0;
    end
    
    y = y / (max(abs(y)) + eps) * 0.9;
end






