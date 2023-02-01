# sexual-satiety
 
# Introduction

These code are used to analyze data and generate figures (or intermediate data) for "Hyperexcitable limbic neurons represent sexual satiety and reduce mating motivation"(manuscript number: abl4038).

# Installation

You could use this code by cloning the repository in Matlab. Alternatively, you can download and save and maintain the code locally on your computer.

It requires a computer with a minimum of 32 GB RAM and should have at least 4 - 6 cores for ease of processing. It has been tested with Matlab 2019a with default packages.

# Usage

## 1.behavior_plot

This part of the code is used to analyze the behavioral differences between experiment groups (2 or more). Therefore, videos should be firstly manually labeled to non-overlapping behavior datasets by BORIS (Our available version is v7.9.8). The code visualizes the behaviors, generates a bar plot of statistics, and calculates transitions between behaviors. 

## 2.auc_calc

This part of the code focuses on the relationship between behavior datasets and calcium imaging signals. We introduce auROC to determine whether the neuronal activities during such behavior are activating or inhibiting.

We combined two form of data and generated intermediate data as follow:
- *_auc_0.30.mat and *_auc_0.70.mat includes auROCs, p values, and so on, while 0.30 and 0.70 are the auROC threshold of inhibition or activation.
- *_combined_trace.mat includes neuron id and raw traces.
- *_den_deconv.mat includes denoised and deconvolved traces and detected events.
- *_neuron.mat includes gender, the frame rate of videos, and behavior data.

All the code in *3.beh_ca2+_analysis* must need outputs above to do futher analysis.

## 3.beh_ca2+_analysis

This part of the code focuses on the common or different neuronal activities among behaviors, animals, and genotypes by providing visualized heatmaps and traces, statistics bar/box plots, and so on. In addition, a little tool is provided to compare the spatial distribution of different subpopulations of neurons in the same microscopic field of vision.



