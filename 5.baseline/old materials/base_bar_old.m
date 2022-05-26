function  base_bar(basebar)


result_folder = basebar.result_folder;
clusterlist = basebar.clusterlist;
datelist = basebar.datelist;
minunit = basebar.minunit;

for i = 1:length(clusterlist)
    aa{i} = read_file_by_date(result_folder,clusterlist{i},datelist);
    for j = 1:length(aa{i})
        [filefolder,trace{i}{j}, dec_data{i}{j}, sig_data{i}{j}, neuron{i}{j}, auc_result_7, auc_result_3] = loadfolderandcellchoose(aa{i}{j});%%%
        Fs{i}{j} = neuron{i}{j}.Fs;
        tlen{i}{j} = neuron{i}{j}.nframe/Fs{i}{j};
        actionidx{i}{j}{1} = find(contains(neuron{i}{j}.action_label,'positive'));
        actionidx{i}{j}{2} = find(contains(neuron{i}{j}.action_label,'mounting'));
        actionidx{i}{j}{3} = find(contains(neuron{i}{j}.action_label,'intro'));
        actionidx{i}{j}{4} = find(contains(neuron{i}{j}.action_label,'ejacu'));
        intruderl{i}{j} = neuron{i}{j}.intruder_label;
        baselist = plotstrspl(neuron{i}{j});
        flag2{i}{j} =  revertTTL2bin(baselist(1), tDur1, Fs{i}{j}, tlen{i}{j});
    end
end


for i = 1:length(clusterlist)
    amp_all{i} = [];
    frequency_all{i} = [];
    activecells_all{i} = [];
    for j = 1:length(aa{i})
        useddata2 = sig_data{i}{j}(:,flag2{i}{j});
        for p = 1:size(useddata2,1)
            squeezeuseddata2(p) = mean(useddata2(p,useddata2(p,:) >ampthreshold));
            spikecounts(p) = length(useddata2(p,useddata2(p,:) >ampthreshold));

            if isnan(squeezeuseddata2(p))
                squeezeuseddata2(p) = 0;
            end
        end  
        amp{i}{j} = squeezeuseddata2;
        frequencies{i}{j} = spikecounts/tDur1;
        activecells{i}{j} = sum(squeezeuseddata2 > 0)/length(frequencies{i}{j});
        amp_all{i} = [amp_all{i},amp{i}{j}];
        frequency_all{i} = [frequency_all{i},frequencies{i}{j}];
        activecells_all{i} = [activecells_all{i},activecells{i}{j}];
    end
    meanamp(i) = mean(amp_all{i});
    semamp(i) = std(amp_all{i})/sqrt(size(amp_all{i},1));
    meanfrequencies(i) = mean(frequency_all{i});
    semfrequencies(i) = std(frequency_all{i})/sqrt(size(frequency_all{i},1));
    meanactivecells(i) = mean(activecells_all{i});
    semactivecells(i) = std(activecells_all{i})/sqrt(size(activecells_all{i},1));
end

%% 1
xs3 = [];all_peak3 = [];clustername = [];
for i =1:length(clusterlist)
    xs3 = [xs3,i+0.2*rand(1,length(activecells_all{i}))-0.1];
    all_peak3 = [all_peak3,activecells_all{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(aa{i}),1)];
end
[p3,~,stats] = anova1(all_peak3,clustername);
multcompare(stats)



%% 2
xs1 = [];all_peak1 = [];clustername = [];
for i =1:length(clusterlist)
    xs1 = [xs1,i+0.2*rand(1,length(amp_all{i}))-0.1];
    all_peak1 = [all_peak1,amp_all{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(amp_all{i}),1)];
end
[p1,~,stats] = anova1(all_peak1,clustername);
multcompare(stats)
%% 3
xs2 = [];all_peak2 = [];clustername = [];
for i =1:length(clusterlist)
    xs2 = [xs2,i+0.2*rand(1,length(frequency_all{i}))-0.1];
    all_peak2 = [all_peak2,frequency_all{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(amp_all{i}),1)];
end
[p2,~,stats] = anova1(all_peak2,clustername);
multcompare(stats)

hfig = figure('color', 'w','Position',[200 200 900 500]);
%% 1   
subplot(1,3,1);
ylength = 1;
hold on;
bar(meanactivecells,'w')
errorbar(meanactivecells,semactivecells,'.k')
scatter(xs3,all_peak3,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1);
ylabel('Active cells %')
xticks(1:1:3)
xticklabels(clusterlist)
text(0.1*length(clusterlist),0.9*ylength,['p = ',num2str(p3)],'fontsize',20)       
set(gca,'Fontsize',20)
ylim([0,ylength])




    
%% 2    
subplot(1,3,2);
ylength = 25;
hold on;
bar(meanamp,'w')
errorbar(meanamp,semamp,'.k')
scatter(xs1,all_peak1,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1);
ylabel('Amp(mean of 60s)')
xticks(1:1:3)
xticklabels(clusterlist)
text(0.1*length(clusterlist),0.9*ylength,['p = ',num2str(p1)],'fontsize',20)       
set(gca,'Fontsize',20)
ylim([0,ylength])

%% 3
subplot(1,3,3);
ylength = 3;
hold on;
bar(meanfrequencies,'w')
errorbar(meanfrequencies,semfrequencies,'.k')
scatter(xs1,all_peak2,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1);
ylabel('Frequency(spikes per second)')
xticks(1:1:3)
xticklabels(clusterlist)
text(0.1*length(clusterlist),ylength*0.9,['p = ',num2str(p2)],'fontsize',20)       
set(gca,'Fontsize',20)
ylim([0,ylength])
suptitle(['threshold:',num2str(ampthreshold)])


hfig.Renderer = 'Painters';
hfig.PaperSize = [20,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0410bar\basebar_',thresholds,'.pdf']);

end



