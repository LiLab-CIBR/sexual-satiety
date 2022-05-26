
function FvsTrans_core(fvstrans)

%% 取变量啊取变量

result_folder = fvstrans.result_folder;
animallist = fvstrans.animallist;
transitioncalctime = fvstrans.transitioncalctime;
durtime = fvstrans.durtime;
datasort = fvstrans.datasort;
is_premount = fvstrans.is_premount;
is_firstsniff = fvstrans.is_firstsniff;
is_del_1_trans = fvstrans.is_del_1_trans;
is_merge_sniff = fvstrans.is_merge_sniff;

%% 读文件啊读文件
for i = 1:length(animallist)
    aa{i} = read2filenew(result_folder,animallist{i});
    for j = 1:length(aa{i})
        [filefolder,trace{i}{j}, dec_data{i}{j}, sig_data, neuron{i}{j}, auc_result_7{i}{j}, auc_result_3] = loadfolderToPlot(aa{i}{j});
        cellchooselist = {'St1823'};
        trace{i}{j} = trace{i}{j}(2:end,:);
        if sum(contains(neuron{i}{j}.name,cellchooselist))
            [auc_result_3,auc_result_7{i}{j},neuron{i}{j},trace{i}{j}] = st18celllist(aa{i}{j},neuron{i}{j}.name);
        end
    end 
end


% 标记行为，intruder，交配前的异性cue以及该cue激活的sniff细胞,三种数据类型

for i = 1:length(animallist)
    for j = 1:length(aa{i})
        intruder{i}{j} = neuron{i}{j}.intruder;
        actionidx{i}{j}{1} = find(contains(neuron{i}{j}.action_label,'positive'));
        actionidx{i}{j}{2} = find(contains(neuron{i}{j}.action_label,'mounting'));
        actionidx{i}{j}{3} = find(contains(neuron{i}{j}.action_label,'intro'));
        actionidx{i}{j}{4} = find(contains(neuron{i}{j}.action_label,'ejacu'));
        intruderl = neuron{i}{j}.intruder_label;
        cuelist{i}{j} = searchcuebeforemating(intruderl,actionidx{i}{j}{4},neuron{i}{j});
        Fs{i}{j} = neuron{i}{j}.Fs;
        [num_neuron, nframe{i}{j}] = size(dec_data{i}{j});
        tlen{i}{j} = nframe{i}{j} / Fs{i}{j};

        usedlist = plotstrspl(neuron{i}{j});
        flagbase = revertTTL2bin(usedlist(1), 180, Fs{i}{j}, tlen{i}{j});

        for k = 1:length(cuelist{i}{j})
            auchsig{i}{j}{k} = auc_result_7{i}{j}.h_signifi(:,actionidx{i}{j}{1},cuelist{i}{j}(k));
            switch datasort
                case 'raw'
                    rtrace{i}{j}{k} = trace{i}{j}(auchsig{i}{j}{k},:);
                case 'zscore'
                    rtrace{i}{j}{k} = zscore(trace{i}{j}(auchsig{i}{j}{k},:),0,2);
                case 'sigma'
                    firstbase = trace{i}{j}(auchsig{i}{j}{k},flagbase);
                    rtrace{i}{j}{k} = (trace{i}{j}(auchsig{i}{j}{k},:)-mean(firstbase,2))./std(firstbase,0,2);
                case 'decdata'
                    rtrace{i}{j}{k} = dec_data{i}{j}(auchsig{i}{j}{k},:);
            end
        end

    end
end

%% 计算 transition
for i = 1:length(animallist)
    for j = 1:length(aa{i})
        events = neuron{i}{j}.events;
        % 先标记所有行为
        y0{i}{j} = zeros(1,nframe{i}{j});
        for k = 1:length(actionidx{i}{j})
            if ~isempty(actionidx{i}{j}{k})
                tRise = events{actionidx{i}{j}{k}}(:,1);
                tEnd = events{actionidx{i}{j}{k}}(:,2);
                tDur = tEnd - tRise;
                flagaction{i}{j}{k} = revertTTL2bin(tRise, tDur, Fs{i}{j}, tlen{i}{j});
                y0{i}{j}(1,flagaction{i}{j}{k}) = k;
            end
        end
        % 删除小于2S的无行为
        pos{i}{j} = find(y0{i}{j} ~= 0);
        k=1;
        for p = 1:length(pos{i}{j})-1
            dist2s(p) = pos{i}{j}(p+1) - pos{i}{j}(p)-1;       
            if dist2s(p) > 0 && dist2s(p) < 2*Fs{i}{j}
                seg{i}{j}{k} = pos{i}{j}(p)+1:pos{i}{j}(p+1)-1;
                k=k+1;
            end
        end
        for p = 1:k-1
            y0{i}{j}(seg{i}{j}{p})=y0{i}{j}(seg{i}{j}{p}(1,1)-1);
        end
        % 选取cue长度的片段
        for p = 1:length(cuelist{i}{j})
            tRise = intruder{i}{j}(cuelist{i}{j}(p),1);
            tEnd = intruder{i}{j}(cuelist{i}{j}(p),2);
            if ~isempty(actionidx{i}{j}{4})
                if ~isempty(neuron{i}{j}.intruder_action{cuelist{i}{j}(p),actionidx{i}{j}{4}})
                    tEnd = neuron{i}{j}.intruder_action{cuelist{i}{j}(p),actionidx{i}{j}{4}}+1/Fs{i}{j};
                end
            end
            tDur = tEnd - tRise;
            flag{i}{j}{p} = revertTTL2bin(tRise, tDur, Fs{i}{j}, tlen{i}{j});
            y2{i}{j}{p} = y0{i}{j}(flag{i}{j}{p})+1;
            % squeeze
            squeezey{i}{j}{p} = [y2{i}{j}{p}(1,1)];
            if length(y2{i}{j}{p}) >transitioncalctime*60*Fs{i}{j}
                usedlength = transitioncalctime*60*Fs{i}{j};
            else
                usedlength = length(y2{i}{j}{p});
            end
            for k = 2:usedlength
                if y2{i}{j}{p}(1,k) ~= y2{i}{j}{p}(1,k-1)
                    squeezey{i}{j}{p} = [squeezey{i}{j}{p},y2{i}{j}{p}(1,k)];
                end
            end
            % 算transition
            squeezey1 = squeezey{i}{j}{p}(1:end-1);
            squeezey2 = squeezey{i}{j}{p}(2:end);
            s2mcount = length(find(squeezey1 == 2 & squeezey2 == 3));
            sniffcount = length(find(squeezey1 == 2));
            if sniffcount >0
                s2mrate{i}{j}{p} = (s2mcount)/(sniffcount);
            end
        end
    end
end
        

% 计算F
for i = 1:length(animallist)
    for j = 1:length(aa{i})
        for k = 1:length(cuelist{i}{j})
            if is_premount%如果计算premount sniff
                tRise = neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{1}}(neuron{i}{j}.intruder_action{cuelist{i}{j}(k),...
                actionidx{i}{j}{1}}(:,1)<neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{2}}(1));
                tEnd = neuron{i}{j}.intruder_action2{cuelist{i}{j}(k),actionidx{i}{j}{1}}(neuron{i}{j}.intruder_action{cuelist{i}{j}(k),...
                actionidx{i}{j}{1}}(:,1)<neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{2}}(1));
                tDur = tEnd - tRise;
            elseif is_firstsniff %如果计算first sniff
                %先拼接过短sniff
                delsniffidx{i}{j} = [];
                sniffevents{i}{j} = [neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{1}},neuron{i}{j}.intruder_action2{cuelist{i}{j}(k),actionidx{i}{j}{1}}];
                for ff = size(sniffevents{i}{j},1):-1:2
                    if sniffevents{i}{j}(ff,1) - sniffevents{i}{j}(ff-1,2) < 3
                        delsniffidx{i}{j} = [delsniffidx{i}{j},ff];
                        sniffevents{i}{j}(ff-1,2) = sniffevents{i}{j}(ff,2);
                    end
                end
                sniffevents{i}{j}(delsniffidx{i}{j},:) = [];
                firstm5sniffidx = find(sniffevents{i}{j}(:,2) - sniffevents{i}{j}(:,1) > 0,1);
                tRise =  sniffevents{i}{j}(firstm5sniffidx,1);
                tEnd = sniffevents{i}{j}(firstm5sniffidx,2);
                tDur = tEnd - tRise;
            else%根据时间计算sniff
                if is_merge_sniff%如果要把sniff拼起来
                    tRise = neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{1}}(neuron{i}{j}.intruder_action{cuelist{i}{j}(k),...
                    actionidx{i}{j}{1}}(:,1) < neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{1}}(1)+durtime);
                    tEnd = neuron{i}{j}.intruder_action2{cuelist{i}{j}(k),actionidx{i}{j}{1}}(neuron{i}{j}.intruder_action{cuelist{i}{j}(k),...
                    actionidx{i}{j}{1}}(:,1) < neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{1}}(1)+durtime);
                    if tEnd(end)>neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{1}}(1)+durtime%如果最后一个sniff超过限定时间
                        tEnd(end) = neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{1}}(1)+durtime;
                    end
                    tDur = tEnd - tRise;                    
                else%不限制行为取限定时间
                    tRise = neuron{i}{j}.intruder_action{cuelist{i}{j}(k),actionidx{i}{j}{1}}(1,1);
                    tDur = durtime;
                end
            end
            flagsniff{i}{j}{k} = revertTTL2bin(tRise, tDur, Fs{i}{j}, tlen{i}{j});
            strace{i}{j}{k} = rtrace{i}{j}{k}(:,flagsniff{i}{j}{k});
            normalizedtrace{i}{j}{k} = mean(mean(strace{i}{j}{k},1));
            snifftraceauc{i}{j}{k} = trapz(mean(strace{i}{j}{k},1));
        end
    end
end

% out 
mfc = []; s2mc = [];sauc = [];
for i = 1:length(animallist)
    mlc2 = [];
    for j = 1:length(aa{i})
        s2mratelist{i,j} = [];
        meanF{i,j} = [];
        Fauc{i,j} = [];
        for p = 1:length(cuelist{i}{j})
            if ~isempty(actionidx{i}{j}{2})%有mount
                if ~isempty(neuron{i}{j}.intruder_action{cuelist{i}{j}(p),actionidx{i}{j}{2}})%这个cue里有mount
                    if is_del_1_trans%去掉100%transition
                        if s2mrate{i}{j}{p} ~= 1
                            s2mratelist{i,j} = [s2mratelist{i,j},s2mrate{i}{j}{p}];
                            meanF{i,j} = [meanF{i,j},normalizedtrace{i}{j}{p}];
                            Fauc{i,j} = [Fauc{i,j},snifftraceauc{i}{j}{p}];
                        end
                    else
                        s2mratelist{i,j} = [s2mratelist{i,j},s2mrate{i}{j}{p}];
                        meanF{i,j} = [meanF{i,j},normalizedtrace{i}{j}{p}];
                        Fauc{i,j} = [Fauc{i,j},snifftraceauc{i}{j}{p}];
                    end
                end
            end
        end
        if ~isempty(actionidx{i}{j}{2})
            tempmfc = meanF{i,j};
            mfc = [mfc,tempmfc];
            s2mc = [s2mc,s2mratelist{i,j}];
            sauc = [sauc,Fauc{i,j}];
        end
    end
end


%% averageF
ylength = nanmean(mfc)+3*nanstd(mfc);
labellist = {['ΔF(',datasort,')'],'Sniff to mount transition'};
[s2mvsmF,ps2mvsmF]=corrcoef(s2mc,mfc);

hfig = figure();
set(gcf,'Position',[300,300,450,450])
hold on;
scatter(s2mc,mfc,'.');
pn = polyfit(s2mc,mfc,1);
yy=polyval(pn,s2mc);
plot(s2mc,yy,'k','linewidth',1.5)
ylabel(labellist{1})
xlabel(labellist{2})
% title(num2str(ps2mvsmF(1,2)))
text(0.03,ylength*0.95,['r = ',num2str(s2mvsmF(1,2))],'fontsize',20)
text(0.03,ylength*0.88,['p = ',num2str(ps2mvsmF(1,2))],'fontsize',20)
% scatter(x1,nomountfc,'.')
% text(s2mc,mfc,namelist2)
axis([-0.05 1.05 0 ylength])
set(gca,'FontSize',20)
xticks([0,0.5,1])
xticklabels({'0','50%','100%'})
hfig.Renderer = 'Painters';
hfig.PaperSize = [20,20];

%% averageF
% ylength = mean(sauc)+3*std(sauc);
% labellist = {'σF auc','Sniff to mount transition'};
% [s2mvsmF,ps2mvsmF]=corrcoef(s2mc,sauc);

% hfig = figure();
% set(gcf,'Position',[300,300,450,450])
% hold on;
% scatter(s2mc,sauc,'.');
% pn = polyfit(s2mc,sauc,1);
% yy=polyval(pn,s2mc);
% plot(s2mc,yy,'k','linewidth',1.5)
% ylabel(labellist{1})
% xlabel(labellist{2})
% % title(num2str(ps2mvsmF(1,2)))
% text(0.03,ylength*0.95,['r = ',num2str(s2mvsmF(1,2))],'fontsize',20)
% text(0.03,ylength*0.88,['p = ',num2str(ps2mvsmF(1,2))],'fontsize',20)
% % scatter(x1,nomountfc,'.')
% % text(s2mc,mfc,namelist2)
% axis([-0.05 1.05 0 ylength])
% set(gca,'FontSize',20)
% xticks([0,0.5,1])
% xticklabels({'0','50%','100%'})
% hfig.Renderer = 'Painters';
% hfig.PaperSize = [20,20];

%% save


for i =1:5
    namecut{i} = '';
end

numcut{1} = ['_',animallist{1}(1:4)];
if is_premount
    numcut{2} = '_premount';
elseif is_firstsniff
    numcut{2} = '_firstsniff';
elseif is_merge_sniff
    numcut{2} = ['_merge_',num2str(durtime),'S_sniff'];
else
    numcut{2} = ['_',num2str(durtime),'S_sniff'];
end
numcut{3} = ['_',num2str(transitioncalctime)];

numcut{4} = ['_',datasort];

if is_del_1_trans
    numcut{5} = '_del_1_trans';
end
idxlist = 'ABCDEFGHIJKLMN';
clusterlist = {'transition','F'};
savename = ['S',numcut{1},numcut{2}];
% xlswrite(['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out\datafile\fig2f_figs5ab.xlsx'],clusterlist,savename,'A1')
% xlswrite(['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out\datafile\fig2f_figs5ab.xlsx'],s2mc',savename,'A2')
% xlswrite(['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out\datafile\fig2f_figs5ab.xlsx'],mfc',savename,'B2')
%     saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0521materials\',...
%         'FTransCorr',numcut{1},numcut{2},numcut{3},numcut{4},numcut{5},'.pdf']);
% 
end
