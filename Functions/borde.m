function BW=borde(V)
BW=0*V;
for i=1:size(V,1)
    BW(i,:,:)=bwperim(squeeze(V(i,:,:)));    
end