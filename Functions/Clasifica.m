function [pin,pout]=Clasifica(Data,P)
%Clasifica los puntos de Data en interiores o exteriores a la superficie
%determinada por los puntos P
%DT = delaunayTriangulation();
[K1,Volumen] = convhull(P(:,1),P(:,2),P(:,3));

Vol=size(Data,1);
time=clock;
for i=1:size(Data,1)
    p1=[P;Data(i,:)];
    %DT1 = delaunayTriangulation(p1(:,1),p1(:,2),p1(:,3));
    [K1,Vol(i)] = convhull(p1(:,1),p1(:,2),p1(:,3));
    if rem(i,5000)==0
        disp(['Puntos Interiores = ',num2str(i),' Tiempo= ',num2str(etime(clock,time)/60)]);
    end
 end
Volumen=repmat(Volumen,1,length(Vol));
%diferencia=abs(Area-Vol);
% pin=find(diferencia<=0.001);
% pout=find(diferencia>0.001);
pout=find(round(Vol,2)>round(Volumen,2));
pin=find(round(Vol,2)<=round(Volumen,2));

end
