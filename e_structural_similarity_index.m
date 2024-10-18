% Example: Calculate SSIM between two Spin Echo images with different TR values
image1 = SI_SE_250_20;  % Image generated with TR=250, TE=20
image2 = SI_SE_1000_20; % Image generated with TR=1000, TE=20

% Calculate SSIM
[ssimval, ssimmap] = ssim(image1, image2);

% Display SSIM value
fprintf('SSIM between image 1 (TR=250) and image 2 (TR=1000): %.4f\n', ssimval);
