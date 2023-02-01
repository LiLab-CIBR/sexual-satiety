
%%
% fig.S5 DG

%%

clear;
% close all;


%% µ¥¸öÅÜ
fvstrans.result_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\5';%Â·¾¶
fvstrans.animallist = {'St181','St1823'};%{'Esr222','Esr229','Esr230','Esr252'} {'St181','St1823'}
fvstrans.transitioncalctime = 10;%5,10 
fvstrans.durtime = 30;%30,60,90,120
fvstrans.is_merge_sniff = false;%true.false
fvstrans.is_premount = false;%true,false
fvstrans.is_firstsniff = true;%true,false
fvstrans.is_del_1_trans = true;%true,false
fvstrans.datasort = 'raw';%{'raw','zscore','sigma','decdata'};

FvsTrans_core(fvstrans)

%% È«¶¼ÅÜ
animallist = {{'Esr222','Esr229','Esr230'},{'St181','St1823'}};
transitioncalctime = {10};
durtime = {30,60,90,120};
datasort = {'raw'};
fvstrans.result_folder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2data\5';%Â·¾¶
fvstrans.is_merge_sniff = true;
fvstrans.is_del_1_trans = true;

for i =1:length(animallist)
    for j = 1:length(transitioncalctime)
        for p = 1:length(durtime)
            for k =1:length(datasort)
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




