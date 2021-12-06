clear;clc;close all;
load("originalImage.mat"); % srcImage
[symbols, probs] = h_ProbStatistic(srcImage, 2);
% disp(probs)
