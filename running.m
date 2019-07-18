clear;
close all;
clc;
n = 1;
m = 1;
t_pathplanning = 0;
dis_total = 0;
path_planning_method = 1;          % choose the path planning method 1:A*, 2:Sarsa, 3:Qleanring
map_matrix = drawMap();            % draw the map and create the map matrix
map_matrix_incar = map_matrix;     % create the map matrix in the car
start_matrix = [24, 1];            % start point   [7, 7];
target_matrix = [1, 24];           % target point  [8, 20];
% use path planning methods to find the path
if path_planning_method == 1
    % using A*
    [P,T_astar] = A_star(map_matrix_incar,start_matrix,target_matrix);
    t_pathplanning = t_pathplanning + T_astar;
elseif path_planning_method == 2 || path_planning_method == 3
    % using Sarsa or Qlreaning
    P = 0;
    while P == 0
        [PSarsa, PQlearn, Qsarsa, Qqlean, rpt_sarsa, rpt_qlearn, n_sarsa, n_qlearn, T_rl, rsarsa, rqlearn] = RL_path_planning(map_matrix_incar,start_matrix,target_matrix);
        if path_planning_method == 2
            P = PSarsa;
        else
            P = PQlearn;
        end
        t_pathplanning = t_pathplanning + T_rl;
    end
else
    % for test only
    P = [24, 2;...
         23, 2;...
         22, 2;...
         22, 1;...
         23, 1;...
         24, 1;...
         24, 2;...
         23, 2;...
         23, 1;...
         24, 1;...
        ];
end
% transfer to XY coordinate system
[i, j] = size(P);
XY = MatrixToXY(P);
plot(XY(1, 1), XY(1, 2), 'o');
hold on;
plot(XY(i, 1), XY(i, 2), '*');
hold on;
plot(XY(:, 1), XY(:, 2));
hold on;
axis([0, 24, 0, 24]);
for t = linspace(0, 300, 3001)
    if t == 0
        % initial conditions
        x = XY(n, m);
        y = XY(n, m+1);
        phi = 0;
        omega = 0;
        x_des = x;
        y_des = y;
        phi_des = 0;
        omega_des = 0;
        x0 = x;
        y0 = y;
    end
    A = directionController([x; y; phi; omega; x_des; y_des; omega_des; t]);
    B = omegaController(A);
    C = dynamics(B);
    drawVehicle([C(1); C(2); C(3); t]);
    plot([x0, x],[y0, y], 'k', 'LineWidth', 2);
    hold on;
    map_matrix = drawNewObstacle(t, map_matrix);                  % draw new obstacles and update the map matrix
    if A(9) == 3                                                  % if arrive a next point, detect arrounding
        for a = P(n, m)-1 : P(n, m)+1
            for b=P(n, m+1)-1 : P(n, m+1)+1
                if a<1 || a>24 || b<1 || b>24
                    continue;
                else
                    map_matrix_incar(a, b) = map_matrix(a, b);    % update the map matrix in the car
                end
            end
        end
        dis_total = dis_total+1;
        n = n+1;
        if n>i
            break;
        end
        if map_matrix_incar(P(n, m), P(n, m+1)) == -1 || map_matrix_incar(P(min(n+1,i), m), P(min(n+1,i), m+1)) == -1
            start_matrix = [P(n-1, m), P(n-1, m+1)];
            if path_planning_method == 1
                % using A*
                [P,T_astar] = A_star(map_matrix_incar,start_matrix,target_matrix);
                t_pathplanning = t_pathplanning + T_astar;
            elseif path_planning_method == 2 || path_planning_method == 3
                % using Sarsa or Qlreaning
                P = 0;
                while P == 0
                    [PSarsa, PQlearn, Qsarsa, Qqlean, rpt_sarsa, rpt_qlearn, n_sarsa, n_qlearn, T_rl, rsarsa, rqlearn] = RL_path_planning(map_matrix_incar,start_matrix,target_matrix);
                    if path_planning_method == 2
                        P = PSarsa;
                    else
                        P = PQlearn;
                    end
                    t_pathplanning = t_pathplanning + T_rl;
                end
            end
            [i, j] = size(P);
            XY = MatrixToXY(P);
            plot(XY(:, 1), XY(:, 2));
            axis([0, 24, 0, 24]);
            hold on;
            n = 2;
        end
        x_des = XY(n, m);
        y_des = XY(n, m+1);
    end
    x0 = x;
    y0 = y;
    x = C(1);
    y = C(2);
    phi = C(3);
    omega = C(4);
end
t_total = t + t_pathplanning;
