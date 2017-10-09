clc;clear;close all;
tic;
dir='E:\素雅\研究生\心律失常判别及临床实验\MATLAB代码\特征提取\';
% cd (dir)
datadir=[dir,'MIT-BIH数据\'];
peakdir=[dir,'MIT-BIH处理过的数据\'];
resultdir=[dir,'提取结果图片\'];
sample_rate=360;
% signalnum=zeros(48,1);
% number=zeros(48,1);
colName={'Signal','beats','TP','FP','Se','Acc','PP'};
% table(signalnum,number,'VariableNames',colName)
i=1;
for num=108:234
    datafilename=[datadir,num2str(num),'_dat_MLII.txt'];
    filename2=[peakdir,num2str(num),'_ann_Peak.txt'];
    if  exist(filename2,'file') && exist(datafilename,'file')
        signalnum(i,1)=num;
        
        l2=load(datafilename);
[R_realPeak type]=textread(filename2,'%d%s');
l2_f=filter_baseline(l2);
R=detection_Rwave(l2_f,sample_rate);
result(i,:)=showresult(l2_f,R,R_realPeak);
saveas(gcf,[resultdir,num2str(num),'.fig']);
pause(0.1);
close all;
i=i+1;
    end
end
result2=[signalnum,result];
resulttable=array2table(result2);
resulttable.Properties.VariableNames=colName;
tabelfile=[resultdir,'result10_8.xls'];

writetable(resulttable,tabelfile);
toc;


l2_part1=l2(54000:65000);
l2_part2=l2(58347:61277);
l2_f=filter_baseline(l2);

R1=detection_Rwave(l2_part1);
R1_m=Rpeak_find(l2_part1);
R_z1=correction_R(l2_part1,R1,sample_rate);
figure(1)
plot(l2_part1)
hold on
plot(R1,l2_part1(R1),'*','color','R'); %R峰
plot(R1_m,l2_part1(R1_m),'o','color','k'); %R峰
plot(R_z1,l2_part1(R_z1),'v','color','g'); %R峰

R2=detection_Rwave(l2_part2);
R2_m=Rpeak_find(l2_part2);
R_z2=correction_R(l2_part2,R,sample_rate);
R2=R_1;
figure(3)
plot(l2_part2)
hold on
plot(R2,l2_part2(R2),'*','color','R'); %R峰
plot(R2_m,l2_part2(R2_m),'o','color','k'); %R峰
plot(R_z2,l2_part1(R_z2),'o','color','k'); %R峰



% R_m=Rpeak_find(l2);
 R_z=correction_R(l2_f,R,sample_rate);
  R_z=correct_detect_R(l2_f,R);
indtable=showresult(l2_f,R,R_realPeak);
indtable2=showresult(l2_f,R_z,R_realPeak);

figure(2)
plot(l2_f)
hold on
plot(R_realPeak,l2_f(R_realPeak),'o','color','k'); %R峰
plot(R,l2_f(R),'*','color','R'); %R峰
plot(R_z,l2_f(R_z),'s','color','c'); %R峰
plot(l2_f,'g');

figure(3)
plot(l2)
hold on
plot(R_realPeak,l2(R_realPeak),'o','color','k'); %R峰

plot(R,l2(R),'*','color','R'); %R峰



R=Rpeak_find(l2);
R2=detection_Rwave(l2);R_z2=correct_detect_R2(l2,R2);R3=detection_Rwave(l2_part2);R_z3=correct_detect_R(l2_part2,R3);
R_z=correction_R(l2,R2);
R_z=correction_R(l2,R2);


figure(1)
plot(l2_f)
hold on
plot(R2,l2_f(R2),'*','color','R'); %R峰
plot(R_realPeak,l2_f(R_realPeak),'o','color','k'); %R峰



figure(7)
plot(l2_part2)
hold on
plot(R3,l2_part2(R3),'*','color','R'); %R峰
plot(R_z3,l2_part2(R_z3),'o','color','k'); %R峰








R_realPeak=textread('E:\素雅\111200515-江素雅-光盘\MIT-BIH下载到的数据以及提取的特征值\101_ann_ActualPeak.txt','%d%*[^\n]');
ActualPeak=textread('E:\素雅\111200515-江素雅-光盘\MIT-BIH下载到的数据以及提取的特征值\101_ann_ActualPeak.txt','%d%s[^\n]');
fid = fopen('E:\素雅\111200515-江素雅-光盘\MIT-BIH下载到的数据以及提取的特征值\101_ann_ActualPeak.txt','r');
bb = textscan(fid,'%s');
aa=fscanf(fid,'%s',[2,inf]);
fclose(fid);



l2_part1=l2(1:325000);
l2_part2=l2(325001:end);

% % % % % % % % % % 滤波
c=medfilt1(l2_part1,330);
l2_med1=l2_part1-c;
c=medfilt1(l2_part2,330);
l2_med2=l2_part2-c;

% % % % % % % % % % % % % % % % 
R_m1=Rpeak_find(l2_med1);
R_1=correct_detect_R(l2_med1,R_m1);
R_m2=Rpeak_find(l2_med2);
R_2=(correct_detect_R(l2_med2,R_m2)+324999);

R_last=[R_1,R_2];

R=Rpeak_find(l2);
R_z=correct_detect_R(l2,R);

l2_f=filter_baseline(l2);
R=detection_Rwave(l2);
R_z=correct_detect_R(l2_f,R);
figure(3)
plot(l2)
hold on
plot(R_realPeak,l2(R_realPeak),'*','color','R'); %R峰

plot(R,l2_f(R),'o','color','g'); %R峰
plot(R_z,l2_f(R_z),'s','color','y'); %R峰











c=medfilt1(l2(1:320000),330);
l2_med1=l2(1:320000)-c;
c=medfilt1(l2(320001:end),401);
l2_med2=l2(320001:end)-c;
l2_med=[l2_med1;l2_med2];
l2_med(320000:320001)=l2(1:320000);
l2_part=l2(1:320000);
plot(l2_med,'r');
hold on
plot(l2,'b');

l2_ma= filter_baseline(l2);
hold on
plot(l2_ma,'r');

c=medfilt1(l2(1:320000),330);
l2_med3=l2(1:320000)-c;
plot(l2_med3,'r');
hold on
plot(l2(1:320000),'b');
plot(l2_med1,'g');

R_m=Rpeak_find(l2_med3);
t=0:1/360:((320000-1)*1/360);
plot(t,l2(1:320000),'k',t,l2_med3,'r'); grid;
