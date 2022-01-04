PSNRs = zeros(5, 4, 3); % index_PSNRs, index_quant_factors, index_SNRs
PSNRs(:,:,1) = [
   12.1865   11.6313   13.9001   14.4582
   17.1933   14.2871   13.4520   11.1865
   15.7654   15.7914   24.8354   10.1513
   11.2844   12.5934   10.9032   13.9175
   15.8778   13.1636   16.6302   12.9355
];

PSNRs(:,:,2) = [
   32.8181   21.6873   17.2918   22.9349
   32.8180   29.6715   25.0017   18.9961
   32.7904   23.2565   17.5262   17.7988
   32.8116   29.6641   22.3442   15.7466
   32.8016   19.6643   18.8841   22.9240
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
plot(lengths * 2, PSNR_MIN, '--', 'Linewidth', 2)
for i = 1:3
    errorbar(lengths * 2, mean(PSNRs(:, :, i), 1), std(PSNRs(:, :, i), 1), '*-', 'LineWidth', 2)
end
plot(lengths * 2, PSNR_MAX, '--', 'LineWidth', 2)
legend('SNR = ' + string(SNRs), 'location', 'northwest')
xlabel('bit stream/bit')
ylabel('PSNR/dB')
title('R-P Graph（1/2效率卷积码，H.261 量化，量化参数分别取 100/50/10/5）')
hold off;
grid on;
xlim(lengths([end,1])*2)
imwrite(frame2im(getframe(gcf)), "实验记录(数据+图像)\信源信道联合编码\12卷积码.png")