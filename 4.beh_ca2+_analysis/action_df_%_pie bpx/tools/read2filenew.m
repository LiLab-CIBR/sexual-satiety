function [filefolder,datelist] = read2filenew(filedir,animalnum)
    filelist2 = dir([filedir,'\',animalnum]);
    filelist2 = {filelist2.name};
    ind_trace_mat = find(~contains(filelist2, '.'));
    for i =1:length(ind_trace_mat)
        filefolder{i} = fullfile([filedir,'\',animalnum], filelist2{ind_trace_mat(i)});
        datelist{i} = filelist2{ind_trace_mat(i)};
    end
end