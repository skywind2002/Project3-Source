r_t = receive_wave;
w_t = 2 * r_t .* exp(-1j * (omega_0 * t)); 
y_t = upfirdn(w_t, t_raisedcos) / precision_N; 
delay = (length(t_raisedcos) - 1) / 2;
y_t = y_t(delay + 1:end - delay);

y_n = zeros(1, length(a_n)); 

for kk = 1:length(a_n)
    y_n(kk) = y_t(kk * precision_N);
end

message_rec = zeros(1, length(a_n)); 


distance = @(z, y)(sum(abs(PSK(y, SK_M, r) - z).^2, 2));
disp("Viterbi Decoding...")
message_rec = viterbi_decode(y_n, n, k, m, A, 1, 2, distance); 
disp(length(message_rec))

message_rec = message_rec(1:length(message));
message_with_noise = message_rec;