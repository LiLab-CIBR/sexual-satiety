clear;close all
% 务必分步运行，不要一次运行全部
%% Settings
%date
dateidx = 'Esr2300626';% Esr2290616;Esr2220514;Esr2300626;Esr2520221;Esr290218

data_dir = ['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\cellmap\Esr2\',dateidx];
pic_dir = ['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\cellmap\cellimg\',dateidx,'.png'];
position_dir = ['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\cellmap\celldata\',dateidx,'.mat'];
cellcluster = {'sniff','ejaculation','both','other'};%{'persistent','transient','other'};%{'sniff','mount&intro','ejaculation','other'}

%% Step1
cellchoose = cellposS1(data_dir,cellcluster,dateidx);
cellchoose

%% Step2
% please follow the instructions of the readme.md using inscopix for this step

%% Step3
picheight = 173;% pixel

position_data = cellposS3(pic_dir,position_dir,cellcluster,picheight);
