function  E=fit_elipsoid_craneal(Vcraneal)
E=0*Vcraneal;
[x,y,z]=ind2sub(size(Vcraneal),find(Vcraneal>0));
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit( [x y z],'' );
[x1,y1,z1,ind]=puntos_ellipsoide(size(Vcraneal),center, radii, v,1, 1e3);
ind=sub2ind(size(E),x1,y1,z1);
E(ind)=1;
% ind=find(E>0);
% [x1,y1,z1]=ind2sub(size(E),ind);
% pinta_ellipsoid(x,y,z,center, radii, evecs, v, chi2)
% hold on,plot3(x1,y1,z1,'.m')

