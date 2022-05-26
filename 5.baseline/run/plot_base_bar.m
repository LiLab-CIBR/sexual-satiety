clear;
close all;

%% 雄
%一级目录地址
basebar.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';
%储存地址
basebar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
%性别
basebar.gender = 'male';
%状态
basebar.clusterlist = {'virgin1','satiated1','recovery1'};%
%三级目录名称（用到的天数）
basebar.datelist.virgin1 = {'Esr2220511','Esr2290607','Esr2300622','Esr2520221','Esr290201'};
% basebar.datelist.virgin2 = {'Esr2220514','Esr2290616','Esr2300626','Esr2520221','Esr290203'};
basebar.datelist.satiated1 = {'Esr2220517','Esr2290625','Esr2300628','Esr2520222','Esr290224'};
basebar.datelist.recovery1 = {'Esr2220621','Esr2290705','Esr2300714','Esr2520316','Esr290323'};
%以动物为单位还是以细胞为单位
basebar.minunit = 'animal';%'animal','neuron'
basebar.isnormalize = true;
base_bar_core(basebar)

%% 雄2
%一级目录地址
basebar.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';
%储存地址
basebar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
%性别
basebar.gender = 'male';
%状态
basebar.clusterlist = {'virgin1','virgin2','satiated1','recovery1','satiated2','recovery2'};%
%三级目录名称（用到的天数）
basebar.datelist.virgin1 = {'Esr2220511','Esr2290607','Esr2300622','Esr2520214','Esr290201'};
basebar.datelist.virgin2 = {'Esr2220514','Esr2290616','Esr2300626','Esr2520221','Esr290203'};
% basebar.datelist.nearly = {'Esr2220515','Esr2290623'};
basebar.datelist.satiated1 = {'Esr2220517','Esr2290625','Esr2300628','Esr2520222','Esr290224'};
basebar.datelist.recovery1 = {'Esr2220621','Esr2290705','Esr2300714','Esr2520316','Esr290323'};
basebar.datelist.satiated2 = {'Esr2220626','Esr2290708','Esr2300715','Esr2520318',''};
basebar.datelist.recovery2 = {'Esr2220625','Esr2290816','Esr2300817','Esr2520210',''};
%以动物为单位还是以细胞为单位
basebar.minunit = 'animal';%'animal','neuron'
basebar.isnormalize = true;
base_bar_core(basebar)

%% 真孕


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
basebar.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';
%储存地址
basebar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0422';
%性别
basebar.gender = 'female';
%状态
basebar.clusterlist = {'virgin1','virgin2','pregant1','pregant2','lactate','recovery'};
%三级目录名称（用到的天数）
basebar.datelist.virgin1 = {'Esr240109','Esr2401213','Esr2370215'};
basebar.datelist.virgin2 = {'Esr240112','Esr2401214','Esr2370216'};
basebar.datelist.pregant1 = {'Esr240125','Esr2401220','Esr2370222'};
basebar.datelist.pregant2 = {'Esr240208','Esr2401230','Esr2370228'};
basebar.datelist.lactate = {'Esr240215','Esr2400110','Esr2370316'};
basebar.datelist.recovery = {'Esr240511','Esr2400228','Esr2400128'};
%以动物为单位还是以细胞为单位
basebar.minunit = 'animal';%'animal','neuron'
basebar.isnormalize = true;
base_bar_core(basebar)

%% 假孕
basebar.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';
%储存地址
basebar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0419';
%性别
basebar.gender = 'female';
%状态
basebar.clusterlist = {'virgin1','virgin2','psudo','recovery'};
%三级目录名称（用到的天数）
basebar.datelist.virgin1 = {'Esr2371214','Esr2540216','Esr2350215'};
basebar.datelist.virgin2 = {'Esr2371227','Esr2540218','Esr2350218'};
basebar.datelist.psudo = {'Esr2371231','Esr2540223','Esr2350331'};
basebar.datelist.recovery = {'Esr2370108','Esr2540228','Esr2350409'};
%以动物为单位还是以细胞为单位
basebar.minunit = 'animal';%'animal','neuron'
basebar.isnormalize = true;
base_bar_core(basebar)

%% 雌性合并


basebar.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';
basebar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0509out';
%性别
basebar.gender = 'female';
%状态
basebar.clusterlist = {'virgin','satiated','recovery'};
%三级目录名称（用到的天数）
basebar.datelist.virgin = {'Esr240109','Esr2401214','Esr2371227','Esr2540216','Esr2350218'};%'Esr2370215',
% basebar.datelist.satiated = {'Esr240208','Esr2401230','Esr2371231','Esr2540223','Esr2350331'};%'Esr2370228',
basebar.datelist.satiated = {'Esr240115','Esr2401220','Esr2371231','Esr2540223','Esr2350331'};%'Esr2370228',
basebar.datelist.recovery = {'Esr240511','Esr2400228','Esr2370108','Esr2540228','Esr2350409'};%缺一个37号0411
%以动物为单位还是以细胞为单位
basebar.minunit = 'animal';%'animal','neuron'
basebar.isnormalize = true;
base_bar_core(basebar)


%% 0425 female virgin 2
basebar.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';
basebar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0419';
%性别
basebar.gender = 'female';
%状态
basebar.clusterlist = {'virgin1','virgin2'};
%三级目录名称（用到的天数）
basebar.datelist.virgin1 = {'Esr240109','Esr2401213','Esr2371214','Esr2540216','Esr2350215'};%
basebar.datelist.virgin2 = {'Esr240112','Esr2401214','Esr2371227','Esr2540218','Esr2350218'};%
%以动物为单位还是以细胞为单位
basebar.minunit = 'animal';%'animal','neuron'
basebar.isnormalize = true;
base_bar_core(basebar)


%% 0425 female satiated 4
basebar.result_folder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0';
basebar.savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0419';
%性别
basebar.gender = 'female';
%状态
basebar.clusterlist = {'virgin','psudo','pregant1','lactate'};%'pregant2',
%三级目录名称（用到的天数）
basebar.datelist.virgin = {'Esr240109','Esr2370215','Esr2401213','Esr2371214','Esr2540216','Esr2350215'};%
basebar.datelist.psudo = {'','','','Esr2371231','Esr2540223','Esr2350331'};
basebar.datelist.pregant1 = {'Esr240125','Esr2401220','Esr2370222','','',''};
% basebar.datelist.pregant2 = {'Esr240208','Esr2401230','Esr2370228','','',''};
basebar.datelist.lactate = {'Esr240215','Esr2400110','Esr2370316','','',''};
%以动物为单位还是以细胞为单位
basebar.minunit = 'animal';%'animal','neuron'
basebar.isnormalize = true;
base_bar_core(basebar)
