function output=directionController(uu)
    persistent x;
    persistent y;
    persistent phi;
    persistent omega;
    persistent x_des;
    persistent y_des;
    persistent phi_des;
    persistent omega_des;
    x=uu(1);
    y=uu(2);
    phi=uu(3);
    omega=uu(4);
    x_des=uu(5);
    y_des=uu(6);
    omega_des=uu(7);
    t=uu(8);
    while phi>pi
        phi=phi-2*pi;
    end
    while phi<=-pi
        phi=phi+2*pi;
    end
    if x<x_des-0.01                                  % need to adjust the error
        phi_des=-pi/2;
        if phi>phi_des+0.015 || phi<phi_des-0.015
            flag=0;
        else
            flag=1;
        end
    elseif x>x_des+0.01                              % need to adjust the error
        phi_des=pi/2;
        if phi>phi_des+0.015 || phi<phi_des-0.015
            flag=0;
        else
            flag=1;
        end
    elseif y<y_des-0.01                              % need to adjust the error
        phi_des=0;
        if phi>phi_des+0.015 || phi<phi_des-0.015
            flag=0;
        else
            flag=2;
        end
    elseif y>y_des+0.01                              % need to adjust the error
        if phi<0
            phi_des=-pi;
            if phi>phi_des+0.015 && phi<-phi_des-0.015
                flag=0;
            else
                flag=2;
            end
        else
            phi_des=pi;
            if phi>-phi_des+0.015 && phi<phi_des-0.015
                flag=0;
            else
                flag=2;
            end
        end
    else
        phi_des=phi;
        omega_des=0;
        flag=3;
    end
    output=[x; y; phi; omega; x_des; y_des; phi_des; omega_des; flag; t];
end