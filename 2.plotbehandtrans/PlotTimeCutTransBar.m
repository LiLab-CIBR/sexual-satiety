function PlotTimeCutTransBar(transbartime)


clusterlist = transition.clusterlist;
behaviorlist = transition.behaviorlist;
form_label = transition.form_label;
events = transition.events;
name = transition.name;
mergebehidx = transition.mergebehidx;

% merge
if transition.dobehmerge
    behcounts = length(behaviorlist) - length(mergebehidx)+1;
    newbehaviorlist = behaviorlist;
    newbehaviorlist(mergebehidx) = [];
    newbehaviorlist{end} = transition.mergedname;
    newbehaviorlist{end+1} = behaviorlist{end};
else
    behcounts = length(behaviorlist);
    newbehaviorlist = behaviorlist;
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
    mountcue{i} =0;
    for j = 1:size(events{i},2) 
        clustername = [clustername,clusterlist2{i}];
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
                    p = f;
                    break;
                end
            end
            for f = mergebehidx
                if ~isempty(actionidx{i}{j}{f+1})
                    y{i}{j}(y{i}{j} == f) = p;
                end
            end
        end
        %ejacu-end
        if actionidx{i}{j}{end}
            y{i}{j}=y{i}{j}(1,1:find(y{i}{j} == actionidx{i}{j}{end},1,'first'));
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
        % align to 1:1:end
        for f = 1:actionidx{i}{j}{end}
            while sum(y{i}{j} == f) <= 0 && sum(y{i}{j} > f) > 0
                y{i}{j}(y{i}{j} > f) = y{i}{j}(y{i}{j} > f) -1;
            end
        end
        
    end
end

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
        transratio{i}{j} = trans{i}{j}./sum(trans{i}{j},2);
    end
end

transmatrix = repmat({repmat({[]},behcounts,behcounts)},1,size(events,2));

for i = 1:behcounts%from
    for j = 1:behcounts%to
        for f = 1:size(events,2) 
            for p = 1:size(events{f},2)
                transmatrix{f}{i,j} = [transmatrix{f}{i,j},transratio{f}{p}(i,j)];
            end
        end
    end
end


%% transition figure
xvalues = newbehaviorlist;
yvalues = flip(newbehaviorlist);

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
    saveas(gcf,[savedir,'\fig1_',name,'_transition_map_',clusterlist{i},'.pdf']);

end

%% ttest or anova

if length(clusterlist) == 2    %ttest
    transdist = transclusterratio{1}-transclusterratio{2};
    ttestmatrix = {zeros(behcounts,behcounts),zeros(behcounts,behcounts)};
    for i = 1:behcounts%from
        for j = 1:behcounts%to
            [ttestmatrix{1}(i,j),ttestmatrix{2}(i,j)] = ttest2(transmatrix{1}{i,j},transmatrix{2}{i,j});
        end
    end
    % ²îÖµ
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
    saveas(gcf,[savedir,'\fig1_',name,'_transition_ttest.pdf']);
% pÖµ
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
    saveas(gcf,[savedir,'\fig1_',name,'_transition_ttest_p.pdf']);
    pvalue = ttestmatrix{2};

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
            if ~isnan(stats.s)
                [sc,~,~,sgnames] = multcompare(stats);
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
    saveas(gcf,[savedir,'\fig1_',name,'_transition_anova_p.pdf']);
    pvalue = stanova;
end






end