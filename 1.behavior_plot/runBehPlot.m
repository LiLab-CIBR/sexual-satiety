clear;clc;close all;

%% settings

clusterlist = {'control','experiment'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\sgHCn1 M2M';
name = 'sgHCn1 M2M';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221008temp\sgHCn1 M2M';
mkdir(savedir)
mkdir([savedir,'/mfile'])
mkdir([savedir,'/datafile'])
mkdir([savedir,'/picfile'])
is_ttest_only = false; 
is_paired_ttest = false;
ttest_group = {[1,2]};

%% Step1: Read data from behavior excel file
% do not use "clear" after this step unless sure to overwrite the data

xls.excel_folder = excel_folder;
xls.clusterlist = clusterlist;
xls.name = name;

[beh.form_label,beh.events,beh.datelist] = S1_LoadBehFromExcel(xls,savedir);%run

%% Step2: Draw behaviors by time

beh.clusterlist =clusterlist;
beh.name = name;
beh.ismerge = true;% whether merge heaviors into one line
%¡ýno more than 7 behaviors;the fisrt beh must be sniff and the last one must be ejaculation
% beh.behaviorlist = {'passive','mounted','lordo','flee','sitting','ejacu'};% female adjusted and used
% beh.behaviorlist = {'sniff','mount','intro','ejacu'}; some old excel adjusted and used, mainly male
beh.behaviorlist = {'positive','mounting','intro','ejacu'};% male adjusted and used
beh.savedir = savedir;
beh.xlength = 2400;%seconds, defining the length of x-axis

S2_DrawBehFig(beh);%run

%% Step3: Draw statistics bar by cluster

behbar.name = name;
behbar.clusterlist = clusterlist;
behbar.form_label = beh.form_label;
behbar.events = beh.events;
behbar.gender = gender;
behbar.is_ttest_only = is_ttest_only;
behbar.is_paired_ttest = is_paired_ttest;
behbar.ttest_group = ttest_group;
behbar.timewindow = 10;% min, restrict the timewindow of certain variables
behbar.savedir = savedir;

S3_PlotBehBar(behbar);%run
   
%% Step4: Draw transition

transition.name = name;
transition.clusterlist = clusterlist;  
transition.form_label = beh.form_label;
transition.events = beh.events;
transition.behaviorlist = beh.behaviorlist;
transition.is_ttest_only = is_ttest_only;
transition.is_paired_ttest = is_paired_ttest;
transition.ttest_group = ttest_group;
transition.dobehmerge = false;% whether merge 2 behaviors into 1 to calc transition, now just used for female rejact beh
transition.mergebehidx = [4,5];% idx of beh in "beh.behaviorlist" above
transition.mergedname = 'reject';% name of merged beh
transition.constimewindow = 10;%min, transition timewindow after first mount (consummptary phase)
transition.constimecuttranslist = {{'mounting','intro'}};%{{¡¾from¡¿},{¡¾to¡¿}}
transition.timewindow = 10;%min, transition timewindow after first given beh
transition.timecuttranslist = {{'positive','mounting'}};%{{¡¾from¡¿},{¡¾to¡¿}}
transition.savedir = savedir;

[transbar.transmatrix,transbar.pvalue,transbar.behaviorlist,transbar.cmatrix] = S4_DrawTranstion(transition);%run

%% Step4 plus: Draw transition bar without timewindow
transbar.behaviorlist
transbar.name = name; 
transbar.clusterlist = clusterlist;
transbar.events = beh.events;
transbar.is_ttest_only = is_ttest_only;
transbar.ttest_group = ttest_group;
transbar.translist = {[1,2]};%beh idx in "transbar.behaviorlist"
transbar.savedir = savedir;

S4p_PlotTransBar(transbar);%run

%% End

