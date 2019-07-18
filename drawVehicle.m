function drawVehicle(uu)
    % process inputs to function
    px = uu(1);         % x position
    py = uu(2);         % y position
    phi = uu(3);        % pitch angle
    t = uu(4);          % time
    % define persistent variables
    persistent vehicle_handle
    persistent Vertices
    persistent Faces
    persistent facecolors
    % first time function is called, initialize plot and persistent vars
    if t==0
        figure(1);
        %clf;
        [Vertices, Faces, facecolors] = defineVehicleBody;
        vehicle_handle = drawVehicleBody(Vertices, Faces, facecolors, px, py, phi, [], 'normal');
        %title('Vehicle');
        %xlabel('X');
        %ylabel('Y');
        axis square;
        axis equal;
        axis tight;
        axis([0, 24, 0, 24]);
        grid on;
        hold on;
    % at every other time step, redraw base and rod
    else
        drawVehicleBody(Vertices, Faces, facecolors, px, py, phi, vehicle_handle);
    end
end

  
%=======================================================================
% drawVehicle
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================

function handle = drawVehicleBody(V, F, patchcolors, px, py, phi, handle, mode)
    V = rotate(V, phi);           % rotate vehicle
    V = translate(V, px, py);     % translate vehicle
    if isempty(handle)
        handle = patch('Vertices', V', 'Faces', F, 'FaceVertexCData', patchcolors, 'FaceColor', 'flat', 'EraseMode', mode);
    else
        set(handle, 'Vertices', V', 'Faces', F);
        drawnow;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pts=rotate(pts, phi)
    % define rotation matrix (right handed)
    R = [cos(phi), -sin(phi);...
        sin(phi), cos(phi)];
    % rotate vertices
    pts = R*pts;
end
% end rotate


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by pn, pe, pd
function pts = translate(pts, px, py)
    pts = pts+repmat([px; py], 1, size(pts, 2));
end
% end translate


%=======================================================================
% defineVehicleBody
%=======================================================================

function [V, F, facecolors] = defineVehicleBody
    % Define the vertices (physical location of vertices)
    V = [-0.25, -0.3;...        % pt 1
         0.25, -0.3;...         % pt 2
         0.25, 0.3;...          % pt 3
         -0.25, 0.3;...         % pt 4          body
         0.25, 0.3;...          % pt 5
         0.4, 0.3;...          % pt 6
         0.4, -0.3;...         % pt 7
         0.25, -0.3;...         % pt 8          right wheel
         -0.25, 0.3;...         % pt 9
         -0.4, 0.3;...         % pt 10
         -0.4, -0.3;...        % pt 11
         -0.25, -0.3;...        % pt 12         left wheel
         0.25, 0.3;...          % pt 13
         0, 0.4;...            % pt 14
         -0.25, 0.3;...         % pt 15         head
         ]';         
    % define faces as a list of vertices numbered above
    F = [1, 2, 3, 4;...
         5, 6, 7, 8;...
         9, 10, 11, 12;...
         13, 13, 14, 15;...
        ];                       % vehicle
    % define colors for each face    
    myred = [1, 0, 0];
    mygreen = [0, 1, 0];
    myblue = [0, 0, 1];
    myyellow = [1, 1, 0];
    mycyan = [0, 1, 1];
    facecolors = [myblue;...
                  mycyan;...
                  mycyan;...
                  mygreen;...
                 ];              % vehicle
end
% end define vehicle body
