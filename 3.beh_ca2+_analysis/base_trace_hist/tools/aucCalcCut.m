

function aucstemp = aucCalcCut(filefolder)

    [filefolder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);%%%
    trace = trace(2:end,:);
    calctime = 60;% second

    Fs = neuron.Fs;
    action_label = neuron.action_label;
    [num_neuron, nframe] = size(dec_data);
    tlen = nframe / Fs;  % total time
    intruder = neuron.intruder;
    nintruder = size(intruder,1);  % intruder×ÜÊý
    ejact_idx = find(contains(neuron.action_label,'ejacu'));
    ejacucue = [];ejact_base = [];long_after_ejacu = [];
    % calc time periods
    for i = 1:nintruder 
        if ~isempty(neuron.intruder_action{i,ejact_idx})
            ejacucue = [ejacucue,i];
            ejact_base = [ejact_base;[neuron.light(find(neuron.light(:,1)<neuron.intruder(i,1),1,'last'),1),neuron.intruder(i,1)-2]];
            if  nintruder >i
                long_after_ejacu = [long_after_ejacu;[neuron.light(find(neuron.light(:,1)>neuron.intruder(i,1),1,'first'),1),neuron.intruder(i+1,1)-2]];
            else
                long_after_ejacu = [long_after_ejacu;neuron.light(find(neuron.light(:,1)>neuron.intruder(i,1),1,'first'),:)];
            end
        end
    end
    % calc time periods and modify to 60S
    numejacu = size(ejacucue,2);
    for i = 1:numejacu
        posttime = neuron.light(find(neuron.light(:,2)>neuron.intruder(ejacucue(i),1),1),2) - neuron.intruder_action{ejacucue(i),ejact_idx};
        postmin = floor((posttime-60)/calctime);
        postejact{i} = [];
        for pp = 1:postmin
           postejact{i} = [postejact{i};[neuron.intruder_action{ejacucue(i),ejact_idx}+(pp-1)*calctime+61,neuron.intruder_action{ejacucue(i),ejact_idx}+pp*calctime+60]];
        end
        if ~isempty(long_after_ejacu)
            if long_after_ejacu(i,2) - long_after_ejacu(i,1) >60
                long_after_ejacu(i,2) = long_after_ejacu(i,1) + 60;
            end
        else
            long_after_ejacu = postejact{i}(end,:);% if no next cue, use last post ejaculation period
        end
    end

    % calc auc
    for i = 1:numejacu
        flagbase{i} = revertTTL2bin(ejact_base(i,1), ejact_base(i,2) - ejact_base(i,1), Fs, tlen);
        flaglae{i} = revertTTL2bin(long_after_ejacu(i,1), long_after_ejacu(i,2) - long_after_ejacu(i,1), Fs, tlen);
        for pp = 1:size(postejact{i},1)
            flagpostejact{i}{pp} = revertTTL2bin(postejact{i}(pp,1), postejact{i}(pp,2) - postejact{i}(pp,1), Fs, tlen);
        end   
        parfor icell = 1:num_neuron
            timeseries = trace(icell,:);
            [aucsbase(icell,1,i), pvalsbase(icell,1,i),~] = auROC_withStates_cxf(timeseries,flagbase{i},flagbase{i},100,5000);
            if sum(timeseries(flagbase{i}))<10 
                aucsbase(icell,1, i)=0.5;
                pvalsbase(icell,1, i)=NaN;
            end 
            [aucslae(icell,1,i), pvalslae(icell,1,i), ~] = auROC_withStates_cxf(timeseries,flaglae{i},flagbase{i},100,5000);
            if sum(timeseries(flaglae{i}))<10 && sum(timeseries(flagbase{i}))<10
                aucslae(icell,1, i)=0.5;
                pvalslae(icell,1, i)=NaN;
            end 
        end
        for pp = 1:size(postejact{i},1)
             parfor icell = 1:num_neuron
                timeseries = trace(icell,:);
                [aucsposte(icell,pp,i), pvalsposte(icell,pp,i), ~] = auROC_withStates_cxf(timeseries,flagpostejact{i}{pp},flagbase{i},100,5000);
                if sum(timeseries(flagpostejact{i}{pp}))<10 && sum(timeseries(flagbase{i}))<10
                    aucsposte(icell,pp,i)=0.5;
                    pvalsposte(icell,pp,i)=NaN;
                end 
             end
        end
        aucsejacu = auc_result_7.aucs(:,ejact_idx,ejacucue(i));
        pvalsejacu = auc_result_7.pvals(:,ejact_idx,ejacucue(i));
        aucstemp.aucsall{i} = [aucsbase(:,1,i),aucslae(:,1,i),aucsejacu,aucsposte(:,1:size(postejact{i},1),i)];
        aucstemp.pvalsall{i} = [pvalsbase(:,1,i),pvalslae(:,1,i),pvalsejacu,pvalsposte(:,1:size(postejact{i},1),i)];
        aucstemp.h_signifi{i} = aucstemp.pvalsall{i}<0.01 & aucstemp.aucsall{i}>0.7;
    end
    aucstemp.name = neuron.name;
end















