x = [7 6 5 4 3 2];
xn = [x x x];
N = length(x);
n = 0:length(xn)-1;
k = 0:3*N-1;
wk = exp(-1j*2*pi/N);
%for i = 1:N
%    X(i) = sum(x.*wk(i).^(n*k));
%end
%for i = 1:length(k)
%    XN(i) = sum(xn.*wk(i).^(0:length(xn)-1));
%end
figure;
subplot(2,1,1);
stem(x);
title('原信号主值序列');
xlabel('n');
ylabel('x(n)');
subplot(2,1,2);
stem(xn);
title('三个周期信号的主值序列');
xlabel('n');
ylabel('x(n)');

XN = 1/3*xn*wk.^(n'*k);
X = x*wk.^((0:5)'*k);
figure;
subplot(2,1,1);
stem(k,abs(XN));
title('三个周期信号的DFS幅度谱');
xlabel('k');
ylabel('|X(k)|');
subplot(2,1,2);
stem(k,angle(XN));
title('三个周期信号的DFS相位谱');
xlabel('k');
ylabel('∠X(k)');
figure;
subplot(2,1,1);
stem(k,abs(X));
title('一个周期信号的DFS幅度谱');
xlabel('k');
ylabel('|X(k)|');
subplot(2,1,2);
stem(k,angle(X));
title('一个周期信号的DFS相位谱');
xlabel('k');
ylabel('∠X(k)');

xn_IDFS = 1/N/3*XN*wk.^(k'*n);
figure;
stem(n,real(xn_IDFS));
title('三个周期信号的IDFS');
xlabel('n');
ylabel('x(n)');



