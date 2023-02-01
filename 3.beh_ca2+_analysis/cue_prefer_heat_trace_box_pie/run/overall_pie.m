%%
%fig.S8 B

%% 


Esr2male = [7,59,34;13,35,52;12,53,35;17,52,30;9,57,35];
St18male = [18,55,27;13,50,38];
Esr2female = [36,45,18;50,36,14;31,46,23;32,32,37;31,31,38];
St18female = [12,10,78;17,8,75;9,5,86];
overallname = {'Esr2male','St18male','Esr2female','St18female'};
overallnum = [138,27,84,83];
overall = {Esr2male,St18male,Esr2female,St18female};
overallmean = {mean(Esr2male,1),mean(St18male,1),mean(Esr2female,1),mean(St18female,1)};
newColors = [ 200/256, 139/256, 116/256;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
              222/256,223/256,224/256;  
              127/256,161/256,180/256];  
sum(sum(St18male))

hfig=figure('color', 'w');
set(hfig, 'position', [200,200, 250*length(overallmean) 300]);

for f = 1:length(overallmean)
    subplot(1,length(overallmean),f);
    ax = gca(); 
    nums = [overallmean{f}(2),overallmean{f}(3),overallmean{f}(1)];
    prefer.num = nums;
    indNonZero = nums~=0;
    assert(any(indNonZero));
    nums = nums(indNonZero);
    H = pie(nums);
    ax.Colormap = newColors(indNonZero,:);
    T = H(strcmpi(get(H,'Type'),'text'));
    if length(T)==1
        P = get(T,'Position');
    else
        P = cell2mat(get(T,'Position'));
    end
    set(T,{'Position'},num2cell(P*0.25,2), 'Fontsize', 20)
    set(findobj(gca, 'type', 'patch'), 'EdgeAlpha', 1);
    set(gca,'Fontsize',20)

    t2 = text(-0.3,-1.3,['N=',num2str(size(overall{f},1))]);
    t2.FontSize = 20;
    t3 = text(-0.3,-1.7,['n=',num2str(overallnum(f))]);
    t3.FontSize = 20;
    title(overallname{f})
end
hfig.Renderer = 'Painters';
hfig.PaperSize = [30,20];
% saveas(gcf,['E:\wupeixuan\auc_plot\data\dzyimg\miniscope data plot\Figure1-3\fig2update\0509\pie_for_prefer.pdf']);
