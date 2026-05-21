xn = [7 6 5 4 3 2];
N = length(xn);
n = 0:length(xn)-1;
wk = exp(-1j*2*pi/N);
X_DFT = zeros(1,N);
for k = 0:N-1
    sum_val = 0;
    for i = 0:N-1
        sum_val = sum_val + xn(i+1) * exp(-1j * 2 * pi * k * i / N);
    end
    X_DFT(k+1) = sum_val;
end

figure;
subplot(2,1,1);
stem(abs(X_DFT));
title('DFS幅度谱');
xlabel('k');
ylabel('|X(k)|');
subplot(2,1,2);
stem(angle(X_DFT));
title('DFS相位谱');
xlabel('k');
ylabel('∠X(k)');

X_IDFT = zeros(1,N);
for n = 0:N-1
    sum_val = 0;
    for k = 0:N-1
        sum_val = sum_val + X_DFT(k+1) * exp(1j * 2 * pi * k * n / N);
    end
    X_IDFT(n+1) = sum_val / N;
end
figure;
subplot(2,1,1);
stem(real(X_IDFT));
title('IDFT重构信号');
xlabel('n');
ylabel('x(n)');
subplot(2,1,2);
stem(xn);
title('原信号');
xlabel('n');
ylabel('x(n)');

