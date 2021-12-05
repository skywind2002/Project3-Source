clear;close all;clc;

load("originalImage.mat"); % srcImage
escape_prob_threshold = 0.9;

h_GenerateOneSymbolCodebook(srcImage, escape_prob_threshold);
