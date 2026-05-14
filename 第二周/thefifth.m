b = [2,3,0];
a = [1,0.4,1];
[h,w] = freqz(b, a, 512);

mag = abs(h);
mag = mag / max(mag);
mag = 20*log10(mag);
pha = angle(h);

wN = w / pi;

%相对幅频响应
subplot(2,1,1);
plot(wN, mag, 'LineWidth', 1.2);
xlim([0 1]);
ylim([-100 0]);
xlabel('\omega/\pi');
ylabel('相对幅度(dB)');
grid on;

%相频响应
subplot(2,1,2);
plot(wN, pha/pi, 'LineWidth', 1.2);
xlim([0 1]);
xlabel('\omega/\pi');
ylabel('相位/\pi');
grid on;


