%%
%fig.S5 DG

%% 

clear; clc; 
% close all;
%% only change this two var
filefolder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\4_new';
% stateslist = {'Esr2m','Esr2f'};
stateslist = {'St18m','St18f'};


ylim = 15;
celltype = 1;
if contains(stateslist,'St18')
    celltype = 0;
    ylim = 5;
end

for f = 1:length(stateslist)
    maxallf{f} = [];
    [filelist{f},datelist{f}] = read2file(filefolder,stateslist{f});
    for kk = 1:length(filelist{f})
        [result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filelist{f}{kk});
        trace = trace(2:end,:);
        rtrace = zscore(trace,[],2);
        % ÕÒËùÓÐfemale cue
        femalelist = [];malelist = []; 
        gender = neuron.gender;
        intruderl = neuron.intruder_label;
        actionidx{1} = find(contains(neuron.action_label,'positive'));% positive means male sniff female
        if gender
            actionidx{2} = find(contains(neuron.action_label,'mounting'));
        else
            actionidx{2} = find(contains(neuron.action_label,'mounted'));
        end
        actionidx{3} = find(contains(neuron.action_label,'intro'));% intro means intromission for male and lordosis for female
        actionidx{4} = find(contains(neuron.action_label,'ejacu'));

        [cuelist,cuelist2] = searchcuebeforemating(intruderl,actionidx{4},neuron);
        if ~gender
            cuelist = cuelist2;
        end
        
%% settings
        usedlist = FindBase(neuron);
        basestart = usedlist(1);
        baseend = basestart+180;
        Fs = neuron.Fs;
        [nneuron,nframe] = size(rtrace);
%% neuPick
        Spick = auc_result_7.h_signifi(:,actionidx{1},cuelist(1));
        Mpick = auc_result_7.h_signifi(:,actionidx{2},cuelist(end));
        Ipick = auc_result_7.h_signifi(:,actionidx{3},cuelist(end));
        Epick = auc_result_7.h_signifi(:,actionidx{4},cuelist(end));
        MIpick = Mpick|Ipick;
%%
        if celltype
            cellpick = Spick|Epick;
        else
            cellpick = Spick|Ipick;
        end
        
        if celltype
            tlen = nframe;
            tRise = neuron.events{1,actionidx{1}}(find(neuron.events{1,actionidx{1}}(:,1) >= neuron.intruder(cuelist(1),1),1),1);
            tEnd = neuron.events{1,actionidx{1}}(find(neuron.events{1,actionidx{1}}(:,1) >= neuron.intruder(cuelist(1),1),1),2);
            tDur = tEnd - tRise;
            flag2{1} = revertTTL2bin(tRise, tDur, Fs, tlen);% first sniff
            tRise = neuron.events{1,actionidx{4}}(1,1);
            tEnd = neuron.events{1,actionidx{4}}(1,2);
            tDur = tEnd - tRise;
            flag2{2} = revertTTL2bin(tRise, tDur, Fs, tlen);% ejacu
        else
            firstmount = neuron.events{1,actionidx{2}}(find(neuron.events{1,actionidx{2}}(:,1) > neuron.intruder(cuelist(1),1),1),1);
            tlen = nframe;
            tRise = neuron.events{1,actionidx{1}}(neuron.events{1,actionidx{1}}(:,1) >= neuron.intruder(cuelist(1),1)&...
                neuron.events{1,actionidx{1}}(:,1) < firstmount,1);
            tEnd = neuron.events{1,actionidx{1}}(neuron.events{1,actionidx{1}}(:,1) >= neuron.intruder(cuelist(1),1)&...
                neuron.events{1,actionidx{1}}(:,1) < firstmount,2);
            tDur = tEnd - tRise;
            flag2{1} = revertTTL2bin(tRise, tDur, Fs, tlen);% pre-mount sniff
            tRise = neuron.events{1,actionidx{3}}(neuron.events{1,actionidx{3}}(:,1) > neuron.intruder(cuelist(end),1)&...
            neuron.events{1,actionidx{3}}(:,1) <neuron.intruder(cuelist(end),2),1);
            tEnd = neuron.events{1,actionidx{3}}(neuron.events{1,actionidx{3}}(:,1) > neuron.intruder(cuelist(end),1)&...
            neuron.events{1,actionidx{3}}(:,1) <neuron.intruder(cuelist(end),2),2);
            tDur = tEnd - tRise;
            flag2{2} = revertTTL2bin(tRise, tDur, Fs, tlen);% intro
        end
        for i = 1:length(flag2)
            celltrace{i} = rtrace(cellpick,flag2{i});
            maxf{f}{kk}(:,i) = mean(celltrace{i},2);
        end
        maxallf{f} = [maxallf{f};maxf{f}{kk}];
    end
end


hfig = figure();
set(gcf,'Position',[300,300,500,500])
axis([-2 8 -2 ylim])
colorlist = {[0,0,0.6],[1,0.3,0.1]};
ylim2 =ylim +2;
for f = 1:2
[mlvsmF{f},pmlvsmF{f}]=corrcoef(maxallf{f}(:,1),maxallf{f}(:,2));
hold on;
h1 = scatter(maxallf{f}(:,1),maxallf{f}(:,2),'o','MarkerEdgeColor',colorlist{f});
set(h1, 'MarkerEdgealpha',0.4)

pn = polyfit(maxallf{f}(:,1),maxallf{f}(:,2),1);
yy=polyval(pn,maxallf{f}(:,1));
plot(maxallf{f}(:,1),yy,'color',colorlist{f},'linewidth',1.5)
text(0,ylim2-f*ylim2/7-2,['r = ',num2str(mlvsmF{f}(1,2))],'fontsize',20,'color',colorlist{f})
text(0,ylim2-(f+0.5)*ylim2/7-2,['p = ',num2str(pmlvsmF{f}(1,2))],'fontsize',20,'color',colorlist{f})
end
xlabel('mean sniff ¦¤F(zscore)')
ylabel('mean intromission ¦¤F(zscore)')
set(gca,'Fontsize',20)

savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221123over';
for f = 1:2
    xlswrite([savedir,'\figs5_dg_corr.xlsx'],{'sniff','intromission'},stateslist{f},'A1')
    xlswrite([savedir,'\figs5_dg_corr.xlsx'],maxallf{f},stateslist{f},'A2')
end

hfig.Renderer = 'Painters';
hfig.PaperSize = [20,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0515materials\newactioncorr\action_corr_of',stateslist{f}(1:4),'.pdf']);

function [filefolder2,datelist] = read2file(filedir,animalnum)
    filelist2 = dir([filedir,'\',animalnum]);
    filelist2 = {filelist2.name};
    ind_trace_mat = find(~contains(filelist2, '.'));
    for i =1:length(ind_trace_mat)
        filefolder2{i} = fullfile([filedir,'\',animalnum], filelist2{ind_trace_mat(i)});
        datelist{i} = filelist2{ind_trace_mat(i)};
    end
end