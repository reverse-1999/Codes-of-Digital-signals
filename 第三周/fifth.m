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

t_des = linspace(-2,2,201);
N0 =201;
T = 1/fs2;
Y = zeros(size(t_des));
N = 9;
for i = 1:N0
    result = 0;
    tp = t_des(i);
    nq = round(tp/T);
    if  == 1
        disp(i);
    end
    for k = -4:4
    idx = nq+k;
    if idx<1 || idx>41
        continue;
    end
    result = result + f2t(idx)*sinc(idx*T);
    end
    Y(i) = result;
end
figure;
stem(t_des,Y);
