
function [data5fig,data3bar] = post_ejaculation_calc(filefolderlist,timecut)
    for matings = 1:length(filefolderlist)
        %% 读文件    
        filefolder = filefolderlist{matings}; 
        [result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
        load([filefolder,'\auc_result_new_',num2str(timecut),'min.mat'],'saveauc');
        %% 参数
        Fs = neuron.Fs;
        gender = neuron.gender;
        usedlist = FindBase(neuron);
        ejacuidx = find(contains(neuron.action_label,'ejacu'));
        sniffidx = find(contains(neuron.action_label,'positive'));
        [num_neuron, nframe] = size(dec_data);
        tlen = nframe / Fs;  % total time
        intruderl = neuron.intruder_label;
        rtrace = trace(2:end,:);
        [cuelist,cuelist2] = searchcuebeforemating(intruderl,ejacuidx,neuron);
        if ~gender
            cuelist = cuelist2;
        end
        newbaseidx = size(saveauc.aucs,2);
        postejacuidxlist{matings} = find(1:1:size(saveauc.aucs,2)-1>size(neuron.action_label,2));
        postmin{matings} = length(postejacuidxlist{matings});
        %% ejaculation细胞
        Epick = auc_result_7.h_signifi(:,ejacuidx,cuelist(end));
        %% ejaculation 起止时间
        cuttime = neuron.events{1,ejacuidx}(find(neuron.events{1,ejacuidx}(:,1) > neuron.intruder(cuelist(1),1),1),1);
        cuttime2 = neuron.events{1,ejacuidx}(find(neuron.events{1,ejacuidx}(:,1) > neuron.intruder(cuelist(1),1),1),2);
        %% 第一个异性cue前120S里的sniff
        sniffcues = neuron.events{1,sniffidx}(neuron.events{1,sniffidx}(:,1) > neuron.intruder(cuelist(1),1)&neuron.events{1,sniffidx}(:,1) < neuron.intruder(cuelist(1),1)+120,:);
        sniffcue = revertTTL2bin(sniffcues(:,1), sniffcues(:,2) - sniffcues(:,1), Fs, tlen);

        %% 全部Ecell 的auc和h_sig统计量
        for pp = 1:postmin{matings}
            mpecauc{matings}(pp) = nanmean(saveauc.aucs(Epick,postejacuidxlist{matings}(pp),cuelist(end)));
            sempecauc{matings}(pp) = nanstd(saveauc.aucs(Epick,postejacuidxlist{matings}(pp),cuelist(end)))/sqrt(length(Epick));
            mpechsig{matings}(pp) = sum(saveauc.h_signifi(Epick,postejacuidxlist{matings}(pp),cuelist(end)),'omitnan')/sum(Epick);
        end
        mbaseauc = nanmean(saveauc.aucs(Epick,end,cuelist(end)));
        sembaseauc = nanstd(saveauc.aucs(Epick,end,cuelist(end)))/sqrt(length(Epick));
        mejacuauc = nanmean(saveauc.aucs(Epick,ejacuidx,cuelist(end)));
        semejacuauc = nanstd(saveauc.aucs(Epick,ejacuidx,cuelist(end)))/sqrt(length(Epick));

        %% persistent Ecell 的auc和h_sig统计量
        pecppick = Epick&saveauc.h_signifi(:,postejacuidxlist{matings}(1),cuelist(end));
        for pp = 1:postmin{matings}
            mpecpauc{matings}(pp) = nanmean(saveauc.aucs(pecppick,postejacuidxlist{matings}(pp),cuelist(end)));
            sempecpauc{matings}(pp) = nanstd(saveauc.aucs(pecppick,postejacuidxlist{matings}(pp),cuelist(end)))/sqrt(sum(pecppick));
        end
        mbasepauc = nanmean(saveauc.aucs(pecppick,end,cuelist(end)));
        sembasepauc = nanstd(saveauc.aucs(pecppick,end,cuelist(end)))/sqrt(sum(pecppick));
        mejacupauc = nanmean(saveauc.aucs(pecppick,ejacuidx,cuelist(end)));
        semejacupauc = nanstd(saveauc.aucs(pecppick,ejacuidx,cuelist(end)))/sqrt(sum(pecppick));

        mpecpbase  = mean(rtrace(pecppick,usedlist(1)*Fs+1:(usedlist(1)+180)*Fs),2);
        mpecpsniff  = mean(rtrace(pecppick,sniffcue),2);
        mpecpejacu  = mean(rtrace(pecppick,cuttime*Fs:cuttime2*Fs),2);
        %% transient Ecell 的auc和h_sig统计量
        pectpick = Epick&~saveauc.h_signifi(:,postejacuidxlist{matings}(1),cuelist(end));
        for pp = 1:postmin{matings}
            mpectauc{matings}(pp) = nanmean(saveauc.aucs(pectpick,postejacuidxlist{matings}(pp),cuelist(end)));
            sempectauc{matings}(pp) = nanstd(saveauc.aucs(pectpick,postejacuidxlist{matings}(pp),cuelist(end)))/sqrt(sum(pectpick));
        end
        mbasetauc = nanmean(saveauc.aucs(pectpick,end,cuelist(end)));
        sembasetauc = nanstd(saveauc.aucs(pectpick,end,cuelist(end)))/sqrt(sum(pectpick));
        mejacutauc = nanmean(saveauc.aucs(pectpick,ejacuidx,cuelist(end)));
        semejacutauc = nanstd(saveauc.aucs(pectpick,ejacuidx,cuelist(end)))/sqrt(sum(pectpick));

        mpectbase  = mean(rtrace(pectpick,usedlist(1)*Fs+1:(usedlist(1)+180)*Fs),2);
        mpectsniff  = mean(rtrace(pectpick,sniffcue),2);
        mpectejacu  = mean(rtrace(pectpick,cuttime*Fs:cuttime2*Fs),2);

        %% none Ecell 的auc和h_sig统计量
        noepick = ~Epick;
        for pp = 1:postmin{matings}
            mnoeauc{matings}(pp) = nanmean(saveauc.aucs(noepick,postejacuidxlist{matings}(pp),cuelist(end)));
            semnoeauc{matings}(pp) = nanstd(saveauc.aucs(noepick,postejacuidxlist{matings}(pp),cuelist(end)))/sqrt(sum(noepick));
        end
        mbasenoeauc = nanmean(saveauc.aucs(noepick,end,cuelist(end)));
        sembasenoeauc = nanstd(saveauc.aucs(noepick,end,cuelist(end)))/sqrt(sum(noepick));
        mejacunoeauc = nanmean(saveauc.aucs(noepick,ejacuidx,cuelist(end)));
        semejacunoeauc = nanstd(saveauc.aucs(noepick,ejacuidx,cuelist(end)))/sqrt(sum(noepick));

        mnoebase  = mean(rtrace(noepick,usedlist(1)*Fs+1:(usedlist(1)+180)*Fs),2);
        mnoesniff  = mean(rtrace(noepick,sniffcue),2);
        mnoeejacu  = mean(rtrace(noepick,cuttime*Fs:cuttime2*Fs),2);

        %% output
        data5fig{matings}.name = neuron.name;
        data5fig{matings}.postejacu_cellpick =  [pecppick,pectpick,noepick];
        data5fig{matings}.allpecauc_withbaseejacu_meansem =  [mbaseauc,mejacuauc,mpecauc{matings};sembaseauc,semejacuauc,sempecauc{matings}];
        data5fig{matings}.allpecauc_h_sig =  mpechsig{matings};
        data5fig{matings}.pecpauc_withbaseejacu_meansem =  [mbasepauc,mejacupauc,mpecpauc{matings};sembasepauc,semejacupauc,sempecpauc{matings}];
        data5fig{matings}.pectauc_withbaseejacu_meansem =  [mbasetauc,mejacutauc,mpectauc{matings};sembasetauc,semejacutauc,sempectauc{matings}];
        data5fig{matings}.noeauc_withbaseejacu_meansem =  [mbasenoeauc,mejacunoeauc,mnoeauc{matings};sembasenoeauc,semejacunoeauc,semnoeauc{matings}];
        data3bar{matings}.data = {mpecpbase,mpectbase,mnoebase;mpecpsniff,mpectsniff,mnoesniff;mpecpejacu,mpectejacu,mnoeejacu};
        data3bar{matings}.name = neuron.name;
    end


end

