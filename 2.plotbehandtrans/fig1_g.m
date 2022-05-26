clear;
clc;
close all;

name = 'fig1_d_data';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
load ([savedir,'\mfile\',name,'.mat'], 'beh')

clusterlist = beh.clusterlist;
form_label = beh.form_label;
events = beh.events;
gender = beh.gender;
 
%要改的
timewindow = 10;%分钟

behaviorlist = {'positive','mount','intro','ejacu'};

dobehmerge = false;%要不要把行为合并（比如flee away和sitting）
mergebehidx = [4,5];%要合并的行为在behaviorlist中的序号
mergedname = 'lordo';%合并后的行为名

timecuttranslist = {{'positive','mount'}};%from在前to在后


  
% merge
if dobehmerge
    behcounts = length(behaviorlist) - length(mergebehidx)+2;
    newbehaviorlist = behaviorlist;
    newbehaviorlist{mergebehidx(1)} = transition.mergedname;
    newbehaviorlist(mergebehidx(2)) = [];
else
    behcounts = length(behaviorlist)+1;
    newbehaviorlist = behaviorlist;
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
        if dobehmerge
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
        % timewindow cut
        for f = 1:length(timecuttranslist)
            ycut2{i}{j}{f} = y{i}{j}(1,find(y{i}{j} == timecutactionidx{f}{1} ,1,'first')+1:end);
            if length(ycut2{i}{j}{f}) > timewindow*60*Fs
                ycut2{i}{j}{f} = ycut2{i}{j}{f}(1,1:timewindow*60*Fs);
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
                transratiocut2{i}{j}{p} = transcut2{i}{j}{p}./sum(transcut2{i}{j}{p},2);
            else
                transratiocut2{i}{j}{p} = zeros(behcounts,behcounts);
            end
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


%% time cut bar
for i = 1:length(timecuttranslist)
    meantrans = [];
    semtrans = [];
    timecuttransall{i} = [];
    for j = 1:size(clusterlist,2) 
        meantrans = [meantrans,mean(timecuttrans{i}{j})];
        semtrans = [semtrans,std(timecuttrans{i}{j})/sqrt(length(timecuttrans{i}{j}))];
        timecuttransall{i} = [timecuttransall{i},timecuttrans{i}{j}];
    end
    
    hfig = figure()
    set(gcf,'Position',[100,100,400,400])
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
    set(gca,'xticklabel','');
    set(gca,'fontsize',20)
    yticks([0,0.5,1])
    yticklabels({'0','50','100'})
    axis([0 length(events)+1 0 ylength])
    box off 
    hfig.Renderer = 'Painters';
    hfig.PaperSize = [25,20];
    saveas(gcf,[savedir,'\fig1_bar_',name,'_',timecuttranslist{i}{1},' to ',timecuttranslist{i}{2},'_in_',num2str(timewindow),'min.pdf']);

end








