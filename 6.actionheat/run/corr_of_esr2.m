% function [num_save,auclist,nname] = heatplotprefernew(filefolder,aninum)

clear; clc; 
% close all;

filefolder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\4_new';
stateslist = {'Esr2m','Esr2f'};
for f = 1:length(stateslist)
maxallf{f} = [];maxallsf{f} = [];maxallef{f} = [];maxallbf{f} = [];
    [aa{f},datelist{f}] = read2filenew(filefolder,stateslist{f});
    for kk = 1:length(aa{f})
        [result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderandcellchoose(aa{f}{kk});
% show(neuron)

rtrace = zscore(trace,[],2);
% rtrace = dec_data;

% 找所有female cue
femalelist = [];malelist = [];
intruderl = neuron.intruder_label;
actionidx{1} = find(contains(neuron.action_label,'positive'));
if contains(stateslist{f},'f')
    actionidx{2} = find(contains(neuron.action_label,'mounted'));
else
    actionidx{2} = find(contains(neuron.action_label,'mount'));
end
actionidx{3} = find(contains(neuron.action_label,'intro'));
actionidx{4} = find(contains(neuron.action_label,'ejacu'));

for i = 1:length(intruderl)
if contains(lower(intruderl{i}),'bedding')||contains(lower(intruderl{i}),'toy')||...
    contains(lower(intruderl{i}),'pup')||contains(lower(intruderl{i}),'obj')
elseif contains(lower(intruderl{i}),'f')
    femalelist = [femalelist,i];
elseif ~contains(lower(intruderl{i}),'cas')
    malelist = [malelist,i];
end
end
if contains(stateslist{f},'f')
    cuelist = malelist;
else
    cuelist = femalelist;
end
% 找第一个有ejaculate的cue,去除后续female cue
intruderl = neuron.intruder_label;
for i = cuelist
    if ~isempty(neuron.intruder_action{i,actionidx{4}})
        cuechoose = i;
        cuelist = cuelist(cuelist<=i);
        break
    end
end


%% settings
usedlist = plotstrspl(neuron);
basestart = usedlist(1);
baseend = basestart+180;
act = neuron.intruder(:,1);
Fs = neuron.Fs;
ttick = (1:size(dec_data,2)) / Fs;
nname = neuron.name;
[nneuron,nframe] = size(rtrace);
%% neuPick
Spick = auc_result_7.h_signifi(:,actionidx{1},cuelist(1));
Mpick = auc_result_7.h_signifi(:,actionidx{2},cuelist(end));
Ipick = auc_result_7.h_signifi(:,actionidx{3},cuelist(end));
Epick = auc_result_7.h_signifi(:,actionidx{4},cuelist(end));

MIpick = Mpick|Ipick;
%%
if contains(aa{f}{kk},'Esr2')
    bothpick = Spick&Epick;
%     otherpick2 = ~(Spick|Epick)&MIpick;
    otherpick = ~(Spick|Epick);
    Apick = Spick&~bothpick; 
    Bpick = Epick&~bothpick;
elseif contains(aa{f}{kk},'St18')
    bothpick = Spick&MIpick;
    otherpick = ~(Spick|MIpick);
    Apick = Spick&~bothpick;
    Bpick = MIpick&~bothpick;
end

tRise = neuron.events{1,actionidx{1}}(find(neuron.events{1,actionidx{1}}(:,1) >= neuron.intruder(cuelist(1),1),1),1);
tEnd = neuron.events{1,actionidx{1}}(find(neuron.events{1,actionidx{1}}(:,1) >= neuron.intruder(cuelist(1),1),1),2);
tDur = tEnd - tRise;
tlen = nframe;
flag2{1} = revertTTL2bin(tRise, tDur, Fs, tlen);
tRise = neuron.events{1,actionidx{4}}(1,1);
tEnd = neuron.events{1,actionidx{4}}(1,2);
tDur = tEnd - tRise;
flag2{2} = revertTTL2bin(tRise, tDur, Fs, tlen);
for i = 1:length(flag2)
    Acelltrace{i} = rtrace(Apick,flag2{i});
    Bcelltrace{i} = rtrace(Bpick,flag2{i});
    bothcelltrace{i} = rtrace(bothpick,flag2{i});
end

for i = 1:length(flag2)
    maxsf{f}{kk}(:,i) = mean(Acelltrace{i},2);
    maxef{f}{kk}(:,i) = mean(Bcelltrace{i},2);
    maxbf{f}{kk}(:,i) = mean(bothcelltrace{i},2);
end
maxf{f}{kk} = [maxsf{f}{kk};maxbf{f}{kk};maxef{f}{kk}];
maxallf{f} = [maxallf{f};maxf{f}{kk}];
maxallsf{f} = [maxallsf{f};maxsf{f}{kk}];
maxallef{f} = [maxallef{f};maxef{f}{kk}];
maxallbf{f} = [maxallbf{f};maxbf{f}{kk}];
% figure()
% hold on;
% % plot(maxsf{f}{kk}(:,1),maxsf{f}{kk}(:,2),'or')
% % plot(maxbf{f}{kk}(:,1),maxbf{f}{kk}(:,2),'og')
% % plot(maxef{f}{kk}(:,1),maxef{f}{kk}(:,2),'ob')
% plot(maxef{f}{kk}(:,1),maxef{f}{kk}(:,2),'ob')
    end
end
hfig = figure();
set(gcf,'Position',[300,300,500,500])
axis([-2 8 -2 15])
colorlist = {[0,0,0.6],[1,0.3,0.1]};
for f = 1:2
[mlvsmF{f},pmlvsmF{f}]=corrcoef(maxallf{f}(:,1),maxallf{f}(:,2));
hold on;
h1 = scatter(maxallf{f}(:,1),maxallf{f}(:,2),'o','MarkerEdgeColor',colorlist{f});
% plot(maxallbf{f}(:,1),maxallbf{f}(:,2),'.','color',colorlist{f})
% plot(maxallef{f}(:,1),maxallef{f}(:,2),'.','color',colorlist{f})
set(h1, 'MarkerEdgealpha',0.4)

pn = polyfit(maxallf{f}(:,1),maxallf{f}(:,2),1);
yy=polyval(pn,maxallf{f}(:,1));
plot(maxallf{f}(:,1),yy,'color',colorlist{f},'linewidth',1.5)
text(0,15-f*2,['r = ',num2str(mlvsmF{f}(1,2))],'fontsize',20,'color',colorlist{f})
text(0,14-f*2,['p = ',num2str(pmlvsmF{f}(1,2))],'fontsize',20,'color',colorlist{f})
end
xlabel('mean first sniff ΔF(zscore)')
ylabel('mean ejaculation ΔF(zscore)')
set(gca,'Fontsize',20)

savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
for f = 1:2
    xlswrite([savedir,'\datafile\figs5_hm_corr.xlsx'],{'sniff','ejaculation'},stateslist{f},'A1')
    xlswrite([savedir,'\datafile\figs5_hm_corr.xlsx'],maxallf{f},stateslist{f},'A2')
end
hfig.Renderer = 'Painters';
hfig.PaperSize = [20,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0515materials\newactioncorr\action_corr_of',stateslist{f}(1:4),'.pdf']);

