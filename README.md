# sexual-satiety
 
# Introduction

These code are used to analysis data and generate figure(or intermediate data) for "Hyperexcitable limbic neurons represent sexual satiety and reduce mating motivation"(manuscript number: abl4038). 

# Installation

You could use this code by cloning the repository in Matlab. Alternatively you can also download the code and save and maintain it locally on your computer.

It requires a computer with a minimum of 32 GB RAM and for ease of processing should have at least 4 - 6 cores. It has been tested with Matlab 2019a with default packages.

# Usage

## 1.behavior_plot

This part of code focuses on the behavioural differences between experiment groups(2 or more). Therefore, videos should be firstly manually labeled to non-overlapping behavior datasets by BORIS. Our available version is v7.9.8.The code visualizes the behaviors, generates bar plot of statistics wo care about, and transitions between behaviors. 

## 2.auc_calc

This part of code focuses on the relationship between behavior datasets and calcium imaging signals. We introduce auROC to determine whether the neuronal activities during such behavior are activating or inhibiting.

We combined two form of data and generated *_auc_0.3.m 








