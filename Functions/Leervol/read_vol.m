function [A,meta,filteredA] = read_vol(filename)
%  READ_VOL - Lectura de ficheros en el formato GE Kretzfile 1.0 cartesiano
%
%  [A,metadata,filteredA] = read_vol(filename)
%
%  La orientacion de A es:   A(coronal,sagittal,axial)
%                      Ej:   squeeze(A(20,:,:))  es la vigesima imagen coronal 
%  filteredA son los datos filtrados, a veces presentes en el fichero
%            original


%  (c) Pedro L. Galindo
%      University of Cadiz, SPAIN,
%      Abril 2021

A=[];
filteredA=[];
meta=[];

fp = fopen(filename,'rb');

meta.FILETYPE = fread(fp,16,'char=>char')';

TagGroup=0;
while TagGroup~=65535
    
  TagGroup     = fread(fp,1,'uint16');
  TagElement   = fread(fp,1,'uint16'); 
  ItemDataSize = fread(fp,1,'uint32');
    
  % disp([dec2hex(TagGroup) '-' dec2hex(TagElement) ' - ' num2str(ItemDataSize)])
  
  data         = fread(fp,ItemDataSize,'uint8=>uint8')';  
  
  if TagGroup == hex2dec('0010') && TagElement == hex2dec('0022')
      meta.MMperPIXEL = typecast(data,'double');
  end
  
  if TagGroup == hex2dec('0110') && TagElement == hex2dec('0001')        
      meta.PACIENTE_ID = char(data);
  end
  
  if TagGroup == hex2dec('0110') && TagElement == hex2dec('0002')      
      meta.PACIENTE = char(data);
  end
  
  if TagGroup == hex2dec('0120') && TagElement == hex2dec('0001')
      meta.HOSPITAL = char(data);
  end
  
  if TagGroup == hex2dec('0130') && TagElement == hex2dec('0001')     
      meta.SONDA = char(data(1:end-1));
  end

  if TagGroup == hex2dec('0140') && TagElement == hex2dec('0002')        
      meta.MARCA = char(data);
  end
    
  if TagGroup == hex2dec('0140') && TagElement == hex2dec('0003')        
      meta.FECHA = datestr(datevec(char(data),'yyyymmdd'),'yyyy-mm-dd');
  end
  
  if TagGroup == hex2dec('0140') && TagElement == hex2dec('0004')              
      meta.COMMENT1 = char(data);
  end
  
  if TagGroup == hex2dec('0150') && TagElement == hex2dec('001B')              
      meta.COMMENT2 = char(data);      
  end

  if TagGroup == hex2dec('0150') && TagElement == hex2dec('0029')              
      meta.MODELO_ECOGRAFO = char(data);
  end
  
  if TagGroup == hex2dec('0150') && TagElement == hex2dec('002A')              
      meta.COMMENT3 = char(data);            
  end
  
  if TagGroup == hex2dec('C000') && TagElement == hex2dec('0001')
      meta.SIZEX = typecast(data,'uint16');
  end
  
  if TagGroup == hex2dec('C000') && TagElement == hex2dec('0002')
      meta.SIZEY = typecast(data,'uint16');
  end
  
  if TagGroup == hex2dec('C000') && TagElement == hex2dec('0003')
      meta.SIZEZ = typecast(data,'uint16');
  end
  
  if TagGroup == hex2dec('C100') && TagElement == hex2dec('0001')
      meta.RADIAL_RESOLUTION = typecast(data,'double')*1000;
  end
  
  if TagGroup == hex2dec('C200') && TagElement == hex2dec('0001')
      meta.Offset1 = typecast(data,'double');
  end
  
  if TagGroup == hex2dec('C200') && TagElement == hex2dec('0002')
      meta.Offset2 = typecast(data,'double');
  end
  
  if TagGroup == hex2dec('C300') && TagElement == hex2dec('0001')
      meta.AnglesPhi = typecast(data,'double');      
  end
  
  if TagGroup == hex2dec('C300') && TagElement == hex2dec('0002')
      meta.AnglesTheta = typecast(data,'double');      
  end
    
  if TagGroup == hex2dec('D000') && TagElement == hex2dec('0001')
      A = reshape(data,[meta.SIZEX,meta.SIZEY,meta.SIZEZ]);
      A = permute(A,[2 1 3]);       
  end

  if TagGroup == hex2dec('D000') && TagElement == hex2dec('0002')  
      filteredA = reshape(data,[meta.SIZEX,meta.SIZEY,meta.SIZEZ]);
      filteredA = permute(filteredA,[2 1 3]);      
  end
  
%   if TagGroup == hex2dec('D100') && TagElement == hex2dec('0002')  
%       plot(data)
%       pause
%   end

end

fclose(fp);

nombres = fieldnames(meta);
for i=1:length(nombres)
    aux = meta.(nombres{i});
    if ischar(aux)        
        % Quitamos los ceros finales
        ind = find(aux~=0);
        aux = aux(1:ind(end));
        meta.(nombres{i}) = aux;
        
        % Cambiamos los ^ por coma 
        ind = find(aux==94);
        aux(ind)=44;
        meta.(nombres{i}) = aux;        
        
        % Cambiamos los  por ., etc.
        ind = find(aux==153);
        aux(ind)=8482; % 58;
        meta.(nombres{i}) = aux;        

        % Cambiamos el TM
        ind = find(aux==2);
        aux(ind)=46;
        meta.(nombres{i}) = aux;        
        
    end
end
