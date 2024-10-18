% Define noise level (if needed, you can calculate the noise from a background region)
noise_level = 0.05;  % Assumed or calculated noise level

% ---------- Calculate SNR for Spin Echo (SE) ----------
disp('--- SNR for Spin Echo (SE) ---');
for i = 1:length(TR_values_SE)
    for j = 1:length(TE_values_SE)
        % Calculate Signal Intensity for Spin Echo (SE)
        SI_SE = P_values .* (1 - exp(-TR_values_SE(i) ./ T1_values)) .* exp(-TE_values_SE(j) ./ T2_values);
        
        % Calculate the mean SI for GM, WM, and CSF
        gm_mean = mean(SI_SE(gm_mask));
        wm_mean = mean(SI_SE(wm_mask));
        csf_mean = mean(SI_SE(csf_mask));
        
        % Calculate SNR for each tissue type
        SNR_GM = gm_mean / noise_level;
        SNR_WM = wm_mean / noise_level;
        SNR_CSF = csf_mean / noise_level;

        % Display the results
        fprintf('TR=%d, TE=%d -> SNR_GM=%.2f, SNR_WM=%.2f, SNR_CSF=%.2f\n', TR_values_SE(i), TE_values_SE(j), SNR_GM, SNR_WM, SNR_CSF);
    end
end
