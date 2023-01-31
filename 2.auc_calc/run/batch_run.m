clear;
clc;
close all;
addpath('E:\wupeixuan\auc_plot')

filefolder = 'E:\wupeixuan\auc_plot\data\auc2 series_0412';% 一级目录地址
% 二级目录
aninumlist =  {{'Esr24','Esr237','Esr240','Esr235','Esr254','Esr256','St187','St188','St1817'},...%'Esr24','Esr237','Esr240','Esr235','Esr254','Esr256','St187','St188','St1817'
    {'Esr29','Esr222','Esr229','Esr230','Esr252','St181','St1823','St1825','St1819'}};%'Esr29','Esr222','Esr229','Esr230',

for gender = 1:2
    p = 0;
    for i = 1:length(aninumlist{gender})
        aa{i} = read_file_with_samename(filefolder,aninumlist{gender}{i});
        for j = 1:length(aa{i}) 
            p=p+1;
            filelist = dir(aa{i}{j});
            filelist = {filelist.name};
            ind_prime_mat = contains(filelist, 'prime_raw.csv');
            num2 = xlsread([aa{i}{j},'\',filelist{find(ind_prime_mat == 1,1)}],1,'A4:A5');%获取帧率
            if num2(2) - num2(1)>0.15
                Fs = 5;
            else
                Fs = 10;
            end
            auc_plot(aa{i}{j},false, false,Fs,gender-1,0.99,{},18,0.8,2,6,[0.7 0.3])%运行aucplot
            close all
        end
    end
end
