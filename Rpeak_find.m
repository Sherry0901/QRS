%读入静止时的心电数据
function R=Rpeak_find(raw_ecg)
% raw_ecg=l2;
%滤波系数取9到11比较合适
ecg_baseline_plus_T_wave=medfilt1(raw_ecg,10);

ecg_QRS_only=raw_ecg-ecg_baseline_plus_T_wave;
% plot(ecg_QRS_only);
%利用qrs_only波进行QRS波探测
%[max_R,maxl]=findpeaks(ecg_QRS_only,'minpeakdistance',100,'minpeakheight',50); %max_R峰峰值点  maxl：峰峰值点对应的位置   最小间隔=100 峰值最小高度=50
% for i = 1:length(raw_ecg)
%     if i<length(raw_ecg)-8   % 分段取R_R间期
%         R_R1 = (Rwave_place(i+1)-Rwave_place(i))+(Rwave_place(i+2)-Rwave_place(i+1))+(Rwave_place(i+3)-Rwave_place(i+2))+(Rwave_place(i+4)-Rwave_place(i+3));
%         R_R2 = (Rwave_place(i+5)-Rwave_place(i+4))+(Rwave_place(i+6)-Rwave_place(i+5))+(Rwave_place(i+7)-Rwave_place(i+6))+(Rwave_place(i+8)-Rwave_place(i+7));
%         R_Rav=(R_R1+R_R2)/8;
%     end
[~,maxl]=findpeaks(ecg_QRS_only,'minpeakdistance',30,'minpeakheight',0.2);
R=maxl;
end
