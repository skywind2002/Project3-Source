clear;close all;clc;

load("originalImage.mat"); % srcImage

escape_prob_threshold = 0.9;

% h_GenerateCodebook(srcImage, escape_prob_threshold, 1);
h_GenerateCodebook(srcImage, escape_prob_threshold, 2);
