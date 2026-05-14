syms a n w0 z
x1n=n*a^n;
x2n=sin(w0*n)*exp(-a*n);
disp('x1(n)的Z变换：')
x1n = ztrans(x1n,n,z); 
disp(x1n);
disp('x2(n)的Z变换：')
X2 = ztrans(x2n,n,z);
disp(x2n);