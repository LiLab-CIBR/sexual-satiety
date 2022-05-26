function [amp,frequencies] = basecalc(aa)

[~,trace, ~, ~, neuron, auc_result_7, auc_result_3] = loadfolderandcellchoose(aa);%%%
Fs = neuron.Fs;
tlen = neuron.nframe/Fs;
tDur1 = 180;
%获取baseline的trace
baselist = plotstrspl(neuron);
flag2 =  revertTTL2bin(baselist(1), tDur1, Fs, tlen);
rawbase = trace(:,flag2);
%根据去除大于平均值加一倍SD的“noise”重新计算平均值和SD
[nneuron,nframe] = size(rawbase);
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
[nneuron,nframe] = size(decusedtrace);
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

end
