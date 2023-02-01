%%
%fig.S8 D

%% 
clear;
% close all;




preafter.filefolder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\5';%'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\5'
preafter.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0521materials';

preafter.gender = 'male';%male,female
preafter.aninumlist = {'Esr222','Esr229','Esr230','Esr252'};%
% preafter.aninumlist = {'St181','St1823'};
% preafter.aninumlist = {'Esr24','Esr237','Esr240','Esr235','Esr254','Esr256'};
% preafter.aninumlist = {'St187','St188','St1817'};
% 
% preafter.aninumlist = {'Esr2220511','Esr2220514','Esr290218','Esr2290607','Esr2290616','Esr2300626','Esr2300714','Esr2300721','Esr2520221'};%,
% preafter.cuelist = [2,1,2,3,2,3,1,1,2];%,
% preafter.aninumlist = {'St1810108','St1810109','St1810323','St18230820','St18230823','St18230824','St18230831','St18230901'};%,
% preafter.cuelist =  [8,5,3,1,2,3,4,1,1];%,
% preafter.aninumlist = {'St1810323'};%,
% preafter.cuelist = [];%,
% preafter.aninumlist = {'St18230823'};%'St1810108',
% preafter.aninumlist = {'Esr2401214','Esr2540218','Esr2350330'};
% preafter.aninumlist = {'St1870329','St1880401'};

preafter.ylength = 70;
preafter.minunit = 'neuron';%neuron,animal

preafter.firstcue = false;%true,false

comparesniff(preafter)  
% plot_every_heat(preafter)

