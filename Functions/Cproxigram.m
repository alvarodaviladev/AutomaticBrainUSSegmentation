function [Distancias,puntosIn,puntosOut]=Cproxigram(Data,DT)
%Calcula la distancias de los datos Data(N*3) a la superficie descrita en por 
%el area convexa la Triangulacion de Delaunay DT= delaunayTriangulation(x,y,z)
tseg=clock;
[S,A] = convexHull(DT);
%[mx,my,mz] Punto central de la superficia convexa
mx = mean(DT.Points(S,1));
my = mean(DT.Points(S,2));
mz = mean(DT.Points(S,3));

%P=puntos que forman la superficie convexa
P=[DT.Points(:,1),DT.Points(:,2),DT.Points(:,3)];
[puntosIn,puntosOut]=Clasifica(Data,P,A);

Distancias=ones(size(Data,1),1)*1000000;

%Calculo de la distancia de los puntos interiores a la superficie
if ~isempty(puntosIn)
 for i1=1:size(S,1)
   if rem(i1,5)==0
        disp(['Distancias interiores=',num2str(i1),' Tiempo= ',num2str(etime(clock,tseg)/60)])
   end
   P=[DT.Points(S(i1,:),1),DT.Points(S(i1,:),2),DT.Points(S(i1,:),3)];
   [A,B,C,D]=calcula_plano(P(1,:),P(2,:),P(3,:));
   Distancias(puntosIn)=min(Distancias(puntosIn),abs(distancia_plano(Data(puntosIn,:),A,B,C,D)));
 end
%Las distancias interiore son negativas
Distancias(puntosIn)=-Distancias(puntosIn);  
end


%Calculo de la distancia de los puntos exteriores a la superficie

Dataaux=Data(puntosOut,:);
Daux=1000000*ones(length(puntosOut),1);
centros=repmat([mx my mz],length(puntosOut),1);
DCentroPuntos=abs(pdist2([mx,my,mz],Dataaux))';

for i1=1:size(S,1)
    if rem(i1,5)==0
        disp(['Distancias exteriores=',num2str(i1),' Tiempo= ',num2str(etime(clock,tseg)/60)])
    end
 P=[DT.Points(S(i1,:),1),DT.Points(S(i1,:),2),DT.Points(S(i1,:),3)];
 [A,B,C,D]=calcula_plano(P(1,:),P(2,:),P(3,:));
 %Distancia puntos exteriores
 [x1,y1,z1]  = puntodecorteRyP(centros,Dataaux,A,B,C,D);
 [Pin,Pout]  = esinterior([x1 y1 z1],[P(1,:);P(2,:);P(3,:)]);
 DPuntoCorte = modulo(Dataaux(Pin,:),[x1(Pin),y1(Pin),z1(Pin)]);
 Daux(Pin)=min(Daux(Pin),DPuntoCorte);
end

Distancias(puntosOut)=Daux;



%%%%%%%%%%%%%%%%%%%%%%%%% FUNCIONES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pin,pout]=Clasifica(Data,P,Area)
%Clasifica los puntos de Data en interiores o exteriores a la superficie
%determinada por los puntos P
Vol=size(Data,1);
time=clock;
for i=1:size(Data,1)
    p1=[P;Data(i,:)];
    DT1 = delaunayTriangulation(p1(:,1),p1(:,2),p1(:,3));
    [K1,Vol(i)] = convexHull(DT1);
    if rem(i,5000)==0
        disp(['Puntos Interiores = ',num2str(i),' Tiempo= ',num2str(etime(clock,time)/60)]);
    end
 end
Area=repmat(Area,1,length(Vol));
diferencia=abs(Area-Vol);
% pin=find(diferencia<=0.001);
% pout=find(diferencia>0.001);
pin=find(round(Vol,2)>round(Area,2));
pout=find(round(Vol,2)<=round(Area,2));

end


function [A B C D]=calcula_plano(p1,p2,p3)
%calcula ecuacion del plano Ax+By+Cz+D=0, datos tres puntos.

A1=p2(1)-p1(1);
A2=p2(2)-p1(2);
A3=p2(3)-p1(3);
B1=p3(1)-p1(1);
B2=p3(2)-p1(2);
B3=p3(3)-p1(3);

A=A2*B3-B2*A3;
B=A3*B1-A1*B3;
C=B2*A1-A2*B1;
D=p1(1)*(B2*A3-A2*B3)+p1(2)*(A1*B3-A3*B1)+p1(3)*(A2*B1-B2*A1);
end

function D=distancia_plano(V,A,B,C,D)
%calcula la distancia del vector de puntos al plano
% A B C D parametros del plano Ax+By+Cz+D=0
%V vector 3*N
[Npuntos,kk]=size(V);
D=V(:,1)*A+V(:,2)*B+V(:,3)*C+D*ones(Npuntos,1);
D=D/sqrt(A*A+B*B+C*C);
end

function [x1,y1,z1]=puntodecorteRyP(P1,P2,A,B,C,D)
%calcula el punto de corte de una recta dada por dos puntos P1 y P2
%y un plano Ax+By+Cz+D=0

V=P1-P2; %Vector director de la recta
% Si el angulo del vector director y la normal del plano es 90% las rectas
% son paralelas. En este caso devuelve inf

K=-(A.*P1(:,1)+B.*P1(:,2)+C.*P1(:,3)+D)./(A*V(:,1)+B*V(:,2)+C*V(:,3));
x1=P1(:,1)+V(:,1).*K;
y1=P1(:,2)+V(:,2).*K;
z1=P1(:,3)+V(:,3).*K;

end

function [puntosIn,puntosOut]=esinterior(Puntos,Triangulo)
%Determina el conjunto de puntos 3D que son interiores al Triangulo
%Puntos: matriz de puntos M=[X,Y,Z](Nx3)
%Triangulo: Matriz con los puntos que forman el Triangulo M=[X,Y,Z](Nx3)
%PuntosIn: Posiciones de los puntos interiores
%PuntosOut: Posiciones de los puntos exteriores

Npuntos=size(Puntos,1);
Vol = zeros(1,Npuntos);
Area=AreaT(Triangulo);
for i=1:Npuntos
   a1=AreaT([Puntos(i,:);Triangulo(1,:);Triangulo(2,:)]);
   a2=AreaT([Puntos(i,:);Triangulo(2,:);Triangulo(3,:)]);
   a3=AreaT([Puntos(i,:);Triangulo(3,:);Triangulo(1,:)]);
   Vol(i)=a1+a2+a3;
end
Area=repmat(Area,1,length(Vol));
diferencia=abs(Area-Vol);
puntosIn=find(diferencia<=0.001);
puntosOut=find(diferencia>0.001);
end

function A=AreaT(T)
    a=norm(T(1,:)-T(2,:));
    b=norm(T(1,:)-T(3,:));
    c=norm(T(2,:)-T(3,:));
    p=(a+b+c)/2;
    A=sqrt(p*(p-a)*(p-b)*(p-c));
end

function D=modulo(X,Y)
    D=sqrt(sum((X-Y).^2,2));
end
end
