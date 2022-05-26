clear
close all

    
result_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3data\2_long';

% % 从csv读
% cd(result_folder);
% filelist = dir(result_folder);
% filelist = {filelist.name};
% ind_prime_mat = contains(filelist, '.csv');
% assert(sum(ind_prime_mat) <= 1); 
% raw_dir = filelist(ind_prime_mat);
% [~, ~, trace_dir] = trace_combine(result_folder,raw_dir);
% [neuron_id, data] = trace_read(trace_dir);

%从mat读
cd(result_folder);
filelist = dir(result_folder);
filelist = {filelist.name};
ind_prime_mat = contains(filelist, 'trace.mat');
assert(sum(ind_prime_mat) <= 1);
trace_dir = fullfile(result_folder,filelist{ind_prime_mat});
[neuron_id, data] = trace_read(trace_dir);


Fs = 10;
tDur1 = 180;
%获取baseline的trace
rawbase = data;
%根据去除大于平均值加一倍SD的“noise”重新计算平均值和SD
[nneuron,nframe] = size(rawbase);
tlen = nframe;
sig_waive_mean = [];
sig_waive_std = [];
for p = 1:nneuron
    flag3 = true(1,nframe);
    outerlist = rawbase(p,:) - mean(rawbase(p,:))-std(rawbase(p,:))>0;
    flag3(1,outerlist) = false;
    sig_waive_mean(p,1) = mean(rawbase(p,flag3));
    sig_waive_std(p,1) = std(rawbase(p,flag3));
end
%使用原始trace去除无峰mean和一倍无峰SD进行dec，获取events
decusedtrace = rawbase - sig_waive_mean-sig_waive_std;
dec_data2 = zeros(nneuron,nframe);
sig_data2 = zeros(nneuron,nframe);
lambda = 1.5;
parfor ii=1:nneuron
        [dec_trace, signal, ~] = deconvolveCa(decusedtrace(ii,:), 'ar1', 'foopsi', 'lambda', lambda, 'optimize_pars');
        dec_data2(ii,:) = dec_trace';
        sig_data2(ii,:) = signal';
end
decevents = sig_data2;
%删除在rawtrace中真实强度小于10倍noise的events
decevents(decevents >0) = 1;
logical(decevents);
newtrace = rawbase.*decevents;
newtrace(newtrace < 10) = 0;
col = {[0 114 178],[0 158 115], [213 94 0],[230 159 0],...
    [86 180 233], [204 121 167], [64 224 208], [240 228 66]}; % colors
cuttime = {[1,1927],[1927,4150],[4151,6220],[6220,8606]};
for paper = 1:5
    hfig = figure('color', 'w','Position',[50,0,2000,5000]);
    for p = 1:8
        y = rawbase(p+paper*8-8,:);
%         c_oasis = dec_data2(p+paper*8-8,:)';
        s_oasis = newtrace(p+paper*8-8,:)';
        for s = 1:4
            subplot(8,4,p*4-4+s)
            hold on;
            plot(y(cuttime{s}(1):cuttime{s}(2)), 'color', col{8}/255);
            alpha(.7);
            plot(s_oasis(cuttime{s}(1):cuttime{s}(2)), '-.', 'color', col{6}/255);
            axis tight;
            set(gca, 'xtick', '');
            title(['neuron_id:',num2str(neuron_id(p+paper*8-8))])
        end
    end
    hfig.Renderer = 'Painters';
    hfig.PaperSize = [50,50];
    saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0425\Esr229all_',num2str(paper),'.pdf']);

end


















%获取事件数和平均强度
for p = 1:size(newtrace,1)
    amp(p) = mean(newtrace(p,newtrace(p,:)>0));
    spikecounts(p) = length(newtrace(p,newtrace(p,:)>0));
    if isnan(amp(p))
        amp(p) = 0;
        spikecounts(p) = 0;
    end
end  
frequencies = spikecounts/tDur1;

