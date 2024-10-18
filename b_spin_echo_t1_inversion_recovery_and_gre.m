
% Set the T1, T2, and P values from the previous step
% Assuming these are already generated as T1_values, T2_values, P_values

% --------------- Spin Echo (SE) ----------------
TR_values_SE = [250, 500, 750, 1000, 2000];  % TR values in ms
TE_values_SE = [20, 40, 60, 80];  % TE values in ms

figure;
for i = 1:length(TR_values_SE)
    for j = 1:length(TE_values_SE)
        % Calculate Signal Intensity for Spin Echo (SE)
        SI_SE = P_values .* (1 - exp(-TR_values_SE(i) ./ T1_values)) .* exp(-TE_values_SE(j) ./ T2_values);
        
        % Plot the SI map for the current combination of TR and TE
        subplot(length(TR_values_SE), length(TE_values_SE), (i-1)*length(TE_values_SE) + j);
        imagesc(SI_SE);
        title(sprintf('SE: TR=%d, TE=%d', TR_values_SE(i), TE_values_SE(j)));
        colorbar;
    end
end
subtitle('Spin Echo (SE) Signal Intensity Maps');

% --------------- T1 Inversion Recovery (IR) ----------------
TR_values_IR = [1000, 2000];  % TR values in ms
TI_values_IR = [50, 100, 250, 500, 750];  % TI values in ms
TE_IR = 0;  % Fixed TE for IR

figure;
for i = 1:length(TR_values_IR)
    for j = 1:length(TI_values_IR)
        % Calculate Signal Intensity for T1 Inversion Recovery (IR)
        SI_IR = P_values .* (1 - 2 * exp(-TI_values_IR(j) ./ T1_values) + exp(-TR_values_IR(i) ./ T1_values)) .* exp(-TE_IR ./ T2_values);
        
        % Plot the SI map for the current combination of TR and TI
        subplot(length(TR_values_IR), length(TI_values_IR), (i-1)*length(TI_values_IR) + j);
        imagesc(SI_IR);
        title(sprintf('IR: TR=%d, TI=%d', TR_values_IR(i), TI_values_IR(j)));
        colorbar;
    end
end
subtitle('T1 Inversion Recovery (IR) Signal Intensity Maps');

% --------------- Gradient Recalled Echo (GRE) ----------------
TR_values_GRE = [25, 50, 100];  % TR values in ms
alpha_values_GRE = deg2rad([15, 30, 45, 60, 90]);  % Flip angles in degrees, converted to radians
TE_GRE = 5;  % Fixed TE for GRE

figure;
for i = 1:length(TR_values_GRE)
    for j = 1:length(alpha_values_GRE)
        % Calculate Signal Intensity for Gradient Recalled Echo (GRE)
        SI_GRE = P_values .* sin(alpha_values_GRE(j)) .* (1 - exp(-TR_values_GRE(i) ./ T1_values)) .* exp(-TE_GRE ./ T2_values) ...
                 ./ (1 - cos(alpha_values_GRE(j)) .* exp(-TR_values_GRE(i) ./ T1_values));
        
        % Plot the SI map for the current combination of TR and alpha
        subplot(length(TR_values_GRE), length(alpha_values_GRE), (i-1)*length(alpha_values_GRE) + j);
        imagesc(SI_GRE);
        title(sprintf('GRE: TR=%d, α=%.1f°', TR_values_GRE(i), rad2deg(alpha_values_GRE(j))));
        colorbar;
    end
end
subtitle('Gradient Recalled Echo (GRE) Signal Intensity Maps');
