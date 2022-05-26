savedir = 'E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig1pic\0421DZY\0506venn';
% numlist = {[50,5,24],[93,27,52,10,158,2,0],[72,25,45],[91,52,196,60,117,1,0]};
% numlist = {[143,32,76,10,158,2,0],[163,77,241,60,117,1,0]};before0514
% numlistregin1 = {[45,5,19],[74,65,11],[44,22,20]};
% numlistregin1 = {[66,27,15,10,148,0,0],[115,45,18,19,121,0,0],[63,25,15,9,69,0,0]};
% numlistregin1 = {[17,3,6,4,18,0,0],[40,4,5,3,37,0,0],[21,6,10,1,22,0,0]};
% numlistregin1 = {[163,92,50],[322,110,69,46,415,0,0],[53,19,13],[79,27,20,31,123,0,0]};
% numlistregin1 = {[87,22,40,24,104,0,0]};

numlistregin1 = {[50,29,27],[57,60,48,72,89,0,0]};

clusterlist = {'last_aromatas_p','last_aromatas_a'};
for i = 1:length(numlistregin1)
hfig=figure('color', 'w');
set(hfig, 'position', [100 ,100, 450, 480]);
hold on;axis equal;
vennX( numlistregin1{i} , 0.02);
hfig.Renderer = 'Painters';
hfig.PaperSize = [50,50];
saveas(gcf,[savedir,'\venn_',clusterlist{i},'.pdf']);

end

% numlist2 = {[50,24,5],[93,52,158,27,2,10,0],[72,45,25],[91,196,117,52,1,60,0]};
% numlist2 = {[143,76,158,32,2,10,0],[163,241,117,77,1,60,0]};
% numlist2regen1 = {[45,19,5],[74,11,65],[44,20,22]};%0514
% numlist2regen1 = {[66,15,148,27,0,10,0],[115,18,121,45,0,19,0],[63,15,69,25,0,9,0]};%0514
% numlist2regen1 = {[17,7,18,3,0,4,0],[40,5,37,4,0,3,0],[21,10,22,6,0,1,0]};%0514
% numlist2regen1 = {[163,50,92],[322,79,415,110,0,46,0],[53,13,19],[79,20,123,27,0,31,0]};%0514
% numlist2regen1 = {[87,40,104,22,0,24,0]};
numlist2regen1  = {[50,27,29],[57,48,89,60,0,72,0]};

for i = 1:length(numlist2regen1)
hfig=figure('color', 'w');
set(hfig, 'position', [100 ,100, 450, 480]);
ax = axes('Parent',hfig);
ax.YAxis.Visible = 'off';  
ax.XAxis.Visible = 'off';  
hold on;axis equal;
venn( numlist2regen1{i});
hfig.Renderer = 'Painters';
hfig.PaperSize = [35,50];
saveas(gcf,[savedir,'\venn2_',clusterlist{i},'.pdf']);

end
