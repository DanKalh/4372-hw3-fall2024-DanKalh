Instructions to Run the Code:

1. MATLAB must be installed.
2. The files should all be in the same directory.
3. Open the directory in MATLAB.
4. You will have to change the paths to your nii files as mine used local directory paths
	These files are where you will have to change the path
		a_load_and_assign_slice_90.m
		g_generate_100_mri_si_maps.m

5. Run each program from the MATLAB command window (in-order to make sure the nii files are loaded):
	a_load_and_assign_slice_90.m
	b_spin_echo_t1_inversion_recovery_and_gre.m
	c_generate_si_maps.m
	d_signal_to_noise_ratio_GM_WM_CSF.m
	e_structural_similarity_index.m
	f_add_gaussian_noise.m
	g_generate_100_mri_si_maps.m

6. Download any dependencies