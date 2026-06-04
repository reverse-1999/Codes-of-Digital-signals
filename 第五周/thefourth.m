fp1 = 1000;
fp2 = 4500;
fs1 = 2000;
fs2 = 3500;
Rp = 1;
As = 40;
Fs = 10000;
ws1 = 2*fs1/Fs;
ws2 = 2*fs2/Fs;
wp1 = 2*fp1/Fs;
wp2 = 2*fp2/Fs;
%带阻滤波器设计
delta_w = min(ws1-wp1, wp2-ws2);
N = ceil(6.2/delta_w);
b = fir1(N+1,[ws1 ws2],'stop');
%频率响应
[H,w] = freqz(b,1,1024);
figure;
subplot(2,1,1);
plot(w/pi,20*log10(abs(H)),'Color','b');
xlabel('频率w/\pi');
ylabel('幅度特性/dB');
title('带阻滤波器的幅频特性曲线');
subplot(2,1,2);
plot(w/pi,angle(H),'Color','b');
xlabel('频率w/\pi');
ylabel('相位特性');
title('带阻滤波器的相频特性曲线');
