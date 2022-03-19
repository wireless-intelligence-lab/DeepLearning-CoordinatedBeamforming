%%%% DeepMIMO parameters set %%%%
% A detailed description of the parameters is available on DeepMIMO.net
params.scenario = 'O1_60';          % The adopted ray tracing scenario [check the available scenarios at https://deepmimo.net/scenarios/]
params.scene_first = 1;
params.scene_last = 1;
params.active_BS = [3, 4, 5, 6];             % Includes the numbers of the active BSs (values from 1-18 for 'O1')(check the scenario description at https://deepmimo.net/scenarios/ for the BS numbers) 
params.active_user_first = 1000;       % The first row of the considered user section (check the scenario description for the user row map)
params.active_user_last = 1300;        % The last row of the considered user section (check the scenario description for the user row map)
params.row_subsampling = 1;         % Randomly select round(row_subsampling*(active_user_last-params.active_user_first)) rows
params.user_subsampling = 1;        % Randomly select round(user_subsampling*number_of_users_in_row) users in each row
params.num_ant_BS = [1, 32, 8];      % Number of antenna elements for the BS arrays in the x,y,z-axes
params.num_ant_UE = [1, 1, 1];      % Number of antenna elements for the user arrays in the x,y,z-axes
params.activate_array_rotation = 0; % 0 -> no array rotation - 1 -> apply the array rotation defined in params.array_rotation_BS
params.array_rotation_BS = [5, 10, 20];         
params.array_rotation_UE = [0, 30, 0];      
params.enable_BS2BSchannels = 1;      % Enable generating BS to BS channel (could be useful for IAB, RIS, repeaters, etc.) 
params.ant_spacing_BS = .5;           % ratio of the wavelength; for half wavelength enter .5
params.ant_spacing_UE = .5;           % ratio of the wavelength; for half wavelength enter .5
params.radiation_pattern = 1;         % 0: Isotropic and 
                                                                     % 1: Half-wave dipole
% System parameters
params.bandwidth = 0.5;               % The bandwidth in GHz
params.activate_RX_filter = 0;        % 0 No RX filter 
params.generate_OFDM_channels = 1;    % 1: activate frequency domain (FD) channel generation for OFDM systems
                                      % 0: activate instead time domain (TD) channel impulse response generation for non-OFDM systems
params.num_paths = 5;                 % Maximum number of paths to be considered (a value between 1 and 25), e.g., choose 1 if you are only interested in the strongest path
params.num_OFDM = 1024;                % Number of OFDM subcarriers
params.OFDM_sampling_factor = 1;      % The constructed channels will be calculated only at the sampled subcarriers (to reduce the size of the dataset)
params.OFDM_limit = 64;               % Only the first params.OFDM_limit subcarriers will be considered  
params.saveDataset = 0;               % 0: Will return the dataset without saving it (highly recommended!) 