
%%
%fig.S6 BC

%% 

%%% 用于计算并输出persistent/transient/other细胞分类和在ejaculation时的sigmaF
clear;clc;close all

% filefolderlist = { 
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220514', 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220515',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220621','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220625',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220629',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290616','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290623',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290705',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290706',... 
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290816',... 
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300626',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300712',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300714','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300721',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300817',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr252\Esr2520221','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr252\Esr2520316',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr29\Esr290218','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr29\Esr290222',...
% };


savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221001temp';

for matings = 1:length(filefolderlist)
    %% 读文件    
    filefolder = filefolderlist{matings}; 
    [filefolder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);%%%
    aucstemp = aucCalcCut(filefolder);
    %% 参数
    trace = trace(2:end,:);
    if neuron.gender
        gender = 'male';
    else
        gender = 'female';
    end
    Fs = neuron.Fs;
    ejacuidx = find(contains(neuron.action_label,'ejacu'));
    [num_neuron, nframe] = size(dec_data);
    tlen = nframe / Fs;  % total time
    intruderl = neuron.intruder_label;
    [cuelist,cuelist2] = searchcuebeforemating(intruderl,ejacuidx,neuron);
    if contains(gender,'fe')
        cuelist = cuelist2;
    end
    %% ejaculation细胞
    Epick = auc_result_7.h_signifi(:,ejacuidx,cuelist(end));
    % persistent细胞
    perspick = Epick & aucstemp.h_signifi{1}(:,4);
    % transient细胞
    transpick = Epick & ~aucstemp.h_signifi{1}(:,4);
    cellpicklist = perspick+transpick*2;

    %% ejaculation 起止时间
    cuttime = neuron.events{1,ejacuidx}(find(neuron.events{1,ejacuidx}(:,1) > neuron.intruder(cuelist(1),1),1),1);
    cuttime2 = neuron.events{1,ejacuidx}(find(neuron.events{1,ejacuidx}(:,1) > neuron.intruder(cuelist(1),1),1),2);
    
    %% persistent Ecell 的auc和h_sig统计量
    ejacutrace  = mean(trace(:,cuttime*Fs:cuttime2*Fs),2);
    neuronidlist = 1:1:num_neuron;
    outdata = [neuronidlist',cellpicklist,ejacutrace];
    xlswrite([savedir,'\allejacubar_',gender,'.xlsx'],{'neuron_id','celltype','σF'},neuron.name,'A1')
    xlswrite([savedir,'\allejacubar_',gender,'.xlsx'],outdata,neuron.name,'A2')

end





