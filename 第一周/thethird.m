%%%(1)%%%
b1 = [1 0 -0.5 0 0];
a1 = [1 -1 1 0 0.25];
poles1 = roots(a1);
if all(abs(poles1) < 1)
	disp('系统一稳定');
else
	disp('系统一不稳定');
end
figure;
subplot(2,1,1);
hn = impz(b1,a1,32);
stem(hn);
title('impz函数求解的冲激响应');
subplot(2,1,2);
yn = dstep(b1,a1,32);
stem(yn);
title('dstep函数求解的阶跃响应');
figure;
n = 0:31;
subplot(2,1,1);
Xn = [1,zeros(1,31)];
Yn = filter(b1,a1,Xn);
stem(Yn);
title('filtic和filter函数求解的冲激响应');
subplot(2,1,2);
Xn = (n>=0);
Yn = filter(b1,a1,Xn);
stem(Yn); 
title('filtic和filter函数求解的阶跃响应');

%%%(2)%%%
b2 = [1 0.5 -0.5 -1 -0.5 1];
a2 = [1 0 0 0 0 0];
poles2 = roots(a2);
if all(abs(poles2) < 1)
	disp('系统二稳定');
else
	disp('系统二不稳定');
end
figure;
subplot(2,1,1);
hn = impz(b2,a2,32);
stem(hn);
title('impz函数求解的冲激响应');
subplot(2,1,2);
yn = dstep(b2,a2,32);
stem(yn);
title('dstep函数求解的阶跃响应');
figure;
subplot(2,1,1);
Xn = [1,zeros(1,31)];
Yn = filter(b2,a2,Xn);
stem(Yn);
title('filtic和filter函数求解的冲激响应');
subplot(2,1,2);
Xn = (n>=0);
Yn = filter(b2,a2,Xn);
stem(Yn);
title('filtic和filter函数求解的阶跃响应');



