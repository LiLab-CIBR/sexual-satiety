

%%
%fig.S5 BE

%% 

clear;
% close all;

%%
%data dir
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St181\St1810109';
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St181\St1810108';
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St187\St1870329';
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220514';
% acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr240\Esr2401214';
acheat.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St1817\St18170630';

acheat.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0521materials';
%colorbar范围
acheat.colorlim =50;
%性别
acheat.gender = 'male';%male,female

%删除细胞
% Esr2220514 [1,2,3,47]
%St1870329 [13,14,15,16,17,45,46,47,48,49,50,51,52,53,54]
%St1810109 [21,22]
acheat.delcell = [];

%用第几个mount
%目前使用：Esr2220514 - 27;Esr2401214 - 12;St1810109 - 9;St1870329 - 2;
%St18170630 - 1;St1810108 - 10并挪动90
acheat.mountidx = 1;
acheat.movetime = 0;%second
% whether have ejaculation (i.e. st18170630 no ejacu)
acheat.withejacu = 0;

action_heat_core(acheat);


function action_heat_core(acheat)

filefolder = acheat.filefolder;
gender = acheat.gender;
delcell = acheat.delcell;
mountidx = acheat.mountidx;
movetime = acheat.movetime;
colorlim = acheat.colorlim;
savedir = acheat.savedir;


[result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
rtrace = trace(2:end,:);
Fs = neuron.Fs;

actionidx{1} = find(contains(neuron.action_label,'positive'));
actionidx{2} = find(contains(neuron.action_label,'mounting'));
if contains(gender,'fe')
    actionidx{2} = find(contains(neuron.action_label,'mounted'));
end
actionidx{3} = find(contains(neuron.action_label,'intro'));
actionidx{4} = find(contains(neuron.action_label,'ejacu'));
intruderl = neuron.intruder_label;

[cuelist,cuelist2] = searchcuebeforemating(intruderl,actionidx{4},neuron);
if contains(gender,'fe')
    cuelist = cuelist2;
end

Spick = auc_result_7.h_signifi(:,actionidx{1},cuelist(1));
Mpick = auc_result_7.h_signifi(:,actionidx{2},cuelist(end));
Ipick = auc_result_7.h_signifi(:,actionidx{3},cuelist(end));
Epick = auc_result_7.h_signifi(:,actionidx{4},cuelist(end));
MIpick = Mpick|Ipick;
%%
if contains(neuron.name,'Esr2')
    bothpick = Spick&Epick;
    Apick = Spick&~bothpick; 
    Bpick = Epick&~bothpick;
    otherpick = MIpick&~(bothpick|Apick|Bpick);
elseif contains(neuron.name,'St18')
    bothpick = Spick&MIpick;
    Apick = Spick&~bothpick;
    Bpick = MIpick&~bothpick;
    otherpick = Epick&~(bothpick|Apick|Bpick);
end

cuttime(1) = neuron.events{1,actionidx{1}}(find(neuron.events{1,actionidx{1}}(:,1) > neuron.intruder(cuelist(1),1),1),1);% first sniff
cuttime(2) = neuron.events{1,actionidx{2}}(mountidx,1)+movetime;% choosen mount
if ~isempty(actionidx{4})
    cuttime(3) = neuron.events{1,actionidx{4}}(find(neuron.events{1,actionidx{4}}(:,1) > neuron.intruder(cuelist(1),1),1),1);% ejaculation
end
for i = 1:length(cuttime)
    Acelltrace{i} = rtrace(Apick,(cuttime(i)-30)*Fs:(cuttime(i)+90)*Fs);
    Bcelltrace{i} = rtrace(Bpick,(cuttime(i)-30)*Fs:(cuttime(i)+90)*Fs);
    bothcelltrace{i} = rtrace(bothpick,(cuttime(i)-30)*Fs:(cuttime(i)+90)*Fs);
    othercelltrace{i} = rtrace(otherpick,(cuttime(i)-30)*Fs:(cuttime(i)+90)*Fs);
end
% sort by dF
Acellmean = mean(Acelltrace{1}(:,301:end),2);
[~, Asort] =sort(Acellmean,'descend');
if contains(neuron.name,'Esr2')
    if ~isempty(actionidx{4})
        Bcellmean = mean(Bcelltrace{3}(:,301:end),2);
        [~, Bsort] =sort(Bcellmean,'descend');
        bothcellmean = mean(bothcelltrace{3}(:,301:end),2);
        [~, bothsort] =sort(bothcellmean,'descend');
    else
        Bsort = [];
        bothsort = [];
    end
    othercellmean = mean(othercelltrace{2}(:,301:end),2);
    [~, othersort] =sort(othercellmean,'descend');
else
    Bcellmean = mean(Bcelltrace{2}(:,301:end),2);
    [~, Bsort] =sort(Bcellmean,'descend');
    bothcellmean = mean(bothcelltrace{2}(:,301:end),2);
    [~, bothsort] =sort(bothcellmean,'descend');
    if ~isempty(actionidx{4})
        othercellmean = mean(othercelltrace{3}(:,301:end),2);
        [~, othersort] =sort(othercellmean,'descend');
    else
        othersort = [];
    end
end
for i = 1:length(cuttime)
    Acelltrace{i} = Acelltrace{i}(Asort,:);
    Bcelltrace{i} = Bcelltrace{i}(Bsort,:);
    bothcelltrace{i} = bothcelltrace{i}(bothsort,:);
    othercelltrace{i} = othercelltrace{i}(othersort,:);
end

%% 挑细胞
for i = 1:length(cuttime)
    [Acelltrace{i}, Bcelltrace{i},bothcelltrace{i},othercelltrace{i}] = changecells_for_actionheat(Acelltrace{i}, Bcelltrace{i},bothcelltrace{i},othercelltrace{i},delcell);
end
alllength = size(Acelltrace{1},1)+ size(Bcelltrace{1},1)+ size(bothcelltrace{1},1)+ size(othercelltrace{1},1);
hfig = figure('color', 'w','Position',[300 300 200*length(cuttime) 320]);
hold on;
for i = 1:length(cuttime)
    if ~isempty(Acelltrace{i})
        imagesc(Acelltrace{i}, 'xdata', [i*123-123,i*123-3], 'ydata', [1 size(Acelltrace{i},1)])
    end
    if ~isempty(Bcelltrace{i})
        imagesc(Bcelltrace{i}, 'xdata',  [i*123-123,i*123-3], 'ydata', [1 size(Bcelltrace{i},1)]+size(Acelltrace{i},1))
    end
    if ~isempty(bothcelltrace{i})
        imagesc(bothcelltrace{i}, 'xdata',  [i*123-123,i*123-3], 'ydata', [1 size(bothcelltrace{i},1)]+size(Bcelltrace{i},1)+size(Acelltrace{i},1))
    end
    if ~isempty(othercelltrace{i})
        imagesc(othercelltrace{i}, 'xdata',  [i*123-123,i*123-3], 'ydata', [1 size(othercelltrace{i},1)]+size(Bcelltrace{i},1)+size(Acelltrace{i},1)+size(bothcelltrace{i},1))
    end
for ii = 1:size(neuron.action_label,2)%画行为颜色
    if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mounting')||...
         contains(lower(neuron.action_label{ii}),'intro')||contains(lower(neuron.action_label{ii}),'ejac')
    event_now = neuron.events{ii} - cuttime(i)+30; %centered by event-action
    indOK = event_now(:,1) >= 0 & event_now(:,2) <= 120;
    event_OK = event_now(indOK, :);
    if isempty(event_OK); continue; end
    hi = barpatch(event_OK(:,1)+i*123-123, event_OK(:,2)-event_OK(:,1),[0.5 0.5-alllength/20],neuron.color{ii});
    set(hi, 'facealpha', 1);
    end
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
xticks([0,30,120,153,243,276,366])
xticklabels({'-30','0','90','0','90','0','90'})
ylabel('Neuron number');
xlabel('Time(s)')

hfig.Renderer = 'Painters';
hfig.PaperSize = [30,15];
% saveas(gcf,[savedir,'\fig2_',neuron.name,'_normalizedF_',num2str(colorlim),'.pdf']);


end
