function [filefolder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderandcellchoose(sa)

    [filefolder,trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(sa);
%     cellchooselist = {'St1823'};
    trace = trace(2:end,:);    
%     if sum(contains(neuron.name,cellchooselist))
%         [auc_result_3,auc_result_7,neuron,trace,dec_data] = st18celllist(sa,neuron.name);
%     end
    
end
