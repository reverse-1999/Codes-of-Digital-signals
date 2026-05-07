%%%(1)%%%
b1 = [1 0 -0.5 0 0];
a1 = [1 -1 1 0 0.25];
figure;
subplot(2,2,1);
hn = impz(b1,a1,32);
stem(hn);
title('impz函数求解的冲激响应');
subplot(2,2,2);
yn = dstep(b1,a1,32);
stem(yn);
title('dstep函数求解的阶跃响应');

n = 0:31;
subplot(2,2,3);
Xn = [1,zeros(1,31)];
Yn = filter(b1,a1,Xn);
stem(Yn);
title('filtic和filter函数求解的冲激响应');
subplot(2,2,4);
Xn = (n>=0);
Yn = filter(b1,a1,Xn);
stem(Yn); 
title('filtic和filter函数求解的阶跃响应');

%%%(2)%%%
b2 = [1 0.5 -0.5 -1 -0.5 1];
a2 = [1 0 0 0 0 0];
figure;
subplot(2,2,1);
hn = impz(b2,a2,32);
stem(hn);
title('impz函数求解的冲激响应');
subplot(2,2,2);
yn = dstep(b2,a2,32);
stem(yn);
title('dstep函数求解的阶跃响应');
subplot(2,2,3);
Xn = [1,zeros(1,31)];
Yn = filter(b2,a2,Xn);
stem(Yn);
title('filtic和filter函数求解的冲激响应');
subplot(2,2,4);
Xn = (n>=0);
Yn = filter(b2,a2,Xn);
stem(Yn);
title('filtic和filter函数求解的阶跃响应');



