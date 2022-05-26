function filefolder = read_file_by_date_and_cluster(filedir,clusterlist2,datelist)

%  filedir = result_folder;
%  clusterlist2 = clusterlist{i};
 
    filelistused = eval(['datelist.',clusterlist2]);
    
    for j = 1:length(filelistused)   
        if isempty(filelistused{j})
            filefolder{j} = {};
        else
            filefolder{j} = [filedir,'\',filelistused{j}(1:end-4),'\',filelistused{j}];
        end
    end
end