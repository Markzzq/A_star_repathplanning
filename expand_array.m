% exp_array calculation function 
% author Ziqian Zhu
% date 02/28/2019
%--------------------------------------------------------------------------
function exp_array = expand_array(node_x,node_y,hn,xTarget,yTarget,CLOSED,MAX_X,MAX_Y)
    % Function to return an expanded array  
    % This function takes a node and returns the expanded list of successors,with the calculated fn values.
    % The criteria being none of the successors are on the CLOSED list.
    exp_array = [];
    exp_count = 1;
    c2 = size(CLOSED,1);% Number of elements in CLOSED including the zeros
    for k = 1:-1:-1
        for j = 1:-1:-1
            if ( abs(k) + abs(j) == 1)  % The node itself is not its successor and choose the nearby 4 nodes
                s_x = node_x+k;  % the x of surrounding node
                s_y = node_y+j;  % the y of surrounding node
                if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y))  % node within array bound 
                    flag = 1;                    
                    for c1 = 1:c2
                        if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2))  % the obstacles in CLOESD list is not in the calculation
                            flag = 0;
                        end
                    end
                          % End of for loop to check if a successor is on closed list.
                    if (flag == 1)
                        exp_array(exp_count,1) = s_x;
                        exp_array(exp_count,2) = s_y;
                        exp_array(exp_count,3) = hn+manhattandistance(node_x,node_y,s_x,s_y);  % cost of travelling to node and this cost is from the original start point
                        exp_array(exp_count,4) = manhattandistance(xTarget,yTarget,s_x,s_y);  % manhattan distance between this node to the target node
                        exp_array(exp_count,5) = exp_array(exp_count,3)+exp_array(exp_count,4);  % fn
                        exp_count = exp_count+1;
                    end
                          % Populate the exp_array list!!!
                end
                          % End of node within array bound
            end
                          % End of if node is not its own successor loop
        end
                          % End of j for loop
    end
                          % End of k for loop