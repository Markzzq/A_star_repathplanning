% A_star path planning function 
% author Ziqian Zhu
% date 02/28/2019
%--------------------------------------------------------------------------
function [path,T_astar] = A_star(MAP,Startposition,Targetposition)
% compute the time this function will use
tic
% transder the map matrix to x-y node matrix 
MAP = rot90(MAP,3); 

% determine the size of the map
MAX_X = size(MAP,1);
MAX_Y = size(MAP,1);

% determine the start xNode & yNode in x-y node matrix
xStart = Startposition(1,2);
yStart = MAX_X +1 - Startposition(1,1);

% determine the target xNode & yNode in x-y node matrix
xTarget = Targetposition(1,2);
yTarget = MAX_X +1 - Targetposition(1,1);

% choose the value of Start position & Target Position
MAP(xTarget,yTarget) = 2;
MAP(xStart,yStart) = 3;

% draw the map 
axis([1 MAX_X+1 1 MAX_Y+1])  % the start point is 1 and end point is MAX_X+1
grid on;
hold on;

% LISTS USED FOR ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPEN LIST STRUCTURE
%--------------------------------------------------------------------------
% IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN = [];

% CLOSED LIST STRUCTURE
%--------------
%X val | Y val |
%--------------
% CLOSED=zeros(MAX_VAL,2);
CLOSED = [];


% Put all obstacles into the Closed list      
k = 1;  % numbers to be count
for i = 1:MAX_X
    for j = 1:MAX_Y
        if(MAP(i,j) == -1)
            CLOSED(k,1) = i;  % search the map and put all the obstacles to the CLOSED list
            CLOSED(k,2) = j; 
            k = k+1;
        end
    end
end 

% get the size of CLOSED list, which is also the numbers of obstacles
CLOSED_COUNT = size(CLOSED,1);   

%set the starting node as the first node
xNode = xStart;  % xNode=xval;
yNode = yStart;  % yNode=yval;

% deal with the Start point with OPEN list and CLOSED list 
OPEN_COUNT = 1;
path_cost = 0;
goal_distance = manhattandistance(xNode,yNode,xTarget,yTarget);  % compute the manhattan distance between the start and target
OPEN(OPEN_COUNT,:) = open_insert(xNode,yNode,xNode,yNode,path_cost,goal_distance,goal_distance);  % set the start node as the first node in OPEN list
OPEN(OPEN_COUNT,1) = 0;
CLOSED_COUNT = CLOSED_COUNT+1; % CLOSED COUNT is the number of elements in CLOSED list
CLOSED(CLOSED_COUNT,1) = xNode;
CLOSED(CLOSED_COUNT,2) = yNode;
NoPath = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while((xNode ~= xTarget || yNode ~= yTarget) && NoPath == 1)  % when this point is not a Target point
 
 % use the expand array function to find the surrounding nodes
 % get the exp_array matrix
 exp_array = expand_array(xNode,yNode,path_cost,xTarget,yTarget,CLOSED,MAX_X,MAX_Y);  
 
 % get the exp_array numbers
 exp_count = size(exp_array,1);    
 
 %UPDATE LIST OPEN WITH THE SURROUNDING NODES
 %OPEN LIST FORMAT
 %-------------------------------------------------------------------------
 %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
 %-------------------------------------------------------------------------
 
 %EXPANDED ARRAY FORMAT
 %--------------------------------
 %|X val |Y val ||h(n) |g(n)|f(n)|
 %--------------------------------
 
 for i = 1:exp_count
    flag = 0;
    for j = 1:OPEN_COUNT
        if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) )  % compare the node between exp_array & OPEN to see whether they are the same node
            OPEN(j,8) = min(OPEN(j,8),exp_array(i,5)); % if YES,then compare which node has the smallest fn
            if OPEN(j,8) == exp_array(i,5) % if two fn's are same, which means fn in exp_array is smaller then fn in OPEN,then we update
                % Update parents,gn,hn into OPEN list
                OPEN(j,4) = xNode;
                OPEN(j,5) = yNode;
                OPEN(j,6) = exp_array(i,3);  
                OPEN(j,7) = exp_array(i,4);
            end
                % End of minimum fn check
            flag = 1; % let flag = 1 when the comparation is over 
        end
                % End of node check
    end
                % End of j for
    if flag == 0  % if flag = 0 which means the comparation is fail and let the 
        OPEN_COUNT = OPEN_COUNT+1;
        OPEN(OPEN_COUNT,:) = open_insert(exp_array(i,1),exp_array(i,2),xNode,yNode,exp_array(i,3),exp_array(i,4),exp_array(i,5));
    end
     %End of insert new element into the OPEN list
 end
 % End of i for loop 
 
 % WHILE LOOP
 % Find out the node with the smallest fn 
  index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget); % find the smallest fn and store in a matrix 
  if (index_min_node ~= -1)    
   %Set xNode and yNode to the node with minimum fn
   xNode=OPEN(index_min_node,2);      
   yNode=OPEN(index_min_node,3);        % get a new xNode & yNode
   path_cost=OPEN(index_min_node,6);    % Update the cost of reaching the parent node
  
  % Move the Node to list CLOSED
  CLOSED_COUNT=CLOSED_COUNT+1;
  CLOSED(CLOSED_COUNT,1)=xNode;    % put this node into CLOSED list
  CLOSED(CLOSED_COUNT,2)=yNode;
  OPEN(index_min_node,1)=0;
  else
      % No path exists to the Target!!
      NoPath=0;  % Exits the loop!
  end
     % End of index_min_node check
end
     % End of While Loop
% Once algorithm has run the optimal path is generated by starting of at the
% last node(if it is the target node) and then identifying its parent node
% until it reaches the start node.This is the optimal path
i=size(CLOSED,1);
Optimal_path=[];    % set up an optimal path list
xval=CLOSED(i,1);
yval=CLOSED(i,2);
i=1;
Optimal_path(i,1)=xval;
Optimal_path(i,2)=yval;
i=i+1;
if ( (xval == xTarget) && (yval == yTarget))
    inode=0;
   %Traverse OPEN and determine the parent nodes
   parent_x=OPEN(node_index(OPEN,xval,yval),4); %node_index returns the index of the node 
   parent_y=OPEN(node_index(OPEN,xval,yval),5); 
   
   while( parent_x ~= xStart || parent_y ~= yStart)
           Optimal_path(i,1) = parent_x;
           Optimal_path(i,2) = parent_y;
           %Get the grandparents:-)
           inode=node_index(OPEN,parent_x,parent_y);
           parent_x=OPEN(inode,4);%node_index returns the index of the node
           parent_y=OPEN(inode,5);
           i=i+1;
   end
 j=size(Optimal_path,1);
 
 % while we have known the optimal list in x-y node matrix, we need to transfer this to map matrix 
 tempy = Optimal_path(:,2);
 Optimal_path(:,2) = Optimal_path(:,1);
 Optimal_path(:,1) = MAX_X + 1 - tempy;
 n = size(Optimal_path,1);
 n = n+1;
 Optimal_path(n,1) = Startposition(1,1);
 Optimal_path(n,2) = Startposition(1,2);
 path = flipud(Optimal_path);
 
 T_astar = toc;
 
%  path = zeros(n,2);
%  for t = 1:n;
%     path(t,1) = Optimal_path(n-t,1);
%     path(t,2) = Optimal_path(n-t,2);
%  end

%  Plot the Optimal Path!
%  p=plot(Optimal_path(j,1)+.5,Optimal_path(j,2)+.5,'bo');
%  j=j-1;
%  % 这个for 循环是用来输出每一个将要走的点的显示
% %  for i=j:-1:1
% %   pause(.25);
% %   set(p,'XData',Optimal_path(i,1)+.5,'YData',Optimal_path(i,2)+.5);
% %  drawnow ;
% %  end;
%  plot(Optimal_path(:,1)+.5,Optimal_path(:,2)+.5);
%  
% else   %  如果没有path到达target 时执行
%  pause(1);
%  h=msgbox('Sorry, No path ex ists to the Target!','warn');
%  uiwait(h,5);
end