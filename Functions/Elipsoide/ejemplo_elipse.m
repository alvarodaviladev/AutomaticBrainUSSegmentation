close all 
clc

func_dir=pwd;
addpath(fullfile(func_dir, 'Frangi'));

options.BlackWhite=false;
options.FrangiScaleRatio=2;
options.FrangiScaleRange=[1 6];
options.FrangiAlpha=0.9;
options.FrangiBeta = 15;
options.FrangiC= 24;
options.verbose=0;
 V=Info.rdata;
 med=round(size(V,1)/2);
Im=squeeze(V(med,:,:));
 Im=medfilt2(Im);
 figure,imshow(Im,[])
 Im1 = FrangiFilter2D(Im,options); 
 %figure,imshow(Im1,[])
 Im2 = imsegkmeans(uint16(Im1),2);
 %figure,imshow(Im2==2,[])
 ind=find(Im2==2);
 [y,x] = ind2sub(size(Im2),ind);
 ellipse_t = fit_ellipse( x,y );
 %figure,imshow(Im,[])
 %[x_e,y_e]=draw_elipse(ellipse_t,1);

 h1 = drawellipse('Center',[ellipse_t.X0_in,ellipse_t.Y0_in],'SemiAxes',[(ellipse_t.a*0.8),(ellipse_t.b*0.8)],'StripeColor','r');
 h2 = drawellipse('Center',[ellipse_t.X0_in,ellipse_t.Y0_in],'SemiAxes',[(ellipse_t.a*1.2),(ellipse_t.b*1.2)],'StripeColor','r');

 mask_interior = createMask(h1);
figure, imshow(mask_interior,[]);
 mask_exterior = ~createMask(h2);
figure, imshow(mask_exterior,[]);


