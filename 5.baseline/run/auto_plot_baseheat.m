clear;
close all;


%一级目录地址
base.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';
%二级目录名称
% base.allclusterlist =  {'Esr29','Esr222','Esr229','Esr230','Esr252','Esr24','Esr237','Esr240','Esr235','Esr254','Esr256'};%{'Esr29','Esr222','Esr229','Esr230'};
base.clusterlist =  {'Esr240'};
%colorbar范围
base.colorlim = 70;
base.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0411singlebase\overall5';

heat_data(base)

% for i = 1:length(base.allclusterlist)
%     base.clusterlist =  {base.allclusterlist{i}};
%     heat_data(base)
% end
