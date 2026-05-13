b = [0.187632 0.241242 0.241242 0.187632];
a = [1 -0.602012 0.495684 -0.035924];
%初始条件y（-1）= 5，x(-1) = 5
y = 5;
x = 5;
z = filtic(b,a,y,x);
n = 0:31;
x1 = (n==3);
x2 = (n>=0 & n<5);
x3 = cos(2*pi/3*n)+sin(3*pi/10*n);
%%%%%%%求x1零输入、零状态、全响应%%%%%%%%
figure;
y11 = filter(b,a,zeros(size(n)),z);
stem(n,y11);
xlabel('n');
ylabel('y1(n)');
title('x1零输入响应');
figure;
y12 = filter(b,a,x1,zeros(length(a)-1, 1));
stem(n,y12);
xlabel('n');
ylabel('y2(n)');
title('x1零状态响应');

figure;
%y13 = y11+y12;
y13 = filter(b,a,x1,z);
stem(n,y13);
xlabel('n');
ylabel('y13(n)');
title('x1全响应');

%%%%%%%求x2零输入、零状态、全响应%%%%%%%%
figure;
y21 = filter(b,a,zeros(size(n)),z);
stem(n,y21);
xlabel('n');
ylabel('y1(n)');
title('x2零输入响应');

figure;
y22 = filter(b,a,x2,zeros(length(a)-1, 1));
stem(n,y22);
xlabel('n');
ylabel('y2(n)');
title('x2零状态响应');

figure;
%y23 = y21+y22;
y23 = filter(b,a,x2,z);
stem(n,y23);
xlabel('n');
ylabel('y23(n)');
title('x2全响应');

%%%%%%%求x3零输入、零状态、全响应%%%%%%%%
figure;
y31 = filter(b,a,zeros(size(n)),z);
stem(n,y31);
xlabel('n');
ylabel('y1(n)');
title('x3零输入响应');

figure;
y32 = filter(b,a,x3,zeros(length(a)-1, 1));
stem(n,y32);
xlabel('n');
ylabel('y2(n)');
title('x3零状态响应');

figure;
%y33 = y31+y32;
y33 = filter(b,a,x3,z);
stem(n,y33);
xlabel('n');
ylabel('y33(n)');
title('x3全响应');
