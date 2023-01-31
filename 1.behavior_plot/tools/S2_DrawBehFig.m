function S2_DrawBehFig(beh)

    form_label = beh.form_label;
    events = beh.events;
    behaviorlist = beh.behaviorlist;
    savedir = beh.savedir;
    xlength = beh.xlength;
    datelist = beh.datelist;
    clusterlist = beh.clusterlist;
    name = beh.name;
    cmap = [1,0,0;0,1,0;0,0,1;1,0,1;1,1,0;0,0,0;0.4,0.4,0.4];
    barlen = 0.8;


    if ~beh.ismerge
        for i = 1:size(events,2)
            hfig = figure();
            hold on;
            set(gcf,'Position',[100,100,1200,1000])
            for j = 1:size(events{i},2) 
                subplot(ceil(size(events{i},2)/3),3,j)
                axis([0,xlength,0,length(behaviorlist)+1])
                for k = 1:length(behaviorlist)
                    ii = find(contains(lower(form_label{i}{j}),behaviorlist{k}));
                    if ~isempty(ii)
                        hpatch = barpatch(events{i}{j}{ii,1}(:,1)-events{i}{j}{contains(lower(form_label{i}{j}),behaviorlist{1}),1}(1,1)+5, ...
                        events{i}{j}{ii,1}(:,2)-events{i}{j}{ii,1}(:,1),  k+barlen*[-1 1]/2);
                        set(hpatch, 'facecolor', cmap(k,:), 'facealpha', 1);
                    end
                end
                axis ij
                if length(datelist{i}{j}) > 15
                    title(datelist{i}{j}(1:15))
                else
                    title(datelist{i}{j})
                end
            end
            box off
            hfig.Renderer = 'Painters';
            hfig.PaperSize = [35,30];
            saveas(gcf,[savedir,'\picfile\fig1_behavior',name,'_',clusterlist{i},'_divided.pdf']);
        end
    else
        for i = 1:size(events,2)
            ylabels{i} = {};
            hfig = figure();
            hold on;
            axis ij
            box off
            set(gcf,'Position',[100,100,500,size(events{i},2)*60+80])
            axis([0,xlength,0,size(events{i},2)+1])
    %         xlim([0,xlength])
            yticks(1:1:size(events{i},2))
            xticklabels('')
            for j = 1:size(events{i},2) 
                for k = 1:length(behaviorlist)
                    ii = find(contains(lower(form_label{i}{j}),behaviorlist{k}));
                    if ~isempty(ii)
                        hpatch = barpatch(events{i}{j}{ii,1}(:,1)-events{i}{j}{contains(lower(form_label{i}{j}),behaviorlist{1}),1}(1,1)+5, ...
                        events{i}{j}{ii,1}(:,2)-events{i}{j}{ii,1}(:,1),  j+barlen*[-1 1]/2);
                        set(hpatch, 'facecolor', cmap(k,:), 'facealpha', 1);
                    end
                end
                if length(datelist{i}{j}) > 10
                    ylabels{i} = [ylabels{i},datelist{i}{j}(1:10)];
                else
                    filllength = 10 - length(datelist{i}{j});
                    ylabels{i} = [ylabels{i},[datelist{i}{j},repmat('0',1,filllength)]];
                end
            end
            yticklabels(ylabels{i});
            hfig.Renderer = 'Painters';
            hfig.PaperSize = [35,50];
            saveas(gcf,[savedir,'\picfile\fig1_behavior_',name,'_',clusterlist{i},'_inone.pdf']);
        end
    end

end

