% 按照需求生成灰度图像的码本（带逃逸码）
% [input]
% srcImage 灰度图像 unit8
% escape_prob_threshold 总和低于这个的符号会被搞成逃逸码
% [output]
% generate table.txt in the current folder

function h_GenerateOneSymbolCodebook(srcImage, escape_prob_threshold)
    [symbols, probs] = h_ProbStatistic(srcImage);
    % probs
    [~, I] = sort(probs, 'ascend');
    sortedSymbols = symbols(I);
    sortedProbs = probs(I);

    probsum = 0;
    thresholdPosition = 0;

    for k = 1:length(sortedSymbols)
        probsum = probsum + sortedProbs(k);

        if probsum > escape_prob_threshold
            thresholdPosition = k;
            break
        end

    end

    newSymbols = sortedSymbols(thresholdPosition:length(sortedSymbols));
    newSymbols = [newSymbols, -1]; % add escape
    newProbs = sortedProbs(thresholdPosition:length(sortedSymbols));
    newProbs = [newProbs, sum(sortedProbs(1:(thresholdPosition - 1)))]; % add escape
    [huffmanSymbols, huffmanCodes] = h_Huffman(newSymbols, newProbs);
    fprintf("huffmanSymbols.len = %d\n", length(huffmanSymbols));

    code_tabel_file = fopen('table.txt', 'w');

    for i = 1:(length(huffmanSymbols) - 1)
        fprintf(code_tabel_file, "%d %s\n", huffmanSymbols(i), huffmanCodes(i));
    end

    fprintf(code_tabel_file, "%s", huffmanCodes(length(huffmanSymbols)));

    fclose(code_tabel_file);
end
