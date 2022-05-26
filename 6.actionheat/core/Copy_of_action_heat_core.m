
% clear; clc; 
% close all;
% 
% filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St181\St1810108';
% gender = 'male';
% colorlim = 100;
% savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0420materials';

function Copy_of_action_heat_core(acheat)

filefolder = acheat.filefolder;
gender = acheat.gender;
colorlim = acheat.colorlim;
savedir = acheat.savedir;




[result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
rtrace = trace(2:end,:);
show(neuron)

actionidx{1} = find(contains(neuron.action_label,'positive'));
actionidx{2} = find(contains(neuron.action_label,'mounting'));
if contains(gender,'fe')
    actionidx{2} = find(contains(neuron.action_label,'mounted'));
end
actionidx{3} = find(contains(neuron.action_label,'intro'));
if isempty(actionidx{3})
    actionidx{3} = find(contains(neuron.action_label,'lordosis'));
end
actionidx{4} = find(contains(neuron.action_label,'ejacu'));
intruderl = neuron.intruder_label;
[cuelist,cuelist2] = searchcuebeforemating(intruderl,actionidx{4},neuron);
if contains(gender,'fe')
    cuelist = cuelist2;
end


%% settings
act = neuron.intruder(:,1);
Fs = neuron.Fs;
ttick = (1:size(dec_data,2)) / Fs;
[nneuron,nframe] = size(rtrace);



Spick = auc_result_7.h_signifi(:,actionidx{1},cuelist(1));
Mpick = auc_result_7.h_signifi(:,actionidx{2},cuelist(end));
Ipick = auc_result_7.h_signifi(:,actionidx{3},cuelist(end));
Epick = auc_result_7.h_signifi(:,actionidx{4},cuelist(end));
MIpick = Mpick|Ipick;
%%
tRise1 = neuron.intruder(cuelist(1),1);tEnd1 =  neuron.intruder(cuelist(1),2);
tDur = tEnd1 - tRise1;
tlen = nframe;
flag1 = revertTTL2bin(tRise1, tDur, Fs, tlen);
tRise = neuron.intruder(cuelist(end),1);tEnd =  neuron.intruder(cuelist(end),2);
tDur = tEnd - tRise;
tlen = nframe;
flag2 = revertTTL2bin(tRise, tDur, Fs, tlen);

Scelltrace = rtrace(Spick,flag1);
Mcelltrace = rtrace(Mpick,flag2);
Icelltrace = rtrace(Ipick,flag2);
Ecelltrace = rtrace(Epick,flag2);

    

%% 挑细胞
% for i = 1:length(cuttime)
% [Scelltrace{i}, Mcelltrace{i},bothcelltrace{i}] = changecells_for_actionheat(Scelltrace{i}, Mcelltrace{i},bothcelltrace{i},delcell);
% end

neuroncount = [size(Scelltrace,1),size(Mcelltrace,1),size(Icelltrace,1),size(Ecelltrace,1),length(Spick)];
alllength1 = size(Scelltrace,1);
alllength2 = size(Mcelltrace,1)+ size(Icelltrace,1)+ size(Ecelltrace,1)+2;
%
hfig = figure('color', 'w','Position',[300 100 1000 800]);
subplot(3,1,1)
hold on;
imagesc(Scelltrace, 'xdata', [0,sum(flag1)/Fs], 'ydata', [1 size(Scelltrace,1)])
for ii = 1:size(neuron.action_label,2)%画行为颜色
    if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mount')||...
         contains(lower(neuron.action_label{ii}),'intro')||contains(lower(neuron.action_label{ii}),'lordo')||contains(lower(neuron.action_label{ii}),'ejac')
    event_now = neuron.events{ii} - neuron.intruder(cuelist(1),1); %centered by event-action
    indOK = event_now(:,1) >= 0 & event_now(:,2) <= sum(flag1)/Fs;
    event_OK = event_now(indOK, :);
    if isempty(event_OK); continue; end
    hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 0.5-alllength1/10],neuron.color{ii});
    set(hi, 'facealpha', 1);
    end
end
cbh = colorbar;
colormap jet
set(cbh, 'Ticks', -30:10:70, 'FontSize', 20, 'TickLength', 0.02);
cbh.Position = [0.92  0.25 0.02 0.40];
set(gca, 'clim',[-colorlim/20 colorlim],'FontSize',20)
axis ij
axis tight
box off

subplot(3,1,2:3)
hold on;
imagesc(Mcelltrace, 'xdata', [0,sum(flag2)/Fs], 'ydata', [1 size(Mcelltrace,1)])
imagesc(Icelltrace, 'xdata', [0,sum(flag2)/Fs], 'ydata', [1 size(Icelltrace,1)]+size(Mcelltrace,1)+1)
imagesc(Ecelltrace, 'xdata', [0,sum(flag2)/Fs], 'ydata', [1 size(Ecelltrace,1)]+size(Mcelltrace,1)+size(Icelltrace,1)+2)
for ii = 1:size(neuron.action_label,2)%画行为颜色
    if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mount')||...
         contains(lower(neuron.action_label{ii}),'intro')||contains(lower(neuron.action_label{ii}),'lordo')||contains(lower(neuron.action_label{ii}),'ejac')
    event_now = neuron.events{ii} - neuron.intruder(cuelist(end),1); %centered by event-action
    indOK = event_now(:,1) >= 0 & event_now(:,2) <= sum(flag2)/Fs;
    event_OK = event_now(indOK, :);
    if isempty(event_OK); continue; end
    hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 0.5-alllength2/10],neuron.color{ii});
    set(hi, 'facealpha', 1);
    end
end
cbh = colorbar;
colormap jet
set(cbh, 'Ticks', -30:10:70, 'FontSize', 20, 'TickLength', 0.02);
cbh.Position = [0.92  0.25 0.02 0.40];
set(gca, 'clim',[-colorlim/20 colorlim],'FontSize',20)
axis ij
axis tight
box off
xlabel(['S:',num2str(neuroncount(1)),'___M:',num2str(neuroncount(2)),'___I:',num2str(neuroncount(3)),'___E:',num2str(neuroncount(4)),'___ALL:',num2str(neuroncount(5))])
suptitle(neuron.name)



hfig.Renderer = 'Painters';
hfig.PaperSize = [30,15];
% saveas(gcf,[savedir,'\fig2_',neuron.name,'_normalizedF_',num2str(colorlim),'.pdf']);


end