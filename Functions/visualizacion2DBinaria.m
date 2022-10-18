function visualizacion2DBinaria(V2, tamVisualizacion,is,spacings)

%=============================PARAMETERS===================================
%is = 0.55;                  % isosurface (0<=is<=1)
%==========================================================================

p = patch(isosurface(V2,is));
isonormals(V2,p)
p.FaceColor = 'red';
p.EdgeColor = 'none';
view(3); 

axis tight
camlight 
%lighting phong;
lightangle(-30,30);
camproj('perspective');
lighting gouraud
rotate3d on
box on
grid on
daspect(tamVisualizacion);    

p = rotate3d;

xlabel('x (cm)');
ylabel('y (cm)');
zlabel('z (cm)');
axis([1,size(V2,2),1,size(V2,1),1,size(V2,3)])

if min(size(V2))<100
     salto=5;
else
    salto=10;
end

step=salto./spacings;
set(gca,'YTick',[0:step(1):size(V2,1)],...
    'YTickLabel',[0:salto:size(V2,1)*spacings(1)]./10)
set(gca,'ZTick',[0:step(3):size(V2,3)],...
    'ZTickLabel',[0:salto:size(V2,3)*spacings(3)]./10)
set(gca,'XTick',[0:step(2):size(V2,2)],...
    'XTickLabel',[0:salto:size(V2,2)*spacings(2)]./10)
p = rotate3d;


