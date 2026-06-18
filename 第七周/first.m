clc;clear all; close all;
x=1:10;%
y=1:10;
%%%题目1.1调用xcorr求x和y的相关函数
                            %%%求x和y的相关
Rxy = xcorr(x,y);

%%%题目1.2调用conv求x和y的相关，注意y应该做翻转；
                            % 为了用卷积实现相关，可以把信号进行翻转，由于卷积运算还要翻转一次，所以两次翻转后就变成了相关。flip 翻转元素顺序
Rxy_conv = conv(x,flip(y));
%%%题目1.3调用conv直接求x和y的卷积
                            %%%求x和y的卷积
xy_conv = conv(x,y);
%%%题目1.4,在一张图里面画出x和y的相关函数、用卷积求相关、以及直接求卷积三种情况的图像。
figure;
plot(Rxy,'-o');hold on;
plot(Rxy_conv,'-x');
plot(xy_conv,'-s');
xlabel('n');ylabel('幅值');
legend('x和y互相关结果','利用卷积计算互相关','x和y卷积结果');

