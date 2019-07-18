function output=MatrixToXY(P)
    [n,m]=size(P);
    XY=zeros(n,m);
    for i=1:n
        x=P(i,m)*1-0.5;
        y=(24-P(i,m-1))*1+0.5;
        XY(i,m-1)=x;
        XY(i,m)=y;
    end
    output=XY;
end