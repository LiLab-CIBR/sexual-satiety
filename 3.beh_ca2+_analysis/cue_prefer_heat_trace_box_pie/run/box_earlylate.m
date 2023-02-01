
%%
%fig.S8 C

%% 

clear;
%  close all
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
load ([savedir,'\mfile\hppn5523_2.mat'])
fcluster = {'Esr2m','Esr2f','St18m','St18f'};
clist = {[1,0,0],[0 0 1]};
tlen = 150;
Fs = 1;

for i = 1:length(fcluster)
    scmalls{i}{1} = [];scmalls{i}{2} = [];
    for j = 1:length(hppn{i})
        sniffaction2{i,j} = [];
        for p = 1:2
             scmall{i,j}{p} = [];
        end
        if contains(fcluster{i},'f')
            sniffaction2{i,j} = [sniffaction2{i,j};hppn{i}{j}.sniffaction{2}];
        else
            sniffaction2{i,j} = [sniffaction2{i,j};hppn{i}{j}.sniffaction{1}];
        end
        for p =1:2       
            tRise =  sniffaction2{i,j}(sniffaction2{i,j}(:,1)<p*60&sniffaction2{i,j}(:,1)>=p*60-60,1)+30;
            tEnd = sniffaction2{i,j}(sniffaction2{i,j}(:,1)<p*60&sniffaction2{i,j}(:,1)>=p*60-60,2)+30;
            if ~isempty(tEnd)
                if tEnd(end) >150
                    tEnd(end) = 150;
                end
            end
            tDur = tEnd - tRise;
            flag{p} = revertTTL2bin(tRise, tDur, Fs, tlen);
            if contains(fcluster{i},'f')
                sniffcut{i,j}{p} = hppn{i}{j}.M1(:,flag{p});
                sniffcutmean{i,j}{p} = mean(sniffcut{i,j}{p},2);
            else
                sniffcut{i,j}{p} = hppn{i}{j}.F1(:,flag{p});
                sniffcutmean{i,j}{p} = mean(sniffcut{i,j}{p},2);
            end
        end
        for p = 1:2
             scmall{i,j}{p} = [scmall{i,j}{p};sniffcutmean{i,j}{p}];
        end
        for p = 1:2
             scmall{i,j}{p} = scmall{i,j}{p}(~isnan(scmall{i,j}{p}));
        end    
        for p = 1:2
            scmalls{i}{p} = [scmalls{i}{p};scmall{i,j}{p}];
        end
    end
end
idxlist = 'ABCDEFGHIJKLMN';
for p =1:4
    x{p} = [];g = [];
    x{p} = [x{p};scmalls{p}{1};scmalls{p}{2}];            
    xlswrite([savedir,'\datafile\fig2_de_data3.xlsx'],{'first','later'},fcluster{p},'A1')
    for i = 1:2
       xlswrite([savedir,'\datafile\fig2_de_data3.xlsx'],scmalls{p}{i},fcluster{p},[idxlist(i),'2'])
    end
end
hfig = figure();
set(gcf,'Position',[300,300,1500,450])
ylength = 60;
    for p =1:4
        g = [];
        subplot(1,4,p)
        g1 = repmat({'1-60'},length(scmalls{p}{1}),1);
        g2 = repmat({'61-120'},length(scmalls{p}{2}),1);
        g = [g;g1;g2];
        boxplot(x{p},g,'colors','k','OutlierSize',8,'symbol','k+','widths',0.8)
        set(gca,'fontsize',20,'fontname','Arial')
        yticks(0:10:100)
        axis([0 3 -5 ylength])
        box off
        title(fcluster{p})
    end
   
hfig.Renderer = 'Painters';                                                   
hfig.PaperSize = [45,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0509\box_2cut_60_raw_2.pdf']);

