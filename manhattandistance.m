% manhattan distance calculation function 
% author Ziqian Zhu
% date 02/28/2019
%--------------------------------------------------------------------------
% This function calculates the distance between any two cartesian node
function dist = manhattandistance(x1,y1,x2,y2)
% calculate the manhattan distance between two nodes 
dist = abs(x2 - x1) + abs(y2 -y1);

% calculate the abs distance between two nodes 
% dist=sqrt((x1-x2)^2 + (y1-y2)^2); 