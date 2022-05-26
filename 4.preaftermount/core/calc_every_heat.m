
% filefolder ='E:\wupeixuan\auc_plot\data\aucs_ver3.0\St181\St1810109';
% gender = 'male'
function [cutpresniff4,cutaftersniff4] = calc_every_heat(filefolder,gender,cuelist)
[~,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
rtrace = zscore(trace(2:end,:),[],2);
% show(neuron)

actionidx{1} = find(contains(neuron.action_label,'positive'));
actionidx{2} = find(contains(neuron.action_label,'mounting'));
if contains(gender,'fe')
    actionidx{2} = find(contains(neuron.action_label,'mounted'));
end
actionidx{3} = find(contains(neuron.action_label,'intro'));
actionidx{4} = find(contains(neuron.action_label,'ejacu'));

intruder = neuron.intruder;
Fs = neuron.Fs;
tlen = size(dec_data,2);
intruderl = neuron.intruder_label;
[femalelist,malelist] = searchcuebeforemating(intruderl,actionidx{4},neuron);
if isempty(cuelist)
    
    cuelist = femalelist;
    if contains(gender,'fe')
        cuelist = malelist;
    end
end
for i = 1:length(cuelist)
    %选取对该cue sniff有响应的细胞
    neuronpick{i} = auc_result_7.h_signifi(:,actionidx{1},cuelist(i));
    %确定mount时间，没有mount用3分钟，并且标记为假mount
    mounttime(i) = intruder(cuelist(i),1)+18000;
    truemount(i) = false;
    if ~isempty(actionidx{2})
        if ~isempty(neuron.intruder_action{cuelist(i),actionidx{2}})
            mounttime(i) = neuron.intruder_action{cuelist(i),actionidx{2}}(1);
            truemount(i) = true;
        end
    end
    %统计pre、after的sniff时间
    premountsniff{i} = [neuron.intruder_action{cuelist(i),actionidx{1}}(neuron.intruder_action2{cuelist(i),actionidx{1}}<=mounttime(i)),...
        neuron.intruder_action2{cuelist(i),actionidx{1}}(neuron.intruder_action2{cuelist(i),actionidx{1}}<=mounttime(i))];
    aftermountsniff{i} = [neuron.intruder_action{cuelist(i),actionidx{1}}(neuron.intruder_action2{cuelist(i),actionidx{1}}>mounttime(i)),...
        neuron.intruder_action2{cuelist(i),actionidx{1}}(neuron.intruder_action2{cuelist(i),actionidx{1}}>mounttime(i))];
    if ~isempty(actionidx{4})
        if ~isempty(neuron.intruder_action{cuelist(i),actionidx{4}})
            aftermountsniff{i} = [neuron.intruder_action{cuelist(i),actionidx{1}}(neuron.intruder_action2{cuelist(i),actionidx{1}}>mounttime(i)...
            &neuron.intruder_action2{cuelist(i),actionidx{1}}<neuron.intruder_action{cuelist(i),actionidx{4}}),...
                neuron.intruder_action2{cuelist(i),actionidx{1}}(neuron.intruder_action2{cuelist(i),actionidx{1}}>mounttime(i)...
            &neuron.intruder_action2{cuelist(i),actionidx{1}}<neuron.intruder_action{cuelist(i),actionidx{4}})];
        end
    end
    % pre
    if ~isempty(premountsniff{i})
        ss2{i} = [premountsniff{i}(1,1)-3,premountsniff{i}(1,1)+3];
        for j = 2:length(premountsniff{i}(:,1))
            if premountsniff{i}(j,1) - premountsniff{i}(j-1,1) >= 3
                tempss2 = [premountsniff{i}(j,1)-3,premountsniff{i}(j,1)+3];
                ss2{i} = [ss2{i};tempss2];
            end
        end
        for j = 1:length(ss2{i}(:,1))
            tRise = ss2{i}(j,1);tEnd = ss2{i}(j,2);tDur = tEnd - tRise;
            flagprecut = revertTTL2bin(tRise, tDur, Fs, tlen);
            cutpresniff{i}{j} = rtrace(neuronpick{i},flagprecut);
        end
        for p = 1:sum(neuronpick{i})
            cutpresniff2{i}{p,1} = [];
            for j = 1:length(ss2{i}(:,1))
                cutpresniff2{i}{p} = [cutpresniff2{i}{p};cutpresniff{i}{j}(p,:)];
            end
            cutpresniff3{i}(p,:)  = mean(cutpresniff2{i}{p,1},1);
        end
        cutpresniff4{i} = [];
        for ss1 = 1:size(cutpresniff3{i},1)
            cutpresniff4{i} = [cutpresniff4{i};mean(reshape(cutpresniff3{i}(ss1,:),Fs/5,[]),1)];
        end    

    else
        truemount(i) = false;
    end
    
    % after
    if ~isempty(aftermountsniff{i})
        ss3{i} = [aftermountsniff{i}(1,1)-3,aftermountsniff{i}(1,1)+3];
        for j = 2:length(aftermountsniff{i}(:,1))
            if aftermountsniff{i}(j,1) - aftermountsniff{i}(j-1,1) >= 3
                tempss3 = [aftermountsniff{i}(j,1)-3,aftermountsniff{i}(j,1)+3];
                ss3{i} = [ss3{i};tempss3];
            end
        end
        for j = 1:length(ss3{i}(:,1))
            tRise = ss3{i}(j,1);tEnd = ss3{i}(j,2);tDur = tEnd - tRise;
            flagaftercut = revertTTL2bin(tRise, tDur, Fs, tlen);
            cutaftersniff{i}{j} = rtrace(neuronpick{i},flagaftercut);
        end
        for p = 1:sum(neuronpick{i})
            cutaftersniff2{i}{p,1} = [];
            for j = 1:length(ss3{i}(:,1))
                cutaftersniff2{i}{p} = [cutaftersniff2{i}{p};cutaftersniff{i}{j}(p,:)];
            end
            cutaftersniff3{i}(p,:) = mean(cutaftersniff2{i}{p,1},1);
        end
        cutaftersniff4{i} = [];
        for ss1 = 1:size(cutaftersniff3{i},1)
            cutaftersniff4{i} = [cutaftersniff4{i};mean(reshape(cutaftersniff3{i}(ss1,:),Fs/5,[]),1)];
        end    

    else
        truemount(i) = false;
    end    
    if ~truemount(i)
        cutaftersniff4{i} = [];
        cutpresniff4{i} = [];
    end
end 
%% 计算

end