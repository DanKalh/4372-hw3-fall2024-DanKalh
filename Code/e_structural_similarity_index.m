% Define TR and TE values for Spin Echo (SE)
TR_values_SE = [250, 500, 750, 1000, 2000];  % TR values
TE_values_SE = [20, 40, 60, 80];  % TE values

% Generate and store the signal intensity maps for each combination of TR and TE
SI_SE_250_20 = P_values .* (1 - exp(-TR_values_SE(1) ./ T1_values)) .* exp(-TE_values_SE(1) ./ T2_values);  % TR=250, TE=20
SI_SE_1000_20 = P_values .* (1 - exp(-TR_values_SE(4) ./ T1_values)) .* exp(-TE_values_SE(1) ./ T2_values); % TR=1000, TE=20


% Calculate SSIM between the two Spin Echo images
[ssimval, ssimmap] = ssim(SI_SE_250_20, SI_SE_1000_20);

% Display SSIM value
fprintf('SSIM between image 1 (TR=250, TE=20) and image 2 (TR=1000, TE=20): %.4f\n', ssimval);
