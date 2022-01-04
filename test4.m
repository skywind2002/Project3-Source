PSNRs = zeros(5, 4, 3); % index_PSNRs, index_quant_factors, index_SNRs

PSNRs(:,:,1) = [
   10.8744   11.6493   11.1243   12.1010
    9.8581    9.9740   12.4163   10.7619
   11.2221    9.4287   11.5549   11.1304
   10.7612    9.3508   10.7732    9.1524
   11.2992   12.0543   11.2832    8.5878
];
PSNRs(:,:,2) = [
   32.5862   23.2056   13.9392   16.2974
   18.8247   18.1569   24.9977   17.0479
   18.9152   19.2555   15.2615   15.0962
   14.7965   24.1853   24.9921   22.8802
   18.9298   29.6377   20.8803   17.9144
];
PSNRs(:,:,3) = [
   32.8180   29.6748   25.0015   22.9348
   32.8180   29.6748   25.0015   22.9348
   32.8180   29.6748   25.0015   22.9348
   32.8180   29.6748   25.0015   22.9348
   32.8180   29.6748   25.0015   22.9348
];

PSNR_MIN = [5.6929    5.6929    5.6929    5.6929];
PSNR_MAX = [32.8180   29.6748   25.0015   22.9348];
SNRs = [-Inf -3, -2, 5 +Inf];
lengths = [148648, 146363, 136148, 132511];
figure; 
hold on;
plot(lengths * 3, PSNR_MIN, '--', 'Linewidth', 2)
for i = 1:3
    errorbar(lengths * 3, mean(PSNRs(:, :, i), 1), std(PSNRs(:, :, i), 1), '*-', 'LineWidth', 2)
end
plot(lengths * 3, PSNR_MAX, '--', 'LineWidth', 2)
legend('SNR = ' + string(SNRs), 'location', 'northwest')
xlabel('bit stream/bit')
ylabel('PSNR/dB')
title('R-P Graph（1/3效率卷积码，H.261 量化，量化参数分别取 100/50/10/5）')
hold off;
grid on;

imwrite(frame2im(getframe(gcf)), "实验记录(数据+图像)\信源信道联合编码\13卷积码.png")