function E=genera_elipsoide(V)

 E=0*V;
[x,y,z]=ind2sub(size(V),find(V>0));
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit( [x y z],'' );
[x1,y1,z1,ind]=puntos_ellipsoide(size(V),center, radii, v,1, 1e3);
ind=sub2ind(size(E),x1,y1,z1);
E(ind)=1;