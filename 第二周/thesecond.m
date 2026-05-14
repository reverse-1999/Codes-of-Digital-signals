n1 = 0:10;
x1 = n1;
n2 = -2:10;
x2 = (n2 >= -2);
y = conv(x1, x2);
ny = -2:20;
stem(ny, y);