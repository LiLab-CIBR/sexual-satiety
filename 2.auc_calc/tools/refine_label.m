function neuron = refine_label(neuron, action_label, form_label, color, events, match_num)
% This code is used to match the definitive action_label and the label in
% the annotation table.
u = zeros(1,length(action_label));
for i = 1:length(form_label)
    contain = strncmp(action_label,form_label{i},match_num);
    u = u+contain;
end
u = logical(u);
neuron.action_label = action_label(u);
neuron.color = color(u);
for i = 1:length(form_label)
    contain = strncmp(neuron.action_label,form_label{i},match_num);
    idx = find(contain,1);
    if isempty(idx)
        continue
    end
    neuron.events{idx} = events{i};
end
end