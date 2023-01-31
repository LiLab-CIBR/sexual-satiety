function S3_PlotBehBar(behbar)
%% totally there are 10 for male and 6 for female, but few of them were meaningful for a specific problem
gender = behbar.gender;
if contains(gender,'fe')
    PlotBehBarForFemale(behbar);
else
    PlotBehBarForMale(behbar); 
end
end


function PlotBehBarForMale(behbar)

form_label = behbar.form_label;
events = behbar.events;
savedir = behbar.savedir;
clusterlist = behbar.clusterlist;
name = behbar.name;
timewindow = behbar.timewindow;
is_ttest_only = behbar.is_ttest_only;
is_paired_ttest = behbar.is_paired_ttest;
ttest_group = behbar.ttest_group;

for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
        intruderidx{i}{j} = find(contains(form_label{i}{j},'intruder'));
        actionidx{i}{j}{1} = find(contains(form_label{i}{j},'positive'));
        if isempty(actionidx{i}{j}{1})
            actionidx{i}{j}{1} = find(contains(form_label{i}{j},'sniff'));
        end
        actionidx{i}{j}{2} = find(contains(form_label{i}{j},'mount'));
        actionidx{i}{j}{3} = find(contains(form_label{i}{j},'intro'));
        actionidx{i}{j}{4} = find(contains(form_label{i}{j},'ejacu'));
    end
end
%% Calc
for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
%% 1.mount latency & appe duration v
        mount_latency2{i}(j) = 1800;
        if ~isempty(actionidx{i}{j}{2})
            mount_latency2{i}(j) = events{i}{j}{actionidx{i}{j}{2},1}(1,1) - events{i}{j}{actionidx{i}{j}{1},1}(1,1);
            if mount_latency2{i}(j) >1800
                mount_latency2{i}(j) = 1800;
            end
        end
        mount_latency2{i}(j) = mount_latency2{i}(j);
%% 2.cons duration v
        cons_length{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{2})
            if ~isempty(actionidx{i}{j}{4})
                cons_length{i}(j) = events{i}{j}{actionidx{i}{j}{4},1}(1,1) - events{i}{j}{actionidx{i}{j}{2},1}(1,1);
            else
                cons_length{i}(j) = events{i}{j}{intruderidx{i}{j},1}(1,2) - events{i}{j}{actionidx{i}{j}{2},1}(1,1);
            end
        end
        cons_length{i}(j) = cons_length{i}(j);
%% 3.intro counts v
        intro_counts{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{3})
            intro_counts{i}(j) = size(events{i}{j}{actionidx{i}{j}{3},1},1);
        end
%% 4.appe sniff duration and % v
        if mount_latency2{i}(j) > timewindow*60
            timecutt = timewindow*60;
        else
            timecutt = mount_latency2{i}(j);
        end
        sniff_appe{i}{j} =  events{i}{j}{actionidx{i}{j}{1},1}(events{i}{j}{actionidx{i}{j}{1},1}(:,2) <= timecutt+events{i}{j}{actionidx{i}{j}{1},1}(1,1),:);
        sniff_appe_dur{i}(j) = 0;
        for p = 1:size(sniff_appe{i}{j},1)
             sniff_appe_dur{i}(j) = sniff_appe_dur{i}(j)+ sniff_appe{i}{j}(p,2)-sniff_appe{i}{j}(p,1);
        end
        sniff_appe_dur_percent{i}(j) = sniff_appe_dur{i}(j)/timecutt*100;
%% 5. % mount+intro dur/cons dur
        mount_cons_dur{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{2})
            mount_cons{i}{j} =  events{i}{j}{actionidx{i}{j}{2},1};
            for p = 1:size(mount_cons{i}{j},1)
                 mount_cons_dur{i}(j) = mount_cons_dur{i}(j)+ mount_cons{i}{j}(p,2)-mount_cons{i}{j}(p,1);
            end
        end
        intro_cons_dur{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{3})
        intro_cons{i}{j} =  events{i}{j}{actionidx{i}{j}{3},1};
        for p = 1:size(intro_cons{i}{j},1)
             intro_cons_dur{i}(j) = intro_cons_dur{i}(j)+ intro_cons{i}{j}(p,2)-intro_cons{i}{j}(p,1);
        end
        end
         mi_cons_dur_percent{i}(j) = 0;
        if cons_length{i}(j) ~= 0
            mi_cons_dur_percent{i}(j) = (intro_cons_dur{i}(j)+mount_cons_dur{i}(j))/cons_length{i}(j)*100;
        end
%% 6. intro interval dur
        intro_inter_dur{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{3})
            if size(events{i}{j}{actionidx{i}{j}{3},1},1) > 1
                for p = 1:size(events{i}{j}{actionidx{i}{j}{3},1},1)-1
                    intro_inter_sigledur{i}{j}(p) = events{i}{j}{actionidx{i}{j}{3},1}(p+1,1) - events{i}{j}{actionidx{i}{j}{3},1}(p,2);
                end
                intro_inter_dur{i}(j) = mean(intro_inter_sigledur{i}{j});
            end
        end
%% 7.mount counts v
        mount_counts{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{2})
            mount_counts{i}(j) = size(events{i}{j}{actionidx{i}{j}{2},1},1);
        end
%% 8.mount freq v
        mount_freq{i}(j) = 0;
        if cons_length{i}(j) >0
            mount_freq{i}(j) = mount_counts{i}(j)/cons_length{i}(j);
        end
%% 9.intro freq v
        intro_freq{i}(j) = 0;
        if cons_length{i}(j) >0
            intro_freq{i}(j) = intro_counts{i}(j)/cons_length{i}(j);
        end
%% 10.ejacu latency
        ejaculatency{i}(j) = 0;
        if mount_latency2{i}(j) <1800
            ejaculatency{i}(j) = cons_length{i}(j)+mount_latency2{i}(j);
        end
    end
end 
%% Draw

%% 1.mount latency & appe duration 
S3p_draw_beh_bar_and_output_data(savedir,name,'mount latency',clusterlist,mount_latency2,is_ttest_only,is_paired_ttest,ttest_group,1800)
%% 2.cons duration
S3p_draw_beh_bar_and_output_data(savedir,name,'cons duration',clusterlist,cons_length,is_ttest_only,is_paired_ttest,ttest_group,3000)
%% 3.intro counts
S3p_draw_beh_bar_and_output_data(savedir,name,'intro counts',clusterlist,intro_counts,is_ttest_only,is_paired_ttest,ttest_group,80)
%% 4.appe sniff duration % 
S3p_draw_beh_bar_and_output_data(savedir,name,['sniff dur in appe or',num2str(timewindow)],clusterlist,sniff_appe_dur_percent,is_ttest_only,is_paired_ttest,ttest_group,100)
%% 5. % mount+intro dur/cons dur
S3p_draw_beh_bar_and_output_data(savedir,name,'mount+intro dur in cons',clusterlist,mi_cons_dur_percent,is_ttest_only,is_paired_ttest,ttest_group,100)
%% 6. mean intro interval dur
S3p_draw_beh_bar_and_output_data(savedir,name,'mean intro interval dur',clusterlist,intro_inter_dur,is_ttest_only,is_paired_ttest,ttest_group,300)
%% 7.mount counts
S3p_draw_beh_bar_and_output_data(savedir,name,'mount counts',clusterlist,mount_counts,is_ttest_only,is_paired_ttest,ttest_group,100)
%% 8. mount freq
S3p_draw_beh_bar_and_output_data(savedir,name,'mount frequency',clusterlist,mount_freq,is_ttest_only,is_paired_ttest,ttest_group,0.1)
%% 9. intro freq
S3p_draw_beh_bar_and_output_data(savedir,name,'intro frequency',clusterlist,intro_freq,is_ttest_only,is_paired_ttest,ttest_group,0.1)
%% 10.ejacu latency
S3p_draw_beh_bar_and_output_data(savedir,name,'ejaculation latency',clusterlist,ejaculatency,is_ttest_only,is_paired_ttest,ttest_group,3000)



end

function PlotBehBarForFemale(behbar)

form_label = behbar.form_label;
events = behbar.events;
savedir = behbar.savedir;
clusterlist = behbar.clusterlist;
name = behbar.name;
timewindow = behbar.timewindow;
events2 = events;
is_ttest_only = behbar.is_ttest_only;
is_paired_ttest = behbar.is_paired_ttest;
ttest_group = behbar.ttest_group;

for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
        intruderidx{i}{j} = find(contains(form_label{i}{j},'intruder'));
        actionidx{i}{j}{1} = find(contains(form_label{i}{j},'passive'));
        actionidx{i}{j}{5} = find(contains(form_label{i}{j},'positive'));
        if isempty(actionidx{i}{j}{1})
            actionidx{i}{j}{1} = find(contains(form_label{i}{j},'sniff'));
        end
        if isempty(actionidx{i}{j}{1})
            actionidx{i}{j}{1} = find(contains(form_label{i}{j},'positive'));
        end

        actionidx{i}{j}{2} = find(contains(form_label{i}{j},'mounted'));
        if isempty(actionidx{i}{j}{2})
            actionidx{i}{j}{2} = find(contains(form_label{i}{j},'mount'));
        end
        actionidx{i}{j}{3} = find(contains(form_label{i}{j},'lordo'));
        if isempty(actionidx{i}{j}{3})
            actionidx{i}{j}{3} = find(contains(form_label{i}{j},'intro'));
        end
        actionidx{i}{j}{4} = find(contains(form_label{i}{j},'ejacu'));
        actionidx{i}{j}{6} = find(contains(form_label{i}{j},'flee'));
        actionidx{i}{j}{7} = find(contains(form_label{i}{j},'sitting'));
%% 根据时间窗限制events
        alleventscounts{i}{j} = 0;
        for p = 1:length(events2{i}{j})
            events2{i}{j}{p}(events2{i}{j}{p}(:,2) > events2{i}{j}{actionidx{i}{j}{2}}(1,1) + timewindow*60,:) = [];
            events2{i}{j}{p}(events2{i}{j}{p}(:,2) < events2{i}{j}{actionidx{i}{j}{2}}(1,1),:) = [];
            alleventscounts{i}{j} = alleventscounts{i}{j}+size(events2{i}{j}{p},1);
        end
        if isempty(actionidx{i}{j}{5})
            alleventscounts{i}{j} = alleventscounts{i}{j} + size(events2{i}{j}{actionidx{i}{j}{2}},1);
        end
        if isempty(actionidx{i}{j}{6})&&isempty(actionidx{i}{j}{7})
            alleventscounts{i}{j} = alleventscounts{i}{j}+size(events2{i}{j}{actionidx{i}{j}{2}},1)-size(events2{i}{j}{actionidx{i}{j}{3}},1);
        end
    end
end

for i = 1:size(events,2)
    for j = 1:size(events{i},2) 
%% 1.lordosis counts v
        if ~isempty(actionidx{i}{j}{3})
            intro_percent{i}(j) = size(events2{i}{j}{actionidx{i}{j}{3},1},1)/alleventscounts{i}{j};
        else
            intro_percent{i}(j) = 0;
        end
%% 2.reject counts v
        if ~isempty(actionidx{i}{j}{6})
            flee_percent{i}(j) = size(events2{i}{j}{actionidx{i}{j}{6},1},1)/alleventscounts{i}{j};
        else
            flee_percent{i}(j) = 0;
        end
        if ~isempty(actionidx{i}{j}{7})
            sitting_percent{i}(j) = size(events2{i}{j}{actionidx{i}{j}{7},1},1)/alleventscounts{i}{j};
        else
            sitting_percent{i}(j) = 0;
        end
        reject_percent{i}(j) = sitting_percent{i}(j) + flee_percent{i}(j);
        if isempty(actionidx{i}{j}{6}) && isempty(actionidx{i}{j}{7}) && ~isempty(actionidx{i}{j}{3})
%         if ~isempty(actionidx{i}{j}{3})
            reject_percent{i}(j) = size(events2{i}{j}{actionidx{i}{j}{2},1},1)/alleventscounts{i}{j} - size(events2{i}{j}{actionidx{i}{j}{3},1},1)/alleventscounts{i}{j};
%         else
%              reject_percent{i}(j) = 1;
        end
%% 3.cons lordosis length %
        if isempty(actionidx{i}{j}{3})
                lordo_cons{i}{j} =  [0,0];
        else
            lordo_cons{i}{j} =  events2{i}{j}{actionidx{i}{j}{3},1};
        end
        lordo_cons_dur{i}(j) = 0;
        for p = 1:size(lordo_cons{i}{j},1)
            lordo_cons_dur{i}(j) = lordo_cons_dur{i}(j)+ lordo_cons{i}{j}(p,2)-lordo_cons{i}{j}(p,1);
        end
        cons_length{i}(j) = timewindow*60;
        if events2{i}{j}{actionidx{i}{j}{2}}(1,1) + timewindow*60 > events{i}{j}{intruderidx{i}{j},1}(1,2)
            cons_length{i}(j) = events{i}{j}{intruderidx{i}{j},1}(1,2) - events2{i}{j}{actionidx{i}{j}{2}}(1,1);
        end
        lordo_cons_dur_percent{i}(j) = lordo_cons_dur{i}(j)/cons_length{i}(j);
%% 5. % mount+intro dur/cons dur
        mount_cons{i}{j} =  events{i}{j}{actionidx{i}{j}{2},1};
        if isempty(actionidx{i}{j}{3})
                intro_cons{i}{j} =  [0,0];
        else
            intro_cons{i}{j} =  events{i}{j}{actionidx{i}{j}{3},1};
        end
        mount_cons_dur{i}(j) = 0;
        for p = 1:size(mount_cons{i}{j},1)
             mount_cons_dur{i}(j) = mount_cons_dur{i}(j)+ mount_cons{i}{j}(p,2)-mount_cons{i}{j}(p,1);
        end
        intro_cons_dur{i}(j) = 0;
        for p = 1:size(intro_cons{i}{j},1)
             intro_cons_dur{i}(j) = intro_cons_dur{i}(j)+ intro_cons{i}{j}(p,2)-intro_cons{i}{j}(p,1);
        end
        mi_cons_dur_percent{i}(j) = (intro_cons_dur{i}(j)+mount_cons_dur{i}(j))/cons_length{i}(j);
        
%% 6. intro interval dur
        intro_inter_dur{i}(j) = 0;
        if ~isempty(actionidx{i}{j}{3})
            if size(events{i}{j}{actionidx{i}{j}{3},1},1) > 1
                for p = 1:size(events{i}{j}{actionidx{i}{j}{3},1},1)-1
                    intro_inter_sigledur{i}{j}(p) = events{i}{j}{actionidx{i}{j}{3},1}(p+1,1) - events{i}{j}{actionidx{i}{j}{3},1}(p,2);
                end
                intro_inter_dur{i}(j) = mean(intro_inter_sigledur{i}{j});
            end
        end
    end
end    

%% 画

%% 1.lordosis counts v
S3p_draw_beh_bar_and_output_data(savedir,name,['lordosis trials in ',num2str(timewindow)],clusterlist,intro_percent,is_ttest_only,is_paired_ttest,ttest_group,1)
%% 2.reject counts v
S3p_draw_beh_bar_and_output_data(savedir,name,['reject trials in ',num2str(timewindow)],clusterlist,reject_percent,is_ttest_only,is_paired_ttest,ttest_group,1)
%% 3.cons lordosis length %
S3p_draw_beh_bar_and_output_data(savedir,name,['lordosis dur in ',num2str(timewindow)],clusterlist,lordo_cons_dur_percent,is_ttest_only,is_paired_ttest,ttest_group,1)
%% 5. % mount+intro dur/cons dur
S3p_draw_beh_bar_and_output_data(savedir,name,'mount_intro dur in cons',clusterlist,mi_cons_dur_percent,is_ttest_only,is_paired_ttest,ttest_group,1)
%% 6. intro interval dur
S3p_draw_beh_bar_and_output_data(savedir,name,'mean intro interval dur',clusterlist,intro_inter_dur,is_ttest_only,is_paired_ttest,ttest_group,300)


end



