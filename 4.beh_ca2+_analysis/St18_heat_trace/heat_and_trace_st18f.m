
%%
%fig.1 H

%% 



clear; clc; 
close all;

filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\St187\St1870329';
gender = 'female';
baselength = 1;% min 下同
postilength = 2;
cuelist = 1;% 第几个cue
% delcelllist = [1,3,6,7,12,13,22,19,25,27,28,29,30,31,32,33];
delcelllist = [1,3,4,6,7,12,13,22,19,25,27,29,30,32,33];
introchoose = 3;%选取第几个intro
timemove = 0;%左为负，右为正，按秒挪动时间轴
colorbar_range = 35;%从-colorbar_range/10到colorbar_range

[result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
rtrace = trace(2:end,:);
Fs = neuron.Fs;
usedlist = FindBase(neuron);
intruderl = neuron.intruder_label;
sniffidx = find(contains(neuron.action_label,'positive'));
mountidx = find(contains(neuron.action_label,'mount'));
introidx = find(contains(neuron.action_label,'intro'));
ejacuidx = find(contains(neuron.action_label,'ejacu'));
[nneuron,nframe] = size(rtrace);
Ipick = auc_result_7.h_signifi(:,introidx,cuelist);
introtime = neuron.intruder_action{cuelist,introidx}(introchoose,1)+timemove;
mounttime = neuron.intruder_action{cuelist,mountidx}(find(neuron.intruder_action{cuelist,mountidx}<introtime,1,'last'));
introbase = rtrace(Ipick,usedlist(1)*Fs+1-100:(usedlist(1)+baselength*60)*Fs-100);
introtrace = rtrace(Ipick,(mounttime-30)*Fs+1:(mounttime+postilength*60)*Fs);

introtrace0 = [];introbase0 = [];
for ss1 = 1:size(introtrace,1)
    introtrace0 = [introtrace0;mean(reshape(introtrace(ss1,:),Fs,[]),1)];
    introbase0 = [introbase0;mean(reshape(introbase(ss1,:),Fs,[]),1)];
end

[nuewaucs,sortlist] = sort(auc_result_7.aucs(Ipick,introidx,cuelist),'descend');    
introcelllist = find(Ipick==1);
introtrace0 = introtrace0(sortlist,:);
introbase0 = introbase0(sortlist,:);

if ~isempty(delcelllist)
    introtrace0(delcelllist,:) = [];
    introbase0(delcelllist,:) = [];
    nuewaucs(delcelllist,:) = [];
end
numcells = size(introtrace0,1);

introdur = neuron.intruder_action2{cuelist,introidx}(introchoose,1) - mounttime;
mountdur = introtime - neuron.intruder_action{cuelist,mountidx}(find(neuron.intruder_action{cuelist,mountidx}<introtime,1,'last'));
meanintrotrace = mean(introtrace0,1);
semintrotrace = std(introtrace0,0,1)/sqrt(numcells);
meanintrobase = mean(introbase0,1);
semintrobase = std(introbase0,0,1)/sqrt(numcells);

hfig = figure('color', 'w','Position',[100 100 800 600]);
suptitle(neuron.name)
subplot(2,2,1)
hold on;
imagesc(introbase0, 'xdata', [0,baselength*60], 'ydata', [1 numcells])
for ii = 1:size(neuron.action_label,2)%画行为颜色
    if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mounting')||...
         contains(lower(neuron.action_label{ii}),'intro')||contains(lower(neuron.action_label{ii}),'ejac')
    event_now = neuron.events{ii} - mounttime+30; %centered by event-action
    indOK = event_now(:,1) >= 0 & event_now(:,2) <= baselength*60+30;
    event_OK = event_now(indOK, :);
    if isempty(event_OK); continue; end
    hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 0.5-numcells/20],'w');
    set(hi, 'facealpha', 1);
    end
end
colormap jet
set(gca, 'clim',[-colorbar_range/10 colorbar_range],'FontSize',20)
axis ij
axis tight
box off
xticks([0,baselength*60])
xticklabels({['-',num2str(baselength)],'0'})
xlim([0,(postilength+1)*60])

subplot(2,2,2)
hold on;
imagesc(introtrace0, 'xdata', [0,postilength*60+30], 'ydata', [1 numcells])
for ii = 1:size(neuron.action_label,2)%画行为颜色
    if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mount')||...
         contains(lower(neuron.action_label{ii}),'intro')||contains(lower(neuron.action_label{ii}),'ejac')
    event_now = neuron.events{ii} - mounttime+30; %centered by event-action
    indOK = event_now(:,1) >= 0 & event_now(:,2) <= postilength*60+30;
    event_OK = event_now(indOK, :);
    if isempty(event_OK); continue; end
    hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 0.5-numcells/20],neuron.color{ii});
    set(hi, 'facealpha', 1);
    end
end

colormap jet
set(gca, 'clim',[-colorbar_range/10 colorbar_range],'FontSize',20)
axis ij
axis tight
box off
xticks([])
xlim([0,(postilength+1)*60])

clist = {[1,0,0],[0,0,1],[0,1,0],[0.5,0.5,.5]};

subplot(2,2,3)
patch('Faces',[1:1:baselength*60*2],'Vertices',[1:1:baselength*60,baselength*60:-1:1;meanintrobase-semintrobase,flip(meanintrobase+semintrobase)]'...
,'Facecolor',clist{2},'Facealpha',0.5,'edgecolor','none')        
hold on;
plot(1:1:baselength*60,meanintrobase,'color',clist{2},'linewidth',1);
axis([0,(postilength+1)*60,-10,60])
xticks([0,baselength*60])
xticklabels({['-',num2str(baselength)],'0'})

subplot(2,2,4)
patch('Faces',[1:1:postilength*60*2+60],'Vertices',[1:1:postilength*60+30,postilength*60+30:-1:1;meanintrotrace-semintrotrace,flip(meanintrotrace+semintrotrace)]'...
,'Facecolor',clist{2},'Facealpha',0.5,'edgecolor','none')        
hold on;
plot(1:1:postilength*60+30,meanintrotrace,'color',clist{2},'linewidth',1);
hold on;
plot(repmat(introdur+30,10,1),-10:7.5:60,'k')
plot(repmat(30+mountdur,10,1),-10:7.5:60,'k')
axis([0,(postilength+1)*60,-10,60])
xticks([30-timemove,introdur+30-timemove])
xticklabels({['intro onset'],['offset']})

hfig.Renderer = 'Painters';
hfig.PaperSize = [30,30];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20220926temp\st18_heat_trace_new\',neuron.name,'_heatandtrace_v5.pdf']);



