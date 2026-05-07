% Insert your code here
b = [1/6 1/2 1/2 1/6];
a = [1 0 1/3 0];
subplot(2,1,1);
impz(b,a);
subplot(2,1,2);
y = dstep(b,a,32);
stem(y);
Xn = (n>=0 & n<5);
%Xn = rectwin(5)
Yn = filter(b,a,Xn);
figure;
stem(Yn,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
title("R5(n)的零状态响应");