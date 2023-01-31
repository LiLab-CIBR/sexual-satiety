%%
%pre step of box_*.m

%% 
clear;
% close all;

 


%% Esr2m

%% 1
%数据地址
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220511';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0509';
%colorbar范围
singleprefer.colorlim =100;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [19 ];
singleprefer.changecell.move_to_female_cellidx = [18,29,30];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [2];
hppn{1}{1} = single_heat(singleprefer);

%% 2
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290616';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim =140;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [24,25,26,27,52,53];
singleprefer.changecell.move_to_female_cellidx = [23];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [1,3,7,8,12,15,28,30,32,33,36];
hppn{1}{2} =single_heat(singleprefer);

%% 3
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300626';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim =90;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [13,14,20,21];
singleprefer.changecell.move_to_female_cellidx = [];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [7];
hppn{1}{3} =single_heat(singleprefer);

%% 4
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr29\Esr290203';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim =100;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [19,20,21];
singleprefer.changecell.move_to_female_cellidx = [];
singleprefer.changecell.move_to_male_cellidx = [17,18];
singleprefer.changecell.move_to_both_cellidx = [23,1,2,7,14];
hppn{1}{4} =single_heat(singleprefer);

%% 5
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr252\Esr2520214';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim =45;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [24];
singleprefer.changecell.move_to_female_cellidx = [11,21,22,23];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [13];
hppn{1}{5} =single_heat(singleprefer);



%% Esr2f

%% 1
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr240\Esr2401214';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim =35;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [14,15];
singleprefer.changecell.move_to_female_cellidx = [];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [6];
hppn{2}{1} =single_heat(singleprefer);

%% 2
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr237\Esr2371227';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim = 45;
%用不用both数据
singleprefer.useboth = false;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [];
singleprefer.changecell.move_to_female_cellidx = [];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [1,2];
hppn{2}{2} =single_heat(singleprefer);

%% 3
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr24\Esr240115';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim = 90;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [];
singleprefer.changecell.move_to_female_cellidx = [20];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [1,11,20];
hppn{2}{3} =single_heat(singleprefer);

%% 4
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr254\Esr2540218';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim = 45;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [13,15,16];
singleprefer.changecell.move_to_female_cellidx = [];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [12];
hppn{2}{4} =single_heat(singleprefer);

%% 5
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr235\Esr2350218';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim = 30;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [9];
singleprefer.changecell.move_to_female_cellidx = [];
singleprefer.changecell.move_to_male_cellidx = [16,17];
singleprefer.changecell.move_to_both_cellidx = [];
hppn{2}{5} =single_heat(singleprefer);



%% St18m

%% 1
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St181\St1810109';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim =50;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [5];
singleprefer.changecell.move_to_female_cellidx = [10,12];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [6];
hppn{3}{1} =single_heat(singleprefer);

%% 2
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St1823\St18230823';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0509';
%colorbar范围
singleprefer.colorlim = 50;
%用不用both数据
singleprefer.useboth =true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [6,9,10];
singleprefer.changecell.move_to_female_cellidx = [17];
singleprefer.changecell.move_to_male_cellidx = [18];
singleprefer.changecell.move_to_both_cellidx = [11,13];
hppn{3}{2} = single_heat(singleprefer);


%% St18f

%% 1
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St187\St1870310';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim = 45;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [4,15];
singleprefer.changecell.move_to_female_cellidx = [];
singleprefer.changecell.move_to_male_cellidx = [48,50];
singleprefer.changecell.move_to_both_cellidx = [1,2,3,4,5,6,7,8,10,16,17,18,19,20,21,22,23,24,28,29,31];
hppn{4}{1} = single_heat(singleprefer);

%% 2
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St188\St1880317';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim = 35;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [10];
singleprefer.changecell.move_to_female_cellidx = [];
singleprefer.changecell.move_to_male_cellidx = [16,17];
singleprefer.changecell.move_to_both_cellidx = [1,2,3,5,7,8];
hppn{4}{2} = single_heat(singleprefer);
%% 3
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St1817\St18170630';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim = 45;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [5,8,9];
singleprefer.changecell.move_to_female_cellidx = [24];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [1,2,6,7];
hppn{4}{3} = single_heat(singleprefer);

%% not used
singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St1819\St18190824';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim =50;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =true;%false;true
singleprefer.changecell.delcellidx = [9];
singleprefer.changecell.move_to_female_cellidx = [8];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [4];
single_heat(singleprefer);

singleprefer.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St181\St1810323';
%存储地址
singleprefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar范围
singleprefer.colorlim =50;
%用不用both数据
singleprefer.useboth = true;%false;true
%画不画trace和pie
singleprefer.draw_trace_and_pie = true;%false;true
%删除/挪动细胞（再重新排序）
singleprefer.changecell.dochange =false;%false;true
singleprefer.changecell.delcellidx = [9];
singleprefer.changecell.move_to_female_cellidx = [8];
singleprefer.changecell.move_to_male_cellidx = [];
singleprefer.changecell.move_to_both_cellidx = [4];
hppn{3}{1} =single_heat(singleprefer);

%% save
% savefile = ['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out\mfile\hppn5523_2.mat'];
% save(savefile,'hppn')

