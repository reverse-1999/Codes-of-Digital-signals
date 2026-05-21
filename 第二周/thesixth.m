z = [0;-2];
p = [0.3 0.4 0.6];
[b,a] = zp2tf(z, p, 1);

N = 32;
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
ylim([-50 0]);
xlabel('\omega/\pi');
ylabel('相对幅度(dB)');
grid on;
title('相对幅度响应');

%相频响应
figure;
subplot(2,1,1);
pha = angle(H);
plot(wN, pha);
xlim([0 1]);
xlabel('\omega/\pi');
ylabel('相位');
grid on;
title('相频响应');
%极零点分布图
subplot(2,1,2);
zplane(b, a);
title('极零点分布图');

%滤波器类型
if all(abs(p) < 1) && all(abs(angle(p)) < pi/4)
    filterType = '低通滤波器';
elseif all(abs(p) < 1) && all(abs(angle(p)) > pi*3/8)
    filterType = '高通滤波器';
elseif any(abs(p) < 1) && any(abs(angle(p)) > pi/6 & abs(angle(p)) < pi*2/3)
    filterType = '带通滤波器';
elseif any(abs(p) < 1) && any(abs(angle(p)) > pi/3 & abs(angle(p)) < pi*5/6)
    filterType = '带阻滤波器';
else
    filterType = '未知类型滤波器';
end
disp(['滤波器类型：', filterType]);