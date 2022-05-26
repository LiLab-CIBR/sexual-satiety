

clear
clusterlist = {'Esr2m','Esr2f','St18m','St18f'};
behlist = {'sniff','mount','introm','ejacu'};
inputvar = {[12,4,4,80;28,3,8,80;29,3,9,38;36,0,4,53],[31,0,4,75;31,3,3,55;20,0,0,52;34,2,2,55],[44,26,25,6;50,57,63,9],[27,6,31,10;58,0,35,13;26,10,26,0]};
row_cmap = 64;
cmap1 = ones(row_cmap,3);
c_r1 = 256/256:-1/256/(row_cmap-1):255/256;
c_g1 = 256/256:-256/256/(row_cmap-1):0/256;
c_b1 = 256/256:-256/256/(row_cmap-1):0/256;
cmap1(:,1) = c_r1;
cmap1(:,2) = c_g1; 
cmap1(:,3) = c_b1;

for i =1:length(clusterlist)
    xs{i} = [];all_peak{i} = [];
	for j = 1:4
        xs{i} = [xs{i},j+0.2*rand(1,size(inputvar{i},1))-0.1];       
        all_peak{i} = [all_peak{i};inputvar{i}(:,j)];
        mean_inputvar{i}(j) = mean(inputvar{i}(:,j));
        sem_inputvar{i}(j) = std(inputvar{i}(:,j))/sqrt(size(inputvar{i},1) );
    end
    hfig = figure()
    set(gcf,'Position',[100,100,400,400])

    % ylength = 3000;
    bar(mean_inputvar{i},'w')
    hold on;
    errorbar(mean_inputvar{i},sem_inputvar{i}, 'k', 'Linestyle', 'None')
    
    axis([0 5 0 100])
    scatter(xs{i},all_peak{i},'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);
    title(clusterlist{i})
    xtl=behlist; 
    yt=get(gca,'YTick');   
    xtextp=get(gca,'XTick'); 
    ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
    text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
    set(gca,'xticklabel','');
    set(gca,'fontsize',20)
    ylabel('neuron percents')
    hfig.Renderer = 'Painters';
    saveas(hfig,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0521materials\bar_percents_',clusterlist{i},'.pdf'])
end

%%%


