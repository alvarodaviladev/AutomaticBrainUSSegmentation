
% Calculamos la composicion en cada cubo

clear all
close all
fich='COMPOSICION_cluster85'; 

load(fich) 
if (size(x,1)==1)
  x=x'; y=y';z=z';  
end

ind=find(C2(:)>0.105);
indc=ind;
%ind=find(C2(:)>mean(C2(:)) & X>-11 & X<11 & Y>-11 & Y<11 & Z>-11 & Z<11 );

figure,scatter3(X(ind),Y(ind),Z(ind),500*C2(ind),C2(ind),'filled');
title('%In','FontSize',14)
axis equal
axis([-45,10,-90,-45,55,105])
colorbar
x1=X(ind); 
y1=Y(ind);
z1=Z(ind);
DT = delaunayTriangulation(x1,y1,z1);
[K,Area] = convexHull(DT);
%en K tenemos los puntos que están en la superficie de la figura,
% en (mx, my, mz) el centro de la supercicie
mx = mean(DT.Points(K,1));
my = mean(DT.Points(K,2));
mz = mean(DT.Points(K,3));
trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','none')
axis([min(x),max(x),min(y),max(y),min(z),max(z)]),axis equal
% figure,
 faceColor  = [0.6875 0.8750 0.8984];
% tetramesh(DT,'FaceColor',faceColor,'FaceAlpha',0.3);

%Calculo puntos interiores y exteriores a la superficie

%reduzco los puntos para probar
ind=find(x>=min(X(:)) & x<=max(X(:)) & ...
         y>=min(Y(:)) & y<=max(Y(:)) & ...
         z>=min(Z(:)) & z<=max(Z(:)) );
x=x(ind);
y=y(ind);
z=z(ind);
tipo=tipo(ind);
[Distancias,PI,PO]=Cproxigram([x y z],DT);

save proxigram_cluster85
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
ind=find(Distancias~=1000000);
Distancias=Distancias(ind);
x=x(ind);y=y(ind),z=z(ind);
tipo=tipo(ind);


[a,b]=hist(Distancias,min(Distancias):15:max(Distancias));
Natomos=zeros(length(b)-1,3);
Error=zeros(length(b)-1,3);
C=[];
%    tetramesh(DT,'FaceColor',faceColor,'FaceAlpha',0.3);
 
for i=1:length(b)-1
    b(i)
    ind=find(Distancias>=b(i) & Distancias<b(i+1));
      
    figure,
    scatter3(DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),500*C2(indcluster),C2(indcluster),'filled');
    hold on
   %plot3(DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'*')
    axis([0,100,0,100,0,280]);
    grid
    plot3(x(ind),y(ind),z(ind),'.');
    pause
    close
    [a1,kk]=hist(tipo(ind),[1 2 3]);
    C(i,:)=a1./sum(a1);
    Error(i,:)=sqrt(C(i,:).*(1-C(i,:))/sum(a1));
end
    
figure,
errorbar(b(2:end-2)+4,C(2:end-1,1),Error(2:end-1,1),'r','LineWidth',3),hold on;
errorbar(b(2:end-2)+4,C(2:end-1,2),Error(2:end-1,2),'k','LineWidth',3)
errorbar(b(2:end-2)+4,C(2:end-1,3),Error(2:end-1,3),'b','LineWidth',3)
set(gca,'FontSize',14)
legend('In','Ga','As')
xlabel('Proximity to interface (Angstrom)')
ylabel('Layer Atomic Fraction')
grid


