function comparesniff(preafter)


filefolder = preafter.filefolder;
aninumlist = preafter.aninumlist;
savedir = preafter.savedir;
gender = preafter.gender;
ylength = preafter.ylength;
minunit = preafter.minunit;
firstcue = preafter.firstcue;

if length(aninumlist{1}) > 6
    for i = 1:length(aninumlist)                          
        aa{i} = [filefolder,'\',aninumlist{i}(1:end-4),'\',aninumlist{i}];
        inonemean{i} = snifftrace(aa{i},gender);
    end
else
    for i = 1:length(aninumlist)                          
        aa{i} = read_file_with_samename(filefolder,aninumlist{i});
        for j = 1:length(aa{i})
            inonemean{i}{j} = snifftrace(aa{i}{j},gender);
        end
    end
end


%%
allsniff = [];
if length(aninumlist{1}) > 6
    saveani = '_bydate';
    for i = 1:length(aninumlist)
        if ~isempty(inonemean{i})
            if firstcue
                if contains(minunit,'neuron')
                    allsniff = [allsniff;inonemean{i}{1}];
                else
                    allsniff = [allsniff;mean(inonemean{i}{1})];
                end
            else
                for p = 1:length(inonemean{i})
                    if contains(minunit,'neuron')
                        allsniff = [allsniff;inonemean{i}{p}];
                    else
                        allsniff = [allsniff;mean(inonemean{i}{p})];
                    end          
                end
            end
        end
    end
else    
    saveani = '_byanimal';
    for i = 1:length(aninumlist)
        for j = 1:length(inonemean{i})
            if ~isempty(inonemean{i}{j})
                if firstcue
                    if contains(minunit,'neuron')
                        allsniff = [allsniff;inonemean{i}{j}{1}];
                    else
                        allsniff = [allsniff;mean(inonemean{i}{j}{1})];
                    end
                else
                    for p = 1:length(inonemean{i}{j})
                        if contains(minunit,'neuron')
                            allsniff = [allsniff;inonemean{i}{j}{p}];
                        else
                            allsniff = [allsniff;mean(inonemean{i}{j}{p})];
                        end          
                    end
                end
            end
        end
    end
end
%%
xs = [];all_peak = [];clustername = [];
for i =1:size(allsniff,2)
    xs = [xs,i+0.2*rand(1,size(allsniff,1))-0.1];
    all_peak = [all_peak;allsniff(:,i)];
end
idxlist = 'ABCDEFGHIJKLMN';
xlswrite(['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out\datafile\figs5_c_box2.xlsx'],{'premount','after mount'},aninumlist{1}(1:4),'A1')
for i = 1:size(allsniff,2)
   xlswrite(['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out\datafile\figs5_c_box2.xlsx'],allsniff(:,i),aninumlist{1}(1:4),[idxlist(i),'2'])
end


means = mean(allsniff,1);
sems = std(allsniff,0,1)/sqrt(length(allsniff(:,1)));

[h2,p2] = ttest2(allsniff(:,1),allsniff(:,2));
hfig = figure()
set(gcf,'Position',[100,100,400,400])

g1 = repmat({'pre'},size(allsniff,1),1);
g2 = repmat({'after'},size(allsniff,1),1);
g = [g1;g2];
boxplot(all_peak,g,'colors','k','OutlierSize',8,'symbol','k+')
text(0.1*size(allsniff,2),0.9*ylength,['p = ',num2str(p2)],'fontsize',20)       

ylabel('average df over noise')
xticklabels({'premount','after mount'})
set(gca,'fontsize',20)
yticks(0:10:100)
axis([0 size(allsniff,2)+1 -5 ylength])
if contains(minunit,'neuron')
    title([aninumlist{1}(1:4),' ',gender,' sniff  n=',num2str(length(all_peak)/2)])
else
    title([aninumlist{1}(1:4),' ',gender,' sniff  N=',num2str(length(all_peak)/2)])
end
hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
if firstcue
    savecue = '_1stcue';
else
    savecue = '_allcue';
end
saveas(gcf,[savedir,'\box_preafter_by',minunit,saveani,savecue,'_',aninumlist{1}(1:4),'_',gender,'.pdf']);


% %%
% 
% allst18sniff = [];
% for i = find(contains(lower(aninumlist),'st18'))
%     for j = 1:length(inonemean{i})
%         if ~isempty(inonemean{i}{j})
%             allst18sniff = [allst18sniff;inonemean{i}{j}{1}];
%         end
%     end
% end
% 
% xs = [];all_peak = [];clustername = [];
% for i =1:size(allst18sniff,2)
%     xs = [xs,i+0.2*rand(1,size(allst18sniff,1))-0.1];
%     all_peak = [all_peak;allst18sniff(:,i)];
% end
% 
% means = mean(allst18sniff,1);
% sems = std(allst18sniff,0,1)/sqrt(length(allst18sniff(:,1)));
% 
% [h2,p2] = ttest2(allst18sniff(:,1),allst18sniff(:,2));
% hfig = figure()
% set(gcf,'Position',[100,100,400,400])
% 
% % ylength = 30;
% % bar(meanst18,'w')
% % hold on;
% % errorbar(meanst18,semst18, 'k', 'Linestyle', 'None')
% % scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);
% g1 = repmat({'pre'},size(allst18sniff,1),1);
% g2 = repmat({'after'},size(allst18sniff,1),1);
% g = [g1;g2];
% boxplot(all_peak,g,'colors','k','OutlierSize',8,'symbol','k+')
% 
% text(0.1*size(allst18sniff,2),0.9*ylength,['p = ',num2str(p2)],'fontsize',20)       
% 
% ylabel('average df over noise')
% xticklabels({'premount','after mount'})
% set(gca,'fontsize',20)
% yticks(0:10:100)
% axis([0 size(allst18sniff,2)+1 -5 ylength])
% title(['St18 sniff  n=',num2str(length(all_peak)/2)])
% hfig.Renderer = 'Painters';
% hfig.PaperSize = [25,20];
% 
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0418materials\box_preafter_alldate_st18_',gender,'_by_neuron.pdf']);
% 











end