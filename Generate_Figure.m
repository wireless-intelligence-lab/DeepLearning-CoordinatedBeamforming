% ---------Deep Learning Coordinated Beamforming with DeepMIMO ----------%
% Author: Ahmed Alkhateeb
% Date: Sept. 5, 2018 
% Paper: A. Alkhateeb, S. Alex, P. Varkey, Y. Li, Q. Qu and D. Tujkovic, 
% "Deep Learning Coordinated Beamforming for Highly-Mobile Millimeter Wave 
% Systems," in IEEE Access, vol. 6, pp. 37328-37348, 2018.
% ---------------------------------------------------------------------- %

%%
% ------  DeepMIMO Dataset Generation  --------------------------------- % 
% addpath('../DeepMIMOv2/DeepMIMO_functions') % DeepMIMO functions folder
addpath('./BF_codebook/')
params = read_params('CBF_parameters.m');
[DeepMIMO_dataset,params] = DeepMIMO_generator(params);

%%
%========================= Coordinated Deep Learning code ================
% Initialization
% Beamforming codebook parameters
over_sampling_x=1;            % The beamsteering oversampling factor in the x direction
over_sampling_y=2;            % The beamsteering oversampling factor in the y direction
over_sampling_z=1;            % The beamsteering oversampling factor in the z direction

% Generating the beamforming codebook 
[BF_codebook]=UPA_codebook_generator(params.num_ant_BS(1), params.num_ant_BS(2), params.num_ant_BS(3),over_sampling_x,over_sampling_y,over_sampling_z,params.ant_spacing_BS);
codebook_size=size(BF_codebook, 2);

num_sampled_OFDM=size(DeepMIMO_dataset{1}.user{1}.channel, 3);    % Number of OFDM samples which equals (from mmMIMO Dataset Generator) ofdm_num_subcarriers/output_subcarrier_downsampling_factor;
num_beams=prod(params.num_ant_BS)*over_sampling_x*over_sampling_y*over_sampling_z;

% ------------ Plotting Deep Learning Outputs ----------------------------
num_DL_size_points=15; 
BW=params.bandwidth*1e9;                                     % Bandwidth in Hz

% Reading the output of the DL code
for DL_size_point=1:1:num_DL_size_points
    saved_filename=strcat('DLCB_code_output/DL_Result',num2str(DL_size_point));
    load(saved_filename)
    
    for t=1:1:length(params.active_BS)
        TX{DL_size_point,t}.pred_beams=eval(matlab.lang.makeValidName(sprintf('TX%iPred_Beams',t)));
        TX{DL_size_point,t}.opt_beams=eval(matlab.lang.makeValidName(sprintf('TX%iOpt_Beams',t)));        
    end
    
    user_indices(DL_size_point,:)=user_index+1;
end

% Calculating the achievable rates of coordinated beamforming using both the predicted and optimal beams

% Noise power and SNR
Pn=-204+10*log10(BW); % Noise power in dB
SNR=10^(.1*(0-Pn)); 
ach_rate_DL=zeros(1,num_DL_size_points);
ach_rate_opt=zeros(1,num_DL_size_points);

for DL_size_point=2:1:num_DL_size_points
    for count=1:1:length(user_indices(DL_size_point,:))
        for t=1:1:length(params.active_BS)
            channel=squeeze(DeepMIMO_dataset{t}.user{user_indices(DL_size_point,count)}.channel);
            % Effective channel with predicted beam
            [max_p,predicted_beam_idx]=max(TX{DL_size_point,t}.pred_beams(count,:));
            eff_channel_pred(t,:)=channel'*BF_codebook(:,predicted_beam_idx);    
            % Effective channel with optimal beam 
            [max_o,opt_beam_idx]=max(TX{DL_size_point,t}.opt_beams(count,:));
            eff_channel_opt(t,:)=channel'*BF_codebook(:,opt_beam_idx);     
        end
        ach_rate_DL(DL_size_point)=ach_rate_DL(DL_size_point)+sum(log2(1+SNR*abs(diag(eff_channel_pred'*eff_channel_pred))))/(size(user_indices,2)*num_sampled_OFDM);
        ach_rate_opt(DL_size_point)=ach_rate_opt(DL_size_point)+sum(log2(1+SNR*abs(diag(eff_channel_opt'*eff_channel_opt))))/(size(user_indices,2)*num_sampled_OFDM);            
    end
end 

% Initial point
for count=1:1:length(user_indices(1,:))
    for t=1:1:length(params.active_BS)
        channel=squeeze(DeepMIMO_dataset{t}.user{user_indices(1,count)}.channel);
        % Effective channel with predicted beam
        eff_channel_pred(t,:)=channel'*BF_codebook(:,randi(num_beams));    
        % Effective channel with optimal beam 
        [max_o,opt_beam_idx]=max(TX{1,t}.opt_beams(count,:));
        eff_channel_opt(t,:)=channel'*BF_codebook(:,opt_beam_idx);     
    end
    ach_rate_DL(1)=ach_rate_DL(1)+sum(log2(1+SNR*abs(diag(eff_channel_pred'*eff_channel_pred))))/(size(user_indices,2)*num_sampled_OFDM);
    ach_rate_opt(1)=ach_rate_opt(1)+sum(log2(1+SNR*abs(diag(eff_channel_opt'*eff_channel_opt))))/(size(user_indices,2)*num_sampled_OFDM);            
end


% Eff achievable rate calculations
theta_user=(102/params.num_ant_BS(2))*pi/180;
alpha=60*pi/180;
distance_user=10;
Tc_const=(distance_user*theta_user)/(2*sin(alpha)); % ms 
Tt=10*1e-6; % msec

v_mph=50;
v=v_mph*1000*1.6/3600; % m/s
Tc=Tc_const/v;

overhead_opt=1-(num_beams*Tt)/Tc; % overhead of beam training
overhead_DL=1-Tt/Tc; % overhead of proposed DL method

%% Plotting the figure
DL_size_array=0:2.5:2.5*(num_DL_size_points-1);

set(0,'defaultAxesFontSize',12)
set(0,'DefaultLineLineWidth',1.5)

figure('Name', 'achievable_rate');

plot(DL_size_array,ach_rate_opt, 'k--',...
    'DisplayName', 'Genie-aided Coordinated Beamforming')
hold on; grid on; box on;
plot(DL_size_array,ach_rate_DL*overhead_DL, 'o-',...
    'DisplayName', 'Deep Learning Coordinated Beamforming',...
    'Color', '#0072BD', 'MarkerFaceColor','w')
plot(DL_size_array,ach_rate_opt*overhead_opt,'s-',...
    'DisplayName', 'Baseline Coordinated Beamforming',...
    'Color',"#A2142F",'MarkerFaceColor','w')

xlabel('Deep Learning Dataset Size (Thousand Samples)')
ylabel('Achievable Rate (bps/Hz)')
legend('Location','SouthEast','FontSize',12)
savefig('result.fig')