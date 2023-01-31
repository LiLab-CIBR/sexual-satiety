function S4p_PlotTransBar(transbar)

transmatrix = transbar.transmatrix;
behaviorlist = transbar.behaviorlist;
name = transbar.name;
clusterlist = transbar.clusterlist;
translist = transbar.translist;
pvalue = transbar.pvalue;
events = transbar.events;
savedir = transbar.savedir;
cmatrix = transbar.cmatrix;
behcounts = length(behaviorlist)+1;
is_ttest_only = transbar.is_ttest_only;
row_cmap = 64;
cmap1 = ones(row_cmap,3);
c_r1 = 256/256:-1/256/(row_cmap-1):255/256;
c_g1 = 256/256:-256/256/(row_cmap-1):0/256;
c_b1 = 256/256:-256/256/(row_cmap-1):0/256;
cmap1(:,1) = c_r1;
cmap1(:,2) = c_g1; 
cmap1(:,3) = c_b1;

for i = 1:behcounts%from
    for j = 1:behcounts%to
        for f = 1:size(clusterlist,2) 
            transclusterratio{f}(i,j) = round(nanmean(transmatrix{f}{i,j}),2);
            transclusterratiosem{f}(i,j) = nanstd(transmatrix{f}{i,j})/sqrt(size(transmatrix{f}{i,j},4));
        end
    end
end


%% Bar

for i = 1:length(translist)
    transpos = [behcounts - translist{i}(1),translist{i}(2)+1];
    meantrans = [];
    semtrans = [];
    for j = 1:size(clusterlist,2) 
        meantrans = [meantrans,transclusterratio{j}(transpos(1),transpos(2))];
        semtrans = [semtrans,transclusterratiosem{j}(transpos(1),transpos(2))];
    end
    
    if length(clusterlist) > 2 &&pvalue{1}(transpos(1),transpos(2)) < 0.05 &&~is_ttest_only
        hfig = figure();
        set(gcf,'Position',[100,100,800,400])
        subplot(1,2,2)
        dist = heatmap(clusterlist,clusterlist,cmatrix{transpos(1),transpos(2)});
        dist.Title = 'multi-compare p';
        colormap(cmap1)
        set(gca,'FontSize',20);
        subplot(1,2,1)
    else
        hfig = figure();
        set(gcf,'Position',[100,100,400,400])
    end

    ylength = 1;
    bar(meantrans,'w')
    hold on;
    errorbar(meantrans,semtrans, 'k', 'Linestyle', 'None')
    xs = [];all_peak = [];
    for j =1:length(clusterlist)
        xs = [xs,j+0.2*rand(1,length(events{j}))-0.1];
        all_peak = [all_peak,transmatrix{j}{transpos(1),transpos(2)}];
    end
    scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);
    ylabel([behaviorlist{translist{i}(1)},' to ',behaviorlist{translist{i}(2)},newline ,'transition probility(%)'])
    xtl=clusterlist; 
    yt=get(gca,'YTick');   
    xtextp=get(gca,'XTick'); 
    ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
    text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
    if ~isempty(pvalue)
        for ss = 1:length(pvalue)
            text(0.1*length(events),(1-0.1*ss)*ylength,['p = ',num2str(pvalue{ss}(transpos(1),transpos(2)))],'fontsize',20)
        end
    end
    set(gca,'xticklabel','');
    set(gca,'fontsize',20)
    yticks([0,0.25,0.5 0.75 1])
    yticklabels({'0','25','50','75','100'})
    axis([0 length(events)+1 0 ylength])
    box off
    hfig.Renderer = 'Painters';
    hfig.PaperSize = [25,20];
    saveas(gcf,[savedir,'\picfile\fig1_bar_',name,'_',behaviorlist{translist{i}(1)},' to ',behaviorlist{translist{i}(2)},'.pdf']);

end

end


