function S3p_draw_beh_bar_and_output_data(savedir,name,savename,clusterlist,inputvar,is_ttest_only,is_paired_ttest,ttest_group,ylength)

idxlist = 'ABCDEFGHIJKLMN';
xlswrite([savedir,'\datafile\',name,'.xlsx'],clusterlist,savename,'A1')
for i = 1:size(clusterlist,2)
   xlswrite([savedir,'\datafile\',name,'.xlsx'],inputvar{i}',savename,[idxlist(i),'2'])
end

row_cmap = 64;
cmap1 = ones(row_cmap,3);
c_r1 = 256/256:-1/256/(row_cmap-1):255/256;
c_g1 = 256/256:-256/256/(row_cmap-1):0/256;
c_b1 = 256/256:-256/256/(row_cmap-1):0/256;
cmap1(:,1) = c_r1;
cmap1(:,2) = c_g1; 
cmap1(:,3) = c_b1;

xs = [];all_peak = [];clustername = [];xs2 = [];all_peak2 = [];
for i =1:length(clusterlist)
    xs = [xs,i+0.2*rand(1,length(inputvar{i}))-0.1];
    if is_paired_ttest
        xs2 = [xs2;i+0.2*rand(1,length(inputvar{i}))-0.1];
        all_peak2 = [all_peak2;inputvar{i}];
    end
    all_peak = [all_peak,inputvar{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(inputvar{i}),1)];
    mean_inputvar(i) = mean(inputvar{i});
    sem_inputvar(i) = std(inputvar{i})/sqrt(size(inputvar{i},2) );
end

if is_ttest_only
    for i = 1:length(ttest_group)
        if is_paired_ttest
            [h2,p2{i}] = ttest(inputvar{ttest_group{i}(1)},inputvar{ttest_group{i}(2)});
        else
            [h2,p2{i}] = ttest2(inputvar{ttest_group{i}(1)},inputvar{ttest_group{i}(2)});
        end
    end
else
    if length(clusterlist) == 2
        if is_paired_ttest
            [h2,p2{1}] = ttest(inputvar{1},inputvar{2});
        else
            [h2,p2{1}] = ttest2(inputvar{1},inputvar{2});
        end
    elseif length(clusterlist) > 2
        [p2{1},~,stats] = anova1(all_peak,clustername);
        if p2{1} <0.05
            [cc,~,~,~] = multcompare(stats);
            cmatrix = squareform(cc(:,6));
        end
    end
end
%%%
if ~is_ttest_only && length(clusterlist) > 2 && p2{1} < 0.05
    hfig = figure()
    set(gcf,'Position',[100,100,800,400])
    subplot(1,2,2)
    dist = heatmap(clusterlist,clusterlist,cmatrix);
    dist.Title = 'multi-compare p';
    colormap(cmap1)
    set(gca,'FontSize',20);
    subplot(1,2,1)
else
    hfig = figure()
    set(gcf,'Position',[100,100,400,400])
end

% ylength = 3000;
bar(mean_inputvar,'w')
hold on;
errorbar(mean_inputvar,sem_inputvar, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);
if is_paired_ttest
    for i = 1:size(xs2,2)
    plot(xs2(:,i),all_peak2(:,i));
    end
end
for i = 1:length(p2)
    text(0.1*length(clusterlist),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel(savename)
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0:ylength/5:ylength])
% yticklabels({'0','10','20','30','40','50'})
axis([0 length(clusterlist)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\picfile\',name,'_',savename,'.pdf']);

end