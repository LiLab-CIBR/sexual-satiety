function [num_save,auclist,nname,auclist2] = heatplotprefernew_withoutboth_for_raw_data(prefer)


result_folder = prefer.result_folder;
clusterlist = prefer.clusterlist;


for i = 1:length(clusterlist)
    aa{i} = read2file(result_folder,clusterlist{i});
    pics = ceil(length(aa{i})/8);
    for ss = 1:pics
        endnum(ss) = ss*8;
    end
    endnum(pics) = length(aa{i});
    for ss = 1:pics
        hfig = figure('color', 'w','Position',[100 50 1600 850]);
        
        for j = ss*8-7:endnum(ss)

            [~,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(aa{i}{j});
            rtrace = trace(2:end,:);


            actionidx{1} = find(contains(neuron.action_label,'positive'));
            actionidx{2} = find(contains(neuron.action_label,'mounting'));
            actionidx{3} = find(contains(neuron.action_label,'intro'));
            actionidx{4} = find(contains(neuron.action_label,'ejacu'));

            clist = {[208/256, 143/256, 116/256],[129/256, 162/256,  179/256]};
            cuttime = [-30,120];
            act = neuron.intruder(:,1);
            intruder = neuron.intruder;
            Fs = neuron.Fs;
            ttick = (1:size(dec_data,2)) / Fs;
            nname = neuron.name;
            intruderl = neuron.intruder_label;
            [cuelist,cuelist2] = searchcuebeforemating(intruderl,actionidx{4},neuron);

            if isempty(cuelist)||isempty(cuelist2)
                num_save = [0,0,0,0];auclist =[NaN,NaN];nname = neuron.name;auclist2 = [];
            else


            usedlist = plotstrspl(neuron);
            R1 = [usedlist(1),180];

                Fpick = auc_result_7.h_signifi(:,actionidx{1},cuelist(1));
                Mpick = auc_result_7.h_signifi(:,actionidx{1},cuelist2(1));
                bothpick = Fpick&Mpick;
                F1pick = Fpick&~bothpick;
                M1pick = Mpick&~bothpick;

                F1celltrace = rtrace(F1pick,:);
                M1celltrace = rtrace(M1pick,:);
                bothcelltrace = rtrace(bothpick,:);
                %选时间
                ffsidx = find(neuron.events{actionidx{1}}(:,1) > intruder(cuelist(1),1)&neuron.events{actionidx{1}}(:,1) < intruder(cuelist(1),2),1);
                ffirstsniff = neuron.events{actionidx{1}}(ffsidx,1);

                mfsidx = find(neuron.events{actionidx{1}}(:,1) > intruder(cuelist2(1),1)&neuron.events{actionidx{1}}(:,1) < intruder(cuelist2(1),2),1);
                mfirstsniff = neuron.events{actionidx{1}}(mfsidx,1);

                indtF1  = ttick > ffirstsniff & ttick < ffirstsniff+cuttime(2);
                indtF1base = ttick > floor(act(cuelist(1))+cuttime(1))-1/Fs & ttick < floor(act(cuelist(1)));
                indtM1  = ttick >mfirstsniff & ttick < mfirstsniff+cuttime(2);
                indtM1base = ttick > floor(act(cuelist2(1))+cuttime(1))-1/Fs & ttick < floor(act(cuelist2(1)));

                %%

                % if sum(contains(neuron.name,cellchangelist))
                %     dateidx = find(contains(cellchangelist,neuron.name));
                %     [F1celltrace,M1celltrace,bothcelltrace] = zengbuxibao2(F1celltrace,M1celltrace,bothcelltrace,dateidx);
                % end

                %%
                %baseline数据
                F1cueF1base = F1celltrace(:,indtF1base);
                F1cueM1base = F1celltrace(:,indtM1base);
                M1cueM1base = M1celltrace(:,indtM1base); 
                M1cueF1base = M1celltrace(:,indtF1base);
                bothcueF1base=bothcelltrace(:,indtF1base);
                bothcueM1base=bothcelltrace(:,indtM1base);
                F1cueF1 = [F1cueF1base,F1celltrace(:,indtF1)];
                F1cueM1 = [F1cueM1base,F1celltrace(:,indtM1)];
                M1cueM1 = [M1cueM1base,M1celltrace(:,indtM1)];
                M1cueF1 = [M1cueF1base,M1celltrace(:,indtF1)];
                bothcueF1 = [bothcueF1base,bothcelltrace(:,indtF1)];
                bothcueM1 = [bothcueM1base,bothcelltrace(:,indtM1)];

                %% 再重排
                F1cellmean = mean(F1cueF1,2);
                [~, F1sort] =sort(F1cellmean,'descend');
                F1cueF1= F1cueF1(F1sort,:);
                F1cueM1= F1cueM1(F1sort,:);

                M1cellmean = mean(M1cueM1,2);
                [~, F1sort] =sort(M1cellmean,'descend');
                M1cueM1= M1cueM1(F1sort,:);
                M1cueF1= M1cueF1(F1sort,:);

                bothcellmean = mean([bothcueF1,bothcueM1],2);
                [~, F1sort] =sort(bothcellmean,'descend');
                bothcueF1= bothcueF1(F1sort,:);
                bothcueM1= bothcueM1(F1sort,:);

                %%
                usedneuron = size(M1celltrace,1)+size(F1celltrace,1);
                %
        %         hfig = figure('color', 'w','Position',[300 300 600 500]);
        %         haxes = matlab.graphics.axis.Axes.empty(0);
                idxx = j+8-8*ss;
                subplot(2,4,idxx)
                imagesc(F1cueF1, 'xdata', [0,cuttime(2)-cuttime(1)], 'ydata', [1 size(F1celltrace,1)])
                hold on;
                imagesc(M1cueF1, 'xdata', [0,cuttime(2)-cuttime(1)], 'ydata', [1 size(M1celltrace,1)]+size(F1celltrace,1)+usedneuron/50)
                imagesc(F1cueM1, 'xdata', [0,cuttime(2)-cuttime(1)]+cuttime(2)-cuttime(1)+5, 'ydata', [1 size(F1celltrace,1)])
                imagesc(M1cueM1, 'xdata', [0,cuttime(2)-cuttime(1)]+cuttime(2)-cuttime(1)+5, 'ydata', [1 size(M1celltrace,1)]+size(F1celltrace,1)+usedneuron/50)

                for ii = 1:size(neuron.action_label,2)%画行为颜色
                    if  contains(lower(neuron.action_label{ii}),'positive')%||contains(lower(neuron.action_label{ii}),'passive')
                    event_now = neuron.events{ii} - ffirstsniff; %centered by event-action
                    indOK = event_now(:,1) >= cuttime(1) & event_now(:,1) <= cuttime(2);
                    event_OK = event_now(indOK, :);
                    if isempty(event_OK); continue; end
                    hi = barpatch(event_OK(:,1)+30, event_OK(:,2)-event_OK(:,1),[0.5 -3*usedneuron/50+0.5],clist{1});
                        if ii == actionidx{1}
                        sniffaction{1} = event_OK;
                        end
                    set(hi, 'facealpha', 1);
                    end
                end
                for ii = 1:size(neuron.action_label,2)%画行为颜色
                    if  contains(lower(neuron.action_label{ii}),'positive')%||contains(lower(neuron.action_label{ii}),'passive')
                        event_now = neuron.events{ii} - mfirstsniff; %centered by event-action
                        indOK = event_now(:,1) >= cuttime(1) & event_now(:,1) <= cuttime(2);
                        event_OK = event_now(indOK, :);
                        if isempty(event_OK); continue; end
                        hi = barpatch(event_OK(:,1)+cuttime(2)-cuttime(1)+35, event_OK(:,2)-event_OK(:,1),[0.5 -3*usedneuron/50+0.5],clist{2});
                        if ii == actionidx{1}
                        sniffaction{2} = event_OK;
                        end
                        set(hi, 'facealpha', 1);
                    end
                end

                colormap jet
    %             cbh = colorbar;
    %             cbh.Position = [0.53  0.195 0.02 0.22];
    %             set(cbh, 'Ticks', -30:10:80, 'FontSize', 20, 'TickLength', 0);
                set(gca, 'clim',[-5 100])
                axis ij
                axis tight
                box off
                xticks([0,-cuttime(1),cuttime(2)/3-cuttime(1),cuttime(2)/1.5-cuttime(1),cuttime(2)-cuttime(1),...
                    cuttime(2)+5-2*cuttime(1),cuttime(2)+5+cuttime(2)/3-2*cuttime(1),cuttime(2)+cuttime(2)/1.5+5-2*cuttime(1),2*cuttime(2)+5-2*cuttime(1)])
                xticklabels({'-30','0',num2str(cuttime(2)/3),num2str(cuttime(2)/1.5),num2str(cuttime(2)),...
                    '0',num2str(cuttime(2)/3),num2str(cuttime(2)/1.5),num2str(cuttime(2))})
                yticks(unique([1,size(F1cueF1,1),size(F1cueF1,1)+size(M1cueF1,1)+usedneuron/50,size(F1cueF1,1)+size(M1cueF1,1)+size(bothcueF1,1)+usedneuron/25]))
                yticklabels({unique([1,size(F1cueF1,1),size(F1cueF1,1)+size(M1cueF1,1),size(F1cueF1,1)+size(M1cueF1,1)+size(bothcueF1,1)])})
                xlim([0,(-cuttime(1)+cuttime(2))*2+5]);
                ylabel('Neurons');
                xlabel('Time(s)')
                set(gca,'FontSize',20);
    %             set(gca,'Position',[0.12,0.2,0.4,0.7]);
                title(neuron.name)

            end
        end
        hfig.Renderer = 'Painters';
        hfig.PaperSize = [50,50];
        saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0416materials\',clusterlist{i},'_withoutboth_heatplot',num2str(ss),'.pdf']);
        
    end
end

end