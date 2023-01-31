### ZD7288female to male1
clusterlist = {'control','expri'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\ZD7288female to male1';
name = 'ZD7288female to male1';
gender = 'female';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221008temp\ZD7288female to male1';
mkdir(savedir)
mkdir([savedir,'/datafile'])
mkdir([savedir,'/picfile'])
is_ttest_only = false;
is_paired_ttest = false;
ttest_group = {[1,2]}

### MRF1023
clusterlist = {'control','exp'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\from mx\MRF1023\data';
name = 'MRF1023';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221008temp\MRF1023';
mkdir(savedir)
mkdir([savedir,'/mfile'])
mkdir([savedir,'/datafile'])
mkdir([savedir,'/picfile'])
is_ttest_only = false;
is_paired_ttest = false;
ttest_group = {[1,2]};

### 'male 2 male caspase_new'
clusterlist = {'control','caspase3'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\male 2 male caspase\new';
name = 'male 2 male caspase_new';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221008temp\male 2 male caspase_new';
mkdir(savedir)
mkdir([savedir,'/mfile'])
mkdir([savedir,'/datafile'])
mkdir([savedir,'/picfile'])
is_ttest_only = false;
is_paired_ttest = false;
ttest_group = {[1,2]};

### 'male 2 male caspase_new2'
clusterlist = {'control','caspase3'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\male 2 male caspase_new2';
name = 'male 2 male caspase_new2';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221008temp\male 2 male caspase_new2';
mkdir(savedir)
mkdir([savedir,'/mfile'])
mkdir([savedir,'/datafile'])
mkdir([savedir,'/picfile'])
is_ttest_only = false;
is_paired_ttest = false;
ttest_group = {[1,2]};

### mx-Esr2M_M C&I
clusterlist = {'control','inhibition'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\mx-Esr2M_M C&I';
name = 'mx-Esr2M_M C&I';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221008temp\mx-Esr2M_M C&I';
mkdir(savedir)
mkdir([savedir,'/mfile'])
mkdir([savedir,'/datafile'])
mkdir([savedir,'/picfile'])
is_ttest_only = true;
is_paired_ttest = false;
ttest_group = {[1,2]};

### Male_Esr2_caspase3_V
clusterlist = {'group1_control','group2_caspase3'};
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\Male_Esr2_caspase3_V';
name = 'Male_Esr2_caspase3_V';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221008temp\Male_Esr2_caspase3_V';
mkdir(savedir)
mkdir([savedir,'/mfile'])
mkdir([savedir,'/datafile'])
mkdir([savedir,'/picfile'])
is_ttest_only = false;
is_paired_ttest = false;
ttest_group = {[1,2]};

### drug deliver C
clusterlist = {'C-V-saline','C-Munip_saline'};% 2 or more clusters of one expriment
excel_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1data\Need DZY to do test0421\drug deliver';% fullpath of parent folder
name = 'drug deliver C';
gender = 'male';
savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\20221008temp\drug deliver C';
mkdir(savedir)
mkdir([savedir,'/datafile'])
mkdir([savedir,'/picfile'])
is_ttest_only = false;
is_paired_ttest = false;
ttest_group = {[1,2]};% only used when "is_ttest_only" is TRUE

