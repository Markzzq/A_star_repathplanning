function [pathSarsa, pathQlearn, Qsarsa,Qqlean,rpt_sarsa,rpt_qlearn,n_sarsa,n_qlearn, time, PerRewSarsa, PerRewQlearn] = RL_path_planning(grid_map,Startposition,Targetposition)
% parameters
num_episodes = 1e4;
learning_rate = 2e-1;
gamma = 1;    % gamma is 1 since this is a episodic task
epsilon = 0.1;  % balance for the exploit and explore

%UP:1 DOWN:2 RIGHT:3 LEFT:4
numActs = 4; 

% the number of states: 
[height,width] = size(grid_map); 
totalStates = height*width; 

%Q function: action-value function
Qsarsa = zeros(totalStates,numActs);
Qqlean = zeros(totalStates,numActs);

%reward per episode
rpt_sarsa = zeros(1,num_episodes); 
rpt_qlearn = zeros(1,num_episodes); 

%number of times we take the action in the state
n_sarsa = zeros(totalStates,numActs); 
n_qlearn = zeros(totalStates,numActs); 

PerRewSarsa = zeros(1,num_episodes); 
PerRewQlearn= zeros(1,num_episodes); 
%how many timestep we take per episode
ets = zeros(num_episodes,2);
tic
for ei=1:num_episodes

  %set the control variables of sarsa finished and q-learning finished
  sarsa_finished=0;
  qlearning_finished=0;
  % initialize the starting state
  st_sarsa = Startposition; 
  sti_sarsa = sub2ind([height,width], st_sarsa(1), st_sarsa(2)); 
  st_qlearn = Startposition; 
  sti_qlearn = sub2ind([height,width], st_qlearn(1), st_qlearn(2)); 

  % pick an initial action using an epsilon greedy policy derived from Q: 
  [dummy,at_sarsa] = max(Qsarsa(sti_sarsa,:)); 
  
  % the part to do the explore for sarsa and qlearning
  if( rand<epsilon )         
    tmp=randperm(numActs); 
    at_sarsa=tmp(1); 
  end
  
  [dummy,at_qlearn] = max(Qqlean(sti_qlearn,:));  
  if( rand<epsilon )        
    tmp=randperm(numActs); 
    at_qlearn=tmp(1); 
  end
  
  % begin an episode
  RewardSarsa=0; RewardQlrean=0; 
  while( 1 ) 
     
    % propagate to state stp1 and collect a reward rew
    [rewardSarsa, stp1_sarsa]  = getRewardNNextState(st_sarsa, at_sarsa,grid_map, Startposition,Targetposition); 
    RewardSarsa = RewardSarsa + rewardSarsa; 
    [rewardQlearn,stp1_qlearn] = getRewardNNextState(st_qlearn,at_qlearn,grid_map,Startposition,Targetposition); 
    RewardQlrean = RewardQlrean + rewardQlearn; 
    
    % pick the greedy action from state stp1: 
    stp1i_sarsa = sub2ind([height,width], stp1_sarsa(1), stp1_sarsa(2)); 
    stp1i_qlearn = sub2ind([height,width], stp1_qlearn(1), stp1_qlearn(2)); 
    
    % SARSA: 
    if (~sarsa_finished)
      ets(ei,1)=ets(ei,1)+1;
      % greedy algorithm
      [dummy,atp1_sarsa] = max(Qsarsa(stp1i_sarsa,:)); 
      % random action or not
      if( rand<epsilon )         
        tmp=randperm(numActs); atp1_sarsa=tmp(1); 
      end
      % statistic the number of actions
      n_sarsa(sti_sarsa,at_sarsa) = n_sarsa(sti_sarsa,at_sarsa)+1; 
      % update the q function: action-value function, the key part of the
      % whole algorithm
      if( ~( (stp1_sarsa(1)==Targetposition(1)) && (stp1_sarsa(2)==Targetposition(2)) ) ) 
        gradientSarsa = rewardSarsa + gamma*Qsarsa(stp1i_sarsa,atp1_sarsa) - Qsarsa(sti_sarsa,at_sarsa);
        Qsarsa(sti_sarsa,at_sarsa) = Qsarsa(sti_sarsa,at_sarsa) + learning_rate*gradientSarsa; 
      else                                                  
        Qsarsa(sti_sarsa,at_sarsa) = Qsarsa(sti_sarsa,at_sarsa) + learning_rate*( rewardSarsa - Qsarsa(sti_sarsa,at_sarsa) );  
        sarsa_finished=1; 
      end 
      %update (st,at) pair: 
      st_sarsa = stp1_sarsa; sti_sarsa = stp1i_sarsa; at_sarsa = atp1_sarsa;   
    end  

    % Q-learning: No explanations here, cus Sarsa and Qlearning are quite the same.
    % Q-learning is nothing but a off-policy method. 
    if (~qlearning_finished)
      ets(ei,2)=ets(ei,2)+1;
      
      n_qlearn(sti_qlearn,at_qlearn) = n_qlearn(sti_qlearn,at_qlearn)+1; 
      [dummy,atp1_qlearn] = max(Qqlean(stp1i_qlearn,:)); 
      
      if( rand<epsilon )         
        tmp=randperm(numActs); atp1_qlearn=tmp(1); 
      end
      
      if( ~( (stp1_qlearn(1)==Targetposition(1)) && (stp1_qlearn(2)==Targetposition(2)) ) ) 
        gradientQlrean = rewardQlearn + gamma*max(Qqlean(stp1i_qlearn,:)) - Qqlean(sti_qlearn,at_qlearn);
        Qqlean(sti_qlearn,at_qlearn) = Qqlean(sti_qlearn,at_qlearn) + learning_rate*gradientQlrean; 
      else                                                  
        Qqlean(sti_qlearn,at_qlearn) = Qqlean(sti_qlearn,at_qlearn) + learning_rate*(rewardQlearn - Qqlean(sti_qlearn,at_qlearn));    
        qlearning_finished=1;
      end
      
      st_qlearn = stp1_qlearn; sti_qlearn = stp1i_qlearn; at_qlearn = atp1_qlearn; 
    end  
    
    if (sarsa_finished && qlearning_finished)
      break;
    end
  end 
  rpt_sarsa(ei) = RewardSarsa; rpt_qlearn(ei) = RewardQlrean;
  
  
  % this part is used for plot reward
  % do not run this part unless you want to plot reward
  % cause it takes about two minutes
  
%   [pathSarsa, pathQlearn] = getPath(grid_map, Qsarsa, Qqlean, n_sarsa, n_qlearn, Startposition, Targetposition);
%   [hhs,wws] = size(pathSarsa);
%   [hhq,wwq] = size(pathQlearn);
%   if hhs>1
%     [perRewSarsa] = getReward(grid_map, pathSarsa, Targetposition);
%   else
%       perRewSarsa = -10000;
%   end
%   
%   if hhq>1
%       [perRewQlearn] = getReward(grid_map, pathQlearn, Targetposition);
%   else
%       perRewQlearn = -10000;
%   end
%   PerRewSarsa(ei) = perRewSarsa;
%   PerRewQlearn(ei) = perRewQlearn;
end
time = toc;
  [pathSarsa, pathQlearn] = getPath(grid_map, Qsarsa, Qqlean, n_sarsa, n_qlearn, Startposition, Targetposition);

function [RewCurQlearn] = getReward(grid_map, pathq, goal)

[heightq,width] = size(pathq);
RewCurQlearn=0;
for i = 1:heightq
  if((pathq(i,1)==goal(1))&&(pathq(i,2)==goal(2)))  
    rewardq = +100; %get reward when we reach the goal
  elseif( grid_map(pathq(i,1),pathq(i,1))==-1 )        
    rewardq  = -100; % meet the obstacle
  else                                    
    rewardq = -40; % running time penalty for accelerating the process
  end
  RewCurQlearn = RewCurQlearn+rewardq;
end
      
function [reward,nextState] = getRewardNNextState(curState,action,grid_map,start,goal)
% getRewardNNextState:
% get the reward and next state based on the current action and state

% get the height and width
[sideII,sideJJ] = size(grid_map); 

% get current state coordinates
indexX = curState(1); 
indexY = curState(2); 

switch action
 case 1
  %UP 
  nextState = [indexX-1,indexY];
 case 2
  %DOWN
  nextState = [indexX+1,indexY];
 case 3
  %RIGHT
  nextState = [indexX,indexY+1];
 case 4
  %LEFT 
  nextState = [indexX,indexY-1];
end

% make sure we dont run out of the grid map
if(nextState(1)<1) 
    nextState(1)=1;      
end
if(nextState(1)>sideII) 
    nextState(1)=sideII; 
end
if(nextState(2)<1) 
    nextState(2)=1;      
end
if(nextState(2)>sideJJ) 
    nextState(2)=sideJJ; 
end

% this is the part to determine reward:
if((indexX==goal(1))&&(indexY==goal(2)))  
  reward = +100; %get reward when we reach the goal
elseif( grid_map(nextState(1),nextState(2))==-1 )        
  reward  = -100; % meet the obstacle
  nextState = start;
else                                    
  reward = -40; % running time penalty for accelerating the process
end

function [pathSarsa, pathQlearn] = getPath(grid_map, Q_sarsa, Q_qlearn, n_sarsa, n_qlearn, start, target)
    [height,width] = size(grid_map);     
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
    pathSarsa = getArray(n_g_sarsa, start, target);
    pathQlearn = getArray(n_g_qlearn, start, target);
    
    % get the path of Sarsa
function [path] = getArray(state_value, start, target)
    
    [height,width] = size(state_value);
    state_value(target(1),target(2)) = 100000;
    
    current = start;
    count = 1;
    path = zeros(1,2);
    path(1,1) = start(1);
    path(1,2) = start(2);
    
    while (~isContain(current, target))
        
        x = current(2);
        y = current(1);

        if (x-1>0)
            fx = x-1;
        else
            fx = 1;
        end
        if isContain(path, [y,fx])
            state1 = -10;
        else
            state1 = state_value(y,fx);
        end
        
        if (x+1<=width)
            sx = x+1;
        else
            sx = width;
        end
        if isContain(path, [y,sx])
            state2 = -10;
        else
            state2 = state_value(y,sx);
        end
        
        
        if (y-1>0)
            ty = y -1;
        else
            ty = 1;
        end
        if isContain(path, [ty,x])
            state3 = -10;
        else
            state3 = state_value(ty,x);
        end
        
        if (y+1<=height)
            fy = y +1;
        else
            fy = height;
        end
        if isContain(path, [fy,x])
            state4 = -10;
        else
            state4 = state_value(fy,x);
        end
        
        allstate = zeros(1,4);
        allstate(1,1) = state1;
        allstate(1,2) = state2;
        allstate(1,3) = state3;
        allstate(1,4) = state4;
        allstate;
        [ma,index] = max(allstate);
        
        nextState = [0,0];
        switch index
         case 1
          nextState = [y,fx];
         case 2
          nextState = [y,sx];
         case 3
          nextState = [ty,x];
         case 4
          nextState = [fy,x];
        end
        
        count = count + 1;
        path(count, 1) = nextState(1);
        path(count, 2) = nextState(2);        
        
        current = nextState;
        
        if (count > height*width)
            path = 0;
            break
        end
    end
        
function flag = isContain(path, location)
    flag = 0;
    [c,r] = size(path);
    for ii = 1:c
        if (path(ii,1) == location(1) && path(ii,2) == location(2))
            flag = 1;
        end
    end
        
    
        

    



