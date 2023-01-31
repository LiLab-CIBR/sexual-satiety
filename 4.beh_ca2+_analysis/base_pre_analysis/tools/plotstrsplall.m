function outputlist = plotstrsplall(neuron)

ejacuidx = find(contains(neuron.action_label,'ejacu'));
ejacucue = [];
if ~isempty(ejacuidx)
    for i = 1:length(neuron.intruder_label)
        if ~isempty(neuron.intruder_action{i,ejacuidx})
            ejacucue = [ejacucue,i];
        end
    end
end
usedlist = [];endlist = [];ejacucorr = [];
%% ��һ��base�Ŀ�ʼ�ͽ���
if neuron.intruder(1,1) > neuron.light(1,2)
    usedlist = [usedlist,neuron.light(1,1)+5];
    endlist = [endlist,neuron.light(1,2)-5];
    ejacucorr = [ejacucorr,0];
end

currentlighton = neuron.light(find(neuron.light(:,1)<neuron.intruder(1,1),1,'last'),1);
usedlist = [usedlist,currentlighton + 5];
endlist = [endlist,neuron.intruder(1,1)-5];
if ismember(1,ejacucue)
    ejacucorr = [ejacucorr,1,2];
    ejacuend = neuron.intruder_action{1,ejacuidx}+60;
    ejaculightoff = neuron.light(find(neuron.light(:,2)>ejacuend,1),2)-5;
    usedlist = [usedlist,ejacuend];
    endlist = [endlist,ejaculightoff];
else
    ejacucorr = [ejacucorr,0];
end

%% �м�base�Ŀ�ʼ�ͽ�����ֻȡlight-intruder��
for i = 2:size(neuron.intruder,1)
    currentlighton = neuron.light(find(neuron.light(:,1)<neuron.intruder(i,1),1,'last'),1);
    if neuron.intruder(i,1) - currentlighton > 10 &&  neuron.intruder(i-1,1) < currentlighton
        usedlist = [usedlist,currentlighton + 5];
        endlist = [endlist,neuron.intruder(i,1)-5];
        if ismember(i,ejacucue)
            ejacucorr = [ejacucorr,1];
        elseif ~isempty(ejacucue)
            if i < ejacucue(1)
                ejacucorr = [ejacucorr,0];
            elseif i > ejacucue(end)
                ejacucorr = [ejacucorr,3];
            else
                ejacucorr = [ejacucorr,0];
            end
        else
            ejacucorr = [ejacucorr,0];
        end
    end
    if ismember(i,ejacucue)
        ejacucorr = [ejacucorr,2];
        ejacuend = neuron.intruder_action2{i,ejacuidx};
        ejaculightoff = neuron.light(find(neuron.light(:,2)>ejacuend,1),2);
        usedlist = [usedlist,ejacuend];
        endlist = [endlist,ejaculightoff];
    end
end
%% ���һ��base�Ŀ�ʼ�ͽ���(���ܲ�����)
if neuron.intruder(end,2) < neuron.light(end,1)
    usedlist = [usedlist,neuron.light(end,1)+5];
    endlist = [endlist,neuron.light(end,2)-5];
    ejacucorr = [ejacucorr,3];
end


%% output
outputlist = [usedlist;endlist;ejacucorr];
end
