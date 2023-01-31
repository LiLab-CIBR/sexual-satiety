function [neuron_id, data] = trace_read(trace_dir)
load(trace_dir);
num_neuron = size(neuron_id,2);
data = trace(2:num_neuron+1,:);
end