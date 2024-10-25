% g_generate_100_mri_si_maps.m
% This script generates 100 MRI images for two patients with varying TR and TE,
% calculates signal intensities for GM, WM, and CSF, and adds Gaussian noise.

num_images = 100;

% Define TR and TE values for Spin Echo (SE)
TR_values = [250, 500, 750, 1000, 2000];  % Example TR values in ms
TE_values = [20, 40, 60, 80];  % Example TE values in ms

% Load the NIfTI file for patient 1 and extract slice 90
nii_patient1 = niftiread('C:\Users\dank\Desktop\matlab\assign3\COSC4372-6370-Assignment_Synthesis_ML-OASIS_v2\COSC4372-6370-Assignment_Synthesis_ML-OASIS\Data\patient1.nii\patient1.nii');
slice_90_patient1 = nii_patient1(:,:,90);

% Load the NIfTI file for patient 2 and extract slice 90
nii_patient2 = niftiread('C:\Users\dank\Desktop\matlab\assign3\COSC4372-6370-Assignment_Synthesis_ML-OASIS_v2\COSC4372-6370-Assignment_Synthesis_ML-OASIS\Data\patient2.nii\patient2.nii');
slice_90_patient2 = nii_patient2(:,:,90);

% Pre-allocate space for storing MRI images for both patients
MRI_images_patient1 = cell(num_images, 1);
MRI_images_patient2 = cell(num_images, 1);

% Process the data for both patients
slices = {slice_90_patient1, slice_90_patient2};  % Cell array to hold slices for both patients

for patient_idx = 1:2
    % Get the current patient slice
    slice_90 = slices{patient_idx};

    % Define the tissue masks for GM, WM, and CSF based on the loaded slice
    gm_mask = (slice_90 == 1) | (slice_90 == 2);  % Gray Matter mask
    wm_mask = (slice_90 == 3);                    % White Matter mask
    csf_mask = (slice_90 == 4);                   % CSF mask

    % Initialize T1, T2, and P value matrices
    T1_values = zeros(size(slice_90));
    T2_values = zeros(size(slice_90));
    P_values = zeros(size(slice_90));

    % Assign T1, T2, and P values based on tissue type
    % Gray Matter (GM)
    T1_values(gm_mask) = 1.62 + 0.26 * randn(sum(gm_mask(:)), 1);
    T2_values(gm_mask) = 85 + 12 * randn(sum(gm_mask(:)), 1);
    P_values(gm_mask) = 105 + 10 * randn(sum(gm_mask(:)), 1);

    % White Matter (WM)
    T1_values(wm_mask) = 1.0 + 0.15 * randn(sum(wm_mask(:)), 1);
    T2_values(wm_mask) = 70 + 8 * randn(sum(wm_mask(:)), 1);
    P_values(wm_mask) = 100 + 5 * randn(sum(wm_mask(:)), 1);

    % CSF (Cerebrospinal Fluid)
    T1_values(csf_mask) = 4.2 + 0.5 * randn(sum(csf_mask(:)), 1);
    T2_values(csf_mask) = 250 + 30 * randn(sum(csf_mask(:)), 1);
    P_values(csf_mask) = 110 + 5 * randn(sum(csf_mask(:)), 1);

    % Loop through all TR and TE values to generate 100 MRI images
    for i = 1:num_images
        % Define TR and TE for this specific image
        TR = TR_values(mod(i-1, length(TR_values)) + 1);  % Cycle through TR values
        TE = TE_values(mod(i-1, length(TE_values)) + 1);  % Cycle through TE values

        % Calculate the signal intensity map for GM, WM, and CSF
        SI_GM = P_values(gm_mask) .* (1 - exp(-TR ./ T1_values(gm_mask))) .* exp(-TE ./ T2_values(gm_mask));  % GM
        SI_WM = P_values(wm_mask) .* (1 - exp(-TR ./ T1_values(wm_mask))) .* exp(-TE ./ T2_values(wm_mask));  % WM
        SI_CSF = P_values(csf_mask) .* (1 - exp(-TR ./ T1_values(csf_mask))) .* exp(-TE ./ T2_values(csf_mask)); % CSF

        % Combine the tissue SI maps into a single image
        SI_SE = zeros(size(slice_90));  % Initialize the entire image with zeros
        SI_SE(gm_mask) = SI_GM;  % Insert Gray Matter SI values
        SI_SE(wm_mask) = SI_WM;  % Insert White Matter SI values
        SI_SE(csf_mask) = SI_CSF;  % Insert CSF SI values

        % Add Gaussian noise with standard deviation 5% of the peak signal
        peak_signal = max(SI_SE(:));
        noise_std = 0.05 * peak_signal;
        SI_SE_noisy = SI_SE + noise_std * randn(size(SI_SE));

        % Store the noisy image for the current patient
        if patient_idx == 1
            MRI_images_patient1{i} = SI_SE_noisy;
        else
            MRI_images_patient2{i} = SI_SE_noisy;
        end
    end
end

% Select and display one of the generated MRI images for each patient
selected_image_patient1 = MRI_images_patient1{69}; 
selected_image_patient2 = MRI_images_patient2{69}; 

% Display the selected image for patient 1
figure;
imshow(selected_image_patient1, []);
title('Patient 1: Selected MRI Image with Noise (Spin Echo, TR=250, TE=20)');

% Display the selected image for patient 2
figure;
imshow(selected_image_patient2, []);
title('Patient 2: Selected MRI Image with Noise (Spin Echo, TR=250, TE=20)');

% Compute and display average signal intensities for GM, WM, and CSF for the selected images

% Patient 1
gm_mean_1 = mean(selected_image_patient1(gm_mask));
wm_mean_1 = mean(selected_image_patient1(wm_mask));
csf_mean_1 = mean(selected_image_patient1(csf_mask));

fprintf('Patient 1 (TR=250, TE=20): GM=%.4f, WM=%.4f, CSF=%.4f\n', gm_mean_1, wm_mean_1, csf_mean_1);

% Patient 2
gm_mean_2 = mean(selected_image_patient2(gm_mask));
wm_mean_2 = mean(selected_image_patient2(wm_mask));
csf_mean_2 = mean(selected_image_patient2(csf_mask));

fprintf('Patient 2 (TR=250, TE=20): GM=%.4f, WM=%.4f, CSF=%.4f\n', gm_mean_2, wm_mean_2, csf_mean_2);
