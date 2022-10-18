function V1=recorta(V)
% Disminuye la dimensión del volumen eliminando los extremos en donde no
% está el cerebro
% V=Info.data;
% V=(V>20).*V;
%Dimension 1
Vs=V>max(V(:))/3;

Myz=(squeeze(sum(Vs,1))>0);
s=sum(Myz,2);
ind=find(s~=0);
ymin=max([1,ind(1)]);
ymax=min([ind(end),size(Vs,2)]);
s=sum(Myz,1);
ind=find(s~=0);
zmin=max([1,ind(1)]);
zmax=min([ind(end),size(Vs,3)]);

Mxz=(squeeze(sum(Vs,2))>0);
s=sum(Mxz,2);
ind=find(s~=0);
xmin=max([1,ind(1)]);
xmax=min([ind(end),size(Vs,1)]);

V1=V(xmin:xmax,ymin:ymax,zmin:zmax);

