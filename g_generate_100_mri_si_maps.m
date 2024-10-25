% g_generate_100_mri_si_maps.m
% This script generates 100 MRI images with varying TR and TE, calculates signal intensities
% for GM, WM, and CSF, and adds Gaussian noise.


num_images = 100;

% Define TR and TE values for Spin Echo (SE)
TR_values = [250, 500, 750, 1000, 2000];  % Example TR values in ms
TE_values = [20, 40, 60, 80];  % Example TE values in ms

% Load or define the masks for GM, WM, CSF (example placeholders)
gm_mask = (slice_90 == 1) | (slice_90 == 2);  % Gray Matter mask
wm_mask = (slice_90 == 3);                    % White Matter mask
csf_mask = (slice_90 == 4);                   % CSF mask

% Load or define P_values (proton density values) for the whole image (example placeholder)
% Assume P_values is a matrix with the same size as your image
P_values = ones(size(slice_90));  % For simplicity, we assume P_values is all ones here

% Generate random T1 and T2 values within the provided ranges for each tissue type
T1_values = randn(num_images, 3) .* [0.26, 0.08, 4.8] + [1.62, 0.92, 10.4];  % GM, WM, CSF
T2_values = randn(num_images, 3) .* [12, 9.75, 472.5] + [85, 80.5, 1055];    % GM, WM, CSF

% Pre-allocate space for storing MRI images
MRI_images_SE = cell(num_images, 1);

% Loop through all TR and TE values to generate 100 MRI images
for i = 1:num_images
    % Define TR and TE for this specific image
    TR = TR_values(mod(i-1, length(TR_values)) + 1);  % Cycle through TR values
    TE = TE_values(mod(i-1, length(TE_values)) + 1);  % Cycle through TE values
    
    % Calculate the signal intensity map for GM, WM, and CSF
    SI_GM = P_values(gm_mask) .* (1 - exp(-TR ./ T1_values(i, 1))) .* exp(-TE ./ T2_values(i, 1));  % Gray Matter
    SI_WM = P_values(wm_mask) .* (1 - exp(-TR ./ T1_values(i, 2))) .* exp(-TE ./ T2_values(i, 2));  % White Matter
    SI_CSF = P_values(csf_mask) .* (1 - exp(-TR ./ T1_values(i, 3))) .* exp(-TE ./ T2_values(i, 3)); % CSF

    % Combine the tissue SI maps into a single image
    SI_SE = zeros(size(slice_90));  % Initialize the entire image with zeros
    SI_SE(gm_mask) = SI_GM;  % Insert Gray Matter SI values
    SI_SE(wm_mask) = SI_WM;  % Insert White Matter SI values
    SI_SE(csf_mask) = SI_CSF;  % Insert CSF SI values

    % Add Gaussian noise with standard deviation 5% of the peak signal
    peak_signal = max(SI_SE(:));
    noise_std = 0.05 * peak_signal;
    SI_SE_noisy = SI_SE + noise_std * randn(size(SI_SE));

    % Store the noisy image for further analysis
    MRI_images_SE{i} = SI_SE_noisy;
end

% Select one of the generated MRI images
selected_image = MRI_images_SE{69};  % You can choose any image

% Display the selected image
figure;
imshow(selected_image, []);
title('Selected MRI Image with Noise (Spin Echo, TR=250, TE=20)');

% Compute the average signal intensity for GM, WM, and CSF for the selected image
gm_mean = mean(selected_image(gm_mask));
wm_mean = mean(selected_image(wm_mask));
csf_mean = mean(selected_image(csf_mask));

% Display the average signal intensities for this image
fprintf('Selected Image (TR=250, TE=20): GM=%.4f, WM=%.4f, CSF=%.4f\n', gm_mean, wm_mean, csf_mean);
