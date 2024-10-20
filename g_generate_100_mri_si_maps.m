% Number of MRI images to generate
num_images = 100;

% Generate random T1 and T2 values within the provided ranges for each tissue type
T1_values = randn(num_images, 3) .* [0.26, 0.08, 4.8] + [1.62, 0.92, 10.4];  % GM, WM, CSF
T2_values = randn(num_images, 3) .* [12, 9.75, 472.5] + [85, 80.5, 1055];  % GM, WM, CSF

% Pre-allocate space to store MRI images
MRI_images_SE = cell(num_images, 1);

% Loop through each MRI image
for i = 1:num_images
    % Calculate the signal intensity map for Spin Echo (SE) for GM, WM, CSF separately

    % Apply the GM values (T1, T2, P) for Gray Matter
    SI_GM = P_values(gm_mask) .* (1 - exp(-TR ./ T1_values(i, 1))) .* exp(-TE ./ T2_values(i, 1));
    
    % Apply the WM values (T1, T2, P) for White Matter
    SI_WM = P_values(wm_mask) .* (1 - exp(-TR ./ T1_values(i, 2))) .* exp(-TE ./ T2_values(i, 2));
    
    % Apply the CSF values (T1, T2, P) for Cerebrospinal Fluid
    SI_CSF = P_values(csf_mask) .* (1 - exp(-TR ./ T1_values(i, 3))) .* exp(-TE ./ T2_values(i, 3));

    % Create the full SI map by combining GM, WM, and CSF contributions
    SI_SE = zeros(size(slice_90));  % Initialize with zeros
    SI_SE(gm_mask) = SI_GM;
    SI_SE(wm_mask) = SI_WM;
    SI_SE(csf_mask) = SI_CSF;

    % Add Gaussian noise with standard deviation = 5% of the peak signal intensity
    peak_signal = max(SI_SE(:));
    noise_std = 0.05 * peak_signal;
    SI_SE_noisy = SI_SE + noise_std * randn(size(SI_SE));

    % Store the noisy image for further analysis
    MRI_images_SE{i} = SI_SE_noisy;
end


% Select one of the generated MRI images
selected_image = MRI_images_SE{10};

% Display the selected image
figure;
imshow(selected_image, []);
title('Selected MRI Image (Spin Echo, TR=250, TE=20)');

% Compute the average signal intensity for GM, WM, and CSF (for the selected image)
gm_mean = mean(selected_image(gm_mask));
wm_mean = mean(selected_image(wm_mask));
csf_mean = mean(selected_image(csf_mask));

% Display the average signal intensities for this image
fprintf('Selected Image (TR=250, TE=20): GM=%.4f, WM=%.4f, CSF=%.4f\n', gm_mean, wm_mean, csf_mean);
