function  heatplotbase(filefolder,tracechoose,stateslist,animallist)

% clear; clc; 
% close all;
% 
% filefolder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3data\1_forheatbase\virgin\Esr2300622';
% tracechoose = 1;
% stateslist = 'virgin';
% animallist = {'Esr222','Esr229','Esr230'};
[filefolder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderandcellchoose(filefolder);%%%

ztrace = zscore(trace,0,2);%%%
Fs = neuron.Fs;tlen = neuron.nframe/Fs;
for i = 1:length(animallist)
    if contains(neuron.name,animallist{i})
        animalidx = animallist{i};
    end
end
% intruder = neuron.intruder;
actionidx{1} = find(contains(neuron.action_label,'positive'));
actionidx{2} = find(contains(neuron.action_label,'mounting'));
actionidx{3} = find(contains(neuron.action_label,'intro'));
actionidx{4} = find(contains(neuron.action_label,'ejacu'));
intruderl = neuron.intruder_label;
baselist = plotstrspl(neuron);
tDur1 = 60;
flag2 =  revertTTL2bin(baselist(1), tDur1, Fs, tlen);
baseline = trace(:,flag2);
bntrace = (trace - mean(baseline,2))./std(baseline,0,2);%%%
%% 总共有三种数据源，1-rawtrace;2-dectrace;3-ztrace;4-basenormalizedtrace
usedtrace = {trace,dec_data,ztrace,bntrace};%%%%%
clim = {[-5,70],[-5,70],[-5,10],[-2,8]};
% if ~isempty(actionidx{4})
%     [cuelist,~] = searchcuebeforemating(intruderl,actionidx{4},neuron);
%     ejacutime = neuron.intruder_action{cuelist(end),actionidx{4}};
%     flag = revertTTL2bin(ejacutime, tDur1, Fs, tlen);
% 	for i = 1:size(usedtrace{tracechoose},1)
%         peaklocate(i) = find(usedtrace{tracechoose}(i,flag)  == max(usedtrace{tracechoose}(i,flag)),1);       
% 	end
%     [~, peaksort] =sort(peaklocate,'ascend');
%     usedtrace{tracechoose}= usedtrace{tracechoose}(peaksort,:);
%     useddata = usedtrace{tracechoose}(:,flag);
%     hfig = figure('color', 'w','Position',[600 300 280 320]);
%     haxes = matlab.graphics.axis.Axes.empty(0);
%     imagesc(useddata, 'xdata', [0,tDur1], 'ydata', [1 size(useddata,1)])
%     hold on;
%     for ii = 1:size(neuron.action_label,2)%画行为颜色
%         if  contains(lower(neuron.action_label{ii}),'ejaculation')
%         event_now = neuron.events{ii} - ejacutime; %centered by event-action
%         indOK = event_now(:,1) >= 0 & event_now(:,2) <= tDur1;
%         event_OK = event_now(indOK, :);
%         if isempty(event_OK); continue; end
%         hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 -1],[0.4, 0, 0.8]);
%         set(hi, 'facealpha', 1);
%         end
%     end
%     colormap jet
%     title([neuron.name,' ',stateslist,' after'])
%      set(gca, 'clim',clim{tracechoose})
%     axis ij
%     axis tight
%     box off
%     hfig.Renderer = 'Painters';
% %     saveas(hfig,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0302dec_data\',stateslist,'\',neuron.name,'_heatafter.pdf']);
% 
% else
% % 	for i = 1:size(usedtrace{tracechoose},1)
% %         peaklocate(i) = find(usedtrace{tracechoose}(i,flag2)  == max(usedtrace{tracechoose}(i,flag2)),1);       
% % 	end
% %     [~, peaksort] =sort(peaklocate,'ascend');
% %     usedtrace{tracechoose}= usedtrace{tracechoose}(peaksort,:); 
% end
    useddata2 = usedtrace{tracechoose}(:,flag2);

    hfig = figure('color', 'w','Position',[300 300 280 300]);
    haxes = matlab.graphics.axis.Axes.empty(0);
    imagesc(useddata2, 'xdata', [0,tDur1], 'ydata', [1 size(useddata2,1)])
    hold on;
    title([animalidx,' ',stateslist,' before'])
    colormap jet
%     cbh = colorbar;
%     cbh.Position(3:4) = [0.02 0.80];
%     cbh.Position(1) = .94-cbh.Position(3);
%     cbh.Position(2) = 0.5-cbh.Position(4)/2;
%     set(cbh, 'Ticks', -5:10:45, 'FontSize', 12, 'TickLength', 0);

    set(gca, 'clim',clim{tracechoose})
    axis ij
    axis tight
    box off
    hfig.Renderer = 'Painters';
%     saveas(hfig,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0302dec_data\',stateslist,'\',neuron.name,'_heatbefore.pdf']);
end







