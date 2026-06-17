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
wp2 = 2*pi*fp2;
ws2 = 2*pi*fs2;
ksp2 = wp2/ws2;
lamdasp2 = sqrt((10^(As2/10)-1)/(10^(Ap2/10)-1));
NIIR2 = ceil(abs(log10(lamdasp2)/log10(ksp2)));
wc2 = wp2/(10^(Ap2/10)-1)^(1/(2*NIIR2));
[A2,B2] = butter(NIIR2,wc2/(Fs/2),'high');
%FIR
NFIR2 = ceil((As2-8)/(2.285*(fp2-fs2)/Fs));
b2 = fir1(NFIR2,fs2/(Fs/2),'high',hanning(NFIR2+1));
%时域
y_highpass_IIR = filter(A2,B2,y);
y_highpass_FIR = filter(b2,1,y);
figure;
subplot(2,1,1);
plot(t,y,'Color','b');
hold on;
plot(t,y_highpass_IIR,'Color','r');
plot(t,y_highpass_FIR,'Color','g');
xlabel('时间/s');
ylabel('幅值');
legend('原始信号','IIR高通滤波后','FIR高通滤波后');
title('高通滤波器的时域响应');
%频域
Y_highpass_IIR = fft(y_highpass_IIR);
Y_highpass_FIR = fft(y_highpass_FIR);
subplot(2,1,2);
plot((0:N-1)*Fs/N,abs(Y),'Color','b');
hold on;
plot((0:N-1)*Fs/N,abs(Y_highpass_IIR),'Color','r');
plot((0:N-1)*Fs/N,abs(Y_highpass_FIR),'Color','g');
xlabel('频率/Hz');
ylabel('幅值');
legend('原始信号','IIR高通滤波后','FIR高通滤波后');
title('高通滤波器的频域响应');
%带通设计
fpl=1200;
fpu=3000;
fsl=1000;
fsu=3200;
As3=15;
Ap3=1;
%IIR  —— 用 buttord 直接设计（双过渡带无法套用低通公式）
Wp = [fpl fpu]/(Fs/2)*2*pi; 
Ws = [fsl fsu]/(Fs/2)*2*pi;
[NIIR3, Wn] = buttord(Wp*Fs, Ws*Fs, Ap3, As3,'s');
[B_s,A_s] = butter(NIIR3, Wn, 's');
[B3, A3] = impinvar(B_s, A_s, Fs);
%FIR
NFIR3 = ceil((As3-8)/(2.285 * min(fpl-fsl, fsu-fpu)/Fs));  % 取最小过渡带
b3 = fir1(NFIR3, [fsl fsu]/(Fs/2), hanning(NFIR3+1));
%时域
y_bandpass_IIR = filter(B3,A3,y);
y_bandpass_FIR = filter(b3,1,y);
figure;
subplot(2,1,1);
plot(t,y,'Color','b');
hold on;
plot(t,y_bandpass_IIR,'Color','r');
plot(t,y_bandpass_FIR,'Color','g');
xlabel('时间/s');
ylabel('幅值');
legend('原始信号','IIR带通滤波后','FIR带通滤波后');
title('带通滤波器的时域响应');
%频域
Y_bandpass_IIR = fft(y_bandpass_IIR);
Y_bandpass_FIR = fft(y_bandpass_FIR);
subplot(2,1,2);
plot((0:N-1)*Fs/N,abs(Y),'Color','b');
hold on;
plot((0:N-1)*Fs/N,abs(Y_bandpass_IIR),'Color','r');
plot((0:N-1)*Fs/N,abs(Y_bandpass_FIR),'Color','g');
xlabel('频率/Hz');
ylabel('幅值');
legend('原始信号','IIR带通滤波后','FIR带通滤波后');
title('带通滤波器的频域响应');



