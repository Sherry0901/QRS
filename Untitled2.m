

for i=100:234
    
  
 clc;clear;close all;   
ecg_anns = rdann('108', 'atr');
num={ecg_anns.sampleNumber}';

type={ecg_anns.typeMnemonic}';
fid=fopen('114_ann_ActualPeak.txt','w+');
for i=1:length(num)
fprintf(fid,'%d\t%s\r\n',num{i},type{i});
end

   Records = rdsamp('108', 'phys', true);       % ∑µªÿµÁ—π÷µ  
   fid=fopen('114_dat_MLII.txt','w+');
for i=1:length(Records)
fprintf(fid,'%.3f\r\n',Records(i,3));
end
a=Records(:,3);
figure(1)
plot(a)
hold on
plot(Records(:,2));