function [x_e,y_e]=draw_elipse(E,pinta)
a=E.a;
b=E.b;
phi=E.phi;
X0=E.X0;
Y0=E.Y0;
X0_in=E.X0_in;
Y0_in=E.Y0_in;
long_axis=E.long_axis;
short_axis=E.short_axis;

 R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];
 ver_line        = [ [X0 X0]; Y0+b*[-1 1] ];
 horz_line       = [ X0+a*[-1 1]; [Y0 Y0] ];
 new_ver_line    = R*ver_line;
 new_horz_line   = R*horz_line; 
 % the ellipse
 theta_r         = linspace(0,2*pi,1000);
 ellipse_x_r     = X0 + a*cos( theta_r );
 ellipse_y_r     = Y0 + b*sin( theta_r );
 rotated_ellipse = R * [ellipse_x_r;ellipse_y_r];
 x_e=rotated_ellipse(1,:);
 y_e=rotated_ellipse(2,:);
 if pinta
    plot( new_ver_line(1,:),new_ver_line(2,:),'r' );
    plot( new_horz_line(1,:),new_horz_line(2,:),'r' );
    plot(x_e,y_e,'r' );
 end
 
  