wp = 0.4*pi;
ws = 0.6*pi;
N = 41;
%%%%%%方法一 频率采样法%%%%%%
%频率采样法设计滤波器
T1 = 0.38;  

k = 0:N-1;
wk = 2*pi*k/N; 

Hk = zeros(1, N);
Hk(wk <= wp) = 1;
Hk(wk >= ws) = 0;

trans_idx = find(wk > wp & wk < ws);
if ~isempty(trans_idx)
    Hk(trans_idx) = T1;  % 过渡带设置为T1=0.38
end

alpha = (N-1)/2;
phase = exp(-1j * alpha * 2*pi*k/N);
Hk = Hk .* phase;
h1 = ifft(Hk, N);
h1 = real(h1); 
[db1, mag1, pha1, grd1, w] = freqz_m(h1, 1);
figure;
stem(0:N-1, h1, 'filled');
title('频率采样法设计的滤波器脉冲响应');
xlabel('n');
ylabel('h(n)');
grid on;
figure;
subplot(2,1,1);
plot(w/pi, db1);
title('频率采样法设计的滤波器幅度响应');
xlabel('归一化频率 (×π rad/sample)');
ylabel('幅度 (dB)');
grid on;
subplot(2,1,2);
plot(w/pi, pha1);
xlabel('归一化频率 (×π rad/sample)');
ylabel('相位 (rad)');
grid on;

%%%%%%方法二 fir2%%%%%%%%%%%%
%fir2设计滤波器
f = [0, wp/pi, ws/pi, 1];  
a = [1, 1, 0, 0];          
h2 = fir2(N-1, f, a, boxcar(N));  
[db2, mag2, pha2, grd2, w] = freqz_m(h2, 1);
figure;
stem(0:N-1, h2, 'filled');
title('fir2设计的滤波器脉冲响应');
xlabel('n');
ylabel('h(n)');
grid on;
figure;
subplot(2,1,1);
plot(w/pi, db2);
title('fir2设计的滤波器幅度响应');
xlabel('归一化频率 (×π rad/sample)');
ylabel('幅度 (dB)');
grid on;
subplot(2,1,2);
plot(w/pi, pha2);
xlabel('归一化频率 (×π rad/sample)');
ylabel('相位 (rad)');
grid on;



function hd = ideal_lp(wc,N)
    % hd = 点0到N-1之间的理想脉冲响应
    % wc = 截止频率(弧度)
    % N = 理想滤波器的长度
    tao = (N-1)/2;
    n = [0:(N-1)];
    m = n-tao+eps;  % 加一个小数以避免0作除数
    hd = sin(wc*m)./(pi*m);
    end
    % 计算滤波器的绝对和相对幅度频率响应和相位频率响应
    
function [db,mag,pha,grd,w] = freqz_m(b,a)
    [H,w] = freqz(b,a,1000,'whole');
    H = (H(1:501))';w = (w(1:501))';
    mag = abs(H);
    db = 20*log10((mag+eps)/max(mag));
    pha = angle(H);
    grd = grpdelay(b,a,w);
end