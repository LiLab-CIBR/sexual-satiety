function [result_folder, trace, dec_data, sig_data, neuron, auc_result_7, auc_result_3] = loadfolderToPlot(result_folder)
    if ~exist('result_folder', 'var') %exist name ���������ű����������ļ��л����Ƿ�����ڹ������У���������ʽ���� name �����͡�0 - name �����ڻ�������ԭ���Ҳ�����1 - name �ǹ������еı�����
        result_folder = uigetdir();%���ļ���ѡ��Ի������ָ�����ļ��д��ڣ����û����ȷ��ʱ��MATLAB��������ѡ·��������û����ȡ����������ϵĹرհ�ť��MATLAB ������ 0
        if isequal(result_folder, 0); return; end %��� A �� B ��Ч���� tf = isequal(A,B) �����߼�ֵ 1 (true)�����򣬷����߼�ֵ 0 (false)��
    end

    %% Get the current list of data
    filelist = dir(result_folder);
    %listing = dir(name)  dir name �г��� name ƥ����ļ����ļ��С���� name Ϊ�ļ��У�dir �г����ļ��е����ݡ�ʹ�þ��Ի����·������ָ�� name�ļ��е�����
    filelist = {filelist.name};%����һ��cell�洢
    %filelist��һ���ṹ��,.name�к���14���ļ���������' .��'. .'
  
    
    %% check the file
    % --- MUST INCLUDE ---
    % {filename}__den_deconv.mat
    % {filename}_neuron.mat
    % {filename}_auc_0.75.mat
    % {filename}_auc_0.30.mat
    
    ind_file = contains(filelist, 'trace.mat');
    %��� filelist ����ָ����ģʽ(trace.mat)�������� 1 (true)�����򷵻� 0 (false)��
    %��� trace.mat ��һ���������ģʽ�����飬�� contains �� filelist �з����κ� trace.mat Ԫ��ʱ���������� 1
    assert(sum(ind_file) == 1, 'No or more auc_0.30.mat file!');
    %��� cond Ϊ false��assert(cond,msg) ������������ʾ������Ϣ msg��
    file = fullfile(result_folder, filelist{ind_file});
    % fullfile����ָ�����ļ��к��ļ��������������ļ�·��
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