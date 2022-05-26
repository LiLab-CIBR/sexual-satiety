

%% 清除
clear;
clc;
close all;
%% 全局变量


%% 1

clusterlist = {'control','inhibition'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\mx-Esr2 M-F c&I';
name = 'fig3_mno_data_temp2';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
is_ttest_only = true;
is_paired_ttest = false;
ttest_group = {[1,2]};
%% 2
clusterlist = {'E-V-CNO','E-Munip-CNO'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\Esr2_4di_satiated';
name = 'figs12_bcdef_data';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
is_ttest_only = true;
is_paired_ttest = false;
ttest_group = {[1,2]};
%% 3
clusterlist = {'E-V','E-CNO'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\Esr2-4di-female-satiated';
name = 'figs12_hijk_data';
gender = 'female';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
is_ttest_only = true;
is_paired_ttest = false;
ttest_group = {[1,2]};
%% 4
clusterlist = {'E-V-ZD7288','E-Munip_Zd7288'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\drug deliver';
name = 'figs13_bcdef_data';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
is_ttest_only = true;
is_paired_ttest = false;
ttest_group = {[1,2]};
%% 5
clusterlist = {'control','experiment'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\female drug deliver';
name = 'figs5_mn_data';
gender = 'female';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
is_ttest_only = true;
is_paired_ttest = false;
ttest_group = {[1,2]};

%% 6
clusterlist = {'day1-1','day1-2','day2-7','day14+gai'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\with ejaculation female-Ves';
name = 'temp';
gender = 'female';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
is_ttest_only = true;
is_paired_ttest = false;
ttest_group = {[1,2]};

%% 1.确定EXCEL地址和分类，读EXCEL文件
%这一步之后尽量别用clear，会清除掉读取的数据

xls.excel_folder = excel_folder;
xls.clusterlist = clusterlist;
xls.name = name;
xls.gender = gender;

%跑这一步
[beh.form_label,beh.events,beh.datelist] = LoadBehFromExcel(xls);
beh.clusterlist =clusterlist;
beh.name = name;
beh.gender = gender;
save ([savedir,'\mfile\',name,'.mat'], 'beh')
%% 直接读
name = 'figs1_mnop_data';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
load ([savedir,'\mfile\',name,'.mat'], 'beh')
clusterlist = beh.clusterlist;
name = beh.name;
gender = beh.gender;
is_ttest_only = true;
is_paired_ttest = false;
ttest_group = {[1,2]};

%% 2.画行为图并保存

beh.clusterlist =clusterlist;
beh.name = name;
%要改的
beh.isdivide = false;%是不是画分行
beh.behaviorlist = {'passive','mount','intro','lordo','flee','sitting','ejacu'};%目前上限7个，第一个是sniff，最后一个是ejaculation
% beh.behaviorlist = {'positive','mount','intro','ejacu'};%目前上限7个，第一个是sniff，最后一个是ejaculation
% beh.behaviorlist = {'positive','mount','intro','ejacu'};%目前上限7个，第一个是sniff，最后一个是ejaculation
beh.savedir = savedir;
% beh.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0421DZY\0503drug deliver\E';

% beh.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0418control_app';
%beh.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\4 states with ejaculation\0417';%自己改
%beh.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\without ejaculation male\0414';%自己改
%beh.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\with ejaculation female\0412 ves\new';%自己改
%beh.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\Fe_Esr2_hM4Di';%自己改
beh.xlength = 2400;%全长多少秒

%跑这一步
DrawBehFig(beh);

%% 3.画N种统计图并保存
%%%%%%%%%%%%%%%%%%%%%%%%% 更新;behbar.timewindow 可以用来调整雄性sniff dur percent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
behbar.name = name;
behbar.clusterlist = clusterlist;
behbar.form_label = beh.form_label;
behbar.events = beh.events;
behbar.gender = gender;
  
%要改的
behbar.is_ttest_only = is_ttest_only;
behbar.is_paired_ttest = is_paired_ttest;
behbar.ttest_group = ttest_group;
behbar.timewindow = 10;%分钟
behbar.savedir = savedir;
%跑这一步
PlotBehBar(behbar);
   
%% 4.画transition并保存

transition.name = name;
transition.clusterlist = clusterlist;
transition.form_label = beh.form_label;
transition.events = beh.events;
transition.behaviorlist = beh.behaviorlist;


%要改的
transition.is_ttest_only = is_ttest_only;
transition.is_paired_ttest = is_paired_ttest;
transition.ttest_group = ttest_group;

transition.dobehmerge = true;%要不要把行为合并（比如flee away和sitting）
transition.mergebehidx = [4,5];%要合并的行为在behaviorlist中的序号
transition.mergedname = 'reject';%合并后的行为名

transition.constimewindow = 10;%分钟,计算mount之后？时间的transition
transition.constimecuttranslist = {{'mount','reject'}};%from在前to在后 {'mount','lordo'},

transition.timewindow = 10;%分钟,计算第一个行为之后？时间的transition
transition.timecuttranslist = {{'passive','mount'}};%from在前to在后
transition.savedir = savedir;
% transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0421DZY\0503drug deliver\E'
% transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0421DZY\mx-drug deliver';
% transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\Esr2-chemo\mx_mf_esr2-0419';%自己改
% transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\with ejaculation female\0412 ves\new';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\Fe_Esr2_hM4Di';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\with ejaculation female';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0406 control&con\0407\new';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0407control_app';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\without ejaculation female';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0406 control&con';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\4 states with ejaculation';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\without ejaculation male\0405';%自己改

%跑这一步
[transbar.transmatrix,transbar.pvalue,transbar.behaviorlist,transbar.cmatrix] = DrawTranstion(transition);

transbar.behaviorlist

%% 5.画N种transition统计图并保存
 b
transbar.name = name;   
transbar.clusterlist = clusterlist;
transbar.events = beh.events;
transbar.is_ttest_only = is_ttest_only;
transbar.ttest_group = ttest_group;


%要改的
transbar.translist = {[1,2],[2,3]};%要画transition bar的行为在newbehaviorlist中的序号
transbar.savedir = savedir;
% transbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0421DZY\mx-drug deliver'
% transbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\with ejaculation female\0412 ves\new';%自己改
%transbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\Fe_Esr2_hM4Di';%自己改
%transbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0407control_app';%自己改
%transbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\4 states with ejaculation\0405';%自己改
%transbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\without ejaculation male';%自己改

%跑这一步
PlotTransBar(transbar);

