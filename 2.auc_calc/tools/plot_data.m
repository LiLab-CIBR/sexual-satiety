function plot_data(data,neuron,seg_ind,varargin)
options = parseinputs(varargin{:});     % parse input arguments
num_plot = length(seg_ind);
for k=1:num_plot
        ind_plot = seg_ind{k};
        figure; 
        if size(ind_plot,2) == 2
            options.ordered = true;
            ind_choose = ind_plot(:,2);
        else
            options.ordered = false;
            ind_choose = ind_plot(:);
        end
        n_neu = length(ind_choose);

        seg_bg = neuron.intruder(:,1);
        seg_end = neuron.intruder(:,2);
        light_bg = neuron.light(:,1);
        light_end = neuron.light(:,2);
        h_light = barpatch(light_bg, light_end - light_bg-20, [80 180]);
        set(h_light, 'facecolor', [0 0 0]);
        h_seg = barpatch(seg_bg, seg_end - seg_bg, [100 160]);
        set(h_seg, 'edgecolor', [0 0 0], 'facecolor', [1 1 1], 'facealpha', 1, 'linestyle', '-');
        
        for i=1:length(neuron.intruder_label)
            text(mean([seg_bg(i),seg_end(i)]), 130,char(neuron.intruder_label(i)), ...
                 'horizontalalignment', 'center', 'VerticalAlignment', 'middle');
        end
        barline(seg_bg,  [-6000 40], 'k-');
        barline(seg_end, [-6000 40], 'k--');
        for i=1:length(neuron.events)
            if neuron.events{i}(1,1) == 0 continue; end
            hi = barpatch(neuron.events{i}(:,1), neuron.events{i}(:,2)-neuron.events{i}(:,1), [-6000 40],cell2mat(neuron.color(i)));
            set(hi, 'facealpha', 0.5);
            text(neuron.events{i}(1,2),65,char(neuron.action_label(i)),'FontSize',9,'Color',neuron.color{i});
        end
        for i=1:n_neu
            ii = ind_choose(i);
            data_now = 1.3*data(ii, :)-(i-1)*10*10.5;
            h = plotHz(neuron.Fs, data_now, 'k','linewidth',1.1);
            if options.plot_thresh
%                 ind_ind = find(ind_plot(:,2)==ii);
                ind_ind = find(ind_choose == ii);
                plot(ind_plot(ind_ind,1)/neuron.Fs,data_now(ind_plot(ind_ind,1)),'+r');
            end 
            if options.zeroline
                bl = zeros(1,length(data));
                plotHz(neuron.Fs,bl-(i-1)*10*10.5,'color',[0.5,0.5,0.5]);
            end
            plot_auc(neuron,options,i,ii);
            if isequal(options.type,'box')
                signifi_events = options.boxes{1};
                box_color = {'r','y','g','b','c'};
                for sig_evt = 1:size(signifi_events,2)
                    if signifi_events(ii,sig_evt) == 1
                        rectangle('position',[options.boxes{2}(sig_evt,1),-10-(i-1)*10*10.5,options.boxes{2}(sig_evt,2),75],'EdgeColor',box_color{sig_evt});
                    end
                end
            end
            set(h, 'xdata', get(h, 'xdata'));
            MakeDrag(h, 'y');
        end
        
        xlabel('Time (sec)');
        xticks auto
        last_num = ceil(length(data)/neuron.Fs/100)*100;
        xlim([0 last_num]);
        yticklabel = arrayfun(@num2str, neuron.neuron_id(ind_choose(n_neu:-1:1)), 'UniformOutput', false); 
        set(gca, 'ytick',(-n_neu+1:0)*10*10.5,'YTickLabel',yticklabel,'Position',[0.03,0.1,0.96,0.86]);
        set(gca, 'tickdir', 'out');
        ylim([min(data_now)- 5, 200]);
        ylabel('Cell (#)')
        ttl = make_ttl(neuron, options, k);
        title(sprintf('%s      Fig(%d/%d)', ttl{1}, k, num_plot));
        if size(ttl{1},1)==1
            if ~isempty(options.save_path)
                savefig(ttl{2});
            end
        else
            if ~isempty(options.save_path)
                if size(ttl{2},1)==1
                    savefig(ttl{2});
                else
                    savefig(ttl{2}{k});
                end
            end
        end
        
end
end


function options=parseinputs(varargin)
%% parse input variables
%% default options
options.type = 'overall';
options.auc_result = {};
options.boxes = {};  % boxes{1}: the situation to plot the boes; e.g.[0 1 0;1 1 0] is that to plot the box in the second event for the first neuron and to plot event 2 and 3 for the second neuron; boxes{2}: start and duration of the box edge. unit: sec
options.sort_event = [];
options.plot_thresh = 0;  % plot the time that the trace first reach the threshold 0: no plot
options.zeroline = false;
options.save_path = [];
options.ttl = {};

k = 1;
while k<nargin
    switch varargin{k}
        case {'deconv','raw','raster','sexual'}
            options.type = varargin{k};
            k = k+1;
        case 'auc'
            options.type = varargin{k};
            options.auc_result = varargin{k+1};
            k = k+2;
        case 'box'
            options.type = varargin{k};
            options.boxes = varargin{k+1};
            k = k+2;
        case 'double_sort'
            options.type = varargin{k};
            options.plot_thresh = varargin{k+1};
            options.sort_event = varargin{k+2};
            k = k+3;
        case 'plot_thresh'
            options.plot_thresh = varargin{k+1};
            k = k+2;
        case 'zeroline'
            options.zeroline = varargin{k+1};
            k = k+1;
        case 'zero_blank'
            options.type = [options.type,'_blank'];
            k = k+1;
        case 'save_path'
            options.save_path = varargin{k+1};
            k = k+2;
        case 'ttl'
            options.ttl = varargin{k+1};
            k = k+2;
        otherwise
            sprintf('Please provide proper parameter!')
    end
end
if ~isempty(options.auc_result)
    options.type = [options.type,'_cue'];  % auc_event has been abandoned
%     if ndims(options.auc_result.aucs) == 3
%         options.type = [options.type,'_cue'];
%     else
%         options.type = [options.type,'_event'];
%     end
end
if strcmp(options.type,'raster')
    options.plot_thresh = false;
end
end

function plot_auc(neuron,options,i,ii)
switch options.type
    case {'auc_cue','auc_blank_cue'}
        nstate = size(options.auc_result.aucs,2);
        nintruder = size(options.auc_result.aucs,3);
        for iintruder=1:nintruder
            for istate=1:nstate
%                 if ~contains(neuron.action_label{istate},'ejac')
                    if options.auc_result.h_signifi(ii,istate,iintruder) == 1
                        flag_amp = iintruder*10;
                        flag = (options.auc_result.actionstates(istate,:)==flag_amp);
                        start = find(flag,1)/neuron.Fs; final = find(flag,1,'last')/neuron.Fs; dur=final-start;
                        rectangle('position',[start,-10-(i-1)*10*10.5,dur,75],'EdgeColor',cell2mat(neuron.color(istate)),'LineStyle','--');
                    end
%                 else
%                     if options.auc_result.ejact_signifi(ii,iintruder) == 1
%                         flag_amp = istate + iintruder*10;
%                         flag = (options.auc_result.bstates==flag_amp);
%                         start = find(flag,1)/neuron.Fs; final = find(flag,1,'last')/neuron.Fs; dur=final-start;
%                         rectangle('position',[start,-10-(i-1)*10*10.5,dur,75],'EdgeColor',cell2mat(neuron.color(istate)));
%                     end
%                     if sum(options.auc_result.ejact_signifi(:,iintruder))~=0
%                         text(3000+iintruder*150,15-(i-1)*10*10.5,num2str(options.auc_result.ejact_base_stds(ii,iintruder)),'Color','b');
%                     end
%                 end
            end
        end
    case {'auc_event','auc_blank_event'}
        nintruder = size(options.auc_result.aucs,2);
        for iintruder=1:nintruder
            if options.auc_result.h_signifi(ii,iintruder) == 1
                flag=(options.auc_result.actionstates(ii,:)==iintruder*10);
                start = find(flag,1)/neuron.Fs; final = find(flag,1,'last')/neuron.Fs; dur=final-start;
                rectangle('position',[start,-10-(i-1)*10*10.5,dur,75],'EdgeColor','r');
            end
        end
end
end

function ttl = make_ttl(neuron, options, plot_num)
ttl = {};
if ~isempty(options.ttl)
    if length(options.ttl) == 1
        ttl{1} = options.ttl;
        ttl{2} = ttl{1};
    else
        ttl{1} = options.ttl{1};
        ttl{2} = sprintf('%s%s_%d.fig', options.save_path, options.ttl{2}, plot_num);
    end
else
    switch options.type
        case {'deconv','raw','sexual'}
            if options.ordered == 1
                ttl{1} = sprintf('%s      Ordered overall   threshold:%.2f',neuron.name,options.plot_thresh);
                ttl{2} = sprintf('%s/overall_%s_%d.fig',options.save_path,options.type,plot_num);
            else
                ttl{1} = sprintf('%s      Overall',neuron.name);
                ttl{2} = sprintf('%s/overall_ordin_%s_%d.fig',options.save_path,options.type,plot_num);
            end
        case 'raster'
            if options.ordered == 1
                ttl{1} = sprintf('%s      Ordered overall   threshold:%.2f',neuron.name,options.plot_thresh);
                ttl{2} = sprintf('%s/raster_%d.fig',options.save_path,plot_num);
            else
                ttl{1} = sprintf('%s      Raster',neuron.name);
                ttl{2} = sprintf('%s/raster_ordin_%d.fig',options.save_path,plot_num);
            end
        case 'double_sort'
            if options.ordered == 1
                ttl{1} = sprintf('%s      Ordered by event%d & %d   threshold:%.2f',neuron.name,options.sort_event(1),options.sort_event(2),options.plot_thresh);
                ttl{2} = sprintf('%s/overall_event_%d&%d_%d.fig',options.save_path,options.sort_event(1),options.sort_event(2),plot_num);
            else
                ttl{1} = sprintf('%s      Overall',neuron.name);
                ttl{2} = sprintf('%s/overall_ordin_%s_%d.fig',options.save_path,options.type,plot_num);
            end
        case 'auc_cue'
            if options.auc_result.auc_thresh >= 0.5
                if options.ordered == 1
                    ttl{1} = sprintf('%s      Ordered overall with auc > %.02f for cue',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                else
                    ttl{1} = sprintf('%s      auc > %.02f for cue',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/ordin_',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                end
            else
                if options.ordered == 1
                    ttl{1} = sprintf('%s      Ordered overall with auc < %.02f for cue',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                else
                    ttl{1} = sprintf('%s      auc < %.02f for cue',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/ordin_',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                end
            end
        case 'auc_event'
            if options.auc_result.auc_thresh >= 0.5
                if options.ordered == 1
                    ttl{1} = sprintf('%s      Ordered overall with auc > %.02f for event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                else
                    ttl{1} = sprintf('%s      auc > %.02f for event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/ordin_',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                end
            else
                if options.ordered == 1
                    ttl{1} = sprintf('%s      Ordered overall with auc < %.02f for event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                else
                    ttl{1} = sprintf('%s      auc < %.02f for event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/ordin_',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                end
            end
        case 'auc_blank_cue'
            if options.auc_result.auc_thresh >= 0.5
                if options.ordered == 1
                    ttl{1} = sprintf('%s      Ordered overall with auc > %.02f for cue, baseline containing blank in event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                else
                    ttl{1} = sprintf('%s      auc > %.02f for cue, baseline containing blank in event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/ordin_',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                end
            else
                if options.ordered == 1
                    ttl{1} = sprintf('%s      Ordered overall with auc < %.02f for cue, baseline containing blank in event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                else
                    ttl{1} = sprintf('%s      auc < %.02f for cue, baseline containing blank in event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/ordin_',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                end
            end
        case 'auc_blank_event'
            if options.auc_result.auc_thresh >= 0.5
                if options.ordered == 1
                    ttl{1} = sprintf('%s      Ordered overall with auc > %.02f for event, baseline containing blank in event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                else
                    ttl{1} = sprintf('%s      auc > %.02f for event, baseline containing blank in event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/ordin_',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                end
            else
                if options.ordered == 1
                    ttl{1} = sprintf('%s      Ordered overall with auc < %.02f for event, baseline containing blank in event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                else
                    ttl{1} = sprintf('%s      auc < %.02f for event, baseline containing blank in event',neuron.name,options.auc_result.auc_thresh);
                    ttl{2} = sprintf(['%s/ordin_',options.type,'_%.02f_%d.fig'],options.save_path,options.auc_result.auc_thresh,plot_num);
                end
            end
    end
end
end