function  heat_data(base)


result_folder = base.result_folder;
clusterlist = base.clusterlist;
colorlim = base.colorlim;
colorlim = [-colorlim/20,colorlim];
savedir = base.savedir;

for i = 1:length(clusterlist)
    aa{i} = read_file_with_samename(result_folder,clusterlist{i});
    for j = 1:length(aa{i})
        [filefolder,trace{i}{j}, dec_data{i}{j}, sig_data{i}{j}, neuron{i}{j}, auc_result_7, auc_result_3] = loadfolderandcellchoose(aa{i}{j});%%%
        Fs{i}{j} = neuron{i}{j}.Fs;
        tlen{i}{j} = neuron{i}{j}.nframe/Fs{i}{j};
%         for p = 1:length(animallist)
%             if contains(neuron{i}{j}.name,animallist{p})
%                 animalidx{i}{j} = animallist{p};
%             end
%         end
        % intruder = neuron.intruder;
        baselist{i}{j} = plotstrspl(neuron{i}{j});
        tDur1 = 180;
        flag2{i}{j} =  revertTTL2bin(baselist{i}{j}(1), tDur1, Fs{i}{j}, tlen{i}{j});
        usedtrace{i}{j} = trace{i}{j}(:,flag2{i}{j});
        [nneuron,nframe] = size(usedtrace{i}{j});
        sig_waive_mean = [];
        sig_waive_std = [];
        for p = 1:nneuron
            flag3 = true(1,nframe);
            outerlist = usedtrace{i}{j}(p,:) - mean(usedtrace{i}{j}(p,:))-std(usedtrace{i}{j}(p,:))>0;
%             for pp = 1:length(outerlist)
%                 if outerlist(pp) <=10*Fs{i}{j}
%                     flag3(1,1:outerlist(pp)+10*Fs{i}{j}) = false;
%                 elseif outerlist(pp) >=170*Fs{i}{j}
%                     flag3(1,outerlist(pp)-10*Fs{i}{j}:end) = false;
%                 else
%                     flag3(1,outerlist(pp)-10*Fs{i}{j}:outerlist(pp)+10*Fs{i}{j}) = false;
%                 end
%             end
            flag3(1,outerlist) = false;
            sig_waive_mean(p,1) = mean(usedtrace{i}{j}(p,flag3));
            sig_waive_std(p,1) = std(usedtrace{i}{j}(p,flag3));
        end
        usedtrace2{i}{j} = usedtrace{i}{j} - sig_waive_mean-sig_waive_std;
        [nneuron,nframe] = size(usedtrace2{i}{j});
        dec_data2 = zeros(nneuron,nframe);
        sig_data2 = zeros(nneuron,nframe);
        lambda = 1.5;
        parfor ii=1:nneuron
%         ii = 16;
%             if mean(usedtrace{i}{j}(ii,:))<5
                [dec_trace, signal, ~] = deconvolveCa(usedtrace2{i}{j}(ii,:), 'ar1', 'foopsi', 'lambda', lambda, 'optimize_pars');
                dec_data2(ii,:) = dec_trace';
                sig_data2(ii,:) = signal';
%             else
%                 [dec_trace, signal, ~] = deconvolveCa(usedtrace{i}{j}(ii,:), 'ar1', 'constrained', 'optimize_b', 'optimize_pars','maxiter',1);
%                 dec_data2(ii,:) = dec_trace';
%                 sig_data2(ii,:) = signal';
%             end
        end
        sig_data3{i}{j} = sig_data2;
        
        sig_data3{i}{j}(sig_data3{i}{j} >0) = 1;
        logical(sig_data3{i}{j});
        newtrace = zeros(nneuron,nframe);
        newtrace = usedtrace{i}{j}.*sig_data3{i}{j};
        newtrace2 = newtrace;
        newtrace2(newtrace2 < 10) = 0;
        useddata2 = newtrace2;
        for p = 1:size(useddata2,1)
%             sdy = std(usedtrace{i}{j}(p,:));
%             squeezeuseddata2(p) = mean(useddata2(p,useddata2(p,:) >0.5*sdy));
%             spikecounts(p) = length(useddata2(p,useddata2(p,:) >0.5*sdy));
            squeezeuseddata2{i}{j}(p) = mean(useddata2(p,useddata2(p,:)>0));
            spikecounts{i}{j}(p) = length(useddata2(p,useddata2(p,:)>0));

            if isnan(squeezeuseddata2{i}{j}(p))
                squeezeuseddata2{i}{j}(p) = 0;
                spikecounts{i}{j}(p) = 0;
            end
        end  
        amp{i}{j} = squeezeuseddata2{i}{j};
        frequencies{i}{j} = spikecounts{i}{j}/tDur1;
        meanamp{i}{j} = mean(amp{i}{j});
        meanfrequencies{i}{j} = mean(frequencies{i}{j});
%         activecells{i}{j} = sum(frequencies{i}{j} > 0.1)/length(frequencies{i}{j});
    end
end

for i = 1:length(clusterlist)
    hfig = figure('color', 'w','Position',[300 0 900 1200]);
    haxes = matlab.graphics.axis.Axes.empty(0);
    for j = 1:length(aa{i})
        subplot(4,4,j)
        useddata3 = trace{i}{j}(:,flag2{i}{j});
%         hfig = figure('color', 'w','Position',[300 300 280 300]);
%         haxes = matlab.graphics.axis.Axes.empty(0);
        imagesc(useddata3, 'xdata', [0,tDur1], 'ydata', [1 size(useddata3,1)])
        hold on;
%         title([animalidx{i}{j},' ',clusterlist{i},' before'])
        title([neuron{i}{j}.name,newline,'Amp: ',num2str(meanamp{i}{j}),newline,'Freq:',num2str(meanfrequencies{i}{j})])
        colormap jet
        set(gca, 'clim',colorlim)
        axis ij
        axis tight
        box off
%         hfig.Renderer = 'Painters';
%         hfig.PaperSize = [20,20];
%         saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0411singlebase\',neuron{i}{j}.name,'_base_heatplot.pdf']);
    end
    hfig.Renderer = 'Painters';
    hfig.PaperSize = [50,50];
    saveas(gcf,[savedir,'\',clusterlist{i},'_overall_base_heatplot.pdf']);

end


end







