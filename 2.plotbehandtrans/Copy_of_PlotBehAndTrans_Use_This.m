

%% 清除
clear;
clc;
close all;
%% 全局变量

%opto control&con phase
clusterlist = {'cons persistent','cons transient','control'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\optogenetic_0228\control_con';
name = 'opto control&con phase';
gender = 'male';

% %W/o ej female
% clusterlist = {'1','2'};
% excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\without ejaculation female';
% name = 'without ejaculation female';
% gender = 'female';

%W ej male
% clusterlist = {'virgin','nsatiated','fsatiated','recovery'};
% excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\4 states with ejaculation';
% name = '4 states with ejaculation';
% gender = 'male';

%W/O ej male
%clusterlist = {'day1','day2','day3'};
%excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\without ejaculation male';
% name = 'without ejaculation male';
% gender = 'male';



%% 1.确定EXCEL地址和分类，读EXCEL文件
%这一步之后尽量别用clear，会清除掉读取的数据
%如果需要的话，把sit变sitting，把单独的sniff变positive/passive，等等

xls.excel_folder = excel_folder;
xls.clusterlist = clusterlist;
xls.name = name;
xls.gender = gender;

% %要改的
% xls.dorefine = true;
%跑这一步
[beh.form_label,beh.events,beh.datelist] = LoadBehFromExcel(xls);


%% 2.画行为图并保存

beh.clusterlist =clusterlist;
beh.name = name;
%要改的
beh.isdivide = false;%是不是画分行
%beh.behaviorlist = {'passive','mount','introm','lordosis','flee','sitting','ejacu'};%目前上限7个，第一个是sniff，最后一个是ejaculation
beh.behaviorlist = {'positive','mounting','introm','ejacu'};%目前上限7个，第一个是sniff，最后一个是ejaculation
beh.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0406 control&con';%自己改
beh.xlength = 2400;%全长多少秒

%跑这一步
DrawBehFig(beh);

%% 3.画N种统计图并保存

behbar.name = name;
behbar.clusterlist = clusterlist;
behbar.form_label = beh.form_label;
behbar.events = beh.events;
behbar.gender = gender;

%要改的
behbar.timewindow = 5;%分钟,这里只有female会用到
behbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0406 control&con';%自己改
%跑这一步
PlotBehBar(behbar);
   
%% 4.画transition并保存

transition.name = name;
transition.clusterlist = clusterlist;
transition.form_label = beh.form_label;
transition.events = beh.events;
transition.behaviorlist = beh.behaviorlist;


%要改的
transition.dobehmerge = false;%要不要把行为合并（比如flee away和sitting）
transition.mergebehidx = [5,6];%要合并的行为在behaviorlist中的序号
transition.mergedname = 'reject';%合并后的行为名
transition.timewindow = 10;%分钟,这里目前只有male会用到
transition.timecuttranslist = {{'positive','mounting'}};%from在前to在后
transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0406 control&con';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\4 states with ejaculation';%自己改
%transition.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\without ejaculation male\0405';%自己改

%跑这一步
[transbar.transmatrix,transbar.pvalue,transbar.behaviorlist] = DrawTranstion(transition);

transbar.behaviorlist

%% 5.画N种transition统计图并保存

transbar.name = name;   
transbar.clusterlist = clusterlist;
transbar.events = beh.events;

%要改的
transbar.translist = {[1,2],[2,3]};%要画transition bar的行为在newbehaviorlist中的序号
transbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\opto_0303\0406 control&con';%自己改
%transbar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\ZXJ_used_20220226\without ejaculation male';%自己改

%跑这一步
PlotTransBar(transbar);

