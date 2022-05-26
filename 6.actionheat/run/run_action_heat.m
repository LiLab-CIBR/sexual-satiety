
clear;
% close all;

%%
%数据地址
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St181\St1810109';
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St181\St1810108';
acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St187\St1870329';
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220514';
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr240\Esr2401214';
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St1817\St18170630';
%存储地址
acheat.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0521materials';
%colorbar范围
acheat.colorlim =50;
%性别
acheat.gender = 'female';%male,female

%删除细胞
% Esr2220514 [1,2,3,47]
%St1870329 [13,14,15,16,17,45,46,47,48,49,50,51,52,53,54]
%St1810109 [21,22]

acheat.delcell = [];
%用第几个mount
%目前使用：Esr2220514 - 27;Esr2401214 - 12;St1810109 - 9;St1870329 - 2;
%St18170630 - 1;St1810108 - 10并挪动90
acheat.mountidx = 2;
%并稍微挪动几秒
acheat.movetime = 0;%second

action_heat_core(acheat);



