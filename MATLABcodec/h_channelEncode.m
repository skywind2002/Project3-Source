function [samplePoints, raisedcos] = h_channelEncode(message)
    alpha = 0.5; 
    precision_N = 3;
    s_len = 128;
    raisedcos = rcosdesign(alpha, s_len, precision_N, 'sqrt'); 
    raisedcos = 1.14 * raisedcos / max(raisedcos); 

    a_t = zeros(1, length(message) * precision_N); 

    for n = 1:length(message)
        a_t(n * precision_N) = message(n); 
    end

    samplePoints = upfirdn(a_t, raisedcos); 
    delay = (length(raisedcos) - 1) / 2;
    samplePoints = samplePoints(delay + 1:end - delay);