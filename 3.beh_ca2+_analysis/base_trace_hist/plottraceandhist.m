%%
%fig.S6 A

%% 
clear; clc; 
% close all;

% filefolderlist = { 
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220514', 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220515',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220621','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220625',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr222\Esr2220629',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290616','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290623',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290705',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290706',... 
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr229\Esr2290816',... 
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300626',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300712',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300714','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300721',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr230\Esr2300817',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr252\Esr2520221','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr252\Esr2520316',...
%     'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr29\Esr290218','E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr29\Esr290222',...
% };
    
plotsavedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20220931temp\new1025';
%% 计算auc
for matings = 1:length(filefolderlist)
    filefolder = filefolderlist{matings};
    [filefolder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);%%%
    trace = trace(2:end,:);
    mkdir([plotsavedir,'\',neuron.name]);
    aucstemp = aucCalcCut(filefolder);
    calctime = 60;
    Fs = neuron.Fs;
    [num_neuron, nframe] = size(dec_data);
    tlen = nframe / Fs;  % total time
    intruder = neuron.intruder;
    nintruder = size(intruder,1);  % intruder总数
    ejact_idx = find(contains(neuron.action_label,'ejacu'));
    
    ejacucue = [];ejact_base = [];postejact = [];
    for i = 1:nintruder
        if ~isempty(neuron.intruder_action{i,ejact_idx})
            ejacucue = [ejacucue,i];
            ejact_base = [ejact_base;[neuron.light(find(neuron.light(:,1)<neuron.intruder(i,1),1,'last'),1),neuron.intruder(i,1)-2]];
            ejact_time = neuron.intruder_action{i,ejact_idx};
            postejact = [postejact;[ejact_time+calctime+1,ejact_time+calctime+60]];
        end
    end
    numejacu = size(ejacucue,2);

    for i = 1:numejacu
        %获取细胞
        Epick{i} = auc_result_7.h_signifi(:,ejact_idx,ejacucue(i));
        perspick{i} = Epick{i} & aucstemp.h_signifi{i}(:,4);
        perspickidx{i} = find(perspick{i});
        transpick{i} = Epick{i} & ~aucstemp.h_signifi{i}(:,4);
        transpickidx{i} = find(transpick{i});
        numpers{i} = sum(perspick{i});
        numtrans{i} = sum(transpick{i});
        % 获取时间段
        flagbase{i} = revertTTL2bin(ejact_base(i,1), ejact_base(i,2) - ejact_base(i,1), Fs, tlen);
        flagpostejact{i} = revertTTL2bin(postejact(i,1), postejact(i,2) - postejact(i,1), Fs, tlen);
        % persistent
        for ipaper = 1:ceil(numpers{i}/5)
            numplot = 5;
            if ipaper == ceil(numpers{i}/5)
                numplot = numpers{i} - (ipaper-1)*5;
            end
            hfig = figure('position',[100,100,1200,850]);
            for ij = 1:numplot
                basef = trace(perspickidx{i}((ipaper-1)*5+ij),flagbase{i});
                basef_per = basef/max(trace(perspickidx{i}((ipaper-1)*5+ij),:));
                tracef = trace(perspickidx{i}((ipaper-1)*5+ij),flagpostejact{i});
                tracef_per = tracef/max(trace(perspickidx{i}((ipaper-1)*5+ij),:));
                cellauc = round(aucstemp.aucsall{i}(perspickidx{i}((ipaper-1)*5+ij),4),2);
                cellpval = round(aucstemp.pvalsall{i}(perspickidx{i}((ipaper-1)*5+ij),4),2);
                subplot(5,3,ij*3-2)
                plot(basef,'linewidth',1.5,'color',[0.3,0.3,0.3])
                axis([0,600,-20,150])
                xticks([0,300,600])
                xticklabels(0:30:60)

                subplot(5,3,ij*3-1)
                plot(tracef,'linewidth',1.5,'color',[240/256 148/256 107/256])
                axis([0,600,-20,150])
                xticks([0,300,600])
                xticklabels(0:30:60)
                title(['neuron id : ',num2str(perspickidx{i}((ipaper-1)*5+ij))])
                
                subplot(5,3,ij*3)
                baselist = basef_per*100;
                activatelist = tracef_per*100;
                baselist(baselist<0) = 0;
                activatelist(activatelist<0) = 0;
                histogram(baselist,'BinWidth',5,'Normalization','probability','FaceColor',[0.3,0.3,0.3],'linewidth',1.5)
                hold on;
                histogram(activatelist,'BinWidth',5,'Normalization','probability','FaceColor',[240/256 148/256 107/256],'linewidth',1.5)
                text(40,0.7,['auROC = ',num2str(cellauc)],'fontsize',15); 
                if  cellpval ==0
                    text(40,0.5,'p < 0.001','fontsize',15,'color','r'); 
                else
                    text(40,0.5,['p = ',num2str(cellpval)],'fontsize',15,'color','r'); 
                end
                axis([-0.5 100,0,1])
                xticks([-0.5,49.5,99.5])
                xticklabels(0:50:100)
                yticks([0,0.5,1])
                box off
            end
            suptitle([neuron.name,' persistent neurons page',num2str(ipaper)])
            hfig.Renderer = 'Painters';
            hfig.PaperSize = [50,50];
%             saveas(gcf,[plotsavedir,'\',neuron.name,'\',neuron.name,'_persistent_neurons_',num2str(i),'_page',num2str(ipaper),'.pdf']);
        end
        % transient
        for ipaper = 1:ceil(numtrans{i}/5)
            numplot = 5;
            if ipaper == ceil(numtrans{i}/5)
                numplot = numtrans{i} - (ipaper-1)*5;
            end
            hfig = figure('position',[100,100,1200,850]);
            for ij = 1:numplot
                basef = trace(transpickidx{i}((ipaper-1)*5+ij),flagbase{i});
                basef_per = basef/max(trace(transpickidx{i}((ipaper-1)*5+ij),:));
                tracef = trace(transpickidx{i}((ipaper-1)*5+ij),flagpostejact{i});
                tracef_per = tracef/max(trace(transpickidx{i}((ipaper-1)*5+ij),:));
                cellauc = round(aucstemp.aucsall{i}(transpickidx{i}((ipaper-1)*5+ij),4),2);
                cellpval = round(aucstemp.pvalsall{i}(transpickidx{i}((ipaper-1)*5+ij),4),2);
                subplot(5,3,ij*3-2)
                plot(basef,'linewidth',1.5,'color',[0.3,0.3,0.3])
                axis([0,600,-20,150])
                xticks([0,300,600])
                xticklabels(0:30:60)

                subplot(5,3,ij*3-1)
                plot(tracef,'linewidth',1.5,'color',[240/256 148/256 107/256])
                axis([0,600,-20,150])
                xticks([0,300,600])
                xticklabels(0:30:60)
                title(['neuron id : ',num2str(transpickidx{i}((ipaper-1)*5+ij))])
                
                subplot(5,3,ij*3)
                baselist = basef_per*100;
                activatelist = tracef_per*100;
                baselist(baselist<0) = 0;
                activatelist(activatelist<0) = 0;
                histogram(baselist,'BinWidth',5,'Normalization','probability','FaceColor',[0.3,0.3,0.3],'linewidth',1.5)
                hold on;
                histogram(activatelist,'BinWidth',5,'Normalization','probability','FaceColor',[240/256 148/256 107/256],'linewidth',1.5)
                text(40,0.7,['auROC = ',num2str(cellauc)],'fontsize',15); 
                if  cellpval ==0
                    text(40,0.5,'p < 0.001','fontsize',15,'color','r'); 
                else
                    text(40,0.5,['p = ',num2str(cellpval)],'fontsize',15,'color','r'); 
                end
                axis([-0.5 100,0,1])
                xticks([-0.5,49.5,99.5])
                xticklabels(0:50:100)
                yticks([0,0.5,1])
                box off
            end
            suptitle([neuron.name,' transient neurons page',num2str(ipaper)])
            hfig.Renderer = 'Painters';
            hfig.PaperSize = [50,50];
%             saveas(gcf,[plotsavedir,'\',neuron.name,'\',neuron.name,'_transient_neurons_',num2str(i),'_page',num2str(ipaper),'.pdf']);
        end
    end
end



