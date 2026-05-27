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

t0 = linspace(-2,2,201); %-2 2
N0 =201;
T1 = 1/fs2;
Y1 = zeros(size(t0));
L1 = 9;
K1 = (L1-1)/2; 
f2t_padded1 = [zeros(1,K1), f2t, zeros(1,K1)];%补零  000 -2  2 000 
t2_padded1 = -2-K1*T1:1/fs2:2+K1*T1;%补零后的时间轴
for i = 1:N0
    tp = t0(i);
    idx = round((tp-t2(1))/T1)+1;%对应f2t的点
    
    for j = 1:L1%j=(L1-1)/2时对应idx点
        sinc1 = sinc((j-(L1-1)/2)*T1);
        Y1(i) = Y1(i) + f2t_padded1(idx+j-1).*sinc1;
    end
end
Y2 = zeros(size(t0));
L2 = 17;
K2 = (L2-1)/2;
f2t_padded2 = [zeros(1,K2), f2t, zeros(1,K2)];
t2_padded2 = -2-K2*T1:1/fs2:2+K2*T1;
for i = 1:N0
    tp = t0(i);
    idx = round((tp-t2(1))/T1)+1;
    for j = 1:L2
        sinc2 = sinc((j-(L2-1)/2)*T1);
        Y2(i) = Y2(i) + f2t_padded2(idx+j-1).*sinc2;
    end
end

Y3 = zeros(size(t0));
L3 = 33;
K3 = (L3-1)/2;
f2t_padded3 = [zeros(1,K3), f2t, zeros(1,K3)];
t2_padded3 = -2-K3*T1:1/fs2:2+K3*T1;
for i = 1:N0
    tp = t0(i);
    idx = round((tp-t2(1))/T1)+1;
    for j = 1:L3
        sinc3 = sinc((j-(L3-1)/2)*T1);
        Y3(i) = Y3(i) + f2t_padded3(idx+j-1).*sinc3;
    end
end

figure;
subplot(2,1,1);
stem(t2,f2t);
title('原信号');
xlabel('t');
subplot(2,1,2);
stem(t0,Y1);
title('9点核函数的插值重构信号');
xlabel('t');
figure;
subplot(2,1,1);
stem(t2,f2t);
title('原信号');
xlabel('t');
subplot(2,1,2);
stem(t0,Y2);
title('17点核函数的插值重构信号');
xlabel('t');
figure;
subplot(2,1,1);
stem(t2,f2t);
title('原信号');
xlabel('t');
subplot(2,1,2);
stem(t0,Y3);
title('33点核函数的插值重构信号');
xlabel('t');

