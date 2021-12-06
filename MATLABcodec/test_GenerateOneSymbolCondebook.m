clear;close all;clc;

load("originalImage.mat"); % srcImage

% [symbols, probs] = h_ProbStatistic(srcImage);

escape_prob_threshold = 0.9;

h_GenerateOneSymbolCodebook(srcImage, escape_prob_threshold);
