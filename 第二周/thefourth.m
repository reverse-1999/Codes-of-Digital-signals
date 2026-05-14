z1 = [0.3];
p1 = [-0.5+0.7j, -0.5-0.7j];
z2 = [0.3];
p2 = [-0.6+0.8j, -0.6-0.8j];
z3 = [0.3];
p3 = [-1+j, -1-j];
[b1,a1] = zp2tf(z1,p1,1);
[b2,a2] = zp2tf(z2,p2,1);  
[b3,a3] = zp2tf(z3,p3,1);
N = 32;
figure;
subplot(2,1,1);
zplane(b1,a1);
subplot(2,1,2);
[h1,n1] = impz(b1,a1,N);
impz(b1,a1,N);
poles1 = roots(a1);
if all(abs(poles1) < 1)
	disp('系统一稳定');
else
	disp('系统一不稳定');
end
if all(h1(n1<0) == 0)
    disp('系统一因果');
else
    disp('系统一非因果');
end
figure;
subplot(2,1,1);
zplane(b2,a2);
subplot(2,1,2);
[h2,n2] = impz(b2,a2,N);
impz(b2,a2,N);
poles2 = roots(a2);
if all(abs(poles2) < 1)
	disp('系统二稳定');
else
	disp('系统二不稳定');
end
if all(h2(n2<0) == 0)
    disp('系统二因果');
else
    disp('系统二非因果');
end
figure;
subplot(2,1,1);
zplane(b3,a3);
subplot(2,1,2);
[h3,n3] = impz(b3,a3,N);
impz(b3,a3,N);
poles3 = roots(a3);
if all(abs(poles3) < 1)
	disp('系统三稳定');
else
	disp('系统三不稳定');
end
if all(h3(n3<0) == 0)
    disp('系统三因果');
else
    disp('系统三非因果');
end