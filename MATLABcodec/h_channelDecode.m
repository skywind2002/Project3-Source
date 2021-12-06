function message = h_channelDecode(samplePoints, raisedcos)
    precision_N = 3;
    y_t = upfirdn(samplePoints, raisedcos) / precision_N; 
    delay = (length(raisedcos) - 1) / 2;
    y_t = y_t(delay + 1:end - delay);

    y_n = zeros(1, length(samplePoints) / precision_N); 

    for n = 1:length(y_n)
        y_n(n) = y_t(n * precision_N);
    end

    message = (y_n > 0.5);