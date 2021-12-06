%% 分析一张灰度图中灰度值的概率分布
% 输入
% 一张灰度图片（二维矩阵 Uint8）
% 输出
% 符号Array
% 概率Array
function [symbols, probs] = h_ProbStatistic(srcImage, symbol_count)

    switch symbol_count
        case 1
            symbols = 1:255; % 共255个灰度值
            probs = zeros(1, length(symbols));
            imagePixelCount = width(srcImage) * height(srcImage);

            for k = 1:length(symbols)
                probs(k) = sum(sum(srcImage == k)) / imagePixelCount;
            end

        case 2
            assert(mod(width(srcImage), 2) == 0, "width of srcImage should be even")
            symbols = (1):(255 * 256 + 255); % 1*256+1 ~ 255*256+255 不妨从1开始
            probs = zeros(1, length(symbols));

            doubleCombinedImage = int32(srcImage(:, 1:2:end)) * 256 + int32(srcImage(:, 2:2:end)); % 相邻奇数列和偶数列
            doublePixelCount = width(doubleCombinedImage) * height(doubleCombinedImage);

            for k = 1:length(symbols) % FXIME 这个算法问题很大，应该是遍历图像然后给symbol里面加值
                probs(k) = sum(sum(doubleCombinedImage == k)) / doublePixelCount;
            end

        otherwise
            assert(0, "unsupported symbol_count")
    end

end
