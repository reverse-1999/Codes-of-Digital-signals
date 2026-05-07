%%impz,dstep,filter,filtic
n = -4:4;
x1 =(n == -3)+2*(n==4);
x2 = (n>=-2)+(n>=2);
subplot(2,1,1);
stem(n,x1,'o-'); %%(1)
xlabel('采样点数n');
ylabel('幅度y(n)');
title('第一问');
subplot(2,1,2);
stem(n,x2,'o-'); %%(2)
xlabel('采样点数n');
ylabel('幅度y(n)');
title('第二问');
%%%%%(3)%%%%%
n = 0:24;
x1n = exp(-n/16);
x2n = 5*sin(2*pi*n/10);
X = x1n.*x2n;
figure;
stem(n,X,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
title('第三问');