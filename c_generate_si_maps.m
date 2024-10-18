% ---------- Spin Echo (SE) ----------
disp('--- Spin Echo (SE) ---');
for i = 1:length(TR_values_SE)
    for j = 1:length(TE_values_SE)
        % Calculate Signal Intensity for Spin Echo (SE)
        SI_SE = P_values .* (1 - exp(-TR_values_SE(i) ./ T1_values)) .* exp(-TE_values_SE(j) ./ T2_values);
        
        % Store the average SI values for GM, WM, and CSF
        gm_avg = mean(SI_SE(gm_mask));  % GM
        wm_avg = mean(SI_SE(wm_mask));  % WM
        csf_avg = mean(SI_SE(csf_mask)); % CSF

        % Display the results
        fprintf('TR=%d, TE=%d -> GM=%.4f, WM=%.4f, CSF=%.4f\n', TR_values_SE(i), TE_values_SE(j), gm_avg, wm_avg, csf_avg);
    end
end

% ---------- T1 Inversion Recovery (IR) ----------
disp('--- T1 Inversion Recovery (IR) ---');
for i = 1:length(TR_values_IR)
    for j = 1:length(TI_values_IR)
        % Calculate Signal Intensity for T1 Inversion Recovery (IR)
        SI_IR = P_values .* (1 - 2 * exp(-TI_values_IR(j) ./ T1_values) + exp(-TR_values_IR(i) ./ T1_values)) .* exp(-TE_IR ./ T2_values);
        
        % Store the average SI values for GM, WM, and CSF
        gm_avg = mean(SI_IR(gm_mask));  % GM
        wm_avg = mean(SI_IR(wm_mask));  % WM
        csf_avg = mean(SI_IR(csf_mask)); % CSF

        % Display the results
        fprintf('TR=%d, TI=%d -> GM=%.4f, WM=%.4f, CSF=%.4f\n', TR_values_IR(i), TI_values_IR(j), gm_avg, wm_avg, csf_avg);
    end
end

% ---------- Gradient Recalled Echo (GRE) ----------
disp('--- Gradient Recalled Echo (GRE) ---');
for i = 1:length(TR_values_GRE)
    for j = 1:length(alpha_values_GRE)
        % Calculate Signal Intensity for Gradient Recalled Echo (GRE)
        SI_GRE = P_values .* sin(alpha_values_GRE(j)) .* (1 - exp(-TR_values_GRE(i) ./ T1_values)) .* exp(-TE_GRE ./ T2_values) ...
                 ./ (1 - cos(alpha_values_GRE(j)) .* exp(-TR_values_GRE(i) ./ T1_values));
        
        % Store the average SI values for GM, WM, and CSF
        gm_avg = mean(SI_GRE(gm_mask));  % GM
        wm_avg = mean(SI_GRE(wm_mask));  % WM
        csf_avg = mean(SI_GRE(csf_mask)); % CSF

        % Display the results
        fprintf('TR=%d, α=%.1f -> GM=%.4f, WM=%.4f, CSF=%.4f\n', TR_values_GRE(i), rad2deg(alpha_values_GRE(j)), gm_avg, wm_avg, csf_avg);
    end
end
