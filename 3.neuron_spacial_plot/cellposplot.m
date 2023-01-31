clear;
%%
clusterchoose = 1;
figureclusterlist = {'Esr2','St18','PT'};
cellclusterlist = {{'sniff','ejaculation','both','other'},{'sniff','intromission','both','other'},{'persistent','transient','other'}};
data_dir = ['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\cellmap\',figureclusterlist{clusterchoose}];
cellcluster = cellclusterlist{clusterchoose};
save_dir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221123over';


rowlist = {'A','B','C','D','E'};
colorlist = {'r','g','k','b','m'};
filelist2 = dir(data_dir);
filelist2 = {filelist2.name};
ind_trace_mat = find(~contains(filelist2, '.'));
for i =1:length(ind_trace_mat)
    filefolder2{i} = fullfile(data_dir, filelist2{ind_trace_mat(i)});
    datelist{i} = filelist2{ind_trace_mat(i)};
end
plotdist = {[],[],[],[],[]};
cutnum = [0:10:190;10:10:200];

for f = 1:length(filefolder2)
    if clusterchoose == 3
        position_dir = ['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\cellmap\celldata\s',filelist2{ind_trace_mat(f)},'.mat'];
        load(position_dir);
        x = position2(:,1);y = position2(:,2);cluster = position2(:,3);
    else
        position_dir = ['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\cellmap\celldata\',filelist2{ind_trace_mat(f)},'.mat'];
        load(position_dir);
        x = position(:,1);y = position(:,2);cluster = position(:,3);
    end  
    totalcellnum(f) = sum(cluster~=4);
    meanrandnum = floor((sum(cluster~=4)+sum(cluster == 3))/2);
    % spcial figure
    hfig = figure('color', 'w','Position',[900,300,800,500]);
    hold on;
    for i = 1:length(cellcluster)
        scatter(x(cluster==i),y(cluster==i),colorlist{i});
    end
    legend(cellcluster,'location','eastoutside')
    title(datelist{f})
    set(gca,'Fontsize',20)
    axis ij
    hfig.Renderer = 'Painters';                                                   
    hfig.PaperSize = [30,30];
    saveas(gcf,[save_dir,'\',datelist{f},'_spacial.pdf']);

    % curve figure
    if clusterchoose == 3
        for i = 1:2
            distlist{i} = pdist([x(cluster==i),y(cluster==i)]);
        end
    else
        for i = 1:2
            distlist{i} = pdist([x(cluster==i|cluster == 3),y(cluster==i|cluster == 3)]);
        end
    end
        distlist{i+1} = pdist([x(cluster ~= length(cellcluster)),y(cluster~= length(cellcluster))]);

%     %% shuffle
%     for iiter = 1:N
%         randcell{iiter} = randperm(totalcellnum(f),meanrandnum);
%         randdist{iiter} = pdist([x(randcell{iiter}),y(randcell{iiter})]);
%         for i = 1:size(cutnum,2)
%             y1(i) = sum(randdist{iiter}>=cutnum(1,i)&randdist{iiter}<cutnum(2,i))/size(randdist{iiter},2);
%             yrand(iiter,i) = sum(y1(1:i));
%         end
%     end
%         yrandmean(f,:) = mean(yrand,1);
    
    hfig2 = figure('color', 'w','Position',[900,300,400,400]);
    hold on;
    for j = 1:length(distlist)
        plotdist{j} = [plotdist{j},distlist{j}];
        for i = 1:size(cutnum,2)
            y1(i) = sum(distlist{j}>=cutnum(1,i)&distlist{j}<cutnum(2,i))/size(distlist{j},2);
            y2{j}(i) = sum(y1(1:i));
        end
        plot(0:10:200,[0,y2{j}]);
    end
%     plot(0:10:200,[0,yrandmean(f,:)]);
    legend([cellclusterlist{clusterchoose}(1:2),'shuffled'],'location','best')
    title(datelist{f})
    hfig2.Renderer = 'Painters';                                                   
    hfig2.PaperSize = [20,20];
    saveas(gcf,[save_dir,'\',datelist{f},'_curve.pdf']);

    xlswrite([save_dir,'\pdist_',figureclusterlist{clusterchoose},'.xlsx'],{'A','B','mix'},datelist{f},'A1')
    for i = 1:length(distlist)
        xlswrite([save_dir,'\pdist_',figureclusterlist{clusterchoose},'.xlsx'],distlist{i}',datelist{f},[rowlist{i},'2'])
    end
end 
% ytotalrandmean = mean(yrandmean,1);
sum(totalcellnum)
% overall curve plot
hfigs = figure('color', 'w','Position',[900,300,400,400]);hold on;  
hold on;
for j = 1:length(distlist)
    for i = 1:size(cutnum,2)
        y1(i) = sum(plotdist{j}>=cutnum(1,i)&plotdist{j}<cutnum(2,i))/size(plotdist{j},2);
        y2{j}(i) = sum(y1(1:i));
    end
    plot(0:10:200,[0,y2{j}]);
end
%     plot(0:10:200,[0,ytotalrandmean]);
legend([cellclusterlist{clusterchoose}(1:2),'shuffled'],'location','best')
ylabel('probability')
xlabel('dist(pixel)')
title(figureclusterlist{clusterchoose})
hfig.Renderer = 'Painters';                                                   
hfig.PaperSize = [20,20];
    
saveas(gcf,[save_dir,'\st18_curve.pdf']);
    
xlswrite([save_dir,'\pdist_',figureclusterlist{clusterchoose},'.xlsx'],{'A','B','mix'},'overall2','A1')
for i = 1:length(distlist)
    xlswrite([save_dir,'\pdist_',figureclusterlist{clusterchoose},'.xlsx'],plotdist{i}','overall2',[rowlist{i},'2'])
end
