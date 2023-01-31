function save2xls(filefolderlist,timecut,xlssavedir)
    for matings = 1:length(filefolderlist)
        filefolder = filefolderlist{matings}; 
        [result_folder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(filefolder);
        load([filefolder,'\auc_result_new_',num2str(timecut),'min.mat'],'saveauc');

        ncells = size(dec_data,1);
        ejacuidx = find(contains(neuron.action_label,'ejacu'));
        intruderl = neuron.intruder_label;
        cuelist = searchcuebeforemating(intruderl,ejacuidx,neuron);
        oldactionlength = length(neuron.action_label);
        newactionlength = length(saveauc.aucs(1,:,1));
        aucs = saveauc.aucs(:,oldactionlength+1:newactionlength,cuelist(end));
        hsig = saveauc.h_signifi(:,ejacuidx,cuelist(end));
        xlabellist = {};
        for pp = 1:newactionlength-oldactionlength-1
            xlabellist = [xlabellist,[num2str((pp-1)*timecut+1),'-',num2str(pp*timecut+1),'min']];
        end

        title = {'neuron_id','is_ejacucells',xlabellist,'baseline'};

        xlswrite([xlssavedir,'\',neuron.name(1:end-4),'aucs_',num2str(timecut),'mincut.xlsx'],[1:1:ncells]',neuron.name,'A2')
        xlswrite([xlssavedir,'\',neuron.name(1:end-4),'aucs_',num2str(timecut),'mincut.xlsx'],title,neuron.name,'A1')
        xlswrite([xlssavedir,'\',neuron.name(1:end-4),'aucs_',num2str(timecut),'mincut.xlsx'],aucs,neuron.name,'C2')
        xlswrite([xlssavedir,'\',neuron.name(1:end-4),'aucs_',num2str(timecut),'mincut.xlsx'],hsig,neuron.name,'B2')

        % xlswrite([xlssavedir,'\',neuron.name(1:end-4),'aucs.xlsx'],hsig,neuron.name,'B2')
        % xlswrite([xlssavedir,'\',neuron.name(1:end-4),'pvals.xlsx'],pvals,neuron.name,'C2')
        % xlswrite([xlssavedir,'\',neuron.name(1:end-4),'pvals.xlsx'],title,neuron.name,'A1')
        % xlswrite([xlssavedir,'\',neuron.name(1:end-4),'pvals.xlsx'],[1:1:ncells]',neuron.name,'A2')

    end

end

