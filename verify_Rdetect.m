%����R�������������
clc;clear;close all;
tic;
dir='E:\����\�о���\����ʧ���б��ٴ�ʵ��\MATLAB����\������ȡ\';
% cd (dir)
datadir=[dir,'MIT-BIH����\'];
peakdir=[dir,'MIT-BIH�����������\'];
resultdir=[dir,'��ȡ���ͼƬ_����\'];
sample_rate=360;
% signalnum=zeros(48,1);
% number=zeros(48,1);
colName={'Signal','beats','TP','FN','FP','Se','Acc','PP'};
% table(signalnum,number,'VariableNames',colName)
i=1;
for num=100:234
    datafilename=[datadir,num2str(num),'_dat_MLII.txt'];
    filename2=[peakdir,num2str(num),'_ann_Peak.txt'];
    if  exist(filename2,'file') && exist(datafilename,'file')
        signalnum(i,1)=num;
        
        l2=load(datafilename);
        [R_realPeak type]=textread(filename2,'%d%s');
%         l2_f=filter_baseline(l2);
        R=detection_Rwave(l2,sample_rate);
        Rlast=correction_R(l2,R,sample_rate);
%         result(i,:)=showresult(l2,num,R,R_realPeak);
        result(i,:)=showresult(l2,num,Rlast,R_realPeak);
        saveas(gcf,[resultdir,num2str(num),'.fig']);
        pause(0.01);
        close all;
        i=i+1;
    end
end
result2=[signalnum,result];
resulttable=array2table(result2);
resulttable.Properties.VariableNames=colName;
tabelfile=[resultdir,'result_10_8_correct.xls'];

writetable(resulttable,tabelfile);
toc;
% 964.422452 seconds.
R_realPeak_1=R_realPeak(1:11);
l2_part1=l2(1:4000);
l2_part1_f=filter_baseline(l2_part1);
c=medfilt1(l2_part1,100);
l2_part1_fm=l2_part1-c;
plot(l2_part1,'r');hold on;plot(l2_part1_f,'b');plot(l2_part1_fm,'g');
plot(R_realPeak_1,l2_part1(R_realPeak_1),'o','color','k'); %R��


% % % % % % % % % % % % % % % clinical data 2 byte
mydir=['E:\����\�о���\����ʧ���б��ٴ�ʵ��\�ٴ�ʵ��\8.10\2\�ź���\'];
temp1=dir([mydir,'*.txt']);
packagename=temp1.name;
time=packagename(9:18);
time_date=[time(1:2),'/',time(3:4)];
time_h=str2double(time(5:6));
time_m=str2double(time(7:8));
time_s=str2double(time(9:10));
new_folder = [mydir,'PDF']; % new_folder ����Ҫ�������ļ��У��Ǿ���·��+�ļ�������
mkdir(new_folder);  % mkdir()���������ļ���

filepath=[mydir,packagename];
b=textread(filepath,'%s');
b1=hex2dec(b);
sample_rate=100;
step=0.04*sample_rate;

len=size(b);
num=len(1);
num=num/20;
guo1=reshape(b1,[20,num]);
guo2=guo1(3:20,:);
guo3=reshape(guo2,[6,num*3]);
l1=guo3(1:1,:)*256+guo3(2:2,:);
l2=guo3(3:3,:)*256+guo3(4:4,:);
v1=guo3(5:5,:)*256+guo3(6:6,:);

for i=1:num*3
    if(l1(i)> 32767)
        l1(i)=l1(i)-65536;
    end
    if(l2(i)> 32767)
        l2(i)=l2(i)-65536;
    end
    if(v1(i)> 32767)
        v1(i)=v1(i)-65536;
    end
end

% % % % % % % % % % % % % % % % % % % % %�����ѹ
l1=l1/8388608*4.8/3.5*1000; %�˳����ߵ����ֽڣ�3.5c/4.8*0x800000=b,�����ģ�b��ʵ�ʵ�ѹ��c�ǲɵ�����ֵ,��λ����
l2=l2/8388608*4.8/3.5*1000;
v1=v1/8388608*4.8/3.5*1000;

l1=l1(2456:end)';
l2=l2(2456:end)';
v1=v1(2456:end)';

R=detection_Rwave(l2);
plot(l2,'b');hold on;
plot(R,l2(R),'*','color','R'); %R��


% % % % % % % % % % % % % % % clinical data 3 byte
clear;close all;clc;
% name_pinyin=input('���뻼��������ƴ��:','s');  %
% name=input('���뻼�ߵ�����:','s');
% yunit=1;%����1����10mm/mv,����2����5mm/mv
% name_pinyin='wangtianjun';
% name='�����';
% time='0810144629';
% name_pinyin='guoshuangquan';
% name='��˫Ȫ';
mydir=['E:\����\�о���\����ʧ���б��ٴ�ʵ��\�ٴ�ʵ��\9.12'];
% d = dir(mydir);
% isub = [d(:).isdir]; %# returns logical vector
% nameFolds = {d(isub).name}';
% nameFolds(ismember(nameFolds,{'.','..'})) = [];
sample_rate=100; %����Ƶ��
name='������';

%     name=cell2mat(nameFolds(i));
pacdir=[mydir,'\',name,'\'];
temp1=dir([pacdir,'*.txt']);
packagename=temp1.name;
filepath=[pacdir,packagename];
b=textread(filepath,'%s');  %��ȡ�ļ�����
b1=hex2dec(b);
len=size(b);
num=len(1);
num=num/20;
guo1=reshape(b1,[20,num]);
guo2=guo1(3:20,:);
guo3=reshape(guo2,[9,num*2]);
l1_origin=guo3(1:1,:)*65536+guo3(2:2,:)*256+guo3(3:3,:);
l2_origin=guo3(4:4,:)*65536+guo3(5:5,:)*256+guo3(6:6,:);
v1_origin=guo3(7:7,:)*65536+guo3(8:8,:)*256+guo3(9:9,:);


% % % % % % % % % % % % % % % % % % % % %�����ѹ
l1=(l1_origin/8388608-0.5)*4.8/3.5*1000; %�˳����ߵ����ֽڣ�3.5c/4.8*0x800000=b,�����ģ�b��ʵ�ʵ�ѹ��c�ǲɵ�����ֵ,��λ����
l2=(l2_origin/8388608-0.5)*4.8/3.5*1000;
v1=(v1_origin/8388608-0.5)*4.8/3.5*1000;

l2_f=(filter_baseline(l2'));
c=medfilt1(l2,100);
l2_m=(l2-c)';
R=detection_Rwave(l2_f,sample_rate);
R_m=detection_Rwave(l2_m,sample_rate);
figure(2)
plot(l2_f,'b');hold on;
plot(R,l2_f(R),'*','color','R'); %R��

plot(l2_m,'b');hold on;
plot(R_m,l2_m(R_m),'*','color','R'); %R��

figure(3)
subplot(2,1,1)
plot(l2_f,'b');hold on;
plot(R,l2_f(R),'*','color','R'); %R��
subplot(2,1,2)
plot(l2_m,'b');hold on;
plot(R_m,l2_m(R_m),'*','color','R'); %R��