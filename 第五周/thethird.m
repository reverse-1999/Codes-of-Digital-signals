wp = 0.2*pi;
ws = 0.3*pi;
Rp = 0.5;
As = 40;
%窗函数法设计FIR滤波器
N = 8*pi/(ws-wp);
N = ceil(N);
n = 0:N-1;
wc = (wp+ws)/2;
hd = ideal_lp(wc,N);
window = hanning(N)';
h = hd.*window; 
w = linspace(0,2*pi,512);
figure;
%实际滤波器的脉冲响应
stem(n,h,'filled');
xlabel('n');
ylabel('h[n]');
title('窗函数法设计的FIR滤波器的脉冲响应');
%窗函数的幅频、相频特性曲线
figure;
subplot(2,1,1);
plot(w/pi,20*log10(abs(fft(window,512))),'Color','r');
xlabel('频率w/\pi');
ylabel('幅度特性/dB');
title('窗函数的幅频特性曲线');
subplot(2,1,2);
plot(w/pi,angle(fft(window,512)),'Color','r');
xlabel('频率w/\pi');
ylabel('相位特性');
title('窗函数的相频特性曲线');
%滤波器的幅频、相频特性曲线
figure;
subplot(2,1,1);
plot(w/pi,20*log10(abs(fft(h,512))),'Color','b');
xlabel('频率w/\pi');
ylabel('幅度特性/dB');
title('FIR滤波器的幅频特性曲线');
subplot(2,1,2);
plot(w/pi,angle(fft(h,512)),'Color','b');
xlabel('频率w/\pi');
ylabel('相位特性');
title('FIR滤波器的相频特性曲线');


function hd = ideal_lp(wc,N)
    % hd = 点0到N-1之间的理想脉冲响应
    % wc = 截止频率(弧度)
    % N = 理想滤波器的长度
    tao = (N-1)/2;
    n = [0:(N-1)];
    m = n-tao+eps;  % 加一个小数以避免0作除数
    hd = sin(wc*m)./(pi*m);
end