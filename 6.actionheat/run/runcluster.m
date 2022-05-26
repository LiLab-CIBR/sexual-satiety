clear;clc;close all

clusters.gender = 'female';
clusters.filefolder = 'E:\wupeixuan\auc_plot\data\aucs_ver3.0\Esr235\Esr2350330';
clusters.aninum = 'Esr235';
clusters.pdists = 'cosine';%euclidean   cosine
clusters.linkages = 'average';%average   ward
clusters.datasort = 'zscore';%zscore  raw
clusters.clusternum2 = 24;
clusters.colorrange = 35;
clusters.timemove = 0;

cluster_core(clusters);


% -9 13