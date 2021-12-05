function [DelaminateVolt, RebuildVolt] = LloydMax(InputImage, Layers, NumofIter)
    % 用Lloyd-Max计算输入图像的最佳量化电平DelaminateVolt和重建电平RebuildVolt
    % 因为图片并不大所以难度并不是很高
    % 输入参数表:
    % InputImage:输入待量化的图像
    % Layers:指定的分层数
    % NumofIter:Lloyd-Max算法迭代次数

    % 首先进行图像概率密度的统计，为Lloyd-Max算法做铺垫
    [height, width] = size(InputImage);
    ProbCount = zeros(height * width, 1); %概率统计矩阵

    for i = 1:height

        for j = 1:width
            ProbCount(InputImage(i, j) + 1) = ProbCount(InputImage(i, j) + 1) + 1;
        end

    end %遍历统计(有什么好的优化算法可以优化，我暂时没想到)

    ProbCount = ProbCount / (height * width); %归一化
    x = (0:255).'; %参照坐标

    DelaminateVolt = linspace(0, 256, Layers + 1);
    RebuildVolt = linspace(0, 256 - Layers, Layers).' + Layers / 2;
    %按照均匀量化初始化分层电平和重建电平

    for k = 1:NumofIter %进行Lloyd-Max算法的迭代步骤
        RebuildTemp = RebuildVolt;

        for t = 1:Layers %逐层计算并更新分层电平的质心作为重建电平
            RebuildVolt(t) = (sum(x(DelaminateVolt(t) + 1:DelaminateVolt(t + 1)) .* (ProbCount(DelaminateVolt(t) + 1:DelaminateVolt(t + 1))))) ./ sum(ProbCount(DelaminateVolt(t) + 1:DelaminateVolt(t + 1)));

            if (isnan(RebuildVolt(t)))
                RebuildVolt(t) = RebuildTemp(t); %这个区间里没有概率，还是保持原样
            end

        end

        %迭代计算重建电平的中点更新分层电平
        for t = 2:Layers
            DelaminateVolt(t) = (RebuildVolt(t) + RebuildVolt(t - 1)) / 2;
        end

        DelaminateVolt = ceil(sort(DelaminateVolt)); %取个整数
    end

end
