 clear;
%  close all
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';

filefolder ='E:\wupeixuan\auc_plot\data\dzyimg\olddata\heatplot\preference&pie\mfile\0408\forpie_raw';
fcluster = {'Esr2m','Esr2f','St18m','St18f'};
filelist{1} = dir([filefolder,'\',fcluster{1}])
for i = 1:length(fcluster)
    filelist{i} = dir([filefolder,'\',fcluster{i}]);
    filelist{i} = {filelist{i}.name};
    filelist{i} = filelist{i}(3:end);
    for j = 1:length(filelist{i})
        filelist2{i,j} = dir([filefolder,'\',fcluster{i},'\',filelist{i}{j}]);
        filelist2{i,j} = {filelist2{i,j}.name};
        ind_trace_mat = find(contains(filelist2{i,j}, 'hppn.mat'));
        for k = 1:length(ind_trace_mat)
            hppnfile{i,j}{k} =  [filefolder,'\',fcluster{i},'\',filelist{i}{j},'\',filelist2{i,j}{ind_trace_mat(k)}];
            load(hppnfile{i,j}{k});
            hppn{i,j}{k} = eval(filelist2{i,j}{ind_trace_mat(k)}(1:end-4));
            clear(filelist2{i,j}{ind_trace_mat(k)}(1:end-4));
        end
    end
end


clist = {[1,0,0],[0 0 1]};
tlen = 150;
Fs = 1;

for i = 1:length(fcluster)
    timemeancue{i,1} = [];timemeancue{i,2} = [];
    for j = 1:length(filelist{i})
        nums_save{i,j} = [];
        aucslist{i,j} = [];
        aucs{i,j} = [];
        sniffaction{i,j} = [];
        sniffaction2{i,j} = {};
        afemale{i,j} = [];
        amale{i,j} = [];
        for p = 1:2
             scmall{i,j}{p} = [];
        end
        for k = 1:length(hppnfile{i,j})
            nums_save{i,j} = [nums_save{i,j};hppn{i,j}{k}.num_save];
            aucslist{i,j} = [aucslist{i,j};hppn{i,j}{k}.auclist];
            aucs{i,j} = [aucs{i,j};hppn{i,j}{k}.auclist2];
            afemale{i,j} = [afemale{i,j};hppn{i,j}{k}.F1];
            amale{i,j} = [amale{i,j};hppn{i,j}{k}.M1];
            if contains(fcluster{i},'f')
                sniffaction2{i,j} = [sniffaction2{i,j};hppn{i,j}{k}.sniffaction{2}];
%                 sniffaction{i,j} = [sniffaction{i,j};hppn{i,j}{k}.sniffaction{2}(find(hppn{i,j}{k}.sniffaction{2}(:,1)>= 60,1),1)];
%                 timemeancue{i,2} = [timemeancue{i,2};mean(hppn{i,j}{k}.M1(:,ceil(sniffaction{i,j}):ceil(sniffaction{i,j})+4),2)];%60秒后第一个sniff后5S
            else
                sniffaction2{i,j} = [sniffaction2{i,j};hppn{i,j}{k}.sniffaction{1}];
%                 sniffaction{i,j} = [sniffaction{i,j};hppn{i,j}{k}.sniffaction{1}(find(hppn{i,j}{k}.sniffaction{1}(:,1)>= 60,1),1)];
%                 timemeancue{i,2} = [timemeancue{i,2};mean(hppn{i,j}{k}.F1(:,ceil(sniffaction{i,j}):ceil(sniffaction{i,j})+4),2)];%60秒后第一个sniff后5S
            end
            for p =1:2
                
                tRise =  sniffaction2{i,j}{k}(sniffaction2{i,j}{k}(:,1)<p*60&sniffaction2{i,j}{k}(:,1)>=p*60-60,1)+30;
                tEnd = sniffaction2{i,j}{k}(sniffaction2{i,j}{k}(:,1)<p*60&sniffaction2{i,j}{k}(:,1)>=p*60-60,2)+30;
                if ~isempty(tEnd)
                    if tEnd(end) >150
                        tEnd(end) = 150;
                    end
                end
                
                tDur = tEnd - tRise;
                flag{p} = revertTTL2bin(tRise, tDur, Fs, tlen);
                if contains(fcluster{i},'f')
                    sniffcut{i,j}{k,p} = hppn{i,j}{k}.M1(:,flag{p});
                    sniffcutmean{i,j}{k,p} = mean(sniffcut{i,j}{k,p},2);
                else
                    sniffcut{i,j}{k,p} = hppn{i,j}{k}.F1(:,flag{p});
                    sniffcutmean{i,j}{k,p} = mean(sniffcut{i,j}{k,p},2);
                end
            end
            for p = 1:2
                 scmall{i,j}{p} = [scmall{i,j}{p};sniffcutmean{i,j}{k,p}];
            end
        end
        for p = 1:2
             scmall{i,j}{p} = scmall{i,j}{p}(~isnan(scmall{i,j}{p}));
        end
        
%         meanfemale{i,j} = mean(afemale{i,j},1);
%         semfemale{i,j} = std(afemale{i,j})/sqrt(size(afemale{i,j},1));
%         meanmale{i,j} = mean(amale{i,j},1);
%         semmale{i,j} = std(amale{i,j})/sqrt(size(amale{i,j},1));
%         if contains(fcluster{i},'f')
%             timemeancue{i,1} = mean(amale{i,j}(:,31:38),2);
%             timemeancue{i,2} = mean(amale{i,j}(:,143:150),2);
%         else
%             timemeancue{i,1} = mean(afemale{i,j}(:,31:38),2);
%             timemeancue{i,2} = mean(afemale{i,j}(:,101:108),2);            
%         end

        
%% trace
    end
end
idxlist = 'ABCDEFGHIJKLMN';
for p =1:4
    x{p} = [];g = [];
    x{p} = [x{p};scmall{p}{1};scmall{p}{2}];            
    q1 = ones(length(scmall{p}{1}),1);
    q2 = ones(length(scmall{p}{2}),1)*2;
    q = [q1;q2];
    [h2{p},p2{p}] = ttest2(scmall{p}{1},scmall{p}{2});
%     xlswrite([savedir,'\datafile\fig2_de_data.xlsx'],{'first','later'},fcluster{p},'A1')
%     for i = 1:2
%        xlswrite([savedir,'\datafile\fig2_de_data.xlsx'],scmall{p}{i},fcluster{p},[idxlist(i),'2'])
%     end

%         [stanova(i,j),~,stats{p}] = anova1(x{p},q);
%         c1{p} =  multcompare(stats{p});
end
hfig = figure();
% scatter(ones(52,1),timemeancue{4,2})
set(gcf,'Position',[300,300,1500,450])
ylength = 60;
    for p =1:4
        g = [];
        subplot(1,4,p)
            g1 = repmat({'1-60'},length(scmall{p}{1}),1);
            g2 = repmat({'61-120'},length(scmall{p}{2}),1);
            g = [g;g1;g2];
            
        boxplot(x{p},g,'colors','k','OutlierSize',8,'symbol','k+')
         text(0.03,ylength*0.9,['p = ',num2str(p2{p})],'fontsize',20)       
        set(gca,'fontsize',20)
        yticks(0:10:100)
        axis([0 3 -5 ylength])
        box off
        title(fcluster{p})
    end

hfig.Renderer = 'Painters';                                                   
hfig.PaperSize = [45,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0408materials\box_2cut_30_raw.pdf']);

