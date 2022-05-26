function  heatplotbase(base)


result_folder = base.result_folder2;
clusterlist = base.clusterlist2;
animallist = base.animallist2;
clim2 = [-3.08,50];


for i = 1:length(clusterlist)
%     aa{i} = read2filenew(result_folder,clusterlist{i});
    aa{i} = read2file(result_folder,clusterlist{i});
    for j = 1:length(aa{i})
        [filefolder,trace{i}{j}, dec_data{i}{j}, sig_data{i}{j}, neuron{i}{j}, auc_result_7, auc_result_3] = loadfolderandcellchoose(aa{i}{j});%%%
        Fs{i}{j} = neuron{i}{j}.Fs;
        tlen{i}{j} = neuron{i}{j}.nframe/Fs{i}{j};
%         for p = 1:length(animallist)
%             if contains(neuron{i}{j}.name,animallist{p})
%                 animalidx{i}{j} = animallist{p};
%             end
%         end
        % intruder = neuron.intruder;
        actionidx{i}{j}{1} = find(contains(neuron{i}{j}.action_label,'positive'));
        actionidx{i}{j}{2} = find(contains(neuron{i}{j}.action_label,'mounting'));
        actionidx{i}{j}{3} = find(contains(neuron{i}{j}.action_label,'intro'));
        actionidx{i}{j}{4} = find(contains(neuron{i}{j}.action_label,'ejacu'));
        intruderl{i}{j} = neuron{i}{j}.intruder_label;
        baselist = plotstrspl(neuron{i}{j});
        tDur1 = 180;
        flag2{i}{j} =  revertTTL2bin(baselist(1), tDur1, Fs{i}{j}, tlen{i}{j});
    end
end

% hfig = figure('color', 'w','Position',[300 300 1200 900]);
% haxes = matlab.graphics.axis.Axes.empty(0);

for i = 1:length(clusterlist)
    amp_all{i} = [];
    frequency_all{i} = [];
    activecells_all{i} = [];
    for j = 1:length(aa{i})
        useddata2 = zscore(sig_data{i}{j}(:,flag2{i}{j}));
        for p = 1:size(useddata2,1)
            squeezeuseddata2(p) = mean(useddata2(p,useddata2(p,:) >1));
            spikecounts(p) = length(useddata2(p,useddata2(p,:) >1));

            if isnan(squeezeuseddata2(p))
                squeezeuseddata2(p) = 0;
            end
        end  
        amp{i}{j} = squeezeuseddata2;
        frequencies{i}{j} = spikecounts/tDur1;
        meanamp{i}{j} = mean(amp{i}{j} );
        meanfrequencies{i}{j} = mean(frequencies{i}{j} );
%         activecells{i}{j} = sum(frequencies{i}{j} > 0.1)/length(frequencies{i}{j});
    end
end

for i = 1:length(clusterlist)
    hfig = figure('color', 'w','Position',[300 0 900 1200]);
    haxes = matlab.graphics.axis.Axes.empty(0);
    for j = 1:length(aa{i})
        subplot(4,4,j)
        useddata2 = trace{i}{j}(:,flag2{i}{j});
%         hfig = figure('color', 'w','Position',[300 300 280 300]);
%         haxes = matlab.graphics.axis.Axes.empty(0);
        imagesc(useddata2, 'xdata', [0,tDur1], 'ydata', [1 size(useddata2,1)])
        hold on;
%         title([animalidx{i}{j},' ',clusterlist{i},' before'])
        title([neuron{i}{j}.name,newline,'Amp: ',num2str(meanamp{i}{j}),newline,'Freq:',num2str(meanfrequencies{i}{j})])
        colormap jet
        set(gca, 'clim',clim2)
        axis ij
        axis tight
        box off
%         hfig.Renderer = 'Painters';
%         hfig.PaperSize = [20,20];
%         saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0411singlebase\',neuron{i}{j}.name,'_base_heatplot.pdf']);
    end
    hfig.Renderer = 'Painters';
    hfig.PaperSize = [50,50];
    saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0411singlebase\overall4(ÏÈ±ð¶¯)\',clusterlist{i},'_overall_base_heatplot.pdf']);

end


end







