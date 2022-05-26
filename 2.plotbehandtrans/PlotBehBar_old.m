function PlotBehBar(behbar)

gender = behbar.gender;
if contains(gender,'fe')
    PlotBehBarForFemale(behbar);
else
    PlotBehBarForMale(behbar); 
end
end


function PlotBehBarForMale(behbar)

form_label = behbar.form_label;
events = behbar.events;
savedir = behbar.savedir;
clusterlist = behbar.clusterlist;
name = behbar.name;
is_ttest_only = behbar.is_ttest_only;
ttest_group = behbar.ttest_group;
timewindow = behbar.timewindow;
row_cmap = 64;
cmap1 = ones(row_cmap,3);
c_r1 = 256/256:-1/256/(row_cmap-1):255/256;
c_g1 = 256/256:-256/256/(row_cmap-1):0/256;
c_b1 = 256/256:-256/256/(row_cmap-1):0/256;
cmap1(:,1) = c_r1;
cmap1(:,2) = c_g1; 
cmap1(:,3) = c_b1;

for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
%% 获取行为序号
        intruderidx{i}{j} = find(contains(form_label{i}{j},'intruder'));
        actionidx{i}{j}{1} = find(contains(form_label{i}{j},'positive'));
        if isempty(actionidx{i}{j}{1})
            actionidx{i}{j}{1} = find(contains(form_label{i}{j},'sniff'));
        end
        actionidx{i}{j}{2} = find(contains(form_label{i}{j},'mount'));
        actionidx{i}{j}{3} = find(contains(form_label{i}{j},'intro'));
        actionidx{i}{j}{4} = find(contains(form_label{i}{j},'ejacu'));
    end
end

for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
%% 1.mount latency & appe duration v
        mount_latency2{i}(j) = 1800;
        if ~isempty(actionidx{i}{j}{2})
            mount_latency2{i}(j) = events{i}{j}{actionidx{i}{j}{2},1}(1,1) - events{i}{j}{actionidx{i}{j}{1},1}(1,1);
            if mount_latency2{i}(j) >1800
                mount_latency2{i}(j) = 1800;
            end
        end
%% 2.cons duration v
        cons_length{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{2})
            if ~isempty(actionidx{i}{j}{4})
                cons_length{i}(j) = events{i}{j}{actionidx{i}{j}{4},1}(1,1) - events{i}{j}{actionidx{i}{j}{2},1}(1,1);
            else
                cons_length{i}(j) = events{i}{j}{intruderidx{i}{j},1}(1,2) - events{i}{j}{actionidx{i}{j}{2},1}(1,1);
            end
        end
%% 3.intro counts v
        intro_counts{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{3})
            intro_counts{i}(j) = size(events{i}{j}{actionidx{i}{j}{3},1},1);
        end
%% 4.appe sniff duration and % v
        if mount_latency2{i}(j) > timewindow*60
            timecutt = timewindow*60;
        else
            timecutt = mount_latency2{i}(j);
        end
        sniff_appe{i}{j} =  events{i}{j}{actionidx{i}{j}{1},1}(events{i}{j}{actionidx{i}{j}{1},1}(:,2) <= timecutt+events{i}{j}{actionidx{i}{j}{1},1}(1,1),:);
        sniff_appe_dur{i}(j) = 0;
%         disp([num2str(i) num2str(j)])
%         disp(sniff_appe{i}{j})
        for p = 1:size(sniff_appe{i}{j},1)
             sniff_appe_dur{i}(j) = sniff_appe_dur{i}(j)+ sniff_appe{i}{j}(p,2)-sniff_appe{i}{j}(p,1);
        end
        sniff_appe_dur_percent{i}(j) = sniff_appe_dur{i}(j)/timecutt;
%% 5. % mount+intro dur/cons dur
        mount_cons_dur{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{2})
            mount_cons{i}{j} =  events{i}{j}{actionidx{i}{j}{2},1};
            for p = 1:size(mount_cons{i}{j},1)
                 mount_cons_dur{i}(j) = mount_cons_dur{i}(j)+ mount_cons{i}{j}(p,2)-mount_cons{i}{j}(p,1);
            end
        end
        intro_cons_dur{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{3})
        intro_cons{i}{j} =  events{i}{j}{actionidx{i}{j}{3},1};
        for p = 1:size(intro_cons{i}{j},1)
             intro_cons_dur{i}(j) = intro_cons_dur{i}(j)+ intro_cons{i}{j}(p,2)-intro_cons{i}{j}(p,1);
        end
        end
         mi_cons_dur_percent{i}(j) = 0;
        if cons_length{i}(j) ~= 0
            mi_cons_dur_percent{i}(j) = (intro_cons_dur{i}(j)+mount_cons_dur{i}(j))/cons_length{i}(j);
        end
%% 6. intro interval dur
        intro_inter_dur{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{3})
            if size(events{i}{j}{actionidx{i}{j}{3},1},1) > 1
                for p = 1:size(events{i}{j}{actionidx{i}{j}{3},1},1)-1
                    intro_inter_sigledur{i}{j}(p) = events{i}{j}{actionidx{i}{j}{3},1}(p+1,1) - events{i}{j}{actionidx{i}{j}{3},1}(p,2);
                end
                intro_inter_dur{i}(j) = mean(intro_inter_sigledur{i}{j});
            end
        end
%% 7.mount counts v
        mount_counts{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{2})
            mount_counts{i}(j) = size(events{i}{j}{actionidx{i}{j}{2},1},1);
        end
%% 8.mount freq v
        mount_freq{i}(j) = 0;
        if cons_length{i}(j) >0
            mount_freq{i}(j) = mount_counts{i}(j)/cons_length{i}(j);
        end
%% 9.intro freq v
        intro_freq{i}(j) = 0;
        if cons_length{i}(j) >0
            intro_freq{i}(j) = intro_counts{i}(j)/cons_length{i}(j);
        end
    end
%% 1.mount latency & appe duration
    mean_mount_latency(i) = mean(mount_latency2{i});
    sem_mount_latency(i) = std(mount_latency2{i})/sqrt(size(mount_latency2{i},2) );
%% 2.cons duration
    mean_cons_length(i) = mean(cons_length{i});
    sem_cons_length(i) = std(cons_length{i})/sqrt(size(cons_length{i},2) );
%% 3.intro counts
    mean_intro_counts(i) = mean(intro_counts{i});
    sem_intro_counts(i) = std(intro_counts{i})/sqrt(size(intro_counts{i},2) );
%% 4.appe sniff duration and % 
    mean_sniff_appe_dur_percent(i) = mean(sniff_appe_dur_percent{i});
    sem_sniff_appe_dur_percent(i) = std(sniff_appe_dur_percent{i})/sqrt(size(sniff_appe_dur_percent{i},2) );
%% 5. % mount+intro dur/cons dur
    mean_mi_cons_dur_percent(i) = mean(mi_cons_dur_percent{i});
    sem_mi_cons_dur_percent(i) = std(mi_cons_dur_percent{i})/sqrt(size(mi_cons_dur_percent{i},2) );
%% 6. intro interval dur
    mean_intro_inter_dur(i) = mean(intro_inter_dur{i});
    sem_intro_inter_dur(i) = std(intro_inter_dur{i})/sqrt(size(intro_inter_dur{i},2) );
end    

%% 画

%% 1.mount latency & appe duration 

xs = [];all_peak = [];clustername = [];
for i =1:length(clusterlist)
    xs = [xs,i+0.2*rand(1,length(mount_latency2{i}))-0.1];
    all_peak = [all_peak,mount_latency2{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(mount_latency2{i}),1)];
end
if is_ttest_only
    if is_paired_ttest
        for i = 1:length(ttest_group)
            [h2,p2{i}] = ttest(mount_latency2{ttest_group{i}(1)},mount_latency2{ttest_group{i}(2)});
        end
    else
        for i = 1:length(ttest_group)
            [h2,p2{i}] = ttest2(mount_latency2{ttest_group{i}(1)},mount_latency2{ttest_group{i}(2)});
        end
    end
else
    if length(clusterlist) == 2
        if is_paired_ttest
            [h2,p2{1}] = ttest(mount_latency2{1},mount_latency2{2});
        else
            [h2,p2{1}] = ttest2(mount_latency2{1},mount_latency2{2});
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

ylength = 1800;
bar(mean_mount_latency,'w')
hold on;
errorbar(mean_mount_latency,sem_mount_latency, 'k', 'Linestyle', 'None')
scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel('Mount latency(min)')
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,600,1200,1800])
yticklabels({'0','10','20','∞'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_mount_latency.pdf']);

%% 2.cons duration

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(cons_length{i}))-0.1];
    all_peak = [all_peak,cons_length{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(cons_length{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(cons_length{ttest_group{i}(1)},cons_length{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        if is_paired_ttest
            [h2,p2{1}] = ttest(cons_length{1},cons_length{2});
        else
            [h2,p2{1}] = ttest2(cons_length{1},cons_length{2});
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

ylength = 3000;
bar(mean_cons_length,'w')
hold on;
errorbar(mean_cons_length,sem_cons_length, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel('Consummatory phase duration(min)')
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,600,1200,1800,2400,3000])
yticklabels({'0','10','20','30','40','50'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_cons_duration.pdf']);

%% 3.intro counts
xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(intro_counts{i}))-0.1];
    all_peak = [all_peak,intro_counts{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(intro_counts{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(intro_counts{ttest_group{i}(1)},intro_counts{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(intro_counts{1},intro_counts{2});
    elseif length(clusterlist) > 2
        [p2{1},~,stats] = anova1(all_peak,clustername);
    end
end



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

ylength = 80;
bar(mean_intro_counts,'w')
hold on;
errorbar(mean_intro_counts,sem_intro_counts, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel('Intromission counts')
% xtl={'virgin','nearly satiated','fully satiated','recovery'}; 
% xtl={'activation','inhibition','control'}; 
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,20,40,60,80])
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_intro_counts.pdf']);

%% 4.appe sniff duration % 

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(sniff_appe_dur_percent{i}))-0.1];
    all_peak = [all_peak,sniff_appe_dur_percent{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(sniff_appe_dur_percent{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(sniff_appe_dur_percent{ttest_group{i}(1)},sniff_appe_dur_percent{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(sniff_appe_dur_percent{1},sniff_appe_dur_percent{2});
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
ylength = 1;
bar(mean_sniff_appe_dur_percent,'w')
hold on;
errorbar(mean_sniff_appe_dur_percent,sem_sniff_appe_dur_percent, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel(['% Sniff in first',num2str(timewindow),'min'])
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,0.2,0.4,0.6,0.8,1])
yticklabels({'0','20','40','60','80','100'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_sniff_dur_percent_in_',num2str(timewindow),'min.pdf']);

%% 5. % mount+intro dur/cons dur

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(mi_cons_dur_percent{i}))-0.1];
    all_peak = [all_peak,mi_cons_dur_percent{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(mi_cons_dur_percent{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(mi_cons_dur_percent{ttest_group{i}(1)},mi_cons_dur_percent{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(mi_cons_dur_percent{1},mi_cons_dur_percent{2});
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

ylength = 1;
bar(mean_mi_cons_dur_percent,'w')
hold on;
errorbar(mean_mi_cons_dur_percent,sem_mi_cons_dur_percent, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel(['% Mount + intromission ',newline,'in consummatory phase'])
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,0.5,1])
yticklabels({'0','50','100'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_cons_m+i_percent.pdf']);

%% 6. mean intro interval dur

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(intro_inter_dur{i}))-0.1];
    all_peak = [all_peak,intro_inter_dur{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(intro_inter_dur{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(intro_inter_dur{ttest_group{i}(1)},intro_inter_dur{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(intro_inter_dur{1},intro_inter_dur{2});
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

ylength = 600;
bar(mean_intro_inter_dur,'w')
hold on;
errorbar(mean_intro_inter_dur,sem_intro_inter_dur, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel('Mean intromission interval(min)')
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0:120:720])
yticklabels({'0','2','4','6','8','10','12'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_intro_inter.pdf']);

%% 7.mount counts
draw_beh_bar(savedir,name,'mount counts',clusterlist,mount_counts,is_ttest_only,ttest_group,100)
%% 8. mount freq
draw_beh_bar(savedir,name,'mount frequency',clusterlist,mount_freq,is_ttest_only,ttest_group,0.1)
%% 9. intro freq
draw_beh_bar(savedir,name,'intro frequency',clusterlist,intro_freq,is_ttest_only,is_paired_ttest,ttest_group,0.1)



end

function PlotBehBarForFemale(behbar)

form_label = behbar.form_label;
events = behbar.events;
savedir = behbar.savedir;
clusterlist = behbar.clusterlist;
name = behbar.name;
timewindow = behbar.timewindow;
events2 = events;
is_ttest_only = behbar.is_ttest_only;
ttest_group = behbar.ttest_group;
row_cmap = 64;
cmap1 = ones(row_cmap,3);
c_r1 = 256/256:-1/256/(row_cmap-1):255/256;
c_g1 = 256/256:-256/256/(row_cmap-1):0/256;
c_b1 = 256/256:-256/256/(row_cmap-1):0/256;
cmap1(:,1) = c_r1;
cmap1(:,2) = c_g1; 
cmap1(:,3) = c_b1;

for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
%% 获取行为序号
        intruderidx{i}{j} = find(contains(form_label{i}{j},'intruder'));
        actionidx{i}{j}{1} = find(contains(form_label{i}{j},'passive'));
        if isempty(actionidx{i}{j}{1})
            actionidx{i}{j}{1} = find(contains(form_label{i}{j},'sniff'));
        end
        if isempty(actionidx{i}{j}{1})
            actionidx{i}{j}{1} = find(contains(form_label{i}{j},'positive'));
        end

        actionidx{i}{j}{2} = find(contains(form_label{i}{j},'mounted'));
        if isempty(actionidx{i}{j}{2})
            actionidx{i}{j}{2} = find(contains(form_label{i}{j},'mount'));
        end
        actionidx{i}{j}{3} = find(contains(form_label{i}{j},'lordo'));
        if isempty(actionidx{i}{j}{3})
            actionidx{i}{j}{3} = find(contains(form_label{i}{j},'intro'));
        end
        actionidx{i}{j}{4} = find(contains(form_label{i}{j},'ejacu'));
        actionidx{i}{j}{6} = find(contains(form_label{i}{j},'flee'));
        actionidx{i}{j}{7} = find(contains(form_label{i}{j},'sitting'));
%% 根据时间窗限制events
        alleventscounts{i}{j} = 0;
        for p = 1:length(events2{i}{j})
            events2{i}{j}{p}(events2{i}{j}{p}(:,2) > events2{i}{j}{actionidx{i}{j}{2}}(1,1) + timewindow*60,:) = [];
            events2{i}{j}{p}(events2{i}{j}{p}(:,2) < events2{i}{j}{actionidx{i}{j}{2}}(1,1),:) = [];
            alleventscounts{i}{j} = alleventscounts{i}{j}+size(events2{i}{j}{p},1);
        end
        if isempty(actionidx{i}{j}{6})&&isempty(actionidx{i}{j}{7})
            alleventscounts{i}{j} = alleventscounts{i}{j}+size(events2{i}{j}{actionidx{i}{j}{2}},1)-size(events2{i}{j}{actionidx{i}{j}{3}},1);
        end
    end
end

for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
%% 1.lordosis counts v
        if ~isempty(actionidx{i}{j}{3})
            intro_percent{i}(j) = size(events2{i}{j}{actionidx{i}{j}{3},1},1)/alleventscounts{i}{j};
        else
            intro_percent{i}(j) = 0;
        end
%% 2.reject counts v
        if ~isempty(actionidx{i}{j}{6})
            flee_percent{i}(j) = size(events2{i}{j}{actionidx{i}{j}{6},1},1)/alleventscounts{i}{j};
        else
            flee_percent{i}(j) = 0;
        end
        if ~isempty(actionidx{i}{j}{7})
            sitting_percent{i}(j) = size(events2{i}{j}{actionidx{i}{j}{7},1},1)/alleventscounts{i}{j};
        else
            sitting_percent{i}(j) = 0;
        end
        reject_percent{i}(j) = sitting_percent{i}(j) + flee_percent{i}(j);
        if isempty(actionidx{i}{j}{6}) && isempty(actionidx{i}{j}{7}) && ~isempty(actionidx{i}{j}{3})
%         if ~isempty(actionidx{i}{j}{3})
            reject_percent{i}(j) = size(events2{i}{j}{actionidx{i}{j}{2},1},1)/alleventscounts{i}{j} - size(events2{i}{j}{actionidx{i}{j}{3},1},1)/alleventscounts{i}{j};
%         else
%              reject_percent{i}(j) = 1;
        end
%% 3.cons lordosis length %
        if isempty(actionidx{i}{j}{3})
                lordo_cons{i}{j} =  [0,0];
        else
            lordo_cons{i}{j} =  events2{i}{j}{actionidx{i}{j}{3},1};
        end
        lordo_cons_dur{i}(j) = 0;
        for p = 1:size(lordo_cons{i}{j},1)
            lordo_cons_dur{i}(j) = lordo_cons_dur{i}(j)+ lordo_cons{i}{j}(p,2)-lordo_cons{i}{j}(p,1);
        end
        cons_length{i}(j) = timewindow*60;
        if events2{i}{j}{actionidx{i}{j}{2}}(1,1) + timewindow*60 > events{i}{j}{intruderidx{i}{j},1}(1,2)
            cons_length{i}(j) = events{i}{j}{intruderidx{i}{j},1}(1,2) - events2{i}{j}{actionidx{i}{j}{2}}(1,1);
        end
        lordo_cons_dur_percent{i}(j) = lordo_cons_dur{i}(j)/cons_length{i}(j);
%% 5. % mount+intro dur/cons dur
        mount_cons{i}{j} =  events{i}{j}{actionidx{i}{j}{2},1};
        if isempty(actionidx{i}{j}{3})
                intro_cons{i}{j} =  [0,0];
        else
            intro_cons{i}{j} =  events{i}{j}{actionidx{i}{j}{3},1};
        end
        mount_cons_dur{i}(j) = 0;
        for p = 1:size(mount_cons{i}{j},1)
             mount_cons_dur{i}(j) = mount_cons_dur{i}(j)+ mount_cons{i}{j}(p,2)-mount_cons{i}{j}(p,1);
        end
        intro_cons_dur{i}(j) = 0;
        for p = 1:size(intro_cons{i}{j},1)
             intro_cons_dur{i}(j) = intro_cons_dur{i}(j)+ intro_cons{i}{j}(p,2)-intro_cons{i}{j}(p,1);
        end
        mi_cons_dur_percent{i}(j) = (intro_cons_dur{i}(j)+mount_cons_dur{i}(j))/cons_length{i}(j);
        
%% 6. intro interval dur
        intro_inter_dur{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{3})
            if size(events{i}{j}{actionidx{i}{j}{3},1},1) > 1
                for p = 1:size(events{i}{j}{actionidx{i}{j}{3},1},1)-1
                    intro_inter_sigledur{i}{j}(p) = events{i}{j}{actionidx{i}{j}{3},1}(p+1,1) - events{i}{j}{actionidx{i}{j}{3},1}(p,2);
                end
                intro_inter_dur{i}(j) = mean(intro_inter_sigledur{i}{j});
            end
        end
    end
%% 1.lordosis counts %
    mean_intro_percent(i) = mean(intro_percent{i});
    sem_intro_percent(i) = std(intro_percent{i})/sqrt(size(intro_percent{i},2) );
%% 2.reject counts %
    mean_reject_percent(i) = mean(reject_percent{i});
    sem_reject_percent(i) = std(reject_percent{i})/sqrt(size(reject_percent{i},2) );
%% 3.cons lordosis length %
    mean_lordo_cons_dur_percent(i) = mean(lordo_cons_dur_percent{i});
    sem_lordo_cons_dur_percent(i) = std(lordo_cons_dur_percent{i})/sqrt(size(lordo_cons_dur_percent{i},2) );
%% 5. % mount+intro dur/cons dur
    mean_mi_cons_dur_percent(i) = mean(mi_cons_dur_percent{i});
    sem_mi_cons_dur_percent(i) = std(mi_cons_dur_percent{i})/sqrt(size(mi_cons_dur_percent{i},2) );
    
%% 6. intro interval dur
    mean_intro_inter_dur(i) = mean(intro_inter_dur{i});
    sem_intro_inter_dur(i) = std(intro_inter_dur{i})/sqrt(size(intro_inter_dur{i},2) );
end    

%% 画

%% 1.lordosis counts v

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(intro_percent{i}))-0.1];
    all_peak = [all_peak,intro_percent{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(intro_percent{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(intro_percent{ttest_group{i}(1)},intro_percent{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(intro_percent{1},intro_percent{2});
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
    hfig = figure();
    set(gcf,'Position',[100,100,800,400])
    subplot(1,2,2)
    dist = heatmap(clusterlist,clusterlist,cmatrix);
    dist.Title = 'multi-compare p';
    colormap(cmap1)
    set(gca,'FontSize',20);
    subplot(1,2,1)
else
    hfig = figure();
    set(gcf,'Position',[100,100,400,400])
end

ylength = 0.6; 
bar(mean_intro_percent,'w')
hold on;
errorbar(mean_intro_percent,sem_intro_percent, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel('Lordosis trials %')
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,0.2,0.4,0.6])
yticklabels({'0','20','40','60'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_lordosis_trials_percent.pdf']);


%% 2.reject counts v

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(reject_percent{i}))-0.1];
    all_peak = [all_peak,reject_percent{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(reject_percent{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(reject_percent{ttest_group{i}(1)},reject_percent{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(reject_percent{1},reject_percent{2});
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
    hfig = figure();
    set(gcf,'Position',[100,100,800,400])
    subplot(1,2,2)
    dist = heatmap(clusterlist,clusterlist,cmatrix);
    dist.Title = 'multi-compare p';
    colormap(cmap1)
    set(gca,'FontSize',20);
    subplot(1,2,1)
else
    hfig = figure();
    set(gcf,'Position',[100,100,400,400])
end

ylength = 0.6;
bar(mean_reject_percent,'w')
hold on;
errorbar(mean_reject_percent,sem_reject_percent, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel('Reject trials %')
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,0.2,0.4,0.6])
yticklabels({'0','20','40','60'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_reject_trials_percent.pdf']);

%% 3.cons lordosis length %

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(lordo_cons_dur_percent{i}))-0.1];
    all_peak = [all_peak,lordo_cons_dur_percent{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(lordo_cons_dur_percent{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(lordo_cons_dur_percent{ttest_group{i}(1)},lordo_cons_dur_percent{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(lordo_cons_dur_percent{1},lordo_cons_dur_percent{2});
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
    hfig = figure();
    set(gcf,'Position',[100,100,800,400])
    subplot(1,2,2)
    dist = heatmap(clusterlist,clusterlist,cmatrix);
    dist.Title = 'multi-compare p';
    colormap(cmap1)
    set(gca,'FontSize',20);
    subplot(1,2,1)
else
    hfig = figure();
    set(gcf,'Position',[100,100,400,400])
end

ylength = 1;
bar(mean_lordo_cons_dur_percent,'w')
hold on;
errorbar(mean_lordo_cons_dur_percent,sem_lordo_cons_dur_percent, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel('Cons lordosis length %')
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,0.5 1])
yticklabels({'0','50','100'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_cons_lordo_percent.pdf']);

%% 5. % mount+intro dur/cons dur

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(mi_cons_dur_percent{i}))-0.1];
    all_peak = [all_peak,mi_cons_dur_percent{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(mi_cons_dur_percent{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(mi_cons_dur_percent{ttest_group{i}(1)},mi_cons_dur_percent{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(mi_cons_dur_percent{1},mi_cons_dur_percent{2});
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
    hfig = figure();
    set(gcf,'Position',[100,100,800,400])
    subplot(1,2,2)
    dist = heatmap(clusterlist,clusterlist,cmatrix);
    dist.Title = 'multi-compare p';
    colormap(cmap1)
    set(gca,'FontSize',20);
    subplot(1,2,1)
else
    hfig = figure();
    set(gcf,'Position',[100,100,400,400])
end

ylength = 1;
bar(mean_mi_cons_dur_percent,'w')
hold on;
errorbar(mean_mi_cons_dur_percent,sem_mi_cons_dur_percent, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel(['% Mount + intromission duration',newline,'in consummatory phase'])
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0,0.5,1])
yticklabels({'0','50','100'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_cons_m+i_percent.pdf']);

%% 6. intro interval dur

xs = [];all_peak = [];clustername = [];
for i =1:length(events)
    xs = [xs,i+0.2*rand(1,length(intro_inter_dur{i}))-0.1];
    all_peak = [all_peak,intro_inter_dur{i}];
    clustername = [clustername;repmat({clusterlist{i}},length(intro_inter_dur{i}),1)];
end

if is_ttest_only
    for i = 1:length(ttest_group)
        [h2,p2{i}] = ttest2(intro_inter_dur{ttest_group{i}(1)},intro_inter_dur{ttest_group{i}(2)});
    end
else
    if length(clusterlist) == 2
        [h2,p2{1}] = ttest2(intro_inter_dur{1},intro_inter_dur{2});
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
    hfig = figure();
    set(gcf,'Position',[100,100,800,400])
    subplot(1,2,2)
    dist = heatmap(clusterlist,clusterlist,cmatrix);
    dist.Title = 'multi-compare p';
    colormap(cmap1)
    set(gca,'FontSize',20);
    subplot(1,2,1)
else
    hfig = figure();
    set(gcf,'Position',[100,100,400,400])
end

ylength = 600;
bar(mean_intro_inter_dur,'w')
hold on;
errorbar(mean_intro_inter_dur,sem_intro_inter_dur, 'k', 'Linestyle', 'None')

scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);

for i = 1:length(p2)
    text(0.1*length(events),(1-0.1*i)*ylength,['p = ',num2str(p2{i})],'fontsize',20)       
end

ylabel('Mean intromission interval(min)')
xtl=clusterlist; 
yt=get(gca,'YTick');   
xtextp=get(gca,'XTick'); 
ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
set(gca,'xticklabel','');
set(gca,'fontsize',20)
yticks([0:120:720])
yticklabels({'0','2','4','6','8','10','12'})
axis([0 length(events)+1 0 ylength])

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,20];
saveas(gcf,[savedir,'\fig1_bar_',name,'_intro_inter.pdf']);

end



