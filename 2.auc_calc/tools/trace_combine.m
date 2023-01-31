function [neuron_id, trace, trace_dir] = trace_combine(folder, list,varargin)
if nargin < 3
    mode = 'accept'; % 'accept'(default): accept neurons only annotated as 'accepted'
else
    mode = varargin{1}; % if 'reject':accept all except "rejected"
end
for i=1:length(list)
    assert(contains(list{i},'_raw.csv'))
end
fn = fullfile(folder,list{1});
[~, file_nm, ~] = fileparts(fn);
rname_ind = strfind(file_nm,'_');
fname = file_nm(1:rname_ind(1)-1);
cell_diameter = str2num(file_nm(rname_ind(1)+1));
if length(list) == 1
    [neuron_id, trace] = csv_read(list{1}, mode);
    trace_dir = sprintf('%s%s%s_combined_trace.mat', folder, filesep, fname);
    save(trace_dir,'neuron_id','trace');
else
    prime_trace = list{1};
    second_trace = list(2:end);
    [neuron_id, trace] = csv_read(prime_trace, mode);
    num_neuron = size(trace,1);
    new_ids = [];
    for i = 1:length(second_trace)
        tr_dir = char(second_trace(i));
        [id2,trace2] = csv_read(tr_dir, mode);
        [~, fnam, ~] = fileparts(tr_dir);
        for id = 1:length(id2)
            new_id = num_neuron+i*100+id;
            neuron_id = [neuron_id,new_id];
            trace = [trace;trace2(id+1,:)];
            sprintf('%s:the %d th neuron has been combined into the prime trace. New id:%d',fnam,id2(id),new_id)
            new_ids = [new_ids;cell_diameter,id2(id),new_id];
        end
        num_neuron = size(trace,1);
    end
    trace_dir = sprintf('%s%s%s_combined_trace.mat', folder, filesep, fname);
    save(trace_dir,'neuron_id','trace');
    note_path = sprintf('%s%s%s%s',folder, filesep,fname,'combination_note.txt');
    fp=fopen(note_path,'a');
    for i = 1:size(new_ids,1)
        note = sprintf('neuron %d in %d has been combined as %d\n',new_ids(i,2),new_ids(i,1),new_ids(i,3));
        fprintf(fp,note);
    end
    fclose(fp);
end