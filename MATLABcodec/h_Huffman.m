%% Huffman encode
% [input]
% symbols - Array
% probability - Array
% [output]
% huffmanSymbols - Array
% huffmanCodes - Array
function [huffmanSymbols, huffmanCodes] = h_Huffman(symbols, probabilities)
    assert(length(symbols) == length(probabilities), "length not match")

    % [output]
    huffmanSymbols = symbols; % `symbols` directly return
    huffmanCodes = strings(1, length(symbols)); % init

    % [preparations]
    symbolsCell = cell(1, length(symbols)); %  equal to nodes in Huffman tree

    for k = 1:length(symbols)
        symbolsCell{k} = [symbols(k)]; % init: each element is an array and initial value is the symbol
    end

    probabilitiesArray = probabilities; % init: initial value is probabilities of symbols

    flag = length(symbols);
    % [main]
    while flag ~= 1
        flag = flag - 1;
        % fprintf("flag = %d\n", flag))
        
        [~, I] = sort(probabilitiesArray, 'ascend'); % I(1) and I(2) are the index of smallest probabilities
        % fprintf("I(1) = %d, I(2) = %d\n", I(1), I(2))

        % append "0" to symbols in symbolsCell
        for left_symbol = symbolsCell{I(1)}
            huffmanCodes(symbols == left_symbol) = "0" + huffmanCodes(symbols == left_symbol);
        end

        % append "1" to symbols in symbolsCell
        for right_symbol = symbolsCell{I(2)}
            huffmanCodes(symbols == right_symbol) = "1" + huffmanCodes(symbols == right_symbol);
        end

        % combine two nodes into one
        symbolsCell{I(1)} = [symbolsCell{I(1)}, symbols(I(2))];
        probabilitiesArray(I(1)) = probabilitiesArray(I(1)) + probabilitiesArray(I(2));
        symbolsCell{I(2)} = []; % not that neccessary, just clear value on the position
        probabilitiesArray(I(2)) = 2; % neccessary, a value bigger than one
    end

end
