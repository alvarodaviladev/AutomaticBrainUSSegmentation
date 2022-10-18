function E=genera_ellipsoide(DIM,center, radii, v)
% mind = min( [ x y z ] );
% maxd = max( [ x y z ] );
mind = [1 1 1] ;
maxd = DIM;
nsteps = 400;
step = ( maxd - mind ) / nsteps;
%[ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ), linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ), linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
[ x, y, z ] = meshgrid(1:maxd(2),1:maxd(1),1:maxd(3));
Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
          2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
          2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
ind=find(Ellipsoid<1);
E=zeros(DIM);
E(ind)=1;


