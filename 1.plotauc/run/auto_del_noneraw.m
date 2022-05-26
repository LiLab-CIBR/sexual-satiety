clear;
clc;
close all;

filefolder = 'E:\wupeixuan\auc_plot\data\auc2 series_0412';%一级目录的全地址

aninumlist =  {'Esr29','Esr222','Esr229','Esr230','Esr252','Esr24','Esr237','Esr240','Esr235','Esr254','Esr256'};%二级目录，可挑选运行
aninumlist =  {'St181','St1823','St1825','St187','St188','St1817','St1819'};
for i = 1:length(aninumlist)
    aa{i} = read_file_with_samename(filefolder,aninumlist{i});%获取二级目录之下三级目录
    for j = 1:length(aa{i}) 
        filelist = dir(aa{i}{j});
        filelist = {filelist.name};%三级目录的子文件名
        ind_prime_mat = contains(filelist, '.mat')|contains(filelist, '.txt')|contains(filelist, '.fig');
        for p = 1:length(ind_prime_mat)
            if ind_prime_mat(p)
                delete([aa{i}{j},'\',filelist{p}])%删除包含以上三个后缀名的子文件
            end
        end
    end
end