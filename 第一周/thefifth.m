b = [1 -1 1 0 0 0 0 0];
a = [1 -0.5 0 0 0 0 1 -0.5];
n  =0:31;
x1 = (n>=3);
x2 = (n==0) - (n==5);
x3 = exp(0.1*n).*(n>=3);
%初始条件y（-1）= 0，x(-1) = 0
%%dlsim函数求解系统的零输入响应
subplot(3,1,1);
Y = dlsim(b, a, x1);
stem(Y,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
title('dlsim函数求解系统的零输入响应');
subplot(3,1,2);
Y= dlsim(b, a, x2);
stem(Y,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
title('dlsim函数求解系统的零输入响应');
subplot(3,1,3);
Y = dlsim(b, a, x3);
stem(Y,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
title('dlsim函数求解系统的零输入响应');

%filter函数求解系统的零输入响应
figure;
subplot(3,1,1);
Y = filter(b, a, x1);
stem(Y,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
title('filter函数求解系统的零输入响应');
subplot(3,1,2);
Y= filter(b, a, x2);
stem(Y,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
title('filter函数求解系统的零输入响应');
subplot(3,1,3);
Y = filter(b, a, x3);
stem(Y,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
title('filter函数求解系统的零输入响应');

