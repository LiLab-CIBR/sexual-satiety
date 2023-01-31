function [transmatrix,pvalue,newbehaviorlist,cmatrix] = S4_DrawTranstion(transition)


clusterlist = transition.clusterlist;
behaviorlist = transition.behaviorlist;
form_label = transition.form_label;
events = transition.events;
name = transition.name;
mergebehidx = transition.mergebehidx;
constimewindow = transition.constimewindow;
constimecuttranslist = transition.constimecuttranslist;
timewindow = transition.timewindow;
timecuttranslist = transition.timecuttranslist;
savedir = transition.savedir;
mountingidx = find(contains(behaviorlist,'mount'));
is_ttest_only = transition.is_ttest_only;
ttest_group = transition.ttest_group;
is_paired_ttest = transition.is_paired_ttest;
% merge
if transition.dobehmerge
    behcounts = length(behaviorlist) - length(mergebehidx)+2;
    newbehaviorlist = behaviorlist;
    newbehaviorlist{mergebehidx(1)} = transition.mergedname;
    newbehaviorlist(mergebehidx(2)) = [];
else
    behcounts = length(behaviorlist)+1;
    newbehaviorlist = behaviorlist;
end

for i = 1:length(constimecuttranslist)
    for j = 1:length(constimecuttranslist{i})
        constimecutactionidx{i}{j} = find(contains(newbehaviorlist,constimecuttranslist{i}{j}));
    end
end
for i = 1:length(timecuttranslist)
    for j = 1:length(timecuttranslist{i})
        timecutactionidx{i}{j} = find(contains(newbehaviorlist,timecuttranslist{i}{j}));
    end
end
for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
        actionidx{i}{j}{1} = find(contains(form_label{i}{j},'intruder'));
        for p = 1:length(behaviorlist)
            actionidx{i}{j}{p+1} = find(contains(form_label{i}{j},behaviorlist{p}));
        end
    end
end

Fs = 10;
row_cmap = 64;
cmap1 = ones(row_cmap,3);
c_r1 = 256/256:-1/256/(row_cmap-1):255/256;
c_g1 = 256/256:-256/256/(row_cmap-1):0/256;
c_b1 = 256/256:-256/256/(row_cmap-1):0/256;
cmap1(:,1) = c_r1;
cmap1(:,2) = c_g1; 
cmap1(:,3) = c_b1;


clusterlist2 = {[],[],[],[],[]};
clustername = {};
for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
        cmatrix{i,j} = [];
        clustername = [clustername,clusterlist{i}];
        x{i}{j} = (events{i}{j}{actionidx{i}{j}{1},1}(1,1):1/Fs:events{i}{j}{actionidx{i}{j}{1},1}(1,2)+1);
        y{i}{j} = zeros(1,size(x{i}{j},2));
        for f =1:length(behaviorlist)
            if ~isempty(actionidx{i}{j}{f+1})
                for p = 1:size(events{i}{j}{actionidx{i}{j}{f+1},1},1)
                    y{i}{j}(1,ceil(events{i}{j}{actionidx{i}{j}{f+1},1}(p,1)*Fs+1):ceil(events{i}{j}{actionidx{i}{j}{f+1},1}(p,2)*Fs)) = f;
                end
            end
        end
        %merge beh
        if transition.dobehmerge
            for f = mergebehidx
                if ~isempty(actionidx{i}{j}{f+1})
                    y{i}{j}(y{i}{j} == f) = mergebehidx(1);
                end
            end
            y{i}{j}(y{i}{j} > mergebehidx(1)) = y{i}{j}(y{i}{j} > mergebehidx(1)) -1;
        end
        % align to 1:1:end
        %ejacu-end
        if sum(contains(form_label{i}{j},'ejacu'))
            y{i}{j}=y{i}{j}(1,1:find(y{i}{j} == max(y{i}{j}),1,'first'));
        end
        % merge 2S nobeh
        pos{i}{j} = find(y{i}{j} ~= 0);
        k=1;
        for f = 1:length(pos{i}{j})-1
            dist2s(f) = pos{i}{j}(f+1) - pos{i}{j}(f)-1;       
            if dist2s(f) > 0 && dist2s(f) < 20
                seg{i}{j}{k} = pos{i}{j}(f)+1:pos{i}{j}(f+1)-1;
                k=k+1;
            end
        end
        for f = 1:k-1
            y{i}{j}(seg{i}{j}{f})=y{i}{j}(seg{i}{j}{f}(1,1)-1);
        end
%         % merge 2S sniff
%         pos{i}{j} = find(y{i}{j} ~= 1);
%         k=1;
%         for f = 1:length(pos{i}{j})-1
%             dist2s(f) = pos{i}{j}(f+1) - pos{i}{j}(f)-1;       
%             if dist2s(f) > 0 && dist2s(f) < 50
%                 seg{i}{j}{k} = pos{i}{j}(f)+1:pos{i}{j}(f+1)-1;
%                 k=k+1;
%             end
%         end
%         for f = 1:k-1
%             y{i}{j}(seg{i}{j}{f})=y{i}{j}(seg{i}{j}{f}(1,1)-1);
%         end
        % constimewindow cut
        for f = 1:length(constimecuttranslist)
            ycut{i}{j}{f} = y{i}{j}(1,find(y{i}{j} == mountingidx ,1,'first')+1:end);
            if length(ycut{i}{j}{f}) > constimewindow*60*Fs
                ycut{i}{j}{f} = ycut{i}{j}{f}(1,1: constimewindow*60*Fs);
            end
        end
        % timewindow cut
        for f = 1:length(timecuttranslist)
            ycut2{i}{j}{f} = y{i}{j}(1,find(y{i}{j} == timecutactionidx{f}{1} ,1,'first')+1:end);
            if length(ycut2{i}{j}{f}) > timewindow*60*Fs
                ycut2{i}{j}{f} = ycut2{i}{j}{f}(1,1:timewindow*60*Fs);
            end
        end

    end
end
% for all
for i = 1:size(events,2) 
    for j = 1:size(events{i},2) 
        sqeezey{i}{j} = [y{i}{j}(1,1)];
        for f = 2:length(y{i}{j})
            if y{i}{j}(1,f) ~= y{i}{j}(1,f-1)
                sqeezey{i}{j} = [sqeezey{i}{j},y{i}{j}(1,f)];
            end
        end
        trans{i}{j} = zeros(behcounts,behcounts);
        for f = 1:length(sqeezey{i}{j})-1
            trans{i}{j}(behcounts-sqeezey{i}{j}(f),sqeezey{i}{j}(f+1)+1) = trans{i}{j}(behcounts-sqeezey{i}{j}(f),sqeezey{i}{j}(f+1)+1)+1;
        end
%         trans{i}{j}(5,2) = trans{i}{j}(5,2) + trans{i}{j}(5,3);% no to mount
%         trans{i}{j}(4,3) = trans{i}{j}(4,3) + trans{i}{j}(5,3);
%         trans{i}{j}(5,3) = 0; 
% 
        transratio{i}{j} = trans{i}{j}./sum(trans{i}{j},2);
    end
end
% for cons time cut
for p = 1:length(constimecuttranslist)
    for i = 1:size(events,2) 
        for j = 1:size(events{i},2) 
            if ~isempty(ycut{i}{j}{p})
                sqeezeycut{i}{j}{p} = [ycut{i}{j}{p}(1,1)];
                for f = 2:length(ycut{i}{j}{p})
                    if ycut{i}{j}{p}(1,f) ~= ycut{i}{j}{p}(1,f-1)
                        sqeezeycut{i}{j}{p} = [sqeezeycut{i}{j}{p},ycut{i}{j}{p}(1,f)];
                    end
                end
                transcut{i}{j}{p} = zeros(behcounts,behcounts); 
                for f = 1:length(sqeezeycut{i}{j}{p})-1
                    transcut{i}{j}{p}(behcounts-sqeezeycut{i}{j}{p}(f),sqeezeycut{i}{j}{p}(f+1)+1) = transcut{i}{j}{p}(behcounts-sqeezeycut{i}{j}{p}(f),sqeezeycut{i}{j}{p}(f+1)+1)+1;
                end        
                transratiocut{i}{j}{p} = transcut{i}{j}{p}./sum(transcut{i}{j}{p},2);
            else
                transratiocut{i}{j}{p} = zeros(behcounts,behcounts); 
            end
        end
    end
end
% for normal time cut
for p = 1:length(timecuttranslist)
    for i = 1:size(events,2) 
        for j = 1:size(events{i},2) 
            if ~isempty(ycut2{i}{j}{p})
                sqeezeycut2{i}{j}{p} = [ycut2{i}{j}{p}(1,1)];
                for f = 2:length(ycut2{i}{j}{p})
                    if ycut2{i}{j}{p}(1,f) ~= ycut2{i}{j}{p}(1,f-1)
                        sqeezeycut2{i}{j}{p} = [sqeezeycut2{i}{j}{p},ycut2{i}{j}{p}(1,f)];
                    end
                end
                transcut2{i}{j}{p} = zeros(behcounts,behcounts);
                for f = 1:length(sqeezeycut2{i}{j}{p})-1
                    transcut2{i}{j}{p}(behcounts-sqeezeycut2{i}{j}{p}(f),sqeezeycut2{i}{j}{p}(f+1)+1) = transcut2{i}{j}{p}(behcounts-sqeezeycut2{i}{j}{p}(f),sqeezeycut2{i}{j}{p}(f+1)+1)+1;
                end
                
                %%
%                 transcut2{i}{j}{p}(5,2) = transcut2{i}{j}{p}(5,2) + transcut2{i}{j}{p}(5,3);% no to mount
%                 transcut2{i}{j}{p}(4,3) = transcut2{i}{j}{p}(4,3) + transcut2{i}{j}{p}(5,3);
%                 transcut2{i}{j}{p}(5,3) = 0; 
                %%
                transratiocut2{i}{j}{p} = transcut2{i}{j}{p}./sum(transcut2{i}{j}{p},2);
            else
                transratiocut2{i}{j}{p} = zeros(behcounts,behcounts);
            end
        end
    end
end

transmatrix = repmat({repmat({[]},behcounts,behcounts)},1,size(events,2));

for i = 1:behcounts%from
    for j = 1:behcounts%to
        for f = 1:size(events,2) 
            for p = 1:size(events{f},2)
                transmatrix{f}{i,j} = [transmatrix{f}{i,j},transratio{f}{p}(i,j)];
            end
            transclusterratio{f}(i,j) = round(nanmean(transmatrix{f}{i,j}),2);
            transclusterratiosem{f}(i,j) = nanstd(transmatrix{f}{i,j})/sqrt(size(transmatrix{f}{i,j},4));
        end
    end
end

for f = 1:size(events,2)     
    for i = 1:length(constimecuttranslist)
        constimecuttrans{i}{f} = [];
        for p = 1:size(events{f},2)
            constimecuttrans{i}{f} = [constimecuttrans{i}{f},transratiocut{f}{p}{i}(behcounts - constimecutactionidx{i}{1},constimecutactionidx{i}{2}+1)];
        end
    end
end

for f = 1:size(events,2)     
    for i = 1:length(timecuttranslist)
        timecuttrans{i}{f} = [];
        for p = 1:size(events{f},2)
            timecuttrans{i}{f} = [timecuttrans{i}{f},transratiocut2{f}{p}{i}(behcounts - timecutactionidx{i}{1},timecutactionidx{i}{2}+1)];
        end
    end
end


%% transition figure
xvalues = ['no beh',newbehaviorlist];
yvalues = [flip(newbehaviorlist),'no beh'];

for i = 1:length(clusterlist)
    pic1 = figure();
    set(gcf,'Position',[100,100,500,550])
    ss{i} = heatmap(xvalues,yvalues,transclusterratio{i});

    ss{i}.Title = clusterlist{i};
    ss{i}.XLabel = 'To';
    ss{i}.YLabel = 'From'; 
    colormap(cmap1)
    set(gca,'FontSize',20);
    hfig.Renderer = 'Painters';
    hfig.PaperSize = [30,30];
    saveas(gcf,[savedir,'\picfile\',name,clusterlist{i},'.pdf']);

end

%% ttest or anova
pvalue = [];
if is_ttest_only
    for ss = 1:length(ttest_group)
        transdist = transclusterratio{ttest_group{ss}(1)}-transclusterratio{ttest_group{ss}(2)};
        ttestmatrix = {zeros(behcounts,behcounts),zeros(behcounts,behcounts)};
        for i = 1:behcounts%from
            for j = 1:behcounts%to
                if is_paired_ttest
                    [ttestmatrix{1}(i,j),ttestmatrix{2}(i,j)] = ttest(transmatrix{ttest_group{ss}(1)}{i,j},transmatrix{ttest_group{ss}(2)}{i,j});
                else
                    [ttestmatrix{1}(i,j),ttestmatrix{2}(i,j)] = ttest2(transmatrix{ttest_group{ss}(1)}{i,j},transmatrix{ttest_group{ss}(2)}{i,j});
                end
            end
        end
        % 差值
        pic1 = figure();
        set(gcf,'Position',[100,100,500,550])
        dist = heatmap(xvalues,yvalues,transdist);
        dist.Title = [clusterlist{1},' vs ',clusterlist{2}];
        dist.XLabel = 'To';
        dist.YLabel = 'From';
        colormap(cmap1)
        set(gca,'FontSize',20);
        hfig.Renderer = 'Painters';
        hfig.PaperSize = [30,30];
        saveas(gcf,[savedir,'\picfile\',name,'_ttest.pdf']);
        % p值
        pic2 = figure();
        set(gcf,'Position',[100,100,500,550])
        dist = heatmap(xvalues,yvalues,ttestmatrix{2});
        dist.Title = ['p(',clusterlist{ttest_group{ss}(1)},' vs ',clusterlist{ttest_group{ss}(2)},')'];
        dist.XLabel = 'To';
        dist.YLabel = 'From';
        colormap(cmap1)
        set(gca,'FontSize',20);
        hfig.Renderer = 'Painters';
        hfig.PaperSize = [30,30];
        saveas(gcf,[savedir,'\picfile\',name,'_ttest_p.pdf']);
        pvalue{ss} = ttestmatrix{2};
    end
else
    if length(clusterlist) == 2    %ttest
        transdist = transclusterratio{1}-transclusterratio{2};
        ttestmatrix = {zeros(behcounts,behcounts),zeros(behcounts,behcounts)};
        for i = 1:behcounts%from
            for j = 1:behcounts%to
                if is_paired_ttest
                    [ttestmatrix{1}(i,j),ttestmatrix{2}(i,j)] = ttest(transmatrix{1}{i,j},transmatrix{2}{i,j});
                else
                    [ttestmatrix{1}(i,j),ttestmatrix{2}(i,j)] = ttest2(transmatrix{1}{i,j},transmatrix{2}{i,j});
                end
            end
        end
        % 差值
        pic1 = figure();
        set(gcf,'Position',[100,100,500,550])
        dist = heatmap(xvalues,yvalues,transdist);
        dist.Title = [clusterlist{1},' vs ',clusterlist{2}];
        dist.XLabel = 'To';
        dist.YLabel = 'From';
        colormap(cmap1)
        set(gca,'FontSize',20);
        hfig.Renderer = 'Painters';
        hfig.PaperSize = [30,30];
        saveas(gcf,[savedir,'\picfile\',name,'_ttest.pdf']);
    % p值
        pic2 = figure();
        set(gcf,'Position',[100,100,500,550])
        dist = heatmap(xvalues,yvalues,ttestmatrix{2});
        dist.Title = ['p(',clusterlist{1},' vs ',clusterlist{2},')'];
        dist.XLabel = 'To';
        dist.YLabel = 'From';
        colormap(cmap1)
        set(gca,'FontSize',20);
        hfig.Renderer = 'Painters';
        hfig.PaperSize = [30,30];
        saveas(gcf,[savedir,'\picfile\',name,'_ttest_p.pdf']);
        pvalue{1} = ttestmatrix{2};

    elseif length(clusterlist) > 2
        %anova
        st = repmat({[]},behcounts,behcounts);
        stanova = zeros(behcounts,behcounts);
        for i = 1:behcounts%from
            for j = 1:behcounts%to
                for f = 1:size(events,2)
                    st{i,j} = [st{i,j},transmatrix{f}{i,j}];
                end
                [stanova(i,j),~,stats] = anova1(st{i,j},clustername);
                if stanova(i,j) <0.05
                    [cc,~,~,~] = multcompare(stats);
                    cmatrix{i,j} = squareform(cc(:,6));
                end
            end
        end
        pic1 = figure();
        set(gcf,'Position',[100,100,500,550])
        stheatmap = heatmap(xvalues,yvalues,roundn(stanova,-3));
        stheatmap.XLabel = 'To';
        stheatmap.YLabel = 'From';
        colormap(flip(cmap1))
        caxis([0 0.05])
        title('Transition anova')
        set(gca,'FontSize',20);
        hfig.Renderer = 'Painters';
        hfig.PaperSize = [30,30];
        saveas(gcf,[savedir,'\picfile\',name,'_anova_p.pdf']);
        pvalue{1} = stanova;
    end
end
idxlist = 'ABCDEFGHIJK';
%% cons time cut bar
for i = 1:length(constimecuttranslist)
    meantrans = [];
    semtrans = [];
    timecuttransall{i} = [];
    xlswrite([savedir,'\datafile\',name,'.xlsx'],clusterlist,[constimecuttranslist{i}{1},'2',constimecuttranslist{i}{2},'in',num2str(constimewindow),'after_mount'],'A1')
    for ii = 1:size(clusterlist,2)
       xlswrite([savedir,'\datafile\',name,'.xlsx'],constimecuttrans{i}{ii}',[constimecuttranslist{i}{1},'2',constimecuttranslist{i}{2},'in',num2str(constimewindow),'after_mount'],[idxlist(ii),'2'])
    end
    for j = 1:size(clusterlist,2) 
        meantrans = [meantrans,mean(constimecuttrans{i}{j})];
        semtrans = [semtrans,std(constimecuttrans{i}{j})/sqrt(length(constimecuttrans{i}{j}))];
        timecuttransall{i} = [timecuttransall{i},constimecuttrans{i}{j}];
    end
    
    if is_ttest_only
        for j = 1:length(ttest_group)
            if is_paired_ttest
                [h2,p2{j}] = ttest(constimecuttrans{i}{ttest_group{j}(1)},constimecuttrans{i}{ttest_group{j}(2)});
            else
                [h2,p2{j}] = ttest2(constimecuttrans{i}{ttest_group{j}(1)},constimecuttrans{i}{ttest_group{j}(2)}); 
            end
        end
    else
        if length(clusterlist) == 2
            if is_paired_ttest
                [h2,p2{1}] = ttest(constimecuttrans{i}{1},constimecuttrans{i}{2});
            else
                [h2,p2{1}] = ttest2(constimecuttrans{i}{1},constimecuttrans{i}{2});
            end
        elseif length(clusterlist) > 2
            [p2{1},~,stats] = anova1(timecuttransall{i},clustername);
            if p2{1} <0.05
                [cc,~,~,~] = multcompare(stats);
                cmatrix2 = squareform(cc(:,6));
            end
        end
    end

    if ~is_ttest_only && length(clusterlist) > 2 && p2{1} < 0.05
        hfig = figure()
        set(gcf,'Position',[100,100,800,400])
        subplot(1,2,2)
        dist = heatmap(clusterlist,clusterlist,cmatrix2);
        dist.Title = 'multi-compare p';
        colormap(cmap1)
        set(gca,'FontSize',20);
        subplot(1,2,1)
    else
        hfig = figure()
        set(gcf,'Position',[100,100,400,400])
    end

    ylength = 1;
    bar(meantrans,'w')
    hold on;
    errorbar(meantrans,semtrans, 'k', 'Linestyle', 'None')
    xs = [];all_peak = [];
    xtl=clusterlist; 
    yt=get(gca,'YTick');   
    xtextp=get(gca,'XTick'); 
    ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
    text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
    for j =1:size(clusterlist,2) 
        xs = [xs,j+0.2*rand(1,length(constimecuttrans{i}{j}))-0.1];
        all_peak = [all_peak,constimecuttrans{i}{j}];
    end
    scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);
    ylabel([constimecuttranslist{i}{1},' to ',constimecuttranslist{i}{2},' transition',newline,'probility in ',num2str(constimewindow),'min after mount(%)'])
    if size(clusterlist,2) > 1
        for j = 1:length(p2)
            text(0.1*length(events),(1-0.1*j)*ylength,['p = ',num2str(p2{j})],'fontsize',20)       
        end
    end
    set(gca,'xticklabel','');
    set(gca,'fontsize',20)
    yticks([0,0.5,1])
    yticklabels({'0','50','100'})
    axis([0 length(events)+1 0 ylength])
    box off 
    hfig.Renderer = 'Painters';
    hfig.PaperSize = [25,20];
    saveas(gcf,[savedir,'\picfile\',name,'_',constimecuttranslist{i}{1},'2',constimecuttranslist{i}{2},'_in_',num2str(constimewindow),'min after mount.pdf']);
end

%% time cut bar
for i = 1:length(timecuttranslist)
    meantrans = [];
    semtrans = [];
    timecuttransall{i} = [];
    xlswrite([savedir,'\datafile\',name,'.xlsx'],clusterlist,[timecuttranslist{i}{1},'2',timecuttranslist{i}{2},'in',num2str(timewindow)],'A1')
    for ii = 1:size(clusterlist,2)
       xlswrite([savedir,'\datafile\',name,'.xlsx'],timecuttrans{i}{ii}',[timecuttranslist{i}{1},'2',timecuttranslist{i}{2},'in',num2str(timewindow)],[idxlist(ii),'2'])
    end

    for j = 1:size(clusterlist,2) 
        meantrans = [meantrans,mean(timecuttrans{i}{j})];
        semtrans = [semtrans,std(timecuttrans{i}{j})/sqrt(length(timecuttrans{i}{j}))];
        timecuttransall{i} = [timecuttransall{i},timecuttrans{i}{j}];
    end
    
    if is_ttest_only
        for j = 1:length(ttest_group)
            if is_paired_ttest
                [h2,p2{j}] = ttest(timecuttrans{i}{ttest_group{j}(1)},timecuttrans{i}{ttest_group{j}(2)});
            else
                [h2,p2{j}] = ttest2(timecuttrans{i}{ttest_group{j}(1)},timecuttrans{i}{ttest_group{j}(2)});
            end
        end
    else
        if length(clusterlist) == 2
            if is_paired_ttest
                [h2,p2{1}] = ttest(timecuttrans{i}{1},timecuttrans{i}{2});
            else
                [h2,p2{1}] = ttest2(timecuttrans{i}{1},timecuttrans{i}{2});
            end
        elseif length(clusterlist) > 2
            [p2{1},~,stats] = anova1(timecuttransall{i},clustername);
            if p2{1} <0.05
                [cc,~,~,~] = multcompare(stats);
                cmatrix2 = squareform(cc(:,6));
            end
        end
    end

    if ~is_ttest_only && length(clusterlist) > 2 && p2{1} < 0.05
        hfig = figure()
        set(gcf,'Position',[100,100,800,400])
        subplot(1,2,2)
        dist = heatmap(clusterlist,clusterlist,cmatrix2);
        dist.Title = 'multi-compare p';
        colormap(cmap1)
        set(gca,'FontSize',20);
        subplot(1,2,1)
    else
        hfig = figure()
        set(gcf,'Position',[100,100,400,400])
    end
    ylength = 1;
    bar(meantrans,'w')
    hold on;
    errorbar(meantrans,semtrans, 'k', 'Linestyle', 'None')
    xs = [];all_peak = [];
    xtl=clusterlist; 
    yt=get(gca,'YTick');   
    xtextp=get(gca,'XTick'); 
    ytextp=(yt(1)-0.4*(yt(2)-yt(1)))*ones(1,length(xtextp)); 
    text(xtextp,ytextp,xtl,'HorizontalAlignment','right','rotation',15,'fontsize',20); 
    for j =1:size(clusterlist,2) 
        xs = [xs,j+0.2*rand(1,length(timecuttrans{i}{j}))-0.1];
        all_peak = [all_peak,timecuttrans{i}{j}];
    end
    scatter(xs,all_peak,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none','LineWidth',1.5);
    ylabel([timecuttranslist{i}{1},' to ',timecuttranslist{i}{2},' transition',newline,'probility in ',num2str(timewindow),'min(%)'])
    if size(clusterlist,2) > 1
        for j = 1:length(p2)
            text(0.1*length(events),(1-0.1*j)*ylength,['p = ',num2str(p2{j})],'fontsize',20)       
        end
    end
    set(gca,'xticklabel','');
    set(gca,'fontsize',20)
    yticks([0,0.5,1])
    yticklabels({'0','50','100'})
    axis([0 length(events)+1 0 ylength])
    box off 
    hfig.Renderer = 'Painters';
    hfig.PaperSize = [25,20];
    saveas(gcf,[savedir,'\picfile\',name,'_',timecuttranslist{i}{1},'2',timecuttranslist{i}{2},'_in_',num2str(timewindow),'min.pdf']);

end




end


