clear all;
close all; 
clc;
save_figs = false;
width  = 12; height = 12; 

env_map = zeros(width,height); 
env_map(11,2:4) = -1; 
env_map(6:8,2) = -1; 
env_map(7,6:7) = -1; 
env_map(3,7:9) = -1; 
env_map(8:10,11) = -1; 
env_map(5,1:4) = -1;
env_map(2,3:6) = -1; 
env_map(2:9,10) = -1;
env_map(9:12,6) = -1; 
env_map(5:8,8) = -1;
env_map(8,1) = -1;

% the beginning and terminal states (in matrix notation): 
s_start = [12,1]; 
s_end   = [1,12]; 

[pathSarsa, pathQlearn, Q_sarsa, Q_qlearn, rpt_sarsa, rpt_qlearn, n_sarsa, n_qlearn] = RL_path_planning(env_map,s_start,s_end);

% extract the greedy policy and state value function from both: 
% 
pol_pi_sarsa  = zeros(width,height); 
V_sarsa  = zeros(width,height); 
n_g_sarsa  = zeros(width,height); 
pol_pi_qlearn = zeros(width,height); 
V_qlearn = zeros(width,height); 
n_g_qlearn = zeros(width,height); 
for ii=1:width
  for jj=1:height
    sti = sub2ind( [width,height], ii, jj ); 
    [V_sarsa(ii,jj),pol_pi_sarsa(ii,jj)] = max( Q_sarsa(sti,:) ); 
    n_g_sarsa(ii,jj) = n_sarsa(sti,pol_pi_sarsa(ii,jj));
    [V_qlearn(ii,jj),pol_pi_qlearn(ii,jj)] = max( Q_qlearn(sti,:) ); 
    n_g_qlearn(ii,jj) = n_qlearn(sti,pol_pi_qlearn(ii,jj));
  end
end

% sarsa:
% 
RL_plot_action_policy(pol_pi_sarsa,env_map,s_start,s_end);
title( 'sarsa policy' ); 
% fn = sprintf('cw_sarsa_policy_nE_%d',MAX_N_EPISODES); if( save_figs ) saveas( gcf, fn, 'png' ); end 

% figure; imagesc( V_sarsa ); colormap(flipud(jet)); colorbar; 
% title( 'sarsa state value function' ); 
% fn = sprintf('cw_sarsa_state_value_fn_nE_%d',MAX_N_EPISODES); if( save_figs ) saveas( gcf, fn, 'png' ); end

figure; imagesc( n_g_sarsa ); colorbar; 
title( 'SARSA: number of greedy samples' ); 

% Plot the reward per epsiode as in the book: 
% rpe_sarsa = cumsum(rpt_sarsa)./cumsum(1:length(rpt_sarsa));
% ph=figure; ph_sarsa = plot( rpe_sarsa, '-x' ); axis([0, 1000, -5 0]); grid on; hold on; 

% Qlearn:
% 
% RL_plot_action_policy(pol_pi_qlearn,env_map,s_start,s_end);
% title( 'qlearn policy' ); 
% fn = sprintf('cw_qlearn_policy_nE_%d',MAX_N_EPISODES); if( save_figs ) saveas( gcf, fn, 'png' ); end
% % 
% figure; imagesc( V_qlearn ); colormap(flipud(jet)); colorbar; 
% title( 'qlearn state value function' ); 
% fn = sprintf('cw_qlearn_state_value_fn_nE_%d',MAX_N_EPISODES); if( save_figs ) saveas( gcf, fn, 'png' ); end

figure; imagesc( n_g_qlearn ); colorbar; 
title( 'QLEARN: number of greedy samples' ); 
% 
% rpe_qlearn = cumsum(rpt_qlearn)./cumsum(1:length(rpt_qlearn));
% figure(ph); ph_qlearn = plot( rpe_qlearn, '-og' ); 
% xlabel('total episodes'); ylabel('Reward per epsiode'); title('Average reward per epsiode');
% legend([ph_sarsa,ph_qlearn],{'SARSA','QLEARN'}, 'location', 'southeast');
% fn = sprintf('cw_avg_reward_per_epsiode_nE_%d',MAX_N_EPISODES); 
% if( save_figs ) saveas( gcf, fn, 'png' ); end


