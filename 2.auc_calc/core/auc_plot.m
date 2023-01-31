function auc_plot(result_folder, load_neuron, load_auc, Fs, gender, thresh,intruder_label,trace_per_plot,double_thresh,first_event,second_event, auc_thresh)
%% Process the raw trace(auc,raster) and plot the result.
%% inputs:
% folder: the path of the folder, where there contains raw traces and behavior.
% options:
% 'raw': plot the raw trace in original order
% 'specific': plot specific traces. Additional input: n x 1 vector, each element is the id of the neuron.
% 'deconv': calculate the deconvolution of the traces
% 'auc_event': calculate the auc by events. Additional input: 0:inhibition 1: excitation
% 'auc_cues': calculate the auc by cues in each events. Additional input: 0: inhibition, 1: excitation
% 'auc_post': calculate the auc: no cue / cue
% 'E:\wupeixuan\auc_plot\data\Esr229\Esr2290721',false, false,10,1,0.99,{},18,0.8,2,6,[0.7 0.3]
% addpath('E:\wupeixuan\auc_plot\utils');

%% Get the current list of data
% aucPlot('E:\wupeixuan\auc_plot\data\Esr254\Esr2540228',false, false,10,0,0.99,{},18,0.8,2,6,[0.7 0.3])
% result_folder = 'E:\wupeixuan\auc_plot\data\Esr237\Esr2371231';
% load_neuron = false;
% load_auc = false;
% Fs = 10;
% gender = 0;
% thresh =  0.99;
% trace_per_plot = 18;
% auc_thresh = [0.7 0.3];
% 
cd(result_folder);
filelist = dir(result_folder);
filelist = {filelist.name};

%% check the file
% --- MUST INCLUDE ---
% {filename}_analysis.xls
% {filename}_trace.mat
ind_analysis_xls = contains(filelist, 'analysis.xls');
assert(sum(ind_analysis_xls) == 1); %exist one and only one 'analysis.xls'
xls_path = fullfile(result_folder, filelist{ind_analysis_xls});

ind_trace_mat = contains(filelist, 'trace.mat');
assert(sum(ind_trace_mat) <= 1); %exist one and only one 'trace.mat'
if sum(ind_trace_mat) == 1
    trace_dir = fullfile(result_folder, filelist{ind_trace_mat});
    [neuron_id, data] = trace_read(trace_dir);
else
    ind_prime_mat = contains(filelist, 'prime_raw.csv');
    assert(sum(ind_prime_mat) <= 1);
    raw_dir = filelist(ind_prime_mat);
    ind_raw_mat = contains(filelist, '_raw.csv');
    raw = ind_raw_mat&~ind_prime_mat;
    raw_dir = {raw_dir{1},filelist{raw}};
    [~, ~, trace_dir] = trace_combine(result_folder,raw_dir);
    [neuron_id, data] = trace_read(trace_dir);
end

% --- OPIONAL INCLUDE (AUTO GENERATE)---
% {filename}_den_deconv.mat
% {filename}_neuron.mat
ind_den_deconv_mat = contains(filelist, '_den_deconv.mat');
assert(sum(ind_analysis_xls) <= 1);
if sum(ind_den_deconv_mat) == 1
    load(fullfile(result_folder, filelist{ind_den_deconv_mat}), 'dec_data', 'sig_data');
end
ind_neuron_mat = contains(filelist,'_neuron.mat');
assert(sum(ind_neuron_mat) <= 1);
if sum(ind_neuron_mat) == 1 && load_neuron
    load(fullfile(result_folder, filelist{ind_neuron_mat}), 'neuron');
end

auc_mat1 = contains(filelist, ['_auc',num2str(auc_thresh(1)),'.mat']);
assert(sum(auc_mat1) <= 1);
if sum(auc_mat1) == 1 && load_auc
    load(fullfile(result_folder, filelist{auc_mat1}), 'neuron');
    auc_result1 = auc_result;
end

auc_mat2 = contains(filelist, ['_auc',num2str(auc_thresh(1)),'.mat']);
assert(sum(auc_mat2) <= 1);
if sum(auc_mat2) == 1 && load_auc
    load(fullfile(result_folder, filelist{auc_mat2}), 'neuron');
    auc_result2 = auc_result;
end

%% --- OPIONAL INCLUDE (AUTO GENERATE)---
% Read the behavior tabel
if ~exist('neuron','var') || ~load_neuron
    [form_label, events, intruder_labels] = excel_analysis(xls_path);
    light_idx = ismember(form_label,'light');
    neuron.light = events{light_idx};
    intruder_idx = ismember(form_label,'intruder');
    neuron.intruder = events{intruder_idx};
    neuron.intruder_label = intruder_labels;
    assert(length(neuron.intruder_label) == size(neuron.intruder,1), 'Error Intruder Labels!');
    if gender
        action_label = {'positive', 'mounting','intromission','ejaculation','penile groom','pelvic thurst'}; % passive,[1 0.63 0] chase [1 0.75 0.80]
        color = {[1 0 0],[0 1 0],[0.494 0.184 0.556],[0 0 1], [0.46 1 1], [1 0.155 0.155],[0.46 0.078 0.57]};  %approach [0.46 0.078 0.57]  [0.2 1 0.597]
%         action_label = {'positive','passive','mounting','intromission','ejaculation','attack','biting','retrieve','beaten','penile groom','sniff other','sniff pups at nest','mounted','approaching','chasing'}; % ,[1 0.63 0] chasing [1 0.75 0.80]
%         color = {[1 0 0],[1 0.63 0],[0 1 0],[0.494 0.184 0.556],[0 0 1],[0 1 1], [1 1 0],[1 0.62 0.83], [1 0.5 0.5], [0.46 1 1], [1 0.155 0.155], [0.15 1 0.15],[0.05 0.749 0.549],[0.46 0.078 0.57],[1 0.75 0.80]};  %approach [0.46 0.078 0.57]  [0.2 1 0.597]
    else
        action_label = {'positive','mounting','attack','biting','retrieve','beaten','sniff other','sniff pups at nest', 'lordosis','mounted','intromitted','ejaculated','fleeing','sitting','passive'}; % passive,[1 0.63 0] chase [1 0.75 0.80]
        color = {[1 0 0],[0.4940 0.1840 0.5560],[0 1 1], [1 1 0],[1 0.62 0.83], [1 0.5 0.5], [1 0.155 0.155], [0.15 1 0.15], [0.82 0.41 0.12],[0.05 0.749 0.549],[0.2 0.597 1],[0.796 0.598 1], [1 0.4 1],[1 1 0],[1 0.63 0] };  %[0.46 0.078 0.57]  [0.2 1 0.597]
    end
    neuron.Fs = Fs; %sample rate of final calcium data.
    neuron.gender = gender;
    
    [rpath, rname, rtype] = fileparts(trace_dir);
    rname_ind = strfind(rname,'_');
    neuron.name = rname(1:rname_ind(1)-1);
    neuron.neuron_id = neuron_id;
    [neuron.num_neuron, neuron.nframe] = size(data);

    %% Refine the behavioral data
    % neuron = waive_overlap_behav(neuron, form_label, 4);  % waive the
    % overlap behavior. e.g. overlap of mounting & intromission
    neuron = refine_label(neuron, action_label, form_label, color, events, 7);
    
    %% save file
    % ---- OUTPUT FILE ----
    % {filename}_neuron.mat
    save(sprintf('%s%s%s_neuron.mat', result_folder, filesep, neuron.name),  'neuron')
end
%% --- OPIONAL INCLUDE (AUTO GENERATE)---
% calculate deconvolution
if ~exist('dec_data','var')
    % ---- denoise_deconv: OUTPUT FILE ----
    % {filename}_den_deconv.mat
    %     [dec_data, sig_data] = calculate_deconv(data,neuron, result_folder, filelist,1);
    [dec_data, sig_data] = denoise_deconv(data,neuron, result_folder, filelist,1);
end

%% plot deconvolution data
[dec_ind, dec_seg_ind] = thresh_order(data,neuron,thresh,trace_per_plot);
% calculate the mean trace
% mean_trace = zeros(10,neuron.nframe);
% mean_trace(2,:) = mean(dec_data,1);d
% dec_seg_ind = {1:10};
% dec_data = mean_trace;
plot_data(data,neuron,dec_seg_ind,'deconv','plot_thresh',thresh,'zeroline','save_path',result_folder)
% 
% [dec_ind2, dec_seg_ind2] = double_sort(dec_data,neuron,double_thresh,first_event, second_event);
% plot_data(dec_data,neuron,dec_seg_ind2,'double_sort',double_thresh,[first_event,second_event],'zeroline','save_path', result_folder)

%% calculate auc
% --- OUTPUT FILE ---
% {filename}_auc_0.75.mat
% {filename}_auc_0.30.mat
%
% --- OUTPUT FIGURE ---
% auc_cue_0.75_{n}.fig
% auc_cue_0.30_{n}.fig
%
% % neuron.light(4,1)=1525;
% ! ¸Äbasline
% neuron.light(4,1)=1330;
% neuron.intruder(4,1)=1490;
if ~exist('auc_result1','var') || ~load_auc
    auc_result1 = auc_cue(data,sig_data,neuron,auc_thresh(1),result_folder,filelist,'light_on');
    plot_data(data,neuron,dec_seg_ind,'auc',auc_result1,'zeroline','zero_blank');
end
% index = 1:length(neuron.neuron_id);
% activated1 = auc_result.h_signifi(:,4,7);
% activated2 = auc_result.h_signifi(:,3,3);
% activated = activated1|activated2;
% a_ind = {index(activated)};
% plot_data(dec_data,neuron,a_ind,'auc',auc_result,'zeroline');
% signifi_plot(neuron,dec_data,sig_data,'ejaculated',auc_result);

if ~exist('auc_result2','var') || ~load_auc
    auc_result2 = auc_cue(data,sig_data,neuron,auc_thresh(2),result_folder,filelist,'light_on');
    plot_data(data,neuron,dec_seg_ind,'auc',auc_result2,'zeroline','zero_blank');
end
% signifi_plot(neuron,dec_data,sig_data,'mounting',auc_result);
% signifi_plot(neuron,dec_data,sig_data,'intromission',auc_result);
% signifi_plot(neuron,dec_data,sig_data,'ejaculated',auc_result);
% signifi_plot(neuron,dec_data,sig_data,'penile groom',auc_result);
end

function signifi_plot(neuron, dec_data, sig_data, label, auc_result)
    action_idx = strncmp(neuron.action_label,label,6);
    if sum(action_idx)~=0
        index = 1:length(neuron.neuron_id);
        activated = auc_result.h_signifi(:,action_idx,:);
        activated = squeeze(activated);
        splt = mat2cell(activated,length(activated),ones(1,size(activated,2)));
        activated = zeros(size(splt{1}));
        for i = 1:length(splt)
            activated=activated|splt{i};
        end
        if sum(activated)~=0
            a_ind = {index(activated)};
            plot_data(dec_data,neuron,a_ind,'auc',auc_result,'zeroline');
        end
%     fig_name = sprintf('%s/%s_%s.fig','E:\wupeixuan\auc_plot\data\mating_inhibit',neuron.name,label);
%     savefig(fig_name);
    end
end