function plot_5figure(filefolderlist,data5fig,timecut,savedir)

    for matings = 1:length(filefolderlist)
    %% 读文件    
        filefolder = filefolderlist{matings}; 
        [result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
        load([filefolder,'\auc_result_new_',num2str(timecut),'min.mat'],'saveauc');
        gender = neuron.gender;
        %% 参数
        Fs = neuron.Fs;
        ejacuidx = find(contains(neuron.action_label,'ejacu'));
        intruderl = neuron.intruder_label;
        rtrace = trace(2:end,:);
        [cuelist,cuelist2] = searchcuebeforemating(intruderl,ejacuidx,neuron);
        if ~gender
            cuelist = cuelist2;
        end
        postejacuidxlist = find(1:1:size(saveauc.aucs,2)-1>size(neuron.action_label,2));
        postmin = length(postejacuidxlist);
        cuttime = neuron.events{1,ejacuidx}(find(neuron.events{1,ejacuidx}(:,1) > neuron.intruder(cuelist(1),1),1),1);

        pe1pick = data5fig{matings}.postejacu_cellpick(:,1);
        pe1npick = data5fig{matings}.postejacu_cellpick(:,2);
        noepick = data5fig{matings}.postejacu_cellpick(:,3);
        meanp3 = data5fig{matings}.pecpauc_withbaseejacu_meansem(1,:);
        semp3 = data5fig{matings}.pecpauc_withbaseejacu_meansem(2,:);
        meant3 = data5fig{matings}.pectauc_withbaseejacu_meansem(1,:);
        semt3 = data5fig{matings}.pectauc_withbaseejacu_meansem(2,:);
        meann3 = data5fig{matings}.noeauc_withbaseejacu_meansem(1,:);
        semn3 = data5fig{matings}.noeauc_withbaseejacu_meansem(2,:);

        xlabellist = {};
        for pp = 1:postmin
            xlabellist = [xlabellist,[num2str((pp-1)*timecut+1),'-',num2str(pp*timecut+1)]];
        end
        pe1trace = rtrace(pe1pick,(cuttime-30)*Fs+1:(cuttime+60*postmin*timecut+60)*Fs);
        pe1ntrace = rtrace(pe1npick,(cuttime-30)*Fs+1:(cuttime+60*postmin*timecut+60)*Fs);
        noetrace = rtrace(noepick,(cuttime-30)*Fs+1:(cuttime+60*postmin*timecut+60)*Fs);
        pe1nsqueeze = [];pe1squeeze = [];noesqueeze = [];
        for ss1 = 1:size(pe1trace,1)
            pe1squeeze = [pe1squeeze;mean(reshape(pe1trace(ss1,:),Fs,[]),1)];
        end
        for ss1 = 1:size(pe1ntrace,1)
            pe1nsqueeze = [pe1nsqueeze;mean(reshape(pe1ntrace(ss1,:),Fs,[]),1)];
        end
        for ss1 = 1:size(noetrace,1)
            noesqueeze = [noesqueeze;mean(reshape(noetrace(ss1,:),Fs,[]),1)];
        end

        hfig = figure('position',[100,100,600,600]);
        suptitle(neuron.name)
        subplot(3,1,[1,2])
        hold on;
        imagesc(pe1squeeze, 'xdata',  [0,60*postmin*timecut+90], 'ydata', [1 size(pe1trace,1)])
        imagesc(pe1nsqueeze, 'xdata',  [0,60*postmin*timecut+90], 'ydata', [size(pe1trace,1)+2  size(pe1trace,1)+size(pe1ntrace,1)+1])
        imagesc(noesqueeze, 'xdata',  [0,60*postmin*timecut+90], 'ydata', [size(pe1trace,1)+size(pe1ntrace,1)+3  size(noetrace,1)+size(pe1trace,1)+size(pe1ntrace,1)+2])
        for ii = 1:size(neuron.action_label,2)%画行为颜色
            if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mount')||...
                 contains(lower(neuron.action_label{ii}),'intr')||contains(lower(neuron.action_label{ii}),'ejacu')||contains(lower(neuron.action_label{ii}),'passive')
            event_now = neuron.events{ii} - cuttime+30; %centered by event-action
            indOK = event_now(:,1) >= 0 & event_now(:,2) <= 60*postmin*timecut+90;
            event_OK = event_now(indOK, :);
            if isempty(event_OK); continue; end
            hi = barpatch(event_OK(:,1), event_OK(:,2)-event_OK(:,1),[0.5 0.5-(size(noetrace,1)+size(pe1trace,1)+size(pe1ntrace,1))/20],neuron.color{ii});
            set(hi, 'facealpha', 1);
            end
        end
        colormap jet
        set(gca, 'clim',[-70/10 70])
        axis ij
        axis tight
        box off
        xticks([0,(0:60:900)+30])
        xticklabels([-30,0:60:900])

        subplot(3,1,3)
        hold on;
        errorbar(meanp3,semp3)
        errorbar(meant3,semt3)
        errorbar(meann3,semn3)

        axis([0,postmin+3,0.2,1])
        ylabel('AUC')
        xticks(1:1:postmin+2)
        xticklabels([{'base','ejacu'},xlabellist])
        title('all ejacu neurons')

    %% save
        hfig.Renderer = 'Painters';
        hfig.PaperSize = [25,20];
    %     saveas(gcf,[savedir,'\',neuron.name,'_',num2str(timecut),'mincut_heat_errorbar.pdf']);

    end

end