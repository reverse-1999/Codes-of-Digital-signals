b = [2 0 -1];
a = [1 -0.7 0];
Xn = (n>=3);
Yn = filter(b,a,Xn);
figure;
stem(Yn,'o-');
xlabel('采样点数n');
ylabel('幅度y(n)');
