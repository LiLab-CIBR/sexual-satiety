function filefolder = read_file_with_samename(filedir,subdir)
    filelist2 = dir([filedir,'\',subdir]);
    filelist2 = {filelist2.name};
    ind_trace_mat = find(contains(filelist2, subdir));
    for i = 1:length(ind_trace_mat)
        filefolder{i} = fullfile([filedir,'\',subdir], filelist2{ind_trace_mat(i)});
    end
end