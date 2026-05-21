fs1 = 100;
fs2 = 10;
t1 = -2:1/fs1:2;
t2 = -2:1/fs2:2;
f1t = sinc(t1);
f2t = sinc(t2);
figure;
subplot(2,1,1);
stem(t1,f1t);
title('fs=100Hz时的sinc函数');
xlabel('t');
ylabel('sinc(t)');
subplot(2,1,2);
stem(t2,f2t);
title('fs=10Hz时的sinc函数');
xlabel('t');
ylabel('sinc(t)');

