function [auc_result, neuron] = auc_cue(dec_data,sig_data,neuron,auc_thresh,filefolder,filelist,varargin)
% Calculate auc by each action in each cue.
% For sniff, take the baseline before cue in.
% For mating behaviors, take the baseline: blank of cue in -> the last
% action of the behavior.
%
% ----- OUTPUT PARA -----
%
% ----- OUTPUT FILE -----
% xxx_auc_{auc_thresh}.mat
Fs = neuron.Fs;
fname = sprintf('auc_%.02f.mat',auc_thresh);
events = neuron.events;
action_label = neuron.action_label;

if ~isempty(varargin)
%     % Calculate only event of mating
%     if strcmp(varargin{1},'sex')
%         fname = sprintf('auc_sex_%.02f.mat',auc_thresh);
%         delete_event = neuron.delete_event;
%         for i = 1:length(delete_event)
%             del_id = delete_event(i);
%             neuron.intruder(del_id,:) = [];
%             neuron.intruder_label(del_id) = [];
%                 delete_event(i:end) = delete_event(i:end) - 1;
%         end
%     else
%         disp('Type unmatch, calculate auc for all events.');
%     end
    if ischar(varargin{1})
        bl_mode = varargin{1};
        if strcmp(bl_mode,'hard') 
            if nargin==3
                base_begin = input('Please specify the begin time (e.g -80):\n');
            else
                base_begin = varargin{2};
            end
        elseif strcmp(bl_mode,'light_on')==0
            error("Mode doesn't correct. Please specfy light_on or hard.")
        end
    elseif isa(varargin{1},'double')
        bl_mode = 'hard';
        base_begin = varargin{1};
    end
else
    bl_mode = 'light_on';
end
        
% %% check the file
% for i =1:length(filelist)
% if contains(filelist{i},fname)
%     load([filefolder,filesep,filelist{i}]);
%     return
% end
% end
%% select event state
[num_neuron, nframe] = size(dec_data);
tlen = nframe / Fs;  % total time
intruder = neuron.intruder;
light = neuron.light;
nintruder = size(intruder,1);  % intruder总数
nstate = size(action_label,2);  % action总数
zerostates = zeros(nintruder, nframe);
actionstates = zeros(nstate, nframe);
none_action = [];
%% Waive the passive
% none = zeros(nintruder,2);
% sniffed_idx = find(ismember(neuron.action_label,'passive'));
% if ~isempty(sniffed_idx)
%     none = zeros(nintruder,2);
%     none(:,1) = sniffed_idx; none(:,2)=1:nintruder;
%     none_action = [none_action; none];
%     events{sniffed_idx} = [0 0];
% end

%% Shorten the length of sniffing: only consider the sniffing in the first 120 sec after cue in
sniff_idx = find(ismember(neuron.action_label,'positive'));
if ~isempty(sniff_idx)

    sniff = events{sniff_idx};
    tRise = sniff(:,1); tDur = sniff(:,2)-sniff(:,1);
    sniff_flag = revertTTL2bin(tRise, tDur, Fs, tlen);
    short_time = 120;
    short_intrud = zeros(size(intruder));
    for i=1:nintruder
        intruder_len = intruder(i,2) - intruder(i,1);
        if intruder_len < short_time
            short_intrud(i,:) = intruder(i,:);
        else
            short_intrud(i,:) = [intruder(i,1), intruder(i,1)+short_time];
        end
    end
    tRise = short_intrud(:,1); tDur = short_intrud(:,2) - short_intrud(:,1);
    flag = revertTTL2bin(tRise, tDur, Fs, tlen);
    [fRise, fDur] = detectTTL(sniff_flag.*flag);
    events{sniff_idx} = [fRise fRise+fDur]/Fs;
end
%% set baseline, intruders and actions
base_end = -2;
switch bl_mode
    case 'hard'
        for i=1:nintruder
            zerostate = zeros(1, nframe);
            tRise = intruder(i,1)+base_begin; tDur = base_end-base_begin;
            if i == 1 && tRise < 0
                tRise = 1/Fs;
            end
            if i>1 && tRise<intruder(i-1,2)
                zerostates(i,:) = zerostates(i-1,:);  %  如果baseline不足100秒，则取前一个cue的baseline
                continue
            end
            flag = revertTTL2bin(tRise, tDur, Fs, tlen);
            zerostate(flag) = 1;
            zerostates(i,:) = zerostate(1:nframe);
        end
    case 'light_on'
        for i=1:nintruder
            zerostate = zeros(1, nframe);
            tRise = light(find(light(:,1)<intruder(i,1), 1, 'last' ),1);
            if tRise == 0
                tRise = 1/Fs;
            end
            tEnd = intruder(find(tRise<intruder(:,1), 1, 'first' ),1) + base_end;
            tDur = tEnd-tRise;
            flag = revertTTL2bin(tRise, tDur, Fs, tlen);
            zerostate(flag) = 1;
            zerostates(i,:) = zerostate(1:nframe);
        end
end
zerostates = logical(zerostates);

% none_action = [];
bstates = zeros(1, nframe);

for i = 1:nstate
    event_now = events{i};
    tRise = event_now(:,1); tDur = event_now(:,2) - tRise;
    flag = revertTTL2bin(tRise, tDur, Fs, tlen);
    for j=1:nintruder
        cue_now = intruder(j,:);  % The start and end time of the jth intruder
        cue_dur = cue_now(2) - cue_now(1);
        flag_cue = revertTTL2bin(cue_now(1), cue_dur, Fs, tlen);
        tot_flag = flag & flag_cue;
        bstates(tot_flag) = i + j*10;
        actionstates(i,tot_flag) = j*10;
        if sum(tot_flag)==0
            none_action = [none_action; i j];
        end
%     serial = (1:nframe)'/Fs; %'
%     flagzero = serial>tseg(i) & serial<tseg(i+1) & ~flag;
%     zerostates(flagzero) = i; 
    end
end
bstates = bstates(1:nframe);
baselines = zeros(nintruder,nstate,nframe);
% Calculate baseline for each behavior
for j=1:nintruder
    if ~isempty(none_action)
        if length(unique(none_action(none_action(:,2)==j,1)))==nstate
            continue
        end
    end
    cue_now = intruder(j,:);
    bstate = bstates>j*10 & bstates<(j+1)*10;
    [bRise, bDur] = detectTTL(bstate);
    bRise=bRise/Fs; bDur = 5+bDur/Fs;
    if bRise(end)+bDur(end)>neuron.intruder(j,2)
        bDur(end) = neuron.intruder(j,2)-bRise(end);
    end
    bstate = revertTTL2bin(bRise, bDur, Fs, tlen);
    for i=1:nstate
        if ~isempty(none_action)
            if sum(ismember(none_action, [i, j],'rows'))~=0
                continue
            end
        end
        if strcmp(neuron.action_label{i},'positive')%||strcmp(neuron.action_label{i},'ejaculated')
            baselines(j,i,:) = zerostates(j,:);
        else
            event_end = find(actionstates(i,:)==j*10,1,'last')/Fs;
            flag_cue_action = revertTTL2bin(cue_now(1), event_end-cue_now(1), Fs, tlen);
            bl = (~bstate)&flag_cue_action;
            if sum(bl)==0
                baselines(j,i,:) = zerostates(j,:);
            else
                baselines(j,i,:) = bl;
            end
        end
    end
end

%% calculate auROC
ejact_idx = find(ismember(neuron.action_label,'ejaculation'));
tic;
aucs = zeros(num_neuron, nstate, nintruder);
pvals = zeros(num_neuron, nstate, nintruder);
rankps = zeros(num_neuron, nstate, nintruder);
for iintruder = 1:nintruder
    for istate = 1:nstate
    %     zerostate = zerostates==istate;
    %     zerostate = zerostates>0;
        if ~isempty(none_action)
            if sum(ismember(none_action, [istate, iintruder],'rows'))~=0  % 如若此行为在此intruder中没有出现，则不用计算
                aucs(:, istate, iintruder) = 0;
                pvals(:, istate, iintruder) = 0;
                rankps(:, istate, iintruder) = 0;
                continue
            end
        end
        flag = iintruder*10;
        behavioralstate = (actionstates(istate,:)==flag);
        bl = logical(squeeze(baselines(iintruder,istate,:)));
        parfor icell = 1:num_neuron
            timeseries = dec_data(icell,:);
            [aucs(icell, istate, iintruder), pvals(icell, istate, iintruder), ~] = auROC_withStates_cxf(timeseries,behavioralstate,bl,100,5000);
            rankps(icell, istate, iintruder) = ranksum(timeseries(behavioralstate), timeseries(bl));
            if sum(timeseries(behavioralstate))<10 && sum(timeseries(bl))<10
                aucs(icell, istate, iintruder)=0.5;
                pvals(icell, istate, iintruder)=NaN;
                rankps(icell, istate, iintruder)=NaN;
            end 
        end
        % To avoid the influence of trailing from intromission
        if istate == ejact_idx
            ejac_state=zeros(1,nframe);
            tRise = find(behavioralstate>0,1);
            ejac_state(tRise:tRise+5*Fs)=true;
            tot_spike = sum(sig_data(:,logical(ejac_state))');
            if auc_thresh > 0.5
                tot_spike(tot_spike<10)=NaN;
                tot_spike(tot_spike>=10)=1;
                pvals(:,istate,iintruder)=pvals(:,istate,iintruder).*tot_spike';
                rankps(:,istate,iintruder)=rankps(:,istate,iintruder).*tot_spike';
            else
                tot_spike(tot_spike>0)=NaN;
                pvals(:,istate,iintruder)=pvals(:,istate,iintruder).*tot_spike';
                rankps(:,istate,iintruder)=rankps(:,istate,iintruder).*tot_spike';
            end
        end
    end
end
toc

for i = 1:size(none_action,1)
    aucs(:,none_action(i,1),none_action(i,2))=NaN;
    pvals(:,none_action(i,1),none_action(i,2))=NaN;
    rankps(:,none_action(i,1),none_action(i,2))=NaN;
end

if auc_thresh >= 0.5
    out_th=(aucs > auc_thresh) & ~isnan(aucs);
else
    out_th=(aucs < auc_thresh) & ~isnan(aucs);
end
h_signifi = pvals<0.01 & out_th;
if auc_thresh < 0.5
    h_signifi = waive_signi(neuron,'mounting',h_signifi);
    h_signifi = waive_signi(neuron,'intromission',h_signifi);
    h_signifi = waive_signi(neuron,'ejaculation',h_signifi);
    h_signifi = waive_signi(neuron,'penile groom',h_signifi);
end

%% save the result
auc_result.actionstates = actionstates;
auc_result.aucs = aucs;
auc_result.pvals = pvals;
auc_result.rankps = rankps;
auc_result.h_signifi = h_signifi;
auc_result.auc_thresh = auc_thresh;

save(sprintf('%s%s%s_%s', filefolder, filesep, neuron.name, fname), 'auc_result');
end

function h_signifi = waive_signi(neuron, label, h_signifi)
    action_idx = strncmp(neuron.action_label,label,6);
    if sum(action_idx)~=0
        h_signifi(:,action_idx,:) = 0;
    end
end