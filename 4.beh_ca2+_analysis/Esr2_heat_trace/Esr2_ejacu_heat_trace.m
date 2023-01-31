

%%
%fig.1 F

%% 
clear; clc; 
close all;

gender = 'male';
baselength = 2;% min,
postelength = 4;% min
% fullpath of data with mating cue
filefolderlist = {
%     'E:\wupeixuan\auc_plot\d++ata\aucs_ver3.0\Esr222\Esr2220514', 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220515',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220621','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220625',...
    'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220629',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290616','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290623',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290705','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290706',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290816',... 
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300626','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300712',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300714','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300721',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300817',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr252\Esr2520221','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr252\Esr2520316',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr29\Esr290218','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr29\Esr290222',...
    };

savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20220926temp\postejacu_heat_umap\v4';


for matings = 1:length(filefolderlist)
    
    filefolder = filefolderlist{matings}; 
    [result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
    Fs = neuron.Fs;
    usedlist = FindBase(neuron);
    aucstemp = aucCalcCut(filefolderlist{matings});
    ejacuidx = find(contains(neuron.action_label,'ejacu'));
    intruderl = neuron.intruder_label;
    rtrace = trace(2:end,:);
    [cuelist,cuelist2] = searchcuebeforemating(intruderl,ejacuidx,neuron);% search cue we need
    if contains(gender,'fe')
        cuelist = cuelist2;
    end
    ztrace = zscore(rtrace,[],2);
    Epick = auc_result_7.h_signifi(:,ejacuidx,cuelist(end));
    ejacutime = neuron.events{1,ejacuidx}(find(neuron.events{1,ejacuidx}(:,1) > neuron.intruder(cuelist(1),1),1),1);
    % cut base and post ejaculation trace, resize to second
    ejacucellztrace = ztrace(Epick,(ejacutime-30)*Fs+1:(ejacutime+postelength*60)*Fs);
    ejacucellrtrace = rtrace(Epick,(ejacutime-30)*Fs+1:(ejacutime+postelength*60)*Fs);
    ejacucellrbase = rtrace(Epick,(usedlist(1))*Fs+1:(usedlist(1)+baselength*60)*Fs);
    ejacuct0  = [];ejacuct02 = [];ejacuctbase = [];
    for ss1 = 1:size(ejacucellztrace,1)
        ejacuct0 = [ejacuct0;mean(reshape(ejacucellztrace(ss1,:),Fs,[]),1)];
        ejacuct02 = [ejacuct02;mean(reshape(ejacucellrtrace(ss1,:),Fs,[]),1)];
        ejacuctbase = [ejacuctbase;mean(reshape(ejacucellrbase(ss1,:),Fs,[]),1)];
    end
    % sort by auc
    [nuewaucs,sortlist] = sort(aucstemp.aucsall{1}(Epick,4),'descend');    
    ejacucelllist = find(Epick==1);
    ejacuct02 = ejacuct02(sortlist,:);
    ejacuctbase = ejacuctbase(sortlist,:);
    dividecell = find(nuewaucs<0.7,1);
    % divide two clusters
    meanpersistentcelltrace = mean(ejacuct02(1:dividecell-1,:),1);
    meantranscientcelltrace = mean(ejacuct02(dividecell:end,:),1);
    meanpersistentcellbase = mean(ejacuctbase(1:dividecell-1,:),1);
    meantranscientcellbase = mean(ejacuctbase(dividecell:end,:),1);
    sempersistentcelltrace = std(ejacuct02(1:dividecell-1,:),0,1)/sqrt(dividecell-1);
    semtranscientcelltrace = std(ejacuct02(1:dividecell-1,:),0,1)/sqrt(length(ejacucelllist)-dividecell+1);
    sempersistentcellbase = std(ejacuctbase(1:dividecell-1,:),0,1)/sqrt(dividecell-1);
    semtranscientcellbase = std(ejacuctbase(1:dividecell-1,:),0,1)/sqrt(length(ejacucelllist)-dividecell+1);
    %%
    % plot 2(persistent/transient) * 2(heat+trace)
    hfig = figure('color', 'w','Position',[100 100 800 600]);
    suptitle(neuron.name)
    subplot(2,2,1)
    hold on;
    % ejacuct = flipud(ejacuct);
    imagesc(ejacuctbase(1:dividecell-1,:), 'xdata',  [0,baselength*60], 'ydata', [1 dividecell-1])
    imagesc(ejacuctbase(dividecell:end,:), 'xdata',  [0,baselength*60], 'ydata', [dividecell+1 size(ejacuct02,1)+1])

    for ii = 1:size(neuron.action_label,2)%画行为颜色
        if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mount')||...
             contains(lower(neuron.action_label{ii}),'intr')||contains(lower(neuron.action_label{ii}),'ejacu')||contains(lower(neuron.action_label{ii}),'passive')
        event_now = neuron.events{ii} - ejacutime+30; %centered by event-action
        indOK = event_now(:,1) >= 0 & event_now(:,2) <= postelength*60+30;
        event_OK = event_now(indOK, :);
        if isempty(event_OK); continue; end
        hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 0.5-size(ejacucellztrace,1)/20],'w');
        set(hi, 'facealpha', 1);
        end
    end
    colormap jet
    set(gca, 'clim',[-70/10 70],'FontSize',20)
    axis ij
    axis tight
    box off
    yticks([dividecell-1])
    xticks([0,baselength*60])
    xticklabels({['-',num2str(baselength)],'0'})
    xlim([0,(postelength+1)*60])

    subplot(2,2,2)
    hold on;
    imagesc(ejacuct02(1:dividecell-1,:), 'xdata',  [0,postelength*60+30], 'ydata', [1 dividecell-1])
    imagesc(ejacuct02(dividecell:end,:), 'xdata',  [0,postelength*60+30], 'ydata', [dividecell+1 size(ejacuct02,1)+1])

    % imagesc(ejacuct02, 'xdata',  [0,postelength*60+30], 'ydata', [1 size(ejacuct02,1)])
    for ii = 1:size(neuron.action_label,2)%画行为颜色
        if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mount')||...
             contains(lower(neuron.action_label{ii}),'intr')||contains(lower(neuron.action_label{ii}),'ejacu')||contains(lower(neuron.action_label{ii}),'passive')
        event_now = neuron.events{ii} - ejacutime+30; %centered by event-action
        indOK = event_now(:,1) >= 0 & event_now(:,2) <= postelength*60+30;
        event_OK = event_now(indOK, :);
        if isempty(event_OK); continue; end
        hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 0.5-size(ejacucellztrace,1)/20],neuron.color{ii});
        set(hi, 'facealpha', 1);
        end
    end
    colormap jet
    set(gca, 'clim',[-70/10 70],'FontSize',20)
    axis ij
    axis tight
    box off
    yticks([dividecell-1])
    xticks([30,postelength*30+30,postelength*60+30])
    xticklabels({'0',num2str(postelength/2),num2str(postelength)})
    xlim([0,(postelength+1)*60])

    subplot(2,2,3)
    patch('Faces',[1:1:baselength*60*2],'Vertices',[1:1:baselength*60,baselength*60:-1:1;meanpersistentcellbase-sempersistentcellbase,flip(meanpersistentcellbase+sempersistentcellbase)]'...
    ,'Facecolor',[0 0 1],'Facealpha',0.5,'edgecolor','none')        
    hold on;
    plot(1:1:baselength*60,meanpersistentcellbase,'color',[0 0 1],'linewidth',1);
    patch('Faces',[1:1:baselength*60*2],'Vertices',[1:1:baselength*60,baselength*60:-1:1;meantranscientcellbase-semtranscientcellbase,flip(meantranscientcellbase+semtranscientcellbase)]'...
    ,'Facecolor',[1 0 0],'Facealpha',0.5,'edgecolor','none')        
    plot(1:1:baselength*60,meantranscientcellbase,'color',[1 0 0],'linewidth',1);
    axis([0,(postelength+1)*60,-20,120])
    xticks([0,baselength*60])
    xticklabels({['-',num2str(baselength)],'0'})

    subplot(2,2,4)
    hold on;
    patch('Faces',[1:1:postelength*120+60],'Vertices',[1:1:postelength*60+30,postelength*60+30:-1:1;meanpersistentcelltrace-sempersistentcelltrace,flip(meanpersistentcelltrace+sempersistentcelltrace)]'...
    ,'Facecolor',[0 0 1],'Facealpha',0.5,'edgecolor','none')        
    plot(1:1:postelength*60+30,meanpersistentcelltrace,'color',[0 0 1],'linewidth',1);
    patch('Faces',[1:1:postelength*60*2+60],'Vertices',[1:1:postelength*60+30,postelength*60+30:-1:1;meantranscientcelltrace-semtranscientcelltrace,flip(meantranscientcelltrace+semtranscientcelltrace)]'...
    ,'Facecolor',[1 0 0],'Facealpha',0.5,'edgecolor','none')        
    plot(1:1:postelength*60+30,meantranscientcelltrace,'color',[1 0 0],'linewidth',1);
    axis([0,(postelength+1)*60,-20,120])
    xticks([30,postelength*30+30,postelength*60+30])
    xticklabels({'0',num2str(postelength/2),num2str(postelength)})

    hfig.Renderer = 'Painters';
    hfig.PaperSize = [40,40];
%     saveas(gcf,[savedir,'\',neuron.name,'_heatandumap_v4.pdf']);
end
