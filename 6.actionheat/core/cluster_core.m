function cluster_core(clusters)

% clear; clc; 
% % close all;
gender = clusters.gender;
filefolder = clusters.filefolder;
aninum = clusters.aninum;

pdists = clusters.pdists;
linkages = clusters.linkages;
datasort = clusters.datasort;
clusternum(1) = clusters.clusternum2;
colorrange = clusters.colorrange;
timemove = clusters.timemove;

[result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);

actionidx{1} = find(contains(neuron.action_label,'positive'));
actionidx{2} = find(contains(neuron.action_label,'mounting'));
if contains(gender,'fe')
    actionidx{2} = find(contains(neuron.action_label,'mounted'));
end
actionidx{3} = find(contains(neuron.action_label,'intro'));
actionidx{4} = find(contains(neuron.action_label,'ejacu'));
intruderl = neuron.intruder_label;

rtrace = trace(2:end,:);
[cuelist,cuelist2] = searchcuebeforemating(intruderl,actionidx{4},neuron);
if contains(gender,'fe')
    cuelist = cuelist2;
end
ztrace = zscore(rtrace,[],2);

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
if contains(aninum,'Esr2')
    bothpick = Spick&Epick;
%     otherpick2 = ~(Spick|Epick)&MIpick;
    otherpick = ~(Spick|Epick);
    Apick = Spick&~bothpick; 
    Bpick = Epick&~bothpick;
elseif contains(aninum,'St18')
    bothpick = Spick&MIpick;
    otherpick = ~(Spick|MIpick);
    Apick = Spick&~bothpick;
    Bpick = MIpick&~bothpick;
end

cuttime = neuron.events{1,actionidx{4}}(find(neuron.events{1,actionidx{4}}(:,1) > neuron.intruder(cuelist(1),1),1),1);
usedtime = neuron.events{1,actionidx{4}}(find(neuron.events{1,actionidx{4}}(:,1) > neuron.intruder(cuelist(1),1),1),2)-cuttime+60+timemove;
if usedtime >90
    usedtime = 90;
end



Bcelltrace = rtrace(Bpick,(cuttime-30)*Fs+1:(cuttime+120)*Fs);
bothcelltrace = rtrace(bothpick,(cuttime-30)*Fs+1:(cuttime+120)*Fs);      
ejacucelltrace = [bothcelltrace;Bcelltrace];
Bcelltrace2 = ztrace(Bpick,(cuttime-30)*Fs+1:(cuttime+120)*Fs);
bothcelltrace2 = ztrace(bothpick,(cuttime-30)*Fs+1:(cuttime+120)*Fs);      
ejacucelltrace2 = [bothcelltrace2;Bcelltrace2];
  
% pdists = 'euclidean';%euclidean   cosine
% linkages = 'ward';%average   ward
% datasort = 'zscore';

ejacuct0 = [];ejacuct02 = [];

for ss1 = 1:size(ejacucelltrace,1)
    ejacuct0 = [ejacuct0;mean(reshape(ejacucelltrace(ss1,:),Fs,[]),1)];
    ejacuct02 = [ejacuct02;mean(reshape(ejacucelltrace2(ss1,:),Fs,[]),1)];
end
ejacuct0([31,23,25,38],:) = [];
ejacuct02([31,23,25,38],:) = [];

if contains(datasort,'raw')
% usedtime = 80;
    cgo = clustergram(ejacuct0(:,usedtime:usedtime+60),'Standardize',3,'colormap','jet','cluster','column','RowPDist',pdists,'OptimalLeafOrder','false');
    set(cgo,'Linkage',linkages,'DisplayRange',10)
else
    cgo = clustergram(ejacuct02(:,usedtime:usedtime+60),'Standardize',3,'colormap','jet','cluster','column','RowPDist',pdists,'OptimalLeafOrder','false');
    set(cgo,'Linkage',linkages,'DisplayRange',10)
end
% rm = struct('GroupNumber',{35,34},'Annotation',{'lasting','other'},...
%      'Color',{'b','m'});
% set(cgo,'RowGroupMarker',rm)
% hfig = figure('color', 'w','Position',[300 300 600 500]);
% plot(cgo)
% hfig.Renderer = 'Painters';
% hfig.PaperSize = [20,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2pic\20220325temp\0330\',neuron.name,'\',neuron.name,'_tree_after',num2str(usedtime),'.pdf']);


hfig = figure('color', 'w','Position',[300 300 600 500]);
subplot(2,2,[1,3])
hold on;
ejacuct = ejacuct0(str2num(cell2mat(cgo.RowLabels)),:);
% ejacuct = flipud(ejacuct);
imagesc(ejacuct, 'xdata',  [0,150], 'ydata', [1 size(ejacuct,1)])
for ii = 1:size(neuron.action_label,2)%»­ÐÐÎªÑÕÉ«
    if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mount')||...
         contains(lower(neuron.action_label{ii}),'intr')||contains(lower(neuron.action_label{ii}),'ejacu')||contains(lower(neuron.action_label{ii}),'passive')
    event_now = neuron.events{ii} - cuttime+30; %centered by event-action
    indOK = event_now(:,1) >= 0 & event_now(:,2) <= 150;
    event_OK = event_now(indOK, :);
    if isempty(event_OK); continue; end
    hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 0.5-size(ejacucelltrace,1)/20],neuron.color{ii});
    set(hi, 'facealpha', 1);
    end
end
xticks([0,30,150])
xticklabels({'-30','0','120'})
cbh = colorbar;
colormap jet
set(cbh, 'Ticks', -30:10:70, 'FontSize', 20, 'TickLength', 0.02);
cbh.Position = [0.48  0.105 0.02 0.40];
set(gca, 'clim',[-colorrange/10 colorrange],'FontSize',20)
axis ij
axis tight
box off
suptitle([neuron.name,' ',pdists,' ',linkages])

% clusternum(1) = 29;
clusternum(2) = size(ejacuct,1)-clusternum(1);
yticks([clusternum(1),size(ejacuct,1)])

clist = {[1,0,0],[0,0,1],[0,1,0],[0.5,0.5,.5]};
trace1m = mean(ejacuct(1:clusternum(1),:),1);
trace1s = std(ejacuct(1:clusternum(1),:),0,1)/sqrt(clusternum(1));
trace2m = mean(ejacuct(clusternum(1)+1:end,:),1);
trace2s = std(ejacuct(clusternum(1)+1:end,:),0,1)/sqrt(clusternum(2));
subplot(2,2,2)
patch('Faces',[1:1:300],'Vertices',[1:1:150,150:-1:1;trace1m-trace1s,flip(trace1m+trace1s)]'...
,'Facecolor',clist{1},'Facealpha',0.5,'edgecolor','none')        
hold on;
patch('Faces',[1:1:300],'Vertices',[1:1:150,150:-1:1;trace2m-trace2s,flip(trace2m+trace2s)]'...
,'Facecolor',clist{2},'Facealpha',0.5,'edgecolor','none')        
plot(trace1m,'color',clist{1},'linewidth',1);
plot(trace2m,'color',clist{2},'linewidth',1);
plot([30,30],[-20,100],'k')
plot([usedtime-30,usedtime-30],[-20,100],'k')
axis([0,150,-20,100])
xticks([30,usedtime-30])
xticklabels({'start','over'})
yticks([-20,0,50,100])
yticklabels({'-20','0','50','100'})
set(gca,'fontsize',20)

subplot(2,2,4)
ax = gca(); 
labels = {'lasting','other'};
nums = clusternum;
prefer.num = nums;
newColors = [ 1,0.5,0.5;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
              0.5,0.5,1;  
              129/256, 162/256,  179/256;
              0.52, 0.52, 0.52;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
              1,1,1];  
indNonZero = nums~=0;
assert(any(indNonZero));
nums = nums(indNonZero);
H = pie(nums);
ax.Colormap = newColors(indNonZero,:);
T = H(strcmpi(get(H,'Type'),'text'));
if length(T)==1
    P = get(T,'Position');
else
    P = cell2mat(get(T,'Position'));
end
set(T,{'Position'},num2cell(P*0.25,2), 'Fontsize', 14)
set(findobj(gca, 'type', 'patch'), 'EdgeAlpha', 1);
t = text(-0.3,-1.5,['n=',num2str(sum(nums))]);
t.FontSize = 20;


hfig.Renderer = 'Painters';
hfig.PaperSize = [20,20];
saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0512cluster\',datasort,'_',pdists,'_',linkages,'\',neuron.name,'move_',num2str(timemove),'_heatandtrace.pdf']);


end