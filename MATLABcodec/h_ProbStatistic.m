%% 分析一张灰度图中灰度值的概率分布

% 输入
% 一张灰度图片（二维矩阵 Uint8）
% 输出
% 符号Array
% 概率Array
function [symbols, probs] = h_ProbStatistic(srcImage)
    symbols = 1:255; % 共255个灰度值
    probs = zeros(1, length(symbols));
    imagePixelCount = width(srcImage) * height(srcImage);

    for k = 1:length(symbols)
        probs(k) = sum(sum(srcImage == k)) / imagePixelCount;
    end

end
