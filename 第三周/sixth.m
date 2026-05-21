N1 = 3;
N2 = 5;
N3 = 10;
w1 = linspace(0,2*pi,N1);
w2 = linspace(0,2*pi,N2);
w3 = linspace(0,2*pi,N3);

x1w = 2+4*exp(-j*w1)+6*exp(-j*2*w1)+4*exp(-j*3*w1)+2*exp(-j*4*w1);
x2w = 2+4*exp(-j*w2)+6*exp(-j*2*w2)+4*exp(-j*3*w2)+2*exp(-j*4*w2);
x3w = 2+4*exp(-j*w3)+6*exp(-j*2*w3)+4*exp(-j*3*w3)+2*exp(-j*4*w3);

x1n = ifft(x1w);
x2n = ifft(x2w);
x3n = ifft(x3w);

figure;
subplot(3,1,1);
stem(0:N1-1,real(x1n));
title('N=3时的IDFT重构信号');
xlabel('n');
ylabel('x(n)');
subplot(3,1,2);
stem(0:N2-1,real(x2n));
title('N=5时的IDFT重构信号');
xlabel('n');
ylabel('x(n)');
subplot(3,1,3);
stem(0:N3-1,real(x3n));
title('N=10时的IDFT重构信号');
xlabel('n');
ylabel('x(n)');

