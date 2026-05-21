xn = [1 0.5 0 0.5 1 1 0.5 0]
fa = 20;
N1 = 8;
N2 = 32;
N3 = 64;
x1n = xn;
x2n = [x1n zeros(1,N2-N1)];
x3n = [x1n zeros(1,N3-N1)];
%计算fft
X1k = fft(x1n);
X2k = fft(x2n);
X3k = fft(x3n);
figure;
subplot(2,1,1);
stem(0:N1-1,abs(X1k));
title('N=8时的DFT幅度谱');
xlabel('k');
ylabel('|X(k)|');
subplot(2,1,2);
stem(0:N1-1,angle(X1k));
title('N=8时的DFT相位谱');
xlabel('k');
ylabel('∠X(k)');
figure;
subplot(2,1,1);
stem(0:N2-1,abs(X2k));
title('N=32时的DFT幅度谱');
xlabel('k');
ylabel('|X(k)|');
subplot(2,1,2);
stem(0:N2-1,angle(X2k));
title('N=32时的DFT相位谱');
xlabel('k');
ylabel('∠X(k)');
figure;
subplot(2,1,1);
stem(0:N3-1,abs(X3k));
title('N=64时的DFT幅度谱'); 
xlabel('k');
ylabel('|X(k)|');
subplot(2,1,2);
stem(0:N3-1,angle(X3k));
title('N=64时的DFT相位谱');
xlabel('k');
ylabel('∠X(k)');

%IFFT
X1k_32 = [X1k(1 : N1/2), zeros(1, N2 - N1), X1k(N1/2 + 1 : end)];
X1k_64 = [X1k(1 : N1/2), zeros(1, N3 - N1), X1k(N1/2 + 1 : end)];
x1n_IFFT = ifft(X1k);
x2n_IFFT = ifft(X1k_32);
x3n_IFFT = ifft(X1k_64);

figure;
subplot(3,1,1);
stem(0:N1-1,real(x1n_IFFT));
title('N=8时的IDFT重构信号');
xlabel('n');
ylabel('x(n)');
subplot(3,1,2);
stem(0:N2-1,real(x2n_IFFT));
title('N=32时的IDFT重构信号');
xlabel('n');
ylabel('x(n)');
subplot(3,1,3);
stem(0:N3-1,real(x3n_IFFT));

