function output=omegaController(uu)
    persistent x;
    persistent y;
    persistent phi;
    persistent omega;
    persistent x_des;
    persistent y_des;
    persistent phi_des;
    persistent omega_des;
    persistent flag;
    x=uu(1);
    y=uu(2);
    phi=uu(3);
    omega=uu(4);
    x_des=uu(5);
    y_des=uu(6);
    phi_des=uu(7);
    omega_des=uu(8);
    flag=uu(9);
    t=uu(10);
    K_p_x=0.5;    % need to adjust
    K_i_x=8;      % need to adjust
    K_p_y=0.5;    % need to adjust
    K_i_y=8;      % need to adjust
    K_p_phi=0.5;    % need to adjust
    K_i_phi=2.5;    % need to adjust 
    omega_max=2;
    if flag==0
        if phi>pi/2 && phi<pi && phi_des==-pi/2
            phi=phi-2*pi;
        end
        omega=K_p_phi*(omega_des-omega)+K_i_phi*(phi_des-phi);
        if omega>omega_max
            omega=omega_max;
        elseif omega<-omega_max
            omega=-omega_max;
        end
    elseif flag==1
        omega=K_p_x*(omega_des-omega)+K_i_x*(x_des-x);
        if omega>omega_max
            omega=omega_max;
        elseif omega<-omega_max
            omega=-omega_max;
        end
    elseif flag==2
        omega=K_p_y*(omega_des-omega)+K_i_y*(y_des-y);
        if omega>omega_max
            omega=omega_max;
        elseif omega<-omega_max
            omega=-omega_max;
        end
    elseif flag==3
        omega=0;
    end
    output=[x; y; phi; omega; flag; t];
end