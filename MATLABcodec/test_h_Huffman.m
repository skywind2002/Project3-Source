clear;close all;clc;

% symbols = [111, 222, 333, 444, 555];
% probabilities = [0.1, 0.2, 0.35, 0.2, 0.15];

symbols = [1, 2, 3, 4, 5, 6, 7, 8];
probabilities = [0.30, 0.23, 0.15, 0.08, 0.06, 0.06, 0.06, 0.06];

[huffmanSymbols, huffmanCodes] = h_Huffman(symbols, probabilities);
disp(huffmanSymbols)
disp(huffmanCodes)
