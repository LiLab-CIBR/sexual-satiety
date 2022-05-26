function plot_every_heat(preafter)


filefolder = preafter.filefolder;
aninumlist = preafter.aninumlist;
savedir = preafter.savedir;
gender = preafter.gender;
ylength = preafter.ylength;
minunit = preafter.minunit;
firstcue = preafter.firstcue;
cuelist  = preafter.cuelist;

if length(aninumlist{1}) > 6
    for i = 1:length(aninumlist)                          
        aa{i} = [filefolder,'\',aninumlist{i}(1:end-4),'\',aninumlist{i}];
        [cutpresniff{i},cutaftersniff{i}]= calc_every_heat(aa{i},gender,cuelist(i));
    end
else
    for i = 1:length(aninumlist)                          
        aa{i} = read_file_with_samename(filefolder,aninumlist{i});
        for j = 1:length(aa{i})
            [cutpresniff{i}{j},cutaftersniff{i}{j}]= calc_every_heat(aa{i}{j},gender,[]);
        end
    end

end



%%
if length(aninumlist{1}) > 6
    allpresniff = [];
    for i = 1:length(aninumlist)
        for p = 1:length(cutpresniff{i})
                allpresniff = [allpresniff;cutpresniff{i}{1}];
%                 allpresniff = [allpresniff;[zeros(1,15),repmat(100,1,15)]];
        end
    end 
    allaftersniff = [];
    for i = 1:length(aninumlist)
        for p = 1:length(cutaftersniff{i})
                allaftersniff = [allaftersniff;cutaftersniff{i}{1}];
%                 allaftersniff = [allaftersniff;[zeros(1,15),repmat(100,1,15)]];
        end
    end
else
    allpresniff = [];
    for i = 1:length(aninumlist)
        for j = 1:length(cutpresniff{i})
    %         if ~isempty(cutpresniff{i}{j})
                    for p = 1:length(cutpresniff{i}{j})
                            allpresniff = [allpresniff;cutpresniff{i}{j}{1}];
                    end
    %         end
        end
    end
    allaftersniff = [];
    for i = 1:length(aninumlist)
        for j = 1:length(cutaftersniff{i})
    %         if ~isempty(cutpresniff{i}{j})
                    for p = 1:length(cutaftersniff{i}{j})
                            allaftersniff = [allaftersniff;cutaftersniff{i}{j}{1}];
                    end
    %         end
        end
    end
end
basepresniff = allpresniff(:,1:15);
meanbasepre = mean(basepresniff,2);
stdbasepre = std(basepresniff,0,2);
allpresniff = (allpresniff - meanbasepre);%./stdbasepre;

baseaftersniff = allaftersniff(:,1:15);
meanbaseafter = mean(baseaftersniff,2);
stdbaseafter = std(baseaftersniff,0,2);
allaftersniff = (allaftersniff - meanbaseafter);%./stdbaseafter;

hfig = figure('color', 'w','Position',[300 300 600 500]);
haxes = matlab.graphics.axis.Axes.empty(0);
subplot(1,2,1)
imagesc(allpresniff, 'xdata', [-3,3], 'ydata', [1 size(allaftersniff,1)])
title('pre-mount')
colormap jet
set(gca, 'clim',[-1 5])
subplot(1,2,2)
imagesc(allaftersniff, 'xdata', [-3,3], 'ydata', [1 size(allaftersniff,1)])
title('after mount')
colormap jet
set(gca, 'clim',[-1 5])
suptitle('St18')

hfig.Renderer = 'Painters';
hfig.PaperSize = [25,40];

saveas(gcf,[savedir,'\heat\heat_',minunit,'_',aninumlist{1}(1:4),'_',gender,'.pdf']);

%%











end