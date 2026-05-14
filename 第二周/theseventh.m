b = [0.187632  0 -0.241242 0 0.241242 0 -0.187632];
a = [1 0 0.602012 0 0.495684 0 -0.035924];

N = 512;
[H,w] = freqz(b, a, N);
wN = w / pi;

magAbs = abs(H);
magRel = magAbs / max(magAbs);
magRel_dB = 20*log10(magRel);

%绝对幅度响应
subplot(2,1,1);
plot(wN, magAbs, 'LineWidth', 1.2);
xlim([0 1]);
xlabel('\omega/\pi');
ylabel('绝对幅度');
grid on;
title('绝对幅度响应');
%相对幅度响应
subplot(2,1,2);
plot(wN, magRel_dB, 'LineWidth', 1.2);
xlim([0 1]);
ylim([-100 0]);
xlabel('\omega/\pi');
ylabel('相对幅度(dB)');
grid on;
title('相对幅度响应');
%相频响应
figure;
subplot(2,1,1);
pha = angle(H);
plot(wN, pha, 'LineWidth', 1.2);
xlim([0 1]);
xlabel('\omega/\pi');
ylabel('相位');
grid on;
title('相频响应');
%群延时
subplot(2,1,2);
grpdelay(b, a, N);
xlim([0 1]);
xlabel('\omega/\pi');
ylabel('群延时');
grid on;
title('群延时');
%滤波器类型
if all(p > 0) && all(p < 1)
    filterType = '低通滤波器';
elseif all(p < 0) && all(p > -1)
    filterType = '高通滤波器';
elseif all(p > 0) && all(p > 1)
    filterType = '带通滤波器';
elseif all(p < 0) && all(p < -1)
    filterType = '带阻滤波器';
else
    filterType = '未知类型滤波器';
end
disp(['滤波器类型：', filterType]);