function Info=leervolumen(filename)
%Leer ficheros .nrrd, .nii, .vol(cartesiano)
% ENTRADA
%   filename: Nombre del fichero completo [filepath,name,ext]
% SALIDA
%   [] si no se ha podido leer el volumen
%   Info.name   :   Filemane
%   Info.data   :   data volumen (NxMxH)
%   Info.spacing:   pixel dimension (1x3)

[filepath,name,ext] = fileparts(filename);
 switch lower(ext)
     case '.nrrd'
         R = nhdr_nrrd_read(filename,'true');
         Info.name     = filename;
         Info.data     = double(flipud(rot90(R.data)));
         Info.spacings = R.spacings;
     case '.nii'
         R = niftiinfo(filename);
         V = niftiread(R);
         Info.name     = filename;
         Info.data     = double(V);
         Info.spacings = R.PixelDimensions;
     case '.vol' %  .VOL CARTESIANO
         [A,R,filteredA] = read_vol(filename);
         Info.name     = filename;
         Info.data     = double(A);
         Info.spacings = ones(1,3)*R.MMperPIXEL;
     otherwise
          Info=[];
 end    
end