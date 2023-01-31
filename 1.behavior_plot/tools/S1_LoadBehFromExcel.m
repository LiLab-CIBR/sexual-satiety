function [form_label,events,datalist] = S1_LoadBehFromExcel(xls,savedir)

    result_folder = xls.excel_folder;
    clusterlist = xls.clusterlist;
    name = xls.name;
    % get the name and path of each data
    for i = 1:length(clusterlist)
        [xls_path{i},datalist{i}] = read_from_excel(result_folder,clusterlist{i});
    end
    % read data
    for i = 1:size(xls_path,2)
        for j = 1:size(xls_path{i},2) 
            [form_label{i}{j},events{i}{j}] = behxlsread_nointruder(xls_path{i}{j});
        end
    end
    % export data info to excel
    idxlist = 'ABCDEFGHIJKLMN';
    xlswrite([savedir,'\datafile\',name,'.xlsx'],clusterlist,'dataname','A1')
    for i = 1:size(clusterlist,2)
       xlswrite([savedir,'\datafile\',name,'.xlsx'],datalist{i}','dataname',[idxlist(i),'2'])
    end

end

function [filefolder,datalist] = read_from_excel(filedir,subdirectory)
    filelist = dir([filedir,'\',subdirectory]);
    filelist = {filelist.name};
    ind_trace_mat = find(contains(filelist, '.xls'));
    for i =1:length(ind_trace_mat)
        filefolder{i} = fullfile([filedir,'\',subdirectory], filelist{ind_trace_mat(i)});
        datalist{i} = filelist{ind_trace_mat(i)};
    end
end



function [form_label,events] = behxlsread_nointruder(xls_path)

    [num2,content,~]=xlsread(xls_path,1,'A:I');
    origin_time = content(17:end,1);% row 16 is header
    templist = num2(~isnan(num2));
    k=0;
    for i = 1:length(origin_time)
        if isempty(origin_time{i})
            k=k+1;
            origin_time{i} = num2str(templist(k));
        end
    end
    origin_time = str2num(char(origin_time));
    behaviors = lower(content(17:end,6));
    status = double(contains(content(17:end,9),'STOP'))+1;
    form_label = unique(lower(behaviors),'stable');
    bhv_dict = {};
    for i=1:length(form_label)
        bhv_dict{i} = {[],[]};
    end
    for i=1:length(origin_time)
        behav_idx = contains(form_label,behaviors(i));
        istatus = status(i);
        bhv_dict{behav_idx}{istatus} = [bhv_dict{behav_idx}{istatus};origin_time(i)];
    end
    events={};
    for i = 1:length(form_label)
        events{i,1} = cell2mat(bhv_dict{i});
    end

end