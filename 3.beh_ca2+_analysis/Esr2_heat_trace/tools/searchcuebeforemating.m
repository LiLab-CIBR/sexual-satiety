function [cuelist,cuelist2] = searchcuebeforemating(intruderlist,ejaculationidx,neuron)


        cuelist = [];cuelist2 = [];
for k = 1:length(intruderlist)
    if contains(lower(intruderlist{k}),'bedding')||contains(lower(intruderlist{k}),'toy')||...
        contains(lower(intruderlist{k}),'pup')||contains(lower(intruderlist{k}),'obj')%||contains(lower(intruderlist{k}),'n')
    elseif contains(lower(intruderlist{k}),'f')
        cuelist = [cuelist,k];
    elseif ~contains(lower(intruderlist{k}),'cas')
        cuelist2 = [cuelist2,k];
    end
end
if ~isempty(ejaculationidx)
    for k = cuelist
        if ~isempty(neuron.intruder_action{k,ejaculationidx})
            cuelist = cuelist(cuelist<=k);
            break
        end
    end
end
 if ~isempty(ejaculationidx)
    for k = cuelist2
        if ~isempty(neuron.intruder_action{k,ejaculationidx})
           cuelist2 = cuelist2(cuelist2<=k);
            break
        end
    end
end
% some odd case
if contains(neuron.name,'Esr2290623')||contains(neuron.name,'Esr2220625')
    cuelist = cuelist([1,3]);
end
if contains(neuron.name,'Esr2220626')
    cuelist = cuelist([1,2,3,4,6]);
end










end