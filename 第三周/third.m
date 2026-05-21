xn = [7 6 5 4 3 2];
N = length(xn);
n = 0:length(xn)-1;
w = linspace(-2*pi, 2*pi, 2000);
X_DTFT = zeros(size(w));
for i = 1:length(w)
    X_DTFT(i) = sum(xn.*exp(-1j*w(i)*n));
end
figure;
stem(xn);
title('原信号');
xlabel('n');
ylabel('x(n)');

figure;
subplot(2,1,1);
plot(w/pi,abs(X_DTFT));
title('DTFT幅度谱');
xlabel('ω/\pi');
ylabel('|X(ω)|');
subplot(2,1,2);
plot(w/pi,angle(X_DTFT));
title('DTFT相位谱');
xlabel('ω/\pi');
ylabel('∠X(ω)');

N = 100;
k = 0:N-1;
wk = exp(-1j*2*pi/N);

X_DFT = xn*wk.^((0:5)'*k);

figure;
subplot(2,1,1);
stem(k,abs(X_DFT));
title('DFT幅度谱');
xlabel('k');
ylabel('|X(k)|');
subplot(2,1,2);
stem(k,angle(X_DFT));
title('DFT相位谱');
xlabel('k');
ylabel('∠X(k)');
