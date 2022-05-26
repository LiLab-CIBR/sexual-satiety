
clear;
% close all;


%% 单个跑
fvstrans.result_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\5';%路径
fvstrans.animallist ={'Esr222','Esr229','Esr230','Esr252'} ;%{'Esr222','Esr229','Esr230','Esr252'} {'St181','St1823'}
fvstrans.transitioncalctime = 10;%5,10 
fvstrans.durtime = 30;%30,60,90,120
fvstrans.is_merge_sniff = false;%true.false
fvstrans.is_premount = false;%true,false
fvstrans.is_firstsniff = true;%true,false
fvstrans.is_del_1_trans = true;%true,false
fvstrans.datasort = 'raw';%{'raw','zscore','sigma','decdata'};

FvsTrans_core(fvstrans)

%% 全都跑
animallist = {{'Esr222','Esr229','Esr230'},{'St181','St1823'}};
transitioncalctime = {5,10};
durtime = {30,60,90,120};
datasort = {'raw','zscore','sigma'};
fvstrans.result_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\5';%路径
fvstrans.is_merge_sniff = true;
fvstrans.is_del_1_trans = true;

for i =1:2
    for j = 1:2
        for p = 1:4
            for k =1:3
                fvstrans.animallist = animallist{i};
                fvstrans.transitioncalctime = transitioncalctime{j};
                if p == 5
                    fvstrans.is_premount = true;
                else
                    fvstrans.is_premount = false;
                    fvstrans.durtime = durtime{p};
                end
                fvstrans.datasort = datasort{k};
                FvsTrans_core(fvstrans)
            end
        end
    end
end




