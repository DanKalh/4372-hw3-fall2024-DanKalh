% Calculate the peak signal intensity
peak_signal = max(SI_SE(:));

% Standard deviation of noise = 5% of the peak signal
noise_std = 0.05 * peak_signal;

% Add Gaussian noise to the image
SI_SE_noisy = SI_SE + noise_std * randn(size(SI_SE));
