%%
%fig.1 GI
% box not used

%% 
clear; clc; 
% close all;


filefolder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\4_new';
stateslist = {'Esr2m','Esr2f','St18m','St18f','St1817'};
% hfig=figure('color', 'w');
% set(hfig, 'position', [200,200, 300 600]);

for f = 1:length(stateslist)
    meanappe{f} = [];meancons{f} = [];maxallef{f} = [];maxallbf{f} = [];
    [aa{f},datelist{f}] = read2filenew(filefolder,stateslist{f});
    for kk = 1:length(aa{f})
        [result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(aa{f}{kk});
        rtrace = trace(2:end,:);
        Dpick{f}{kk} = [];
% ÕÒËùÓÐfemale cue
        femalelist = [];malelist = [];
        intruderl = neuron.intruder_label;
        actionidx{1} = find(contains(neuron.action_label,'positive'));
        if contains(stateslist{f},'f')
            actionidx{2} = find(contains(neuron.action_label,'mounted'));
        else
            actionidx{2} = find(contains(neuron.action_label,'mounting'));
        end
        actionidx{3} = find(contains(neuron.action_label,'intro'));
        if isempty(actionidx{3})
            actionidx{3} = find(contains(neuron.action_label,'lordo'));
        end
        actionidx{4} = find(contains(neuron.action_label,'ejacu'));

        [cuelist,cuelist2] = searchcuebeforemating(intruderl,actionidx{4},neuron);
        if contains(stateslist{f},'f')
            cuelist = cuelist2;
        end

        Spick = auc_result_7.h_signifi(:,actionidx{1},cuelist(1));
        Mpick = auc_result_7.h_signifi(:,actionidx{2},cuelist(end));
        Ipick = auc_result_7.h_signifi(:,actionidx{3},cuelist(end));
        Epick = auc_result_7.h_signifi(:,actionidx{4},cuelist(end));
        MIpick = Mpick|Ipick;
        pickalls{f}(kk,:) = [sum(Spick)/length(Spick),sum(Mpick)/length(Spick),sum(Ipick)/length(Spick),sum(Epick)/length(Spick),sum(MIpick)/length(Spick)];
        %% settings
        usedlist = FindBase(neuron);
        basestart = usedlist(1);
        baseend = basestart+180;
        act = neuron.intruder(:,1);
        Fs = neuron.Fs;
        ttick = (1:size(dec_data,2)) / Fs;
        nname = neuron.name;
        [nneuron,nframe] = size(rtrace);
        MIpick = Mpick|Ipick;    
        tlen = nframe;
        
                %%
        if contains(aa{f}{kk},'Esr2')
            bothpick = Spick&Epick;
            Apick = Spick&~bothpick; 
            Bpick = Epick&~bothpick;  
            Cpick = Ipick&~(bothpick|Apick|Bpick);
            sumpick = bothpick|Apick|Bpick|Cpick;
            
            tRise = neuron.events{1,actionidx{1}}(find(neuron.events{1,actionidx{1}}(:,1) > neuron.intruder(cuelist(1),1),1),1);
            tEnd = neuron.events{1,actionidx{1}}(find(neuron.events{1,actionidx{1}}(:,1) > neuron.intruder(cuelist(1),1),1),2);
            tDur = tEnd - tRise;
            cuttime{1} = revertTTL2bin(tRise, tDur, Fs, tlen);
            
            tRise = neuron.events{1,actionidx{4}}(find(neuron.events{1,actionidx{4}}(:,1) > neuron.intruder(cuelist(end),1),1),1);
            tEnd = neuron.events{1,actionidx{4}}(find(neuron.events{1,actionidx{4}}(:,1) > neuron.intruder(cuelist(end),1),1),2);
            tDur = tEnd - tRise;
            cuttime{2} = revertTTL2bin(tRise, tDur, Fs, tlen);
        elseif contains(aa{f}{kk},'St18')
%             if contains(stateslist{f},'St1817')
%                 bothpick = Spick&Mpick;
%                 Bpick = Mpick&~bothpick;
%             else
                bothpick = Spick&Ipick;
                Bpick = Ipick&~bothpick;
%             end
            Apick = Spick&~bothpick;
            if ~isempty(Epick)
                Cpick = Epick&~(bothpick|Apick|Bpick|Mpick);
            else
                Cpick = false(length(Bpick),1);
            end
            Dpick{f}{kk} = Mpick&~(bothpick|Apick|Bpick|Epick);
            sumpick = bothpick|Apick|Bpick|Cpick;
            
            firstmount = neuron.events{1,actionidx{2}}(find(neuron.events{1,actionidx{2}}(:,1) > neuron.intruder(cuelist(1),1),1),1);
            tRise = neuron.events{1,actionidx{1}}(neuron.events{1,actionidx{1}}(:,1) > neuron.intruder(cuelist(1),1)&...
            neuron.events{1,actionidx{1}}(:,1) <firstmount,1);
            tEnd = neuron.events{1,actionidx{1}}(neuron.events{1,actionidx{1}}(:,1) > neuron.intruder(cuelist(1),1)&...
            neuron.events{1,actionidx{1}}(:,1) <firstmount,2);
            tDur = tEnd - tRise;
            cuttime{1} = revertTTL2bin(tRise, tDur, Fs, tlen);
%             if contains(aa{f}{kk},'St1817')
%                 tRise = neuron.events{1,actionidx{2}}(neuron.events{1,actionidx{2}}(:,1) > neuron.intruder(cuelist(1),1)&...
%                 neuron.events{1,actionidx{2}}(:,1) <neuron.intruder(cuelist(1),2),1);
%                 tEnd = neuron.events{1,actionidx{2}}(neuron.events{1,actionidx{2}}(:,1) > neuron.intruder(cuelist(1),1)&...
%                 neuron.events{1,actionidx{2}}(:,1) <neuron.intruder(cuelist(1),2),2);
%                 tDur = tEnd - tRise;
%                 cuttime{2} = revertTTL2bin(tRise, tDur, Fs, tlen);            
%             else
                tRise = neuron.events{1,actionidx{3}}(neuron.events{1,actionidx{3}}(:,1) > neuron.intruder(cuelist(end),1)&...
                neuron.events{1,actionidx{3}}(:,1) <neuron.intruder(cuelist(end),2),1);
                tEnd = neuron.events{1,actionidx{3}}(neuron.events{1,actionidx{3}}(:,1) > neuron.intruder(cuelist(end),1)&...
                neuron.events{1,actionidx{3}}(:,1) <neuron.intruder(cuelist(end),2),2);
                tDur = tEnd - tRise; 
                cuttime{2} = revertTTL2bin(tRise, tDur, Fs, tlen);            
%             end
        end  

        for i = 1:length(cuttime)
            Acelltrace{i} = rtrace(Apick|bothpick,cuttime{i});
            Bcelltrace{i} = rtrace(Bpick|bothpick,cuttime{i});
%             Acelltrace{i} = (Acelltrace{i}-mean(Acellbase,2))./std(Acellbase,0,2);
%             Bcelltrace{i} = (Bcelltrace{i}-mean(Bcellbase,2))./std(Bcellbase,0,2);
        end
        meanappe{f} = [meanappe{f};mean(Acelltrace{1},2)];
        meancons{f} = [meancons{f};mean(Bcelltrace{2},2)];
       

        Aper{f}(kk) = sum(Apick)/length(sumpick);
        Bper{f}(kk) = sum(Bpick)/length(sumpick);
        bothper{f}(kk) = sum(bothpick)/length(sumpick);
        Cper{f}(kk) = sum(Cpick)/length(sumpick);
        if isempty(Dpick{f}{kk})
           Dper{f}(kk) = 0;
        else
           Dper{f}(kk) = sum(Dpick{f}{kk})/length(sumpick);
        end
        otherper{f}(kk) = 1 - Aper{f}(kk) - Bper{f}(kk) - bothper{f}(kk);
        neuroncount{f}(kk,1) = sum(sumpick);
        neuroncount{f}(kk,2) = sum(sumpick)- sum(Cpick);
        neuroncount{f}(kk,3) = length(sumpick);

    end
    percent2{f} = [nanmean(Aper{f}),nanmean(Bper{f}),nanmean(bothper{f}),nanmean(otherper{f}),nanmean(Cper{f}),nanmean(Dper{f})];
    sumcount{f}(1) = sum(neuroncount{f}(:,1));
    sumcount{f}(2) = sum(neuroncount{f}(:,2));
    sumcount{f}(3) = sum(neuroncount{f}(:,3));
    pickallmean{f} = mean(pickalls{f},1);
end
hfig=figure('color', 'w');
set(hfig, 'position', [200,200, 1200 300]);
for f = 1:length(stateslist)
    subplot(1,5,f);
%     set(gca,'Position',[0.2,0.55,0.6,0.4])
    ax = gca(); 
    labels = {'other','Ejaculate'};
    nums = [percent2{f}(1),percent2{f}(2),percent2{f}(3),percent2{f}(4)];
    prefer.num = nums;
    newColors = [ 208/256, 143/256, 116/256;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                  187/256,102/256,145/256;  
                  0.72, 0.72, 0.72;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                  1,1,1];  
    if contains(stateslist{f},'St')
        newColors = [ 208/256, 143/256, 116/256;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                      129/256, 162/256,  179/256;
                      0.72, 0.72, 0.72;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                      1,1,1];  
    end
    indNonZero = nums~=0;
    assert(any(indNonZero));
    nums = nums(indNonZero);
    H = pie(nums);
    ax.Colormap = newColors(indNonZero,:);
    T = H(strcmpi(get(H,'Type'),'text'));
    if length(T)==1
        P = get(T,'Position');
    else
        P = cell2mat(get(T,'Position'));
    end
    set(T,{'Position'},num2cell(P*0.25,2), 'Fontsize', 20)
    set(findobj(gca, 'type', 'patch'), 'EdgeAlpha', 1);
    % legend({'Female','Both','Male'},'Location','northoutside');
    t = text(-0.3,-1.3,['n=',num2str(sumcount{f}(3))]);
    t.FontSize = 20;
    t2 = text(-0.3,1.3,['N=',num2str(length(aa{f}))]);
    t2.FontSize = 20;
    set(gca,'Fontsize',20)
    
end

    hfig.Renderer = 'Painters';
    hfig.PaperSize =  [50,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0521materials\pie_actioncut_0530.pdf']);

hfig = figure();
% scatter(ones(52,1),timemeancue{4,2})
set(gcf,'Position',[300,300,1800,450])

idxlist = 'ABCDEFGHIJKLMN';
% savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';

for p =1:length(stateslist)
%     xlswrite([savedir,'\datafile\figs5_efjk_box3.xlsx'],{'appe','cons'},stateslist{p},'A1')
%     xlswrite([savedir,'\datafile\figs5_efjk_box3.xlsx'],meanappe{p},stateslist{p},[idxlist(1),'2'])
%     xlswrite([savedir,'\datafile\figs5_efjk_box3.xlsx'],meancons{p},stateslist{p},[idxlist(2),'2'])
    subplot(1,length(stateslist),p)
        x{p} = [meanappe{p};meancons{p}];            
        g1 = repmat({'appe'},length(meanappe{p}),1);
        g2 = repmat({'cons'},length(meancons{p}),1);
        g = [g1;g2];
        [h2{p},p2{p}] = ttest2(meanappe{p},meancons{p});
    boxplot(x{p},g,'colors','k','OutlierSize',8,'symbol','k+')
         text(0.03,135,['p = ',num2str(p2{p})],'fontsize',20)       
    set(gca,'fontsize',20)
    yticks([-10,0:30:150])
    axis([0 3 -10 150])
    box off
    title(stateslist{p})
end

hfig.Renderer = 'Painters';                                                   
hfig.PaperSize = [50,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0521materials\box_actioncut_0530.pdf']);
