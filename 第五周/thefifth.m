wp = 0.4*pi;
ws = 0.6*pi;
N = 41;
%%%%%%方法一 频率采样法%%%%%%
%频率采样法设计滤波器

%%%%%%方法二 fir2%%%%%%%%%%%%
%fir2设计滤波器





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