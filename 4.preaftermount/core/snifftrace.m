
% filefolder ='E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr237\Esr2370215';

function inonemean = snifftrace(filefolder,gender)
[~,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
rtrace = trace(2:end,:);
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
cuelist = femalelist;
if contains(gender,'fe')
    cuelist = malelist;
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
    %拼起来
    if ~isempty(premountsniff{i})
        tRise = premountsniff{i}(:,1);tEnd = premountsniff{i}(:,2);tDur = tEnd - tRise;
        flagpre{i} = revertTTL2bin(tRise, tDur, Fs, tlen);
        mergepresniff{i} = rtrace(neuronpick{i},flagpre{i});
    else
        mergepresniff{i} = 0;
        truemount(i) = false;
    end
    if ~isempty(aftermountsniff{i})
        tRise = aftermountsniff{i}(:,1);tEnd = aftermountsniff{i}(:,2);tDur = tEnd - tRise;
        flagafter{i} = revertTTL2bin(tRise, tDur, Fs, tlen);
        mergeaftersniff{i} = rtrace(neuronpick{i},flagafter{i});
    else
        mergeaftersniff{i} = 0;
        truemount(i) = false;
    end
    %求平均
    meanpre{i} = mean(mergepresniff{i},1);
    meanafter{i} = mean(mergeaftersniff{i},1);
end

%% 计算
inonemean = {};
p=1;
for i = 1:length(cuelist)
    if truemount(i)
    inonemean{p} = [mean(mergepresniff{i},2),mean(mergeaftersniff{i},2)];
    p = p+1;
    end
end
%% plot trace
% hfig = figure('color', 'w','Position',[300 300 500 60+100*length(cuelist)]);
% for i = 1:length(cuelist)
%     subplot(length(cuelist),1,i)
%     hold on;
%     x1 = 1:1:length(meanpre{i});
%     x2 = [length(meanpre{i}),length(meanpre{i})];
%     x3 = (1:1:length(meanafter{i}))+length(meanpre{i});
%     plot(x1,meanpre{i},'k');
%     if truemount(i)
%         plot(x2,[-10,50],'b');
%     else
% %         plot(x2,[-5,10],'r');
%     end
%     plot(x3,meanafter{i},'k');
%     xticks([0,300,600,900,1200,1500])
%     xticklabels({'0','30','60','90','120','150'})
%     axis([0,1500,-5,50])
% end
% suptitle(neuron.name)
% hfig.Renderer = 'Painters';
% hfig.PaperSize = [20,20];
% saveas(gcf,[savedir,'\',neuron.name,'_sniff_trace.pdf']);

end