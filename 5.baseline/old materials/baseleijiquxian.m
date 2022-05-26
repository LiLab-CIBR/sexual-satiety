function [aucs,y2] = baseleijiquxian(filefolder,stateslist)


% filefolder = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3data\1_forheatbase\virgin\Esr2290616';
[filefolder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderandcellchoose(filefolder);%%%
Fs = neuron.Fs;tlen = neuron.nframe/Fs;
baselist = plotstrspl(neuron);
tDur1 = 180;
flag2 =  revertTTL2bin(baselist(1), tDur1, Fs, tlen);
baseline = dec_data(:,flag2);
dists = mean(baseline,2);
cutnum = [0:0.5:9.5;0.5:0.5:10];
% cutnum = [0:0.5:9.5;[0.5:0.5:9.5,100]];
hfigs = figure('color', 'w','Position',[650,300,500,400]);
subplot(1,2,1);
hold on;
ndata = randi(size(baseline, 1),[1,15]);
for ineu = 1:length(ndata)
    d = baseline(ndata(ineu),:) - (ineu-1)*5*10.5;
    h = plot(d, 'k','linewidth',1);
end
set(gca, 'ytick',(-length(ndata)+1:0)*5*10.5,'YTickLabel', 1:length(ndata), ...
     'tickdir', 'out');
axis([ 0 Fs*tDur1 -787.5 100])
for i = 1:size(cutnum,2)
    y(i) = sum(dists>=cutnum(1,i)&dists<cutnum(2,i))/size(dists,1);
    y2(i) = sum(y(1:i));
end
% hfigs = figure('color', 'w','Position',[900,300,250,400]);hold on;
subplot(1,2,2);
hold on;
histogram(dists, 0:0.5:10, 'Normalization','probability')
plot(0:0.5:10,[0,y2]);
aucs = trapz(0:0.5:10,[0,y2])/10;
hfigs.Renderer = 'Painters';
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig3pic\0307basetrace\',stateslist,'\',neuron.name,'_base.pdf']);

end