function [form_label, events, intruder_labels] = excel_analysis(xls_path,varargin)
%CALCULATE_BEHAV a. Substract the time of all the annotations by the the
%time interval of light off.
%b. Read the intruder name from the form.
% xls_path = 'E:\wupeixuan\auc_plot\data\St181m\St1810109\1202\st18-1_20210109_dingzhaoyi_1202_analysis.xlsx';
assert(nargin<=2);
if nargin < 3
    mode = 'sheet1'; % 'sheet1'(default): read the first sheet and calculate the time
else
    mode = varargin{3}; % if 'sheet3': read the third sheet directly
end
switch mode
    case 'sheet1'
        [num2,content,~]=xlsread(xls_path,1,'A:I');
        if ~isempty(num2)
            origin_time = num2;
        else
            origin_time = content(17:end,1);
            origin_time = str2num(char(origin_time));
        end
        behaviors = content(17:end,6);
        status = double(contains(content(17:end,9),'STOP'))+1;
        form_label = lower(unique(behaviors));
        light_idx = contains(form_label,'light');
        intruder_idx = contains(form_label,'intruder');
        bhv_dict = {};
        for i=1:length(form_label)
            bhv_dict{i} = {[],[]};
        end

        factor = 0;
        stop_factor = 0;
        light_on = 0;
        for i=1:length(origin_time)
            if contains(behaviors(i),'light')&&isequal(status(i),1)
                factor = origin_time(i) - stop_factor + factor;
                bhv_dict{light_idx}{1} = [bhv_dict{light_idx}{1};(origin_time(i)-factor)];
                light_on = 1;
            elseif contains(behaviors(i),'light')&&isequal(status(i),2)
                bhv_dict{light_idx}{2} = [bhv_dict{light_idx}{2};(origin_time(i)-factor)];
                stop_factor = origin_time(i);
                light_on = 0;
            else
                if (light_on==0)&&(contains(behaviors(i),'intruder'))&&isequal(status(i),2)&&(origin_time(i-1)==origin_time(i))
                    istatus = status(i);
                    bhv_dict{behav_idx}{istatus} = [bhv_dict{behav_idx}{istatus};bhv_dict{light_idx}{2}(end)];
                else
                    behav_idx = contains(form_label,lower(behaviors(i)));
                    istatus = status(i);
                    bhv_dict{behav_idx}{istatus} = [bhv_dict{behav_idx}{istatus};(origin_time(i)-factor)];
                end
            end
        end

        events={};
        for i = 1:length(form_label)
            events{i} = cell2mat(bhv_dict{i});
            if size(events{i},2) == 1
                events{i}(:,2) = events{i}(:,1)+0.2;
            end
        end
    case 'sheet3'
        [~,intruder_label0,~]=xlsread(xls_path,3,'A:A');
        intruder_label0 = rmmissing(intruder_label0);
        form_label = lower(intruder_label0');
        num_event = length(form_label);
        [num,~,~]=xlsread(xls_path,3);
        u = isnan(num(:,1));
        ncut = diff([0; find(u); size(num,1)]); %cut into parts by 'nan'
        events = mat2cell(num, ncut);
        for i=1:length(events)-1
            events{i}(end, :)=[]; %give away 'nan'
        end
end

[~,intruder_labels,~]=xlsread(xls_path,2,'A:A');
intruder_labels = rmmissing(intruder_labels);
end