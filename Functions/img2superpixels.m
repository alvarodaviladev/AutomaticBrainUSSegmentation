function Vs=img2superpixels(V,N)

Vs=0*V;
for i=1:size(V,1)
  img=int16(squeeze(V(i,:,:)));
  [Vs(i,:,:),NUM] = superpixels(img,N);
  idx = label2idx(Vs(i,:,:));
  aux=0*img;
  for j=1:NUM    
     aux(idx{j})=median(img(idx{j}));
  end
  Vs(i,:,:)=aux;
end
 

