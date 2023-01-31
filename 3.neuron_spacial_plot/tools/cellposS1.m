function cellchoose = cellposS1(data_dir,cellcluster,dateidx)

    [filefolder,~, ~, ~, neuron, auc_result_7, ~] = loadfolderToPlot(data_dir);
    intruderl = neuron.intruder_label;
    actionidx{4} = find(contains(neuron.action_label,'ejacu'));
    [cuelist,cuelist2] = searchcuebeforemating(intruderl,actionidx{4},neuron);
    if neuron.gender == 0
       cuelist = cuelist2;
    end

    switch length(cellcluster)
        case 3 % for pers trans other
            aucstemp = aucCalcCut(filefolder);

            Epick = auc_result_7.h_signifi(:,actionidx{4},cuelist(end));
            perspick = Epick & aucstemp.h_signifi{1}(:,4);
            transpick = Epick & ~aucstemp.h_signifi{1}(:,4);

            cellchoose{1} = neuron.neuron_id(perspick);
            cellchoose{2} = neuron.neuron_id(transpick);
        case 4 %for sniff ejacu/mi both other
            actionidx{1} = find(contains(neuron.action_label,'positive'));
            actionidx{2} = find(contains(neuron.action_label,'mounting'));
            actionidx{3} = find(contains(neuron.action_label,'intro'));

            if contains(dateidx,'Esr2')
                used2cells = auc_result_7.h_signifi(:,actionidx{4},cuelist(end));%用第一个异性cue的sniff和交配cue的ejaculate
            else
                used2cells = auc_result_7.h_signifi(:,actionidx{3},cuelist(end))|auc_result_7.h_signifi(:,actionidx{2},cuelist(end));
            end
            sniffcells = auc_result_7.h_signifi(:,actionidx{1},cuelist(1));
            bothcells = used2cells&sniffcells;%取交集，余集
            used2cells = used2cells&~bothcells;
            sniffcells = sniffcells&~bothcells;

            cellchoose{2} = neuron.neuron_id(used2cells);%储存在这里
            cellchoose{1} = neuron.neuron_id(sniffcells);
            cellchoose{3} = neuron.neuron_id(bothcells);
    end
end