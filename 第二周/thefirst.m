n1 = 0:9;
x1 = (n1 >= 0) - (n1 >= 10);
n2 = 0:14;
x2 = (n2 >= 0) - (n2 >= 15);
y = conv(x1, x2);
ny = 0:(length(y) - 1);
stem(ny, y);