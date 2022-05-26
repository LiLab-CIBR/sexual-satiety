function  base_bar_core(basebar)


result_folder = basebar.result_folder;
clusterlist = basebar.clusterlist;
datelist = basebar.datelist;
minunit = basebar.minunit;
gender = basebar.gender;
savedir = basebar.savedir;
isnormalize = basebar.isnormalize;

%获取数据
for i = 1:length(clusterlist)
    aa{i} = read_file_by_date_and_cluster(result_folder,clusterlist{i},datelist);
    for j = 1:length(aa{i})
        if isempty(aa{i}{j})
            amp{i}{j} = 0;
            frequencies{i}{j} = 0;
        else
            [amp{i}{j},frequencies{i}{j}] = basecalc(aa{i}{j});
        end
    end
end
%画图
if contains(minunit,'animal')
    %以动物为基本单位,并且normalized到virgin
    for i = 1:length(clusterlist)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
        amp_all{i} = [];
        frequency_all{i} = [];
        for j = 1:length(aa{i})
            amp_ani{i}{j} = mean(amp{i}{j});
            freq_ani{i}{j} = mean(frequencies{i}{j});
            if isnormalize
                amp_all{i} = [amp_all{i},amp_ani{i}{j}/amp_ani{1}{j}];
                frequency_all{i} = [frequency_all{i},freq_ani{i}{j}/freq_ani{1}{j}];
            else
                amp_all{i} = [amp_all{i},amp_ani{i}{j}];
                frequency_all{i} = [frequency_all{i},freq_ani{i}{j}];
            end
        end
    end
else
    %以细胞为基本单位
    for i = 1:length(clusterlist)
        amp_all{i} = [];
        frequency_all{i} = [];
        for j = 1:length(aa{i})
                amp_all{i} = [amp_all{i},amp{i}{j}];
                frequency_all{i} = [frequency_all{i},frequencies{i}{j}];
        end
    end
end   
idxlist = 'ABCDEFGHIJKLMN';
% xlswrite([savedir,'\datafile\figs11_bc_data3.xlsx'],clusterlist,[gender,'_amp'],'A1')
% for i = 1:size(clusterlist,2)
%    xlswrite([savedir,'\datafile\figs11_bc_data3.xlsx'],amp_all{i}',[gender,'_amp'],[idxlist(i),'2'])
% end
% xlswrite([savedir,'\datafile\figs11_bc_data3.xlsx'],clusterlist,[gender,'_freq'],'A1')
% for i = 1:size(clusterlist,2)
%    xlswrite([savedir,'\datafile\figs11_bc_data3.xlsx'],frequency_all{i}',[gender,'_freq'],[idxlist(i),'2'])
% end
    % plot amp
    plotamp(amp_all,clusterlist,gender)
%     saveas(gcf,[savedir,'\picfile\Esr2_',gender,'_amp_by',minunit,'_base_6bar_new.pdf']);

    % plot freq
    plotfreq(frequency_all,clusterlist,gender)
%     saveas(gcf,[savedir,'\picfile\Esr2_',gender,'_freq_by',minunit,'_base_6bar_new.pdf']);
    

end

function [amp,frequencies] = basecalc(aa)

[~,trace, ~, ~, neuron, auc_result_7, auc_result_3] = loadfolderandcellchoose(aa);%%%
Fs = neuron.Fs;
tlen = neuron.nframe/Fs;
tDur1 = 180;
%获取baseline的trace
baselist = plotstrspl(neuron);
flag2 =  revertTTL2bin(baselist(1), tDur1, Fs, tlen);
rawbase = trace(:,flag2);
%根据去除大于平均值加一倍SD的“noise”重新计算平均值和SD
[nneuron,nframe] = size(rawbase);
sig_waive_mean = [];
sig_waive_std = [];
for p = 1:nneuron
    flag3 = true(1,nframe);
    outerlist = rawbase(p,:) - mean(rawbase(p,:))-std(rawbase(p,:))>0;
    flag3(1,outerlist) = false;
    sig_waive_mean(p,1) = mean(rawbase(p,flag3));
    sig_waive_std(p,1) = std(rawbase(p,flag3));
end
%使用原始trace去除无峰mean和一倍无峰SD进行dec，获取events
decusedtrace = rawbase - sig_waive_mean-sig_waive_std;
[nneuron,nframe] = size(decusedtrace);
dec_data2 = zeros(nneuron,nframe);
sig_data2 = zeros(nneuron,nframe);
lambda = 1.5;
parfor ii=1:nneuron
        [dec_trace, signal, ~] = deconvolveCa(decusedtrace(ii,:), 'ar1', 'foopsi', 'lambda', lambda, 'optimize_pars');
        dec_data2(ii,:) = dec_trace';
        sig_data2(ii,:) = signal';
end
decevents = sig_data2;
%删除在rawtrace中真实强度小于10倍noise的events
decevents(decevents >0) = 1;
logical(decevents);
newtrace = rawbase.*decevents;
newtrace(newtrace < 10) = 0;
%获取事件数和平均强度
for p = 1:size(newtrace,1)
    amp(p) = mean(newtrace(p,newtrace(p,:)>0));
    spikecounts(p) = length(newtrace(p,newtrace(p,:)>0));
    if isnan(amp(p))
        amp(p) = 0;
        spikecounts(p) = 0;
    end
end  
frequencies = spikecounts/tDur1;

end


function plotamp(amp_all,clusterlist,gender)
easycluster = {};
xs1 = [];all_peak1 = [];clustername = [];all_peak2 = [];xs2 = [];
for i =1:length(clusterlist)
    all_peak2 = [all_peak2;amp_all{i}];
    xs2 = [xs2;repmat(i,1,length(amp_all{i}))];
    meanamp(i) = mean(amp_all{i}(amp_all{i}>0));
    semamp(i) = std(amp_all{i}(amp_all{i}>0))/sqrt(sum(amp_all{i}>0));
    xs1 = [xs1,i+0.2*rand(1,length(amp_all{i}))-0.1];
    all_peak1 = [all_peak1,amp_all{i}(amp_all{i}>0)];
    clustername = [clustername;repmat({clusterlist{i}},sum(amp_all{i}>0),1)];
    easycluster = [easycluster,[clusterlist{i}(1),clusterlist{i}(end)]];
end
for i = 1:size(xs2,2)
    allpeak3{i} = all_peak2(all_peak2(:,i)>0,i);
    xs3{i} = xs2(all_peak2(:,i)>0,i);
end
ylength = max(all_peak1)*1.2;
% [h2,p2] = ttest2(amp_all{1}(amp_all{1}>0),amp_all{2}(amp_all{2}>0));
% [h3,p3] = ttest2(amp_all{3}(amp_all{3}>0),amp_all{5}(amp_all{5}>0));
[p1,~,stats] = anova1(all_peak1,clustername);
[cc,~,~,~] = multcompare(stats);
cmatrix = squareform(cc(:,6));
hfig = figure();
% set(gcf,'Position',[100,100,500,500])
set(gcf,'Position',[100,100,1000,500])
subplot(1,2,2)
% dist = heatmap(clusterlist,clusterlist,cmatrix);
dist = heatmap(clusterlist(1:end),clusterlist(1:end),cmatrix);
dist.Title = 'multi-compare p';
%     colormap(cmap1)
set(gca,'FontSize',20);
subplot(1,2,1)

hold on;
bar(meanamp,'w')
errorbar(meanamp,semamp,'.k')
for i = 1:size(xs2,2)
    plot(xs3{i},allpeak3{i})
    plot(xs3{i},allpeak3{i},'.k','LineWidth',2)
end
% scatter(xs1,all_peak1,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1);
ylabel('Amp')
xticks(1:1:length(clusterlist))
xticklabels(easycluster)
text(0.1*length(clusterlist),0.9*ylength,['p = ',num2str(p1)],'fontsize',20)       
% text(0.1*length(clusterlist),0.84*ylength,['vtp = ',num2str(p2)],'fontsize',20)       
% text(0.1*length(clusterlist),0.78*ylength,['stp = ',num2str(p3)],'fontsize',20)       
set(gca,'Fontsize',20)
ylim([0,ylength])
title(['Esr2 ',gender])
hfig.Renderer = 'Painters';
hfig.PaperSize = [30,20];


end
        
function plotfreq(frequency_all,clusterlist,gender)

easycluster = {};
xs1 = [];all_peak1 = [];clustername = [];all_peak2 = [];xs2 = [];
for i =1:length(clusterlist)
    all_peak2 = [all_peak2;frequency_all{i}];
    xs2 = [xs2;repmat(i,1,length(frequency_all{i}))];
    meanfreq(i) = mean(frequency_all{i}(frequency_all{i}>0));
    semfreq(i) = std(frequency_all{i}(frequency_all{i}>0))/sqrt(sum(frequency_all{i}>0));
    xs1 = [xs1,i+0.2*rand(1,length(frequency_all{i}))-0.1];
    all_peak1 = [all_peak1,frequency_all{i}(frequency_all{i}>0)];
    clustername = [clustername;repmat({clusterlist{i}},sum(frequency_all{i}>0),1)];
%     easycluster = [easycluster,[clusterlist{i}(1),clusterlist{i}(end)]];
    easycluster = [easycluster,clusterlist{i}];
end
for i = 1:size(xs2,2)
    allpeak3{i} = all_peak2(all_peak2(:,i)>0,i);
    xs3{i} = xs2(all_peak2(:,i)>0,i);
end
ylength = max(all_peak1)*1.2;
% [h2,p2] = ttest2(frequency_all{1}(frequency_all{1}>0),frequency_all{2}(frequency_all{2}>0));
% [h3,p3] = ttest2(frequency_all{3}(frequency_all{3}>0),frequency_all{5}(frequency_all{5}>0));
[p1,~,stats] = anova1(all_peak1,clustername);
[cc,~,~,~] = multcompare(stats);
cmatrix = squareform(cc(:,6));
hfig = figure();
% set(gcf,'Position',[100,100,500,500])
set(gcf,'Position',[100,100,1000,500])
subplot(1,2,2)
dist = heatmap(clusterlist(1:end),clusterlist(1:end),cmatrix);
dist.Title = 'multi-compare p';
%     colormap(cmap1)
set(gca,'FontSize',20);
subplot(1,2,1)

hold on;
bar(meanfreq,'w')
errorbar(meanfreq,semfreq,'.k')
for i = 1:size(xs2,2)
    plot(xs3{i},allpeak3{i})
    plot(xs3{i},allpeak3{i},'.k','LineWidth',2)
end
% scatter(xs1,all_peak1,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1);
ylabel('Freq')
xticks(1:1:length(clusterlist))
xticklabels(easycluster)
text(0.1*length(clusterlist),0.9*ylength,['p = ',num2str(p1)],'fontsize',20)       
% text(0.1*length(clusterlist),0.84*ylength,['vtp = ',num2str(p2)],'fontsize',20)       
% text(0.1*length(clusterlist),0.78*ylength,['stp = ',num2str(p3)],'fontsize',20)       
set(gca,'Fontsize',20)
ylim([0,ylength])
title(['Esr2 ',gender])
hfig.Renderer = 'Painters';
hfig.PaperSize = [30,20];


end
        
        
        




