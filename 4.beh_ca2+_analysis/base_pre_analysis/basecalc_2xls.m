
%%
% all base data's pre-analysis
% generate fig.s9 H

%%


clear;clc
%% settings
sd = 1.5;
outeramp = 10;
result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';%路径
animallist ={ 'Esr229'};%'Esr222','Esr229','Esr230',Esr252 'Esr237','Esr24','Esr240','Esr235','Esr254'

%% 结果保存地址
%% 搜索事件的方法
%% 对于foopsi：mean+多少stdσF以下视为无反应
thresh.cut_before_ejacu = 1;
thresh.before_ejacu_time = 20;% 对于female 用交配cue的第一个intro做结尾
%     thresh.outeramp = 10;
thresh.outeramp = outeramp;
thresh.is_sig_waive = 0;
%     thresh.sd = 1.5;
thresh.sd = sd;
%     thresh.calcunit = 'date';%'neuron';
thresh.deckernel = 'ar1';% 'ar2','exp2'
%% 合并cue
merge.domerge = 1;
merge.mergelist = {};
%% 自动合并和切割
cutmerge.automerge = 1;
cutmerge.autocut = 1;
cutmerge.timelist = {[0,5],[0,0]};
%% 删除细胞
delcell.dodel = 0;
delcell.dellist = [1,22];
%% 只显示persistent cells
showpostcells = 0;
%% 切割post ejaculation
cutpost.ejacucut = 0;
cutpost.timechoose = 3;
%% 画不画trace
dodrawtrace = 1;
%%

%% 单个运行
% filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr29\Esr290323';
% [meanfreq,meanamp,name,durlist,typelist,fa0percent,outtemp2] = basecalc_new(filefolder,savedir,detectmethod,hresh,merge,delcell,showpostcells,cutpost,dodrawtrace,cutmerge,cchoose) ;   
% 
% %% 输出 xls
% trials = 0;
% trials = savetoxls(savedir,meanfreq,meanamp,name,durlist,typelist,fa0percent,outtemp2,trials);

 
trials = 0;
for i = 1:length(animallist)
    aa{i} = read2filenew(result_folder,animallist{i});
    savedir = ['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20220930temp222\allbase_dzy1_',num2str(sd),'SD_',num2str(outeramp),'Ampli_all_',animallist{i}];
    mkdir(savedir);
    mkdir([savedir,'\allheat'])

    for j = 1:length(aa{i})
%         cchoose.neurons = cchooselist{i}{j};
        [meanfreq,meanamp,name,durlist,typelist,fa0percent,outtemp2] = basecalc_new(aa{i}{j},savedir,thresh,merge,delcell,showpostcells,cutpost,dodrawtrace,cutmerge) ;   

         %% 输出 xls
        trials = savetoxls(savedir,meanfreq,meanamp,name,durlist,typelist,fa0percent,outtemp2,trials);
        close all
    
    end 
end


function [meanfreq,meanamp,name,durlist,typelist,fa0percent,outtemp2] =basecalc_new(filefolder,savedir,thresh,merge,delcell,showpostcells,cutpost,dodrawtrace,cutmerge)

[~,trace, ~, ~, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);%%%
trace = trace(2:end,:);
ejacuidx = find(contains(neuron.action_label,'ejacu'));
introidx = find(contains(neuron.action_label,'intro'));
 if isempty(introidx)
     introidx = find(contains(neuron.action_label,'lordo'));
 end 
usedcells = ones(size(trace,1),1);
name = neuron.name;
Fs = neuron.Fs;
ppecells = [];
ejacutime = [];
if ~isempty(ejacuidx)
    load([filefolder,'\auc_result_new_1min.mat'],'saveauc');
    poste1idx = length(neuron.action_label)+1;
    ejacucue = find(neuron.intruder(:,2)>neuron.events{ejacuidx}(1,1),1);
    ejacutime = neuron.events{ejacuidx}(1,1);
    if ~neuron.gender
        ejacutime = neuron.events{introidx}(1,1);
    end
    ppecells = saveauc.h_signifi(:,ejacuidx,ejacucue)&saveauc.h_signifi(:,poste1idx,ejacucue);
end
if showpostcells
    usedcells = usedcells&ppecells;
end
ejacucellidx = find(ppecells);

if delcell.dodel
    delcells = zeros(size(trace,1),1);
    delcells(delcell.dellist) = 1;
    usedcells = usedcells&~delcells;
end


usedcells = logical(usedcells);
neuronlist = find(usedcells);
trace = trace(usedcells,:);
name = neuron.name;
mkdir([savedir,'\',name])
%% 先计算整根trace的event
if thresh.cut_before_ejacu
    cutetime = thresh.before_ejacu_time*Fs*60;
    if cutetime> size(trace,2)
        cutetime = size(trace,2);
    end
    if isempty(ejacutime)
        if ejacutime - 30*Fs < thresh.before_ejacu_time*Fs*60
            cutetime = ejacutime - 30*Fs;
        end
    end
else
    cutetime = size(trace,2);
end
eventtrace = wholetracedec(trace,thresh,cutetime);
%% 统计当天所有base，选中片段并计算freq和amp    
outputlist = plotstrsplall(neuron);
typelist = {};
rawbasesize = size(outputlist,2);
durlist = outputlist(2,:) - outputlist(1,:);
for i = 1:size(outputlist,2)
    if outputlist(3,i) == 2
        typelist = [typelist,['post ejaculation  dur:',num2str(durlist(i))]];
    else
        typelist = [typelist,['dur:',num2str(durlist(i))]];
    end
end
for i = 1:rawbasesize
    timecut = outputlist(1:2,i)';
    [freq{i},amp{i},sigtrace{i},rawtrace{i}] =  calcFAbytime(trace,timecut,neuron,eventtrace);
    meanfreq(i) = mean(freq{i});
    meanamp(i) = mean(amp{i});
end

ejacuheatidx = find(outputlist(3,:)==2);

if merge.domerge
    if cutmerge.automerge
        if isempty(ejacuidx)
            mergelists = 1:1:rawbasesize;
            for j = 1:length(cutmerge.timelist)
                [typelist,durlist,freq{rawbasesize+1},amp{rawbasesize+1},sigtrace{rawbasesize+1},rawtrace{rawbasesize+1}] = mergecues(typelist,durlist,mergelists,trace,outputlist,neuron,eventtrace,cutmerge,j);            
                meanfreq(rawbasesize+1) = mean(freq{rawbasesize+1});
                meanamp(rawbasesize+1) = mean(amp{rawbasesize+1});
                rawbasesize = rawbasesize+1;
                firstcut = rawbasesize-1;
            end
        else
            tempbefore = 0;tempafter = 0;
            if ejacuheatidx(1) > 2
                mergelists = 1:1:ejacuheatidx(1)-1;
                [typelist,durlist,freq{rawbasesize+1},amp{rawbasesize+1},sigtrace{rawbasesize+1},rawtrace{rawbasesize+1}] = mergecues(typelist,durlist,mergelists,trace,outputlist,neuron,eventtrace,cutmerge,1);            
                meanfreq(rawbasesize+1) = mean(freq{rawbasesize+1});
                meanamp(rawbasesize+1) = mean(amp{rawbasesize+1});
                tempbefore = 1;
                firstcut = rawbasesize+1;                
            end
            if rawbasesize - ejacuheatidx(end) > 1
                mergelists = ejacuheatidx(end)+1:1:rawbasesize;
                [typelist,durlist,freq{rawbasesize+2},amp{rawbasesize+2},sigtrace{rawbasesize+2},rawtrace{rawbasesize+2}] = mergecues(typelist,durlist,mergelists,trace,outputlist,neuron,eventtrace,cutmerge,2);            
                meanfreq(rawbasesize+2) = mean(freq{rawbasesize+2});
                meanamp(rawbasesize+2) = mean(amp{rawbasesize+2});
                tempafter = 1;
            end
            rawbasesize = rawbasesize+tempbefore+tempafter;
        end
    else
        for i = 1:length(merge.mergelist)
            mergelists = merge.mergelist{i};
            [typelist,durlist,freq{rawbasesize+i},amp{rawbasesize+i},sigtrace{rawbasesize+i},rawtrace{rawbasesize+i}] = mergecues(typelist,durlist,mergelists,trace,outputlist,neuron,eventtrace,cutmerge);            
            meanfreq(rawbasesize+i) = mean(freq{rawbasesize+i});
            meanamp(rawbasesize+i) = mean(amp{rawbasesize+i});
        end
        rawbasesize = rawbasesize+length(merge.mergelist);
    end
end

    

%% ejacu cut
if cutpost.ejacucut &&ismember(2,outputlist(3,:))
    kk = 1;
    for i = 1:length(ejacuheatidx)
        postlength = outputlist(2,ejacuheatidx(i)) -  outputlist(1,ejacuheatidx(i)) ;
        numcut = ceil(postlength/(cutpost.timechoose*60));
        for j = 1:numcut-1
            typelist = [typelist,['no.',num2str(i),' ejacu:',num2str((j-1)*cutpost.timechoose+1),'-',num2str(j*cutpost.timechoose+1),'min']];
            timecut = [outputlist(1,ejacuheatidx(i))+(j-1)*cutpost.timechoose*60,outputlist(1,ejacuheatidx(i))+j*cutpost.timechoose*60-1];
            [freq{rawbasesize+kk},amp{rawbasesize+kk},sigtrace{rawbasesize+kk},rawtrace{rawbasesize+kk}] =  calcFAbytime(trace,timecut,neuron,eventtrace);
            meanfreq(rawbasesize+kk) = mean(freq{rawbasesize+kk});
            meanamp(rawbasesize+kk) = mean(amp{rawbasesize+kk});
            durlist = [durlist,cutpost.timechoose*60];
            kk = kk+1;
        end
        tempdur = postlength - (numcut-1)*cutpost.timechoose*60;
        typelist = [typelist,['no.',num2str(i),' ejacu:',num2str((numcut-1)*cutpost.timechoose+1),'-',num2str(ceil(postlength/60)),'min dur:',num2str(tempdur)]];
        timecut = [outputlist(1,ejacuheatidx(i))+(numcut-1)*cutpost.timechoose*60,outputlist(2,ejacuheatidx(i))];
        [freq{rawbasesize+kk},amp{rawbasesize+kk},sigtrace{rawbasesize+kk},rawtrace{rawbasesize+kk}] =  calcFAbytime(trace,timecut,neuron,eventtrace);
        meanfreq(rawbasesize+kk) = mean(freq{rawbasesize+kk});
        meanamp(rawbasesize+kk) = mean(amp{rawbasesize+kk});
        durlist = [durlist,tempdur];
        kk = kk+1;
    end
end

outtemp2 = [neuronlist';freq{firstcut};amp{firstcut}];
%% 画两种图
% drawheatmap(rawtrace,meanfreq,meanamp,name,typelist,savedir)
fa0percent = drawheatmap(rawtrace,meanfreq,meanamp,name,typelist,savedir,freq,amp);
if dodrawtrace && ~delcell.dodel
    drawtraceall(trace,eventtrace,neuron,savedir,ejacucellidx,neuronlist,outtemp2(2,:))
end
end


function eventtrace = wholetracedec(trace,thresh,cutetime)

[nneuron,nframe] = size(trace);

calctrace = trace(:,1:cutetime);
sig_waive_mean = zeros(nneuron,1);
sig_waive_std = zeros(nneuron,1);
for p = 1:nneuron
        flag3 = true(1,cutetime);
        outerlist = calctrace(p,:) - thresh.outeramp>0;
        flag3(1,outerlist) = false;
        if sum(flag3)>0
            sig_waive_mean(p,1) = mean(calctrace(p,flag3));
            sig_waive_std(p,1) = std(calctrace(p,flag3));
        end
end

decusedtrace = trace - sig_waive_mean-thresh.sd*sig_waive_std;


[nneuron,nframe] = size(decusedtrace);
dec_data2 = zeros(nneuron,nframe);
sig_data2 = zeros(nneuron,nframe);
lambda = 1.5;
deckernel = thresh.deckernel;
parfor ii=1:nneuron
        [dec_trace, signal, ~] = deconvolveCa(decusedtrace(ii,:), deckernel, 'foopsi', 'lambda', lambda, 'optimize_pars');
        dec_data2(ii,:) = dec_trace';
        sig_data2(ii,:) = signal';
end
mean_sig_waive_mean = mean(sig_waive_mean);
mean_sig_waive_std = mean(sig_waive_std);
decevents = sig_data2;
decevents(decevents >0) = 1;
logical(decevents);
eventtrace = trace.*decevents;

end





function [frequencies,amp,sigtrace,rawtrace] = calcFAbytime(trace,timecut,neuron,eventtrace)

Fs = neuron.Fs;
tlen = neuron.nframe/Fs;
tDur1 = timecut(:,2) - timecut(:,1);
flag2 =  revertTTL2bin(timecut(:,1), tDur1, Fs, tlen);
if length(flag2)>neuron.nframe
    flag2(neuron.nframe+1:end) = [];
end
newtrace = eventtrace(:,flag2);
%获取事件数和平均强度
for p = 1:size(newtrace,1)
    amp(p) = mean(newtrace(p,newtrace(p,:)>0));
    spikecounts(p) = length(newtrace(p,newtrace(p,:)>0));
    if isnan(amp(p))
        amp(p) = 0;
        spikecounts(p) = 0;
    end
end  
alltimelength = sum(tDur1);
frequencies = spikecounts/alltimelength;
sigtrace = newtrace;
rawtrace = trace(:,flag2);

end


function fa0percent = drawheatmap(rawtrace,meanfreq,meanamp,name,typelist,savedir,freq,amp)

numfig = length(meanfreq);
hfig = figure('position',[100,100,300*numfig,800]);
hold on;
fa0percent = [];
for i = 1:numfig
    % 热图
    subplot(3,numfig,i)
    imagesc(rawtrace{i}, 'xdata', [1,size(rawtrace{i},2)], 'ydata', [1,size(rawtrace{i},1)])
    xlabel(typelist(i))
    title(['Amp: ',num2str(meanamp(i)),newline,'Freq:',num2str(meanfreq(i))])
    colormap jet
    set(gca, 'clim',[-10,100])
    % freq频率分布图
    subplot(3,numfig,i+numfig)
    histogram(freq{i}(freq{i}>0),[0:0.03:0.3])
%     sum(freq{i}==0)
    title([num2str(sum(freq{i}==0)),' / ',num2str(sum(freq{i}>0))])
    ylim([0,length(freq{i})])
    yticks([0,length(freq{i})/4,length(freq{i})/2,length(freq{i})*3/4,length(freq{i})])
    yticklabels({'0','25%','50%','75%','100%'})
    %     freq{i}
    % amp频率分布图
    subplot(3,numfig,i+numfig*2)
    histogram(amp{i}(amp{i}>0),[0:5:50])
    xlabel(['amp:',num2str(mean(amp{i}(amp{i}>0))),newline,'freq:',num2str(mean(freq{i}(freq{i}>0)))])
    ylim([0,length(freq{i})])
    yticks([0,length(freq{i})/4,length(freq{i})/2,length(freq{i})*3/4,length(freq{i})])
    yticklabels({'0','25%','50%','75%','100%'})
    fa0percent = [fa0percent;sum(freq{i}==0)/length(freq{i})];
end
suptitle(name)
hfig.Renderer = 'Painters';
hfig.PaperSize = [100,40];
saveas(gcf,[savedir,'\allheat\',name,'_overall_heatplot.pdf']);
saveas(gcf,[savedir,'\',name,'\',name,'_overall_heatplot.pdf']);
 
end


function drawtraceall(trace,eventtrace,neuron,savedir,ejacucellidx,neuronlist,freq)
Fs = neuron.Fs;
name = neuron.name;
[numneuron,nframe] = size(trace);

x = 1:1:nframe;
for k = 1:ceil(numneuron/10)
    hfig = figure('position',[100,100,1500,800]);
    hold on;
    for i = 1:10
        if (k-1)*10+i <= numneuron
            rawtrace = trace((k-1)*10+i,:);
            sigtrace = logical(eventtrace((k-1)*10+i,:));
            subplot(5,2,i)
            plot(x,rawtrace)
            hold on;
            plot(x(sigtrace>0),sigtrace(sigtrace>0)+100,'.r')
            axis([0,nframe,-10,120])
            for ii = 1:size(neuron.action_label,2)%画行为颜色
                if  contains(lower(neuron.action_label{ii}),'positive')||contains(lower(neuron.action_label{ii}),'mount')||...
                     contains(lower(neuron.action_label{ii}),'intro')||contains(lower(neuron.action_label{ii}),'ejac')
                event_now = neuron.events{ii}*Fs; %centered by event-action
                if isempty(event_now); continue; end
                hi = barpatch(event_now(:,1), event_now(:,2)-event_now(:,1),[110 150],neuron.color{ii});
                set(hi, 'facealpha', 1);
                end
            end
            if ismember((k-1)*10+i,ejacucellidx)
%                 title(['Post neuron id: ',num2str(neuronlist((k-1)*10+i)),'  freq: ',num2str(sum(sigtrace)*10/length(sigtrace))]);
                title(['Post neuron id: ',num2str(neuronlist((k-1)*10+i)),'  freq: ',num2str(freq((k-1)*10+i))]);
            else
%                 title(['neuron id: ',num2str(neuronlist((k-1)*10+i)),'  freq: ',num2str(sum(sigtrace)*10/length(sigtrace))]);
                title(['neuron id: ',num2str(neuronlist((k-1)*10+i)),'  freq: ',num2str(freq((k-1)*10+i))]);
            end
        end
    end
suptitle([neuron.name,'--page ',num2str(k)])
hfig.Renderer = 'Painters';
hfig.PaperSize = [40,30];
saveas(gcf,[savedir,'\',name,'\',name,'_page',num2str(k),'.pdf']);


end


end


function trials = savetoxls(savedir,meanfreq,meanamp,name,durlist,typelist,fa0percent,outtemp2,trials)

    
xlswrite([savedir,'\freq_amp_all.xlsx'],typelist',name,'A2')
xlswrite([savedir,'\freq_amp_all.xlsx'],durlist',name,'B2')
xlswrite([savedir,'\freq_amp_all.xlsx'],meanfreq',name,'C2')
xlswrite([savedir,'\freq_amp_all.xlsx'],meanamp',name,'D2')
xlswrite([savedir,'\freq_amp_all.xlsx'],fa0percent,name,'E2')
xlswrite([savedir,'\freq_amp_all.xlsx'],[{'name'},{'duration'},{'freq'},{'amp'},{'''=0%'}],name,'A1')

xlswrite([savedir,'\freq_amp_',name(1:end-4),'.xlsx'],[{'neuron_id'},{'freq'},{'amp'}],name,'A1')
xlswrite([savedir,'\freq_amp_',name(1:end-4),'.xlsx'],outtemp2',name,'A2')

trials = trials + 1;
numlist = [0:0.01:0.2];
filllist = zeros(1,length(numlist));
strlist = {'date_id'};
for i = 1:length(numlist)
    strlist = [strlist,num2str(numlist(i))];
end
xlswrite([savedir,'\freq_amp_',name(1:end-4),'.xlsx'],strlist,name(1:end-4),'A1')
for i = 1:size(outtemp2,2)
    filllist(numlist == floor(outtemp2(2,i)*100)/100) = filllist(numlist == floor(outtemp2(2,i)*100)/100)+1;
    if ~find(numlist == floor(outtemp2(2,i)*100)/100)
        filllist(end) = filllist(end)+1;
    end
end
xlswrite([savedir,'\freq_amp_',name(1:end-4),'.xlsx'],filllist,name(1:end-4),['B',num2str(trials+1)])
xlswrite([savedir,'\freq_amp_',name(1:end-4),'.xlsx'],{name},name(1:end-4),['A',num2str(trials+1)])
end


function [typelist,durlist,freq,amp,sigtrace,rawtrace] = mergecues(typelist,durlist,mergelists,trace,outputlist,neuron,eventtrace,cutmerge,idxx)

ejacuidx = find(contains(neuron.action_label,'ejacu'));
tempstr = num2str(mergelists(1));
for j = 2:length(mergelists)
    tempstr = [tempstr,'+',num2str(mergelists(j))];
end
if cutmerge.automerge
    if isempty(ejacuidx)
        tempstr = ['all  ',num2str(cutmerge.timelist{idxx}(1)),'-',num2str(cutmerge.timelist{idxx}(2)),'min'];
    else
        if mergelists(1) == 1
        tempstr = ['before  ',num2str(cutmerge.timelist{idxx}(1)),'-',num2str(cutmerge.timelist{idxx}(2)),'min'];
        else
        tempstr = ['after  ',num2str(cutmerge.timelist{idxx}(1)),'-',num2str(cutmerge.timelist{idxx}(2)),'min'];
        end
    end
end
timecut = outputlist(1:2,mergelists)';
tempdur = sum(timecut(:,2) - timecut(:,1));
if cutmerge.autocut
    tempdur = (cutmerge.timelist{idxx}(2) - cutmerge.timelist{idxx}(1))*60;        
end
typelist = [typelist,['merge cue: ',tempstr,' dur:',num2str(tempdur)]];
durlist = [durlist,tempdur];
[freq,amp,sigtrace,rawtrace] =  calcFAbytimemerge(trace,timecut,neuron,eventtrace,cutmerge,idxx);


end


function [frequencies,amp,sigtrace,rawtrace] = calcFAbytimemerge(trace,timecut,neuron,eventtrace,cutmerge,idxx)

Fs = neuron.Fs;
tlen = neuron.nframe/Fs;
tDur1 = timecut(:,2) - timecut(:,1);
flag2 =  revertTTL2bin(timecut(:,1), tDur1, Fs, tlen);
if length(flag2)>neuron.nframe
    flag2(neuron.nframe+1:end) = [];
end
flag2list = find(flag2==1);
alltimelength = sum(tDur1);

if cutmerge.autocut
    if length(flag2list) > cutmerge.timelist{idxx}(2)*60*Fs - cutmerge.timelist{idxx}(1)*60*Fs+1
        flag2list = flag2list(cutmerge.timelist{idxx}(1)*60*Fs+1:cutmerge.timelist{idxx}(2)*60*Fs);
        alltimelength = (cutmerge.timelist{idxx}(2) - cutmerge.timelist{idxx}(1))*60;
    else
        alltimelength = length(flag2list)/Fs;
    end
end
newtrace = eventtrace(:,flag2list);
%获取事件数和平均强度
for p = 1:size(newtrace,1)
    amp(p) = mean(newtrace(p,newtrace(p,:)>0));
    spikecounts(p) = length(newtrace(p,newtrace(p,:)>0));
    if isnan(amp(p))
        amp(p) = 0;
        spikecounts(p) = 0;
    end
end  
frequencies = spikecounts/alltimelength;
sigtrace = newtrace;
rawtrace = trace(:,flag2list);

end


function [filefolder,datelist] = read2filenew(filedir,animalnum)
    filelist2 = dir([filedir,'\',animalnum]);
    filelist2 = {filelist2.name};
    ind_trace_mat = find(~contains(filelist2, '.'));
    for i =1:length(ind_trace_mat)
        filefolder{i} = fullfile([filedir,'\',animalnum], filelist2{ind_trace_mat(i)});
        datelist{i} = filelist2{ind_trace_mat(i)};
    end
end
