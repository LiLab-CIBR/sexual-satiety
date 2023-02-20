function [neuron, trace] = csv_read(fname,varargin)
% 用于读取由inscopix识别神经元活动产生的csv文件
% Only the neuron that annotated as 'accepted' would be counted in the
% trace.
% neuron; a list of id that annotated as 'accepted'
% trace = [N+1, I], where N = num(neuron), I is the intensity of the
% neuronal activity. First row is the recording time.
% NOTICE that the first row of var 'trace' is time-axis, the latters are the
% traces.
if nargin < 2
    mode = 'accept'; %default: accept neurons only annotated as 'accepted'
else
    mode = varargin{1}; % if 'reject': accept all except "rejected"
end

T = readtable(fname);
vname = char(T.Properties.VariableNames);
trace = str2num(char(T.(vname(1,:))(2:length(T.(vname(1,:))))))';  % time, x axis
neuron = [0];
switch mode
    case 'accept'
        for i=2:size(T.Properties.VariableNames,2)
            if strcmp(char(T.(strtrim(vname(i,:)))(1)),'accepted')
                trace = [trace;str2num(char(T.(strtrim(vname(i,:)))(2:length(T.(strtrim(vname(i,:)))))))'];
                % store the id of the neurons
                neuron = [neuron,str2num(strtrim(vname(i,2:size(vname(i,:),2))))];
            end
        end
    case 'reject'
        for i=2:size(T.Properties.VariableNames,2)
            if ~strcmp(char(T.(strtrim(vname(i,:)))(1)),'rejected')
                trace = [trace;str2num(char(T.(strtrim(vname(i,:)))(2:length(T.(strtrim(vname(i,:)))))))'];
                % store the id of the neurons
                neuron = [neuron,str2num(strtrim(vname(i,2:size(vname(i,:),2))))];
            end
        end
end
num_neuron = size(neuron, 2);
neuron = neuron(2:num_neuron);