function [dec_data, sig_data, varianc] = denoise_deconv(data,neuron,filefolder,filelist,save_or_not)
%
%
%
% ---- OUTPUT FILE ----
% {filename}_den_deconv.mat

addpath('E:\wupeixuan\CalImgProcess\CaImAn-MATLAB\');
num_neuron = neuron.num_neuron;
nframe = neuron.nframe;
Fs = neuron.Fs;

% Check the calculated file
for i =1:length(filelist)
if contains(filelist{i},'_den_deconv.mat')
    load([filefolder,filesep,filelist{i}]);
    return
end
end

% a.waive the largest peak and calculate the variance
tlen = nframe/Fs;
sig_waive_peak = zeros(num_neuron,nframe);
norm_data = normalize(data,2,'range');

for i=1:num_neuron
    large_idx = find(norm_data(i,:)>0.99,1);
    large_time = large_idx/Fs;
    tRise = large_time-5; tDur=10;
    if tRise<=0 tRise=1/Fs; 
    elseif tRise+tDur >= tlen tRise = large_time-10; end
    large_time = revertTTL2bin(tRise, tDur, Fs, tlen);
    revert_large = (~large_time)';
    sig_waive_peak(i,:) = data(i,:).*revert_large;
end
varianc = std(sig_waive_peak');
% b. subtracting the variance by raw data
trace_sub_var = data-varianc';
% c. Deconvolution
dec_data = zeros(num_neuron,nframe);
sig_data = zeros(num_neuron,nframe);
lambda = 1.5;
parfor i=1:num_neuron
    if mean(trace_sub_var(i,:))<15
        %     try
%         [dec_trace, signal, ~] = deconvolveCa(trace_sub_var(i,:)', 'ar1', 'constrained', 'optimize_b', 'optimize_pars','maxiter',5);
%         dec_data(i,:) = dec_trace';
%         sig_data(i,:) = signal';
%     catch
        [dec_trace, signal, ~] = deconvolveCa(trace_sub_var(i,:)', 'ar1', 'foopsi', 'lambda', lambda, 'optimize_pars');
        dec_data(i,:) = dec_trace';
        sig_data(i,:) = signal';
%     end
    else
        [dec_trace, signal, ~] = deconvolveCa(trace_sub_var(i,:)', 'ar1', 'constrained', 'optimize_b', 'optimize_pars','maxiter',5);
        dec_data(i,:) = dec_trace';
        sig_data(i,:) = signal';
    end
end
if save_or_not
    save([filefolder, filesep, neuron.name, '_den_deconv.mat'], 'dec_data', 'sig_data');
end
end