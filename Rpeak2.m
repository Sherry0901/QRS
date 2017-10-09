function R=Rpeak2(s_orign) 


%%%%%% ************** self data  ************** %%%%%%   
% dt = xlsread('self_data.xlsx');
% s_orign=dt(1:WIDTH,1);
% ref_value =250;
% **************************************** % 

%%%%%% ************** ICC_ECG_data  ************** %%%%%%  
% a = textread(filename, '%s')'; 
% s_i=hex2dec(a);
%s_i = load('rec_ECG.txt');
% s_i = load(filename);
 %s_orign=l2;
% sfreq =125;
 %ref_value =250;
% **************************************** % 

X=s_orign';
points=length(s_orign);                                    %��������
%level=4;                                           %�ֽ����Ϊ4��_maxweller 
ecgdata=X;
signal=ecgdata(1:1*points);         %��ecgdata������һ�������뵽���� signal��
%�Ĳ�ֽ�
                                      % ��һ��ֽ�� �ƽ�ϵ��a1��С��ϵ��w1
a1=zeros(1,points);
w1=zeros(1,points);
                                      % �ڶ���ֽ�� �ƽ�ϵ��a1��С��ϵ��w1
a2=zeros(1,points);
w2=zeros(1,points);
                                      % ������ֽ�� �ƽ�ϵ��a1��С��ϵ��w1
a3=zeros(1,points);
w3=zeros(1,points);
                                      % ���Ĳ�ֽ�� �ƽ�ϵ��a1��С��ϵ��w1
a4=zeros(1,points);
w4=zeros(1,points);

% *******************  С���ֽⲿ��  ********************** %
%��һ��ֽ⣬�Ǵӵ�4�㿪ʼ�ģ�ǰ�������ֵΪ��
%�����ֽ⣬�Ǵӵ�25�㿪ʼ�ģ�ǰ24�����ֵΪ��
%ע�� 2^0 = 1
% ******************************************************** %
for i=1:points-3           
  a1(i+3)= 1/4*signal(i+3- 2^0*0) + 3/4*signal(i+3- 2^0*1) + 3/4*signal(i+3- 2^0*2)+ 1/4*signal(i+3- 2^0*3);
  w1(i+3)= -1/4*signal(i+3- 2^0*0) - 3/4*signal(i+3- 2^0*1) + 3/4*signal(i+3- 2^0*2) + 1/4*signal(i+3- 2^0*3);
end
                                  %�������C���Ե���ƣ����Բ��þ��󷨽������  
j=2;
for i=1:points-24
a2(i+24)=1/4*a1(i+24-2^(j-1)*0)+3/4*a1(i+24-2^(j-1)*1)+3/4*a1(i+24-2^(j-1)*2)+1/4*a1(i+24-2^(j-1)*3);
w2(i+24)=-1/4*a1(i+24-2^(j-1)*0)-3/4*a1(i+24-2^(j-1)*1)+3/4*a1(i+24-2^(j-1)*2)+1/4*a1(i+24-2^(j-1)*3);
end
j=3;
for i=1:points-24
a3(i+24)=1/4*a2(i+24-2^(j-1)*0)+3/4*a2(i+24-2^(j-1)*1)+3/4*a2(i+24-2^(j-1)*2)+1/4*a2(i+24-2^(j-1)*3);
w3(i+24)=-1/4*a2(i+24-2^(j-1)*0)-3/4*a2(i+24-2^(j-1)*1)+3/4*a2(i+24-2^(j-1)*2)+1/4*a2(i+24-2^(j-1)*3);
end


j=4;
for i=1:points-24
a4(i+24)=1/4*a3(i+24-2^(j-1)*0)+3/4*a3(i+24-2^(j-1)*1)+3/4*a3(i+24-2^(j-1)*2)+1/4*a3(i+24-2^(j-1)*3);
w4(i+24)=-1/4*a3(i+24-2^(j-1)*0)-3/4*a3(i+24-2^(j-1)*1)+3/4*a3(i+24-2^(j-1)*2)+1/4*a3(i+24-2^(j-1)*3);
end

%   figure(1);
%   subplot(4,1,1);plot(w1,'LineWidth',2);ylabel('w1');
%   subplot(4,1,2);plot(w2,'LineWidth',2);ylabel('w2');
%   subplot(4,1,3);plot(w3,'LineWidth',2);ylabel('w3');
%   subplot(4,1,4);plot(w4,'LineWidth',2);ylabel('w4');


% *******************   �ҳ�ÿһ��ļ���ֵ��ͼ�Сֵ��  ********************%
%  ����C���Է������Բ��þ�������
%  ÿ�����Ѱ�ҷ�����һ���� 
%  ��ֵѰ�Һ�������� maximum_value_find
% m_w_1��m_w_2��m_w_3��m_w_4�Ⱦ��Ǹ���ļ�ֵ�㣬���Ǽ�ֵ���ֵ��Ϊ0��
% ************************************************************************%
%�ȷ�����һ���ռ�
%m_w_1 = zeros(1,points);
%m_w_2 = zeros(1,points);
%m_w_3 = zeros(1,points);
%m_w_4 = zeros(1,points);

m_w_1 = maximum_value_find(w1,points);      %%�ҳ�ÿ��ļ�ֵ���ҳ���������ʵ��ֵ��
%m_w_2 = maximum_value_find(w2,points);
m_w_3 = maximum_value_find(w3,points);
m_w_4 = maximum_value_find(w4,points);

% ***************   ��ֵ����ֵ����    ******************* %
%  p_n_v_3 ��ֵ����ֵ���� �������-1,0��1��ֵ����Ϊ����һ���ļ�ֵ�Ե�Ѱ����׼��
%p_n_v_3 = zeros(1,points);  
[p_n_v_3,threshold] = threshold_process(m_w_3,points);  %ֻ����������

% ***************                �ҳ���ֵ��           ****************** %
%%�ҵ� ����ȷ��ֵ��λ�ã�����λ������ ��-1,1��Գ���
%�����������ļ�ֵ��ʱ��������ǳ��ֵĶ���ļ�ֵ�ԣ���Ӧ����������ʵ�����йء�
% ************************************************************************%

%position_3 = zeros(1,points);
position_3 = find_m_pair(p_n_v_3,points); 


% ************ ��������ֵ�Թ��㣬��R����ֵ��������QRS����㼰�յ� ***** %
%������� �����������λ������
% ************************************************************************%

[R_1,count,count2,count3]= find_zeros (m_w_1,m_w_3,position_3,points);

%************************ɾ�����㣬����©���**************************%
num2=1;
while(num2~=0)   %һֱ���е���û�ж���Ϊֹ
   num2=0;
   R_1=find(count);   %j=3,�����
   R_R=R_1(2:length(R_1))-R_1(1:length(R_1)-1); %�������
   RRmean=mean(R_R);
   
% ������R�����С��0.4RRmeanʱ,ȥ��ֵС��R��
for i=2:length(R_1)
    if (R_1(i)-R_1(i-1))<=0.4*RRmean
        num2=num2+1;
        if signal(R_1(i))>signal(R_1(i-1))
            count(R_1(i-1))=0;
        else
            count(R_1(i))=0;
        end
    end
end
end

num1 = 2;
while(num1>0)
   num1=num1-1;
   R_1=find(count);
   R_R=R_1(2:length(R_1))-R_1(1:length(R_1)-1);
   RRmean=mean(R_R);
  
%������R���������1.6RRmeanʱ,��С��ֵ,����һ�μ��R��
for i=2:length(R_1)
    if (R_1(i)-R_1(i-1))>1.6*RRmean
        Mjadjust=m_w_4(R_1(i-1)+80:R_1(i)-80);    %���õ��Ĳ�ֽ��
        points2=(R_1(i)-80)-(R_1(i-1)+80)+1;
%��������ֵ��
        adjustposi=Mjadjust.*(Mjadjust>0);
        adjustposi=(adjustposi>threshold(1)/4);    %ԭ������ֵ��С
%�󸺼���ֵ��
        adjustnega=Mjadjust.*(Mjadjust<0);
        adjustnega=-1*(adjustnega<threshold(2)/5);    %ԭ������ֵ��С
%�� adjustposi �� adjustnega ����һ��  interva4=adjustposi+adjustnega;

adjust_after = zeros(1,points2);
for k=1:points2  %ע������𽻲�ʹ����
    if adjustposi(k) ~=0 
        adjust_after(k) = adjustposi(k);
    else if adjustnega(k) ~=0 
         adjust_after(k) = adjustnega(k);
        else
          adjust_after(k) = 0;  
        end
    end
end      

%�ҳ���0��       
        j_a=1;
loca3_1 = zeros(1,points2);
for k_1=1:points2
    if adjust_after(k_1) ~=0
      loca3_1(j_a) = k_1;
      j_a = j_a + 1;
    end
end
      j_a = j_a - 1; 
  loca3 = loca3_1(1:j_a);
   
  diff2=zeros(1,length(loca3)-1);
  for k_2=1:length(loca3)-1   %diff�ĳ�������һ��
  diff2(k_2) = adjust_after(loca3(k_2)) - adjust_after(loca3(k_2+1));  %������λ�õ��߼������ ������������Ҫ������1-1��-1-1,1-��-1����
  end
  
 % ���϶���ȷ         
% ����м���ֵ��,�ҳ�����ֵ�� 
% ��diff=-2��λ�ü�¼����
position2 = zeros(1,length(diff2));   %����ȸ�һ������
position3 = zeros(1,length(diff2)); 
     j_b=1;
for k_3=1:length(diff2)
    if diff2(k_3) == -2
      position2(j_b)= loca3(k_3);  %����Сֵ��λ�ü�¼����
      position3(j_b)= loca3(k_3+1);%������ֵ��λ�ü�¼����
      j_b = j_b + 1;
    end
end
      j_b = j_b - 1;    
  position_21 = position2(1:j_b);
  position_31= position3(1:j_b);
% �����Ϳ���������Ҫ�ĸ�����ֵ�㡢������ֵ����

 position4 = zeros(1,points2); 
 position5 = zeros(1,points2); 

for k_4= 1: points2
    for k_5=1:length(position_21)
        if k_4 == position_21(k_5)
             position4(k_4) = k_4;   %��������ֵ��λ����ȡ����
        else if k_4 == position_31(k_5)
             position5(k_4) = k_4;   %��������ֵ��λ����ȡ����
            end
         end
    end  
end

% ���ҵ��ĸ�����ֵ�㡢������ֵ��������һ��
 position6 = zeros(1,points2); 
 for k_6=1:points2
     if position4(k_6) ~=0
        position6(k_6) = -1;
     else if position5(k_6) ~=0 
         position6(k_6) = 1;
         else
          position6(k_6)=0; 
         end
     end
 end
   posi_adjust = position6;
       
%������
       % mark4=0;
       % mark5=0;
       % mark6=0;
        j=1;
    while j<points2   %������˺ܾã��ŷ��� j�Լ�û���塣
         if posi_adjust(j)==-1;
            mark4=j;
            j=j+1;
            while(j<points2 && posi_adjust(j)==0)
                 j=j+1;
            end
            mark5=j;
            mark6= round((abs(Mjadjust(mark5))*mark4+mark5*abs(Mjadjust(mark4)))/(abs(Mjadjust(mark5))+abs(Mjadjust(mark4))));
            count(R_1(i-1)+80+mark6-10)=1;
            j=j+60;
         end
         j=j+1;
     end
    end
 end
end

%************************��ȷR���� �� QRS��λ��**************************%

% QRS���ĺ�����
Qstart=[];
for m=1:points    %  c2num=size(count2); for m=1:c2num(2)  
    if count2(m)==-1
        Qstart=[Qstart,m];  %��ʵ���﷨���⣬Ҳ���� Qstart=m,��������
    end
end
%QRS�յ�ĺ�����
Send=[];
for m=1:points      % c3num=size(count3); for m=1:c3num(2)  
    if count3(m)==-1
        Send=[Send,m];   %��ʵ���﷨���⣬Ҳ���� Send=m ��������
    end
end
%���R��
QRSnum=size(R_1);
R=[];
for m=1:(QRSnum(2)-1)
     a=Qstart(m);
     c=Send(m);
     [~, r0]=max(X(1,a:c));
     r=a+r0-1;
     R=[R,r];  %��ʵ���﷨���⣬Ҳ���� R=r ��������
end
end
% fid=fopen('Rpeak.txt','w+');
% for i=int32(1):length(R)
%     
% fprintf(fid,'%d\r\n',R(i));
% end
% fclose(fid);
%    figure(1);
%      plot(X,'r');
%      hold on;
%      plot(R,X(R),'o'); %R��
% end
% %���Q�㡢R���S��
% Q=[];
% S=[];
% for m=1:QRSnum(2)
%     a=Qstart(m);
%     b=R(m);
%     c=Send(m);
%     [yQ q0]=min(X(1,a:b));  %���������������͵�  yQ����ֵ��q0����Сֵ��λ�á�
%     [yS s0]=min(X(1,b:c));  %���������������͵�
%     q=a+q0-1;
%     Q=[Q,q];    %��ʵ���﷨���⣬Ҳ���� Q=q ��������
%     s=b+s0-1;
%     S=[S,s];    %��ʵ���﷨���⣬Ҳ���� S=s ��������
% end
% 
%
% % ************************    ��ͼ    **************************%
%     num=size(Qstart);
%     Y=zeros(1,points );
%     for i=1:num(2)
%         for j=Qstart(i):Send(i)
%             Y(j)= ref_value;
%         end
%     end
%      figure(1);
%      plot(X,'r');
%      hold on;
%      plot(R,X(R),'o'); %R��
%     plot(Q,X(Q),'o'); %R��
%     plot(S,X(S),'o'); %R��
%     plot(Y);          %QRS����
%     ylabel('s_orign');
%     title('R�����') ;



