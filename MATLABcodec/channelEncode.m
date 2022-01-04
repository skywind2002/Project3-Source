SK_way = 'PSK';
f_low = 300; omega_low = f_low * 2 * pi;
f_high = 3400; omega_high = f_high * 2 * pi;
f_0 = (f_high + f_low) / 2; omega_0 = f_0 * 2 * pi;
W = (f_high - f_low) / 2; 
alpha = 0.5;
Ts = (alpha + 1) / 2 / W; 
Rs = 1 / Ts;
subplot_r = 5; subplot_c = 3; 
frequency_range = [-1.5 * f_high, 1.5 * f_high];

if rem(length(message), 12) ~= 0 
    message = [message, repmat([0], 1, 12 - rem(length(message), 12))];
end

if(conv_mode == 3)
    SK_M = 8; n = 3; k = 1; m = 4;
    A = cat(3, [1 1 1], [1 0 1], [0 1 1], [1 1 1]);
elseif(conv_mode == 2)
    SK_M = 4; n = 2; k = 1; m = 4;
    A = cat(3, [1 1], [0 1], [1 1], [1 1]);
end

disp("Conv Encoding...")
conv_encoded_message = conv_encode(message, n, k, m, A, 1, 1, 2);

r = 1;
a_n = PSK(conv_encoded_message, SK_M, r);

t_start = 0; t_end = Ts * length(a_n) * 1.2;
precision_N = 8; precision = Ts / precision_N; 
omega_range = [-1.5 * omega_high, 1.5 * omega_high]; 
omega_N = 8000;
t_range = [t_start, t_end];
t_N = (t_end - t_start) / precision;
T = t_range(2) - t_range(1);
t = linspace(t_range(1), t_range(2) - T / t_N, t_N)';
t = t'; 
s_len = min(2 * length(a_n), 128);
t_raisedcos = rcosdesign(alpha, s_len, precision_N, 'sqrt'); 
t_raisedcos = 1.14 * t_raisedcos / max(t_raisedcos); 

a_t = zeros(1, length(t)); 

for kk = 1:length(a_n)
    a_t(kk * precision_N) = a_n(kk); 
end

s_t = upfirdn(a_t, t_raisedcos); 
delay = (length(t_raisedcos) - 1) / 2;
s_t = s_t(delay + 1:end - delay);

u_t = s_t .* exp(1j * (omega_0 * t));
u_t = real(u_t);

transfer_wave = u_t;