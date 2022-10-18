function [VCON,VSEG]=preprocesa(M)

    time=0.05;
    f = waitbar(time,'Espere... procesando');
    Mc = imgaussfilt3(M); 
    options.BlackWhite=false;
    options.FrangiScaleRatio=2;
    options.FrangiScaleRange=[1 6];
    options.FrangiAlpha=0.9;
    options.FrangiBetaTwo = 15;
    options.verbose=0;
    time=0.1;
    
  for j=1:1
    time=time+0.15;   
    waitbar(time,f,'Espere...  procesando la imagen');
    Fz=0*Mc;
    for i=1:size(Mc,3)
         Fz(:,:,i)=FrangiFilter2D(Mc(:,:,i),options);
    end
     time=time+0.15; 
     waitbar(time,f,'Espere...  procesando la imagen');
     Fy=0*Mc;
     for i=1:size(Mc,2)
         Fy(:,i,:)=FrangiFilter2D(squeeze(Mc(:,i,:)),options);
     end
     time=time+0.15; 
     waitbar(time,f,'Espere...  procesando la imagen');
     Fx=0*Mc;
     for i=1:size(Mc,1)
         Fx(i,:,:)=FrangiFilter2D(squeeze(Mc(i,:,:)),options);
     end
   Mc=max(Fx,Fy);
   Mc=max(Mc,Fz);
   Mc=255*Mc;
  end  VCON=Mc;
  VSEG=0*VCON;
  close(f)
end
        