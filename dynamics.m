function output=dynamics(uu)
    persistent x;
    persistent y;
    persistent phi;
    persistent omega;
    persistent flag;
    persistent t0;
    x=uu(1);
    y=uu(2);
    phi=uu(3);
    omega=uu(4);
    flag=uu(5);
    t=uu(6);
    D=0.6;
    L=0.65;
    if t==0
        t0=t;
    end
    if flag==0
        %x=x;
        %y=y;
        phi=phi+omega*(t-t0)*D/L;
    elseif flag==1
        x=x+omega*(t-t0)*D/2;
        %y=y;
        %phi=phi;
    elseif flag==2
        %x=x;
        y=y+omega*(t-t0)*D/2;
        %phi=phi;
    else
        %x=x;
        %y=y;
        %phi=phi;
    end
    t0=t;
    output=[x; y; phi; omega];
end