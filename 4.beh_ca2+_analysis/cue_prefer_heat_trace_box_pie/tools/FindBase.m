function usedlist = FindBase(neuron)

usedlist = [];
if neuron.intruder(1,1) > 210
    usedlist = [usedlist,30];
    
end
for i = 1:size(neuron.intruder,1)-1
    if neuron.intruder(i+1,1) -  neuron.intruder(i,2) > 185
        usedlist = [usedlist,neuron.intruder(i,2)+3];
    end
end
if neuron.nframe/neuron.Fs -  neuron.intruder(end,2) > 185
    usedlist = [usedlist,neuron.intruder(end,2)+3];
end

end
