function [x1,y1,z1]=calculaPuntosElipsoide(center, radii,M,min, max)
%Devuelve los puntos del volumen M que están a una distancia entre [min
%max] del elipsoide dado en [center radii]

I=(M==1);
xo=center(1);
yo=center(2);
zo=center(3);
a=radii(1);
b=radii(2);
c=radii(3);

[x,y,z]=meshgrid(1:size(M,2),1:size(M,1),1:size(M,3));
E=(((x-xo).^2)/(a*a)) + ((y-yo).^2)/(b*b) + ((z-zo).^2)/(c*c);
ind=find((E>=min & E<=max & I==1)); 
[y1,x1,z1]=ind2sub(size(I),ind);
ind=find((abs(E-1)<0.01));
[y2,x2,z2]=ind2sub(size(I),ind);
y1=[y1;y2;y2;y2];
x1=[x1;x2;x2;x2];
z1=[z1;z2;z2;z2];






