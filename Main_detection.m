
clc;
clear; 

%************************** 特征提取进入*****************************************%
% dt = load('D:\DWT\A_Last_Searching\特征提取_2016.11.12\特征提取_程序_for_lab_2017.5.5\处理过的数据\2017.5.16 rec_ECG_noname1.txt');
% dt = load('D:\DWT\A_Last_Searching\特征提取_2016.11.12\特征提取_程序_for_lab_2017.5.5\处理过的数据\2017.5.16 rec_ECG_dny.txt');
% dt = load('D:\DWT\A_Last_Searching\特征提取_2016.11.12\特征提取_程序_for_lab_2017.5.5\处理过的数据\2017.5.16 rec_ECG_lz.txt');
% dt = load('D:\DWT\A_Last_Searching\特征提取_2016.11.12\特征提取_程序_for_lab_2017.5.5\处理过的数据\陈土改.txt');
 %%% R波检测主程序设计 %%  
  s_orign=l2;
 Rwave_place= detection_Rwave(s_orign);

 
%%%%%% 2017.05.16添加了以下辅助检测部分 %%%%%%%%%%
%%%  防漏检程序设计 %%%%%
      k=1;
      m=1;
  for i = 1:length(Rwave_place)  
    if i<length(Rwave_place)-8   % 分段取R_R间期
       R_R1 = (Rwave_place(i+1)-Rwave_place(i))+(Rwave_place(i+2)-Rwave_place(i+1))+(Rwave_place(i+3)-Rwave_place(i+2))+(Rwave_place(i+4)-Rwave_place(i+3));
       R_R2 = (Rwave_place(i+5)-Rwave_place(i+4))+(Rwave_place(i+6)-Rwave_place(i+5))+(Rwave_place(i+7)-Rwave_place(i+6))+(Rwave_place(i+8)-Rwave_place(i+7));
       R_Rav=(R_R1+R_R2)/8;
    end
      R_p(k)=Rwave_place(m);
     if i<length(Rwave_place)-1
         if(Rwave_place(i+1)-Rwave_place(i))>R_Rav*1.5  %当R_R间期过大时，判定为有可能漏检
               z=1;B=0;posi=0;l=1;
         for x=Rwave_place(i)+10:Rwave_place(i+1)-10
             A=s_orign(x);
             if B<A
                 B=A; posi=x;
             else
                 posi=posi;
             end
             z=z+1;
         end
          k=k+1;R_p(k)=posi; % 进行漏检补偿
     end
     k=k+1;m=m+1;
     end  
  end
%%%  防误检程序设计 %%%%% 
      j=2;
for i = 1:length(R_p) 
     if i<length(R_p)-3 % 分段求R波峰平均值
        peak = s_orign(R_p(i))+s_orign(R_p(i+1))+s_orign(R_p(i+2))+s_orign(R_p(i+3));
        Rpeak=peak/4;
     end
     Rlast(1)= R_p(1);
     if i>1
       if (s_orign(R_p(i))< Rpeak*0.5)  % 当R波幅度较小时，判断为误检
%            if(R_p(i+1)-R_p(i))>R_Rav*0.98
%               Rlast(j)= R_p(i);
%               j=j+1;
%            end
       else
       Rlast(j)= R_p(i);
       j=j+1;
       end
     end
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%  当大于R_Rav*1.5没有R波时，提取出这个波段  %%%%%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      k=1;
      m=1;
  for i = 1:length(Rlast)  
    if i<length(Rlast)-8   % 分段取R_R间期
       R_R1 = (Rlast(i+1)-Rlast(i))+(Rlast(i+2)-Rlast(i+1))+(Rlast(i+3)-Rlast(i+2))+(Rlast(i+4)-Rlast(i+3));
       R_R2 = (Rlast(i+5)-Rlast(i+4))+(Rlast(i+6)-Rlast(i+5))+(Rlast(i+7)-Rlast(i+6))+(Rlast(i+8)-Rlast(i+7));
       R_Rav=(R_R1+R_R2)/8;
    end
     if i<length(Rlast)-1
         if(Rlast(i+1)-Rlast(i))>R_Rav*1.5  %当R_R间期过大时，判定为有可能漏检
            for x=Rlast(i)-10:Rlast(i+1)+10
                R_miss(k)=x;
                 k=k+1;
            end
         end
     end  
  end


figure(1)
plot(s_orign,'b');
hold on;
plot(Rlast,s_orign(Rlast),'*','color','R'); %R峰
hold on;
%将《没有R波》或《R波较小》的波段标记出来，用蓝色曲线标记，用于医生查看
plot(R_miss,s_orign(R_miss),'*','color','R');
%为了方便看波形限制了一下Y轴范围
ylim([-40 100]);  
  
  
% s_orign1=s_orign/5+100;
% w31=w3/20+90;
% w41=w4/20+80;
% figure(2)
% plot(s_orign1,'r');
% hold on;
% plot(Rlast,s_orign1(Rlast),'o'); %R峰
% hold on;
% plot(w31); 
% hold on;
% plot(w41); 
% % set(gca,'xtick',0:1:6);
% ylim([60 120]);
% subplot(2,1,1);plot(s_orign);ylabel('s_orign1');
% subplot(2,1,2);plot(w3,'r');ylabel('s_rec'); 






% plot(Rwave_place,s_orign(Rwave_place),'o'); %R峰
%plot(Q,X(Q),'o'); %Q点
%plot(S,X(S),'o'); %Q点
%plot(Y);          %QRS波段



