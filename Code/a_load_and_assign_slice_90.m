
% You'll have to change this when grading
nii = niftiread('C:\Users\dank\Desktop\matlab\assign3\COSC4372-6370-Assignment_Synthesis_ML-OASIS_v2\COSC4372-6370-Assignment_Synthesis_ML-OASIS\Data\patient1.nii\patient1.nii');

% Extract slice 90
slice_90 = nii(:,:,90);

% Initialize matrices for T1, T2, and P values for the same size as the slice
T1_values = zeros(size(slice_90));
T2_values = zeros(size(slice_90));
P_values = zeros(size(slice_90));

% Assign T1, T2, and P values based on tissue type
% 1 or 2 for GM (Gray Matter)
gm_mask = (slice_90 == 1) | (slice_90 == 2);
T1_values(gm_mask) = 1.62 + 0.26 * randn(sum(gm_mask(:)), 1);  % Mean 1.62, std 0.26
T2_values(gm_mask) = 85 + 12 * randn(sum(gm_mask(:)), 1);      % Mean 85, std 12
P_values(gm_mask) = 105 + 10 * randn(sum(gm_mask(:)), 1);      % Mean 105, std 10

% 3 for WM (White Matter)
wm_mask = (slice_90 == 3);
T1_values(wm_mask) = 1.0 + 0.15 * randn(sum(wm_mask(:)), 1);   % Mean 1.0, std 0.15
T2_values(wm_mask) = 70 + 8 * randn(sum(wm_mask(:)), 1);       % Mean 70, std 8
P_values(wm_mask) = 100 + 5 * randn(sum(wm_mask(:)), 1);       % Mean 100, std 5

% 4 for CSF (Cerebrospinal Fluid)
csf_mask = (slice_90 == 4);
T1_values(csf_mask) = 4.2 + 0.5 * randn(sum(csf_mask(:)), 1);  % Mean 4.2, std 0.5
T2_values(csf_mask) = 250 + 30 * randn(sum(csf_mask(:)), 1);   % Mean 250, std 30
P_values(csf_mask) = 110 + 5 * randn(sum(csf_mask(:)), 1);     % Mean 110, std 5

% Display the assigned T1, T2, and P maps for the slice
figure;
subplot(1, 3, 1);
imagesc(T1_values);
colorbar;
title('T1 Values (Slice 90)');

subplot(1, 3, 2);
imagesc(T2_values);
colorbar;
title('T2 Values (Slice 90)');

subplot(1, 3, 3);
imagesc(P_values);
colorbar;
title('P (Proton Density) Values (Slice 90)');