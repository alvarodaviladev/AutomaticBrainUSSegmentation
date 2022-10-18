function ind=puntos_interiores_ellipsoide(DIM,center, radii, v)

mind = [1 1 1] ;
maxd = max(DIM(:))*ones(1,3);
nsteps = 400;
step = ( maxd - mind ) / nsteps;
[ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ), linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ), linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
          2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
          2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
ind=find(Ellipsoid>1.001);
x=x(ind);
y=y(ind);
z=z(ind);
DATA=[x, y, z];

 DATA=round(DATA);
 ind=find(DATA(:,1)>0 & DATA(:,2)>0 & DATA(:,3)>0 & ...
           DATA(:,1)<DIM(1) & DATA(:,2)<DIM(2) & DATA(:,3)<DIM(3));
 DATA=DATA(ind,:);
 ind=sub2ind(DIM,DATA(:,1),DATA(:,2),DATA(:,3));
