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
points=length(s_orign);                                    %采样点数
%level=4;                                           %分解层数为4层_maxweller 
ecgdata=X;
signal=ecgdata(1:1*points);         %将ecgdata的数据一个个导入到数组 signal中
%四层分解
                                      % 第一层分解的 逼近系数a1和小波系数w1
a1=zeros(1,points);
w1=zeros(1,points);
                                      % 第二层分解的 逼近系数a1和小波系数w1
a2=zeros(1,points);
w2=zeros(1,points);
                                      % 第三层分解的 逼近系数a1和小波系数w1
a3=zeros(1,points);
w3=zeros(1,points);
                                      % 第四层分解的 逼近系数a1和小波系数w1
a4=zeros(1,points);
w4=zeros(1,points);

% *******************  小波分解部分  ********************** %
%第一层分解，是从第4点开始的，前三个点的值为零
%其余层分解，是从第25点开始的，前24个点的值为零
%注意 2^0 = 1
% ******************************************************** %
for i=1:points-3           
  a1(i+3)= 1/4*signal(i+3- 2^0*0) + 3/4*signal(i+3- 2^0*1) + 3/4*signal(i+3- 2^0*2)+ 1/4*signal(i+3- 2^0*3);
  w1(i+3)= -1/4*signal(i+3- 2^0*0) - 3/4*signal(i+3- 2^0*1) + 3/4*signal(i+3- 2^0*2) + 1/4*signal(i+3- 2^0*3);
end
                                  %这儿对于C语言的设计，可以采用矩阵法进行设计  
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


% *******************   找出每一层的极大值点和极小值点  ********************%
%  对于C语言法，可以采用矩阵来做
%  每个层的寻找方法是一样的 
%  极值寻找函数的设计 maximum_value_find
% m_w_1，m_w_2，m_w_3，m_w_4等就是各层的极值点，不是极值点的值变为0。
% ************************************************************************%
%先分配了一个空间
%m_w_1 = zeros(1,points);
%m_w_2 = zeros(1,points);
%m_w_3 = zeros(1,points);
%m_w_4 = zeros(1,points);

m_w_1 = maximum_value_find(w1,points);      %%找出每层的极值点找出来：（真实数值）
%m_w_2 = maximum_value_find(w2,points);
m_w_3 = maximum_value_find(w3,points);
m_w_4 = maximum_value_find(w4,points);

% ***************   极值的阈值处理    ******************* %
%  p_n_v_3 极值点阈值处理 输出的是-1,0，1的值，是为了下一步的极值对的寻找做准备
%p_n_v_3 = zeros(1,points);  
[p_n_v_3,threshold] = threshold_process(m_w_3,points);  %只计算第三层的

% ***************                找出极值对           ****************** %
%%找到 更精确极值对位置，其它位置置零 让-1,1配对出现
%再设计找所需的极值对时，这儿还是出现的多余的极值对，这应该是与采样率的设计有关。
% ************************************************************************%

%position_3 = zeros(1,points);
position_3 = find_m_pair(p_n_v_3,points); 


% ************ 求正负极值对过零，即R波峰值，并检测出QRS波起点及终点 ***** %
%输出的是 各个特征点的位置坐标
% ************************************************************************%

[R_1,count,count2,count3]= find_zeros (m_w_1,m_w_3,position_3,points);

%************************删除多检点，补偿漏检点**************************%
num2=1;
while(num2~=0)   %一直运行到，没有多检点为止
   num2=0;
   R_1=find(count);   %j=3,过零点
   R_R=R_1(2:length(R_1))-R_1(1:length(R_1)-1); %过零点间隔
   RRmean=mean(R_R);
   
% 当两个R波间隔小于0.4RRmean时,去掉值小的R波
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
  
%当发现R波间隔大于1.6RRmean时,减小阈值,在这一段检测R波
for i=2:length(R_1)
    if (R_1(i)-R_1(i-1))>1.6*RRmean
        Mjadjust=m_w_4(R_1(i-1)+80:R_1(i)-80);    %利用第四层分解的
        points2=(R_1(i)-80)-(R_1(i-1)+80)+1;
%求正极大值点
        adjustposi=Mjadjust.*(Mjadjust>0);
        adjustposi=(adjustposi>threshold(1)/4);    %原来的阈值减小
%求负极大值点
        adjustnega=Mjadjust.*(Mjadjust<0);
        adjustnega=-1*(adjustnega<threshold(2)/5);    %原来的阈值减小
%将 adjustposi 和 adjustnega 合在一起  interva4=adjustposi+adjustnega;

adjust_after = zeros(1,points2);
for k=1:points2  %注意变量别交叉使用了
    if adjustposi(k) ~=0 
        adjust_after(k) = adjustposi(k);
    else if adjustnega(k) ~=0 
         adjust_after(k) = adjustnega(k);
        else
          adjust_after(k) = 0;  
        end
    end
end      

%找出非0点       
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
  for k_2=1:length(loca3)-1   %diff的长度少了一个
  diff2(k_2) = adjust_after(loca3(k_2)) - adjust_after(loca3(k_2+1));  %这两个位置的逻辑数相减 。这个运算很重要（包含1-1，-1-1,1-（-1））
  end
  
 % 以上都正确         
% 如果有极大值对,找出极大值对 
% 将diff=-2的位置记录下来
position2 = zeros(1,length(diff2));   %随便先给一个长度
position3 = zeros(1,length(diff2)); 
     j_b=1;
for k_3=1:length(diff2)
    if diff2(k_3) == -2
      position2(j_b)= loca3(k_3);  %将极小值的位置记录下来
      position3(j_b)= loca3(k_3+1);%将极大值的位置记录下来
      j_b = j_b + 1;
    end
end
      j_b = j_b - 1;    
  position_21 = position2(1:j_b);
  position_31= position3(1:j_b);
% 这样就可以找所需要的负极大值点、正极大值点了

 position4 = zeros(1,points2); 
 position5 = zeros(1,points2); 

for k_4= 1: points2
    for k_5=1:length(position_21)
        if k_4 == position_21(k_5)
             position4(k_4) = k_4;   %将负极大值的位置提取出来
        else if k_4 == position_31(k_5)
             position5(k_4) = k_4;   %将正极大值的位置提取出来
            end
         end
    end  
end

% 将找到的负极大值点、正极大值点整合在一起。
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
       
%求过零点
       % mark4=0;
       % mark5=0;
       % mark6=0;
        j=1;
    while j<points2   %这儿找了很久，才发现 j自己没定义。
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

%************************精确R波峰 和 QRS波位置**************************%

% QRS起点的横坐标
Qstart=[];
for m=1:points    %  c2num=size(count2); for m=1:c2num(2)  
    if count2(m)==-1
        Qstart=[Qstart,m];  %其实是语法问题，也就是 Qstart=m,生成数组
    end
end
%QRS终点的横坐标
Send=[];
for m=1:points      % c3num=size(count3); for m=1:c3num(2)  
    if count3(m)==-1
        Send=[Send,m];   %其实是语法问题，也就是 Send=m 生成数组
    end
end
%检测R点
QRSnum=size(R_1);
R=[];
for m=1:(QRSnum(2)-1)
     a=Qstart(m);
     c=Send(m);
     [~, r0]=max(X(1,a:c));
     r=a+r0-1;
     R=[R,r];  %其实是语法问题，也就是 R=r 生成数组
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
%      plot(R,X(R),'o'); %R峰
% end
% %检测Q点、R点和S点
% Q=[];
% S=[];
% for m=1:QRSnum(2)
%     a=Qstart(m);
%     b=R(m);
%     c=Send(m);
%     [yQ q0]=min(X(1,a:b));  %这儿又是在搜索最低点  yQ是数值，q0是最小值的位置。
%     [yS s0]=min(X(1,b:c));  %这儿又是在搜索最低点
%     q=a+q0-1;
%     Q=[Q,q];    %其实是语法问题，也就是 Q=q 生成数组
%     s=b+s0-1;
%     S=[S,s];    %其实是语法问题，也就是 S=s 生成数组
% end
% 
%
% % ************************    画图    **************************%
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
%      plot(R,X(R),'o'); %R峰
%     plot(Q,X(Q),'o'); %R峰
%     plot(S,X(S),'o'); %R峰
%     plot(Y);          %QRS波段
%     ylabel('s_orign');
%     title('R波检测') ;



