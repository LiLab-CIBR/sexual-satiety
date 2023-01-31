function [result_folder, trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(result_folder)
    if ~exist('result_folder', 'var') %exist name 检查变量、脚本、函数、文件夹或类是否存在于工作区中，以数字形式返回 name 的类型。0 - name 不存在或因其他原因找不到。1 - name 是工作区中的变量。
        result_folder = uigetdir();%打开文件夹选择对话框，如果指定的文件夹存在，则当用户点击确定时，MATLAB将返回所选路径。如果用户点击取消或标题栏上的关闭按钮，MATLAB 将返回 0
        if isequal(result_folder, 0); return; end %如果 A 和 B 等效，则 tf = isequal(A,B) 返回逻辑值 1 (true)；否则，返回逻辑值 0 (false)。
    end

    %% Get the current list of data
    filelist = dir(result_folder);
    %listing = dir(name)  dir name 列出与 name 匹配的文件和文件夹。如果 name 为文件夹，dir 列出该文件夹的内容。使用绝对或相对路径名称指定 name文件夹的内容
    filelist = {filelist.name};%当做一个cell存储
    %filelist是一个结构体,.name中含有14个文件名，包含' .’'. .'
  
    
    %% check the file
    % --- MUST INCLUDE ---
    % {filename}__den_deconv.mat
    % {filename}_neuron.mat
    % {filename}_auc_0.75.mat
    % {filename}_auc_0.30.mat
    
    ind_file = contains(filelist, 'trace.mat');
    %如果 filelist 包含指定的模式(trace.mat)，将返回 1 (true)，否则返回 0 (false)。
    %如果 trace.mat 是一个包含多个模式的数组，则当 contains 在 filelist 中发现任何 trace.mat 元素时，它将返回 1
    assert(sum(ind_file) == 1, 'No or more auc_0.30.mat file!');
    %如果 cond 为 false，assert(cond,msg) 会引发错误并显示错误消息 msg。
    file = fullfile(result_folder, filelist{ind_file});
    % fullfile根据指定的文件夹和文件名构建完整的文件路径
    load(file, 'trace');
   
    
    ind_file = contains(filelist, '_den_deconv.mat');
    assert(sum(ind_file) == 1, 'No or more den_deconv.mat file!'); %exist one and only one '_den_deconv.mat'
    file = fullfile(result_folder, filelist{ind_file});
    load(file, 'dec_data', 'sig_data');

    ind_file = contains(filelist, '_neuron.mat');
    assert(sum(ind_file) == 1, 'No or more neuron.mat file!');
    file = fullfile(result_folder, filelist{ind_file});
    load(file, 'neuron');
    neuron = NeuronSource(neuron);

    ind_file = contains(filelist, 'auc_0.70.mat');
    assert(sum(ind_file) == 1, 'No or more auc_0.70.mat file!');
    file = fullfile(result_folder, filelist{ind_file});
    load(file, 'auc_result');
    auc_result_7 = auc_result;

    ind_file = contains(filelist, 'auc_0.30.mat');
    assert(sum(ind_file) == 1, 'No or more auc_0.30.mat file!');
    file = fullfile(result_folder, filelist{ind_file});
    load(file, 'auc_result');
    auc_result_3 = auc_result;
    
   
end