function [MASK]=elipse_mask(aux,ellipse_t)
   %Dada la ecuación paramétrica de una elipse, calcula la ecuación general
   % y devuelve una mascara formada con el interior de la elipse a 1
   
    [X,Y]=meshgrid(1:size(aux,2),1:size(aux,1));
    X=X(:); Y=Y(:);
    a=ellipse_t.a;
    b=ellipse_t.b;
    cx=ellipse_t.X0_in;
    cy=ellipse_t.Y0_in;
    A=b^2;
    C=a^2;
    D=-2*b^2*cx;
    E=-2*a^2*cy;
    F=a^2*cy^2 + b^2*cx^2 - a^2*b^2;
    S=A*X.^2 + C*Y.^2 + D*X + E*Y + F;  %Ecuación general de una elipse
    ind=find(S<=0);
    %Rotamos la elipse respecto del punto (0,0)
    phi=ellipse_t.phi;
    R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ]; 
    X1=X(ind)-cx; %trasladamos al origen
    Y1=Y(ind)-cy;
    DATA=[X1,Y1];
    RD = R * DATA';  %Rotamos
    RD1=RD(1,:)+cx; %volvemos a su posición inicial
    RD2=RD(2,:)+cy;
    MASK=aux*0;
    ind1=find(RD2>=1 & RD2<size(aux,1) & (RD1>=1&RD1<size(aux,2)));
    ind=sub2ind(size(aux),round(RD2(ind1)),round(RD1(ind1)));
    MASK(ind)=1;
    MASK=imclose(MASK,ones(3,3));
    