%%
%fig.S8 BC

%% 
clear;
% close all;


%% for all
prefer.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';%һ��Ŀ¼��ַ

%����Ŀ¼���ɵ�������ĳһֻ����
prefer.clusterlist = {'Esr222','Esr29','Esr229','Esr230','Esr252','Esr24','Esr237','Esr240','Esr235','Esr254','Esr256',...
    'St181','St187','St188','St1817','St1823','St1819','St1825'};%'Esr222','Esr29','Esr229','Esr230','Esr252','Esr24','Esr237','Esr240','Esr235','Esr254','Esr256',
prefer.clusterlist = {'Esr24'};
%�洢��ַ
prefer.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0417';
%colorbar��Χ
prefer.colorlim = 90;

heat_trace_pie(prefer);


