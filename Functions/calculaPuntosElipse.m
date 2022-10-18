function [x1,y1]=calculaPuntosElipse(pos,I,min,max)

%Devuelve los puntos de la imagen I que están a una distancia entre [min
%max] de la elipse dado en [center radii]

I=squeeze(I);
I=(I==1);
a=pos(3)/2;
b=pos(4)/2;
xo=pos(1)+a;
yo=pos(2)+b;
[x,y]=meshgrid(1:size(I,2),1:size(I,1));
E=(((x-xo).^2)/(a*a)) + (((y-yo).^2)/(b*b));
ind=find(E>=min & E<=max);
[x1,y1]=ind2sub(size(I),ind);
ind=find((abs(E-1)<=0.01));  %Cogemos puntos teóricos de la elipse 
[x2,y2]=ind2sub(size(I),ind);  %y los añadimos dandoles más peso
x1=[x1;x2;x2;x2];
y1=[y1;y2;y2;y2];





