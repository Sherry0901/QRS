function result=showresult(s_orign,num,R,R_realPeak)
%close all;
R_com=[R;R_realPeak];
R_com=sort(R_com);
j=1;
R_num=length(R_com);
a=0;
for i=2:R_num-1
    if abs(R_com(i)-R_com(i-1))>11 && abs(R_com(i+1)-R_com(i))>11
        a(j)=R_com(i);
        j=j+1;
    end
end
% j=j-1;
% true-positive (TP) when an
% R-peak is correctly detected by the proposed algorithm, falsenegative
% (FN) when an R-peak is missed, and false-positive (FP)
% when a noise spike is detected as R-peak.
%Se represents the percentage of correctly detected heartbeats, while PP represents the percentage of detected heartbeats that are actually true.

FP=sum(ismember(a,R));
 FN=sum(ismember(a,R_realPeak));
 TP=length(R_realPeak)-FN;
 Se=TP/(TP+FN)*100; %SN
 Acc=TP/(TP+FN+FP)*100;
 PP=TP/(TP+FP)*100; %+P
%  indices={'beats';'TP';'FP';'Se';'Acc';'PP'};
result=[length(R_realPeak);TP;FN;FP;Se;Acc;PP]';
%  colName={'indices','Number'};
%  indtable=table(indices,number,'VariableNames',colName)
fp_posi=ismember(a,R).* a;
fp_posi(fp_posi==0)=[]; %%将0元素删除
fn_posi=ismember(a,R_realPeak).* a;
fn_posi(fn_posi==0)=[]; %%将0元素删除


 figure(1)
% subplot(2,1,1);
plot(s_orign,'b');hold on
plot(fp_posi,s_orign(fp_posi),'*','color','R'); %R峰误检  
plot(fn_posi,s_orign(fn_posi),'o','color','k'); %R峰漏检
s_orign_below=s_orign-4.5;
% subplot(2,1,2);
plot(s_orign_below,'b');hold on
plot(R_realPeak,s_orign_below(R_realPeak),'o','color','k'); %R峰
plot(R,s_orign_below(R),'*','color','r'); %R峰
%title('*为检测出的R波位置，O为标注位置');
title([num2str(num),'上图*为误检，O为漏检,下图*为检测出的R波位置，O为标注位置']);
end
 
 

