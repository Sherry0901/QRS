clc;clear;close all;
mydir='E:\����\�о���\����ʧ���б��ٴ�ʵ��\MATLAB����\������ȡ\MIT-BIH����\';
mydir2='E:\����\�о���\����ʧ���б��ٴ�ʵ��\MATLAB����\������ȡ\MIT-BIH�����������\';
j=1; %||type(i)==(' ')"
for num=100:234
    filename=[mydir,num2str(num),'_ann_ActualPeak.txt'];
    type=[];
    R_realPeak=[];
    if (exist(filename)~=0)
        [R_realPeak type]=textread(filename,'%d%s');
        filename2=[mydir2,num2str(num),'_ann_Peak.txt'];
        
        type=char(type);
        for i=1:length(type)
            if type(i)==('~')||type(i)==('+')||type(i)==('|')||type(i)==('"')||type(i)==('!')||type(i)==('(')||type(i)==(')')||type(i)==('[')||type(i)==(']')||type(i)==('x')
                type(i)='0';
                R_realPeak(i)='0';
            end            
        end
        type(find(type=='0'))=[]; %%��0Ԫ��ɾ��
        R_realPeak(find(R_realPeak=='0'))=[]; %%��0Ԫ��ɾ��
        fid=fopen(filename2,'w+');
        for m=1:length(type)
            fprintf(fid,'%d\t%s\r\n',R_realPeak(m),type(m));
        end
        fclose(fid);
     %   pause(0.1);
        tract(j,1)=num;
        tract(j,2)=length(type);
        j=j+1;
    end
end
filename3=[mydir2,'table.txt'];
        fid=fopen(filename3,'w+');
        for m=1:length(tract)
            fprintf(fid,'%d\t%d\r\n',tract(m,1),tract(m,2));
        end
        fclose(fid);



filename=[mydir,num2str(num),'_dat_MLII.txt'];
l2=load(filename);
plot(l2)
hold on
plot(R_realPeak,l2(R_realPeak),'*','color','R'); %R��
R_realPeak(8)
type(8)
filename3=[mydir,num2str(num),'_ann_ActualPeak.txt'];
 [R_realPeak2 type2]=textread(filename3,'%d%s');
 plot(R_realPeak2,l2(R_realPeak2),'o','color','k'); %R��