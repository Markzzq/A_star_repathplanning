function output=drawNewObstacle(uu,map_matrix)
    % define persistent variables
    persistent Vertices
    persistent Faces
    persistent facecolors
    t=uu(1);
    figure(1);
%   if t>=16
%         [Vertices, Faces, facecolors] = defineObstacle4;
%         patch('Vertices', Vertices', 'Faces', Faces, 'FaceVertexCData', facecolors, 'FaceColor', 'flat', 'EraseMode', 'normal');
%         map_matrix(13, 17)=0;
%         map_matrix(13, 18)=0;
%         map_matrix(14, 17)=0;
%         map_matrix(14, 18)=0;
%         output=map_matrix;
    if t==12
        [Vertices, Faces, facecolors] = defineObstacle3;
        patch('Vertices', Vertices', 'Faces', Faces, 'FaceVertexCData', facecolors, 'FaceColor', 'flat', 'EraseMode', 'normal');
        map_matrix(15, 18)=-1;
        map_matrix(15, 19)=-1;
        map_matrix(16, 18)=-1;
        map_matrix(16, 19)=-1;
        output=map_matrix;
    elseif t==8
        [Vertices, Faces, facecolors] = defineObstacle2;
        patch('Vertices', Vertices', 'Faces', Faces, 'FaceVertexCData', facecolors, 'FaceColor', 'flat', 'EraseMode', 'normal');
        map_matrix(5, 11)=-1;
        map_matrix(5, 12)=-1;
        map_matrix(6, 11)=-1;
        map_matrix(6, 12)=-1;
        output=map_matrix;
    elseif t==4
        [Vertices, Faces, facecolors] = defineObstacle1;
        patch('Vertices', Vertices', 'Faces', Faces, 'FaceVertexCData', facecolors, 'FaceColor', 'flat', 'EraseMode', 'normal');
        map_matrix(11, 15)=-1;
        map_matrix(11, 16)=-1;
        map_matrix(12, 15)=-1;
        map_matrix(12, 16)=-1;
        output=map_matrix;
    else
        output=map_matrix;
    end
    %title('Map');
    %xlabel('X');
    %ylabel('Y');
    axis square;
    axis equal;
    axis tight;
    axis([0, 24, 0, 24]);
    grid on;
    hold on;
end

%=======================================================================
% defineObstacles
%=======================================================================

function [V, F, facecolors] = defineObstacle1
    % Define the vertices (physical location of vertices)
    V = [14, 12;...       % pt 1
         16, 12;...       % pt 2
         16, 14;...       % pt 3
         14, 14;...       % pt 4            obstacle1
         ]';         
    % define faces as a list of vertices numbered above
    F = [1, 2, 3, 4;...           % obstacle1
        ];
    % define colors for each face    
    myred = [1, 0, 0];
    mygreen = [0, 1, 0];
    myblue = [0, 0, 1];
    myyellow = [1, 1, 0];
    mycyan = [0, 1, 1];
    facecolors = [myyellow];    % obstacle1
end
% end define obstacle1

function [V, F, facecolors] = defineObstacle2
    % Define the vertices (physical location of vertices)
    V = [10, 18;...       % pt 1
         12, 18;...       % pt 2
         12, 20;...       % pt 3
         10, 20;...       % pt 4            obstacle2
         ]';         
    % define faces as a list of vertices numbered above
    F = [1, 2, 3, 4;...           % obstacle2
        ];
    % define colors for each face    
    myred = [1, 0, 0];
    mygreen = [0, 1, 0];
    myblue = [0, 0, 1];
    myyellow = [1, 1, 0];
    mycyan = [0, 1, 1];
    facecolors = [myyellow];    % obstacle2
end
% end define obstacle2

function [V, F, facecolors] = defineObstacle3
    % Define the vertices (physical location of vertices)
    V = [17, 8;...       % pt 1
         19, 8;...       % pt 2
         19, 10;...       % pt 3
         17, 10;...       % pt 4            obstacle3
         ]';         
    % define faces as a list of vertices numbered above
    F = [1, 2, 3, 4;...           % obstacle3
        ];
    % define colors for each face    
    myred = [1, 0, 0];
    mygreen = [0, 1, 0];
    myblue = [0, 0, 1];
    myyellow = [1, 1, 0];
    mycyan = [0, 1, 1];
    facecolors = [myyellow];    % obstacle3
end
% end define obstacle3

function [V, F, facecolors] = defineObstacle4
    % Define the vertices (physical location of vertices)
    V = [16, 10;...       % pt 1
         18, 10;...       % pt 2
         18, 12;...       % pt 3
         16, 12;...       % pt 4            obstacle4
         ]';         
    % define faces as a list of vertices numbered above
    F = [1, 2, 3, 4;...           % obstacle4
        ];
    % define colors for each face    
    myred = [1, 0, 0];
    mygreen = [0, 1, 0];
    myblue = [0, 0, 1];
    myyellow = [1, 1, 0];
    mycyan = [0, 1, 1];
    mywhite = [1, 1, 1];
    facecolors = [mywhite];    % obstacle4
end
% end define obstacle4