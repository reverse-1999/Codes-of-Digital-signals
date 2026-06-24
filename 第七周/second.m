samplingFreq=38192000;  %采样频率38.192MHz
codeFreqBasis=1023000;  %GPS信号码率1.023MHz
codeLength=1023;        %GPS信号码长，每个C/A码码长是1023位
ts = 1 / samplingFreq;  %采样间隔
IF=9548000;             %中频本振信号频率
samplesPerCode = round(samplingFreq/(codeFreqBasis/codeLength));%每个码的采样点数

%--- 生成10ms的C/A码序列用于该PRN ---------------------
PRN=2;
caCode1 = generateCAcode(PRN);
PRN=3;
caCode2 = generateCAcode(PRN);
%%%题目2.1 画出cacode1和caCode2的图像；
figure;
subplot(2,1,1);
plot(caCode1,'b');
ylim([-1.5,1.5]);
xlabel('码片索引');ylabel('幅值');
subplot(2,1,2);
plot(caCode2,'b');
ylim([-1.5,1.5]);
xlabel('码片索引');ylabel('幅值');
%%%题目2.2 求cacode1和caCode2的互相关，并画图；
RcaCode12 = xcorr(caCode1,caCode2);
figure;
plot(RcaCode12,'b');
xlabel('码片索引');ylabel('幅值');
%%%题目2.3 分别求cacode1和caCode1的自相关，并画图；
RcaCode11 = xcorr(caCode1,caCode1);
RcaCode22 = xcorr(caCode2,caCode2);
figure;
subplot(2,1,1);
plot(RcaCode11,'b');
xlabel('码片索引');ylabel('幅值');
subplot(2,1,2);
plot(RcaCode22,'b');
xlabel('码片索引');ylabel('幅值');


load longSignal.mat   %%%这个信号是中频采样信号，长度大概是11ms。
Len = length(longSignal);
tin = (1:Len)*ts*1e3;
fin = (-Len/2+1:Len/2)/Len*samplingFreq/1e6;  %%%单位MHz
figure;
plot(tin,(longSignal));
xlabel('时间(ms)');
ylabel('信号幅度');
axis tight;
title('接收到的GPS信号');
%%%题目3.1 请求上述信号的幅度谱，并画图，横坐标范围（-fs/2，fs/2），请注意做完FFT后，频率范围是0到fs/2，-fs/2到0.
figure;
plot(fin,abs(fftshift(fft(longSignal))));
xlabel('频率(MHz)');
ylabel('幅度');
axis tight;
title('接收到的GPS信号频谱');
%%%题目3.2观察上述频谱，我们发现0频处存在一个很高的分量，那是信号中存在直流分量。请消除0频分量（可以采用减掉信号平均值的方法），然后再画图。
longSignal_noDC = longSignal - mean(longSignal);
figure;
plot(fin,abs(fftshift(fft(longSignal_noDC))));
xlabel('频率(MHz)');
ylabel('幅度');
axis tight;
title('去直流的接收的GPS信号频谱');


load BasebandSignalPRN.mat  %%%这个信号是正交解调后的复信号,长度也是11ms。
%%%题目3.3 画出变量BasebandSignalPRN的频谱，观察它的频谱分量，注意横坐标范围（-fs/2，fs/2），请注意做完FFT后，频率范围是0到fs/2，-fs/2到0。
%我们发现，这个信号并非理想的基带信号，它包括基带信号分量，以及两倍中频分量，还有个搬移到中频的零频分量。中频为9.548MHz
LenBaseband = length(BasebandSignalPRN);
finBaseband = (-LenBaseband/2+1:LenBaseband/2)/LenBaseband*samplingFreq/1e6;  %%%单位MHz
figure;
plot(finBaseband,abs(fftshift(fft(BasebandSignalPRN))));
xlabel('频率(MHz)');
ylabel('幅度');
axis tight;
title('BasebandSignalPRN的频谱');
%%%%我们发现这个所谓的基带复信号其实并非"基带"，而是带有两倍中频分量。
%%%%%%%%%题目3.4 设计一个低通滤波器，将感兴趣的频谱（-2至2MHz）滤出来，滤除两倍中频分量和在中频位置零频分量，画出滤波器的时域和幅频响应曲线（dB显示）。
%设计一个低通滤波器，截止频率为2MHz，采样频率为38.192MHz，滤波器阶数为1000。
cutoffFreq = 2000000; % MHz
normalizedCutoffFreq = cutoffFreq / (samplingFreq/2); % 归一化截止频率
filterOrder = 1000; % 滤波器阶数
% 使用窗函数法设计低通滤波器
b = fir1(filterOrder, normalizedCutoffFreq, 'low');
% 画出滤波器的时域响应
figure;
subplot(2,1,1);
stem(0:filterOrder, b, 'filled');
xlabel('样本索引');ylabel('滤波器系数');
title('低通滤波器的时域响应');
% 画出滤波器的幅频响应
[H, W] = freqz(b, 1, 1024);
subplot(2,1,2);
plot(W/pi*samplingFreq/2, 20*log10(abs(H)));
xlabel('频率(MHz)');ylabel('幅度(dB)');

%%%%%滤波器设计完毕。
%%%题目3.5 对BasebandSignalPRN信号进行滤波处理，结果应该只剩下基带信号，画出滤波前后的频谱。
filteredSignal = filter(b, 1, BasebandSignalPRN);
figure;
subplot(2,1,1);
plot(finBaseband,abs(fftshift(fft(BasebandSignalPRN))));
xlabel('频率(MHz)');
ylabel('幅度');
axis tight;
title('滤波前的BasebandSignalPRN频谱');
subplot(2,1,2);
plot(finBaseband,abs(fftshift(fft(filteredSignal))));
xlim([-3,3]);
xlabel('频率(MHz)');
ylabel('幅度');
title('滤波后的BasebandSignalPRN频谱');


PRN=3;
load caCodesTable.mat   %%%
caCode=caCodesTable(PRN, :);
caCodeFreqDom=conj(fft(caCode,length(BasebandSignalPRN)));%%%%求本地C/A码信号的频谱并取共轭。
figure;plot(abs(caCodeFreqDom))
%%%%题3.6 画出caCodeFreqDom的频谱并观察，给出主瓣宽度（主瓣旁边两个零点之间的宽度），应该是2MHz左右。
figure;
plot(finBaseband,abs(fftshift(caCodeFreqDom)));
xlabel('频率(MHz)');
ylabel('幅度');
axis tight;
title('caCodeFreqDom的频谱');
%%%%题3.7 对滤波后的BasebandSignalPRN信号进行相关处理并画图。采用频域共轭相乘再反变换的方法，注意本地信号caCode的求频谱后取共轭，并且求频谱的时候要补零到跟BasebandSignalPRN一样长，以保证后面两者相乘长度一致。
filteredSignalFreqDom = fft(filteredSignal);
correlationFreqDom = filteredSignalFreqDom .* caCodeFreqDom;
correlationTimeDom = ifft(correlationFreqDom);
figure;
plot(abs(correlationTimeDom));
xlabel('时间(ms)');
ylabel('相关结果幅值');
axis tight;
title('滤波后的BasebandSignalPRN与caCode的相关结果');
%%%%题3.8对滤波后的BasebandSignalPRN信号进行卷积处理(注意擦caCode信号要翻转)并画图。当然，也可以用相关的方法。比较两者结果，分析为何在两端存在差异。
convolutionResult = conv(filteredSignal, flip(caCode));
figure;
plot(abs(convolutionResult));
xlabel('时间(ms)');
ylabel('卷积结果幅值');
axis tight;
title('滤波后的BasebandSignalPRN与caCode的卷积结果');


acqThreshold=sqrt(2.5);       %检测判决门限
longSignal=longSignal-mean(longSignal);%减去直流分量
signal1 = longSignal(1 : samplesPerCode);  %%%%取出1ms数据，只进行一次计算。
%%  下面定义频率搜索的范围，一共搜索29个频点，每个频点差500Hz，所以
%一共搜索28*500Hz
acqSearchBand =14;%捕获的频带宽度
numberOfFrqBins = round(acqSearchBand * 2) + 1;%搜索的频点，每个频点之间的差是500Hz
%%  载入CA码的码表，可以把CA码看成是系统的冲激响应h(n)

%% --- 初始化一些使用到的数组以加快运算速度 -------------------------------

for PRN=1:32   %%%不同卫星搜索
    caCodeFreqDom = conj(fft(caCodesTable(PRN, :),length(signal1)));%将序号为PRN的卫星参考信号通过DFT变换到频域，相当于得到h(n)对应的H(k)
    %--- Make the correlation for whole frequency band (for all freq. bins)
    for frqBinIndex = 1:numberOfFrqBins   %%%不同的多普勒的搜索

        %--- Generate carrier wave frequency grid (0.5kHz step) -----------
        frqBins(frqBinIndex) = IF - (acqSearchBand/2) * 1000 + 0.5e3 * (frqBinIndex - 1); %%%中频信号减去多普勒频率，后面用这个频率进行正交解调，去除多普勒的影响。
       
        %--- Generate local sine and cosine -------------------------------
      
       %%%%题目4.1 产生本地正弦和余弦信号，完成对signal1信号的正交解调，并形成复信号，是否存在2倍中频分量。
        t = (0:length(signal1)-1) * ts; % 时间向量
        localSine = sin(2*pi*frqBins(frqBinIndex)*t); % 本地正弦信号
        localCosine = cos(2*pi*frqBins(frqBinIndex)*t); % 本地余弦信号
        signalIQ = signal1 .* (localCosine + 1j*localSine); % 正交解调后的复信号
       
        if(frqBinIndex==1 && PRN==1) %%%只画出第一个频点，第一个卫星的结果
        figure;
        plot(abs(fftshift(fft(signalIQ))));
        xlabel('频率(MHz)');
        ylabel('幅度');
        axis tight;
        title(['正交解调后的信号频谱，频点索引：', num2str(frqBinIndex)]);
        end
       %%%%题目4.2 利用之前设计的低通滤波其完成对signal1信号的滤波,观察频谱是否只剩下低频分量。
        signalIQ_filtered = filter(b, 1, signalIQ);
        if(frqBinIndex==1 && PRN==1) %%%只画出第一个频点，第一个卫星的结果
        figure;
        plot(abs(fftshift(fft(signalIQ_filtered))));
        xlabel('频率(MHz)');
        ylabel('幅度');
        axis tight;
        title(['滤波后的信号频谱，频点索引：', num2str(frqBinIndex)]);
        end
       %%%%题目4.3 利用频域共轭相乘方法完成相关运算。
        % acqRes1 = abs(ifft(convCodeIQ1)) .^ 2; %%%%相关结果
        % temp=acqRes1;
        signalIQ_filtered_freqDom = fft(signalIQ_filtered);
        correlationFreqDom = signalIQ_filtered_freqDom .* caCodeFreqDom;
        correlationTimeDom = ifft(correlationFreqDom);
        temp = abs(correlationTimeDom);
       %%%%题目4.4 搜索最大峰，记录最大峰位置。用max函数，可以给出最大值和最大值的下标。
        [peakSize, peakIndex] = max(temp);
       %%%%题目4.5 搜索次高峰，可以先将最大峰主瓣范围（±38）全部置零，然后在搜索出最高峰。
        for i = -38:38
            if (peakIndex + i) > 0 && (peakIndex + i) <= length(correlationTimeDom)
                correlationTimeDom(peakIndex + i) = 0; % 将最大峰主瓣范围内的值置零
            end
        end
        [secondPeakSize, ~] = max(correlationTimeDom); %%%%搜索次高峰
        
        % If the result is above threshold, then there is a signal ...
        biaozhiwei=0; %%用于标记搜索到峰值。
        if (peakSize/secondPeakSize) > acqThreshold     %peakSize为最大峰值，secondPeakSize为第二大峰值
            biaozhiwei=biaozhiwei+1;
            %% Fine resolution frequency search =======================================
           
            %             title(['第',num2str(PRN),'颗卫星卷积结果'])
            %--- Indicate PRN number of the detected signal -------------------
            if biaozhiwei==1
                fprintf('第%02d颗卫星的 ', PRN);
            end
            fprintf('第%02d个频带捕获到信号 ', frqBinIndex);
            figure;
            plot(abs(temp));   %%%画出检测到信号的结果
            
        else
            %--- No signal with this PRN --------------------------------------
            %             fprintf('. ');
        end   % if (peakSize/secondPeakSize) > settings.acqThreshold
    end % frqBinIndex = 1:numberOfFrqBins

end


