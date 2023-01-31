
function auc_result_new = auc_postejacu(filefolderlist,timecut,saveornot)

for matings = 1:length(filefolderlist)
%% 读文件    
filefolder = filefolderlist{matings}; 
[result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
%% 参数
ejacuidx = find(contains(neuron.action_label,'ejacu'));
rtrace = trace(2:end,:);
calctime = 60*timecut;
%% 行为数量
numaction = length(neuron.action_label);
%% 增加行为，用于计算auc
if ~isempty(ejacuidx)
    posttime = neuron.light(find(neuron.light(:,2)>neuron.events{ejacuidx}(1,1),1),2) - neuron.events{ejacuidx}(1,1);
    postmin = floor((posttime-60)/calctime);
    for pp = 1:postmin
        neuron.action_label{numaction+pp} = ['postejact',num2str(pp)];
        neuron.color{numaction+pp} = [0.7,0.7,0.7];
        neuron.events{numaction+pp} = [neuron.events{ejacuidx}(1,1)+(pp-1)*calctime+61,neuron.events{ejacuidx}(1,1)+pp*calctime+60];
    end
    neuron.action_label{numaction+postmin+1} = 'newbase';
    neuron.color{numaction+postmin+1} = [0.2,0.2,0.2];
    neuron.events{numaction+postmin+1} = [neuron.events{ejacuidx}(1,1)+1,neuron.events{ejacuidx}(1,1)+2];
%% 计算auc
    auc_result_new{matings} = auc_cue_noout(rtrace,sig_data,neuron,0.7,'light_on');
    if saveornot
        saveauc = auc_result_new{matings};
        save([filefolder,'\auc_result_new_',num2str(timecut),'min.mat'],'saveauc');
    end
else
    disp([neuron.name,' data no ejaculation!'])
end 

end