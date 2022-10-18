function [Cerebro,Craneo]=busca_craneo(V)
color = [255 0 0];
mapa = jet(256);
filter_size = [3 3];

 options.BlackWhite=false;
 options.FrangiScaleRatio=2;
 options.FrangiScaleRange=[1 6];
 options.FrangiAlpha=0.9;
 options.FrangiBeta = 15;
 options.FrangiC= 24;
 options.verbose=0;
 
Vsegx=0*V;
for i=1:size(V,1)
    img=squeeze(V(i,:,:));
    A = FrangiFilter2D(img,options); 
    A=imadjust(A);
    Threshold    = multithresh(A,2);
    A = imhmin(A,Threshold(2));
    kk = A>Threshold(2);
    Vsegx(i,:,:)= kk;
end
 Vsegz=0*V;
% for i=1:size(V,3)
%     img=squeeze(V(:,:,i));
%     A = FrangiFilter2D(img,options); 
%     A=imadjust(A);
%     Threshold    = multithresh(A,2);
%     A = imhmin(A,Threshold(2));
%     kk = A>Threshold(2);
%     Vsegz(:,:,i)= kk;
% end
 Vsegy=0*V;
% for i=1:size(V,2)
%     img=squeeze(V(:,i,:));
%     A = FrangiFilter2D(img,options); 
%     A=imadjust(A);
%     Threshold    = multithresh(A,2);
%     A = imhmin(A,Threshold(2));
%     kk = A>Threshold(2);
%     Vsegy(:,i,:)= kk;
% end

Vc=Vsegx+Vsegy+Vsegz;

MASK=V>0;
MASK=imerode(MASK,strel('cuboid',[20,20,20]));
MASK(1:20,:,:)=0;
MASK(end-20:end,:,:)=0;
MASK(:,1:20,:)=0;
MASK(:,end-20:end,:)=0;
MASK(:,:,1:20)=0;
MASK(:,:,end-20:end)=0;
Vc=(Vc>0.5).*MASK;
s=regionprops3(Vc>0,Vc,"Volume",'VoxelIdxList');
[vol,or]=sort(s.Volume,'descend');
 ind=find(vol>prctile(vol,80) & vol<prctile(vol,95));
 Cerebro=0*Vc;
 for i=1:length(ind)
     Cerebro(s.VoxelIdxList{or(ind(i))})=1;
 end
 ind=find(vol>=prctile(vol,99));

Craneo=0*Vc;

  if vol(1)>100000
      Craneo(s.VoxelIdxList{or(1)})=1;
  else
      for i=1:3
        Craneo(s.VoxelIdxList{or(i)})=1;
      end
  end
 
%  figure,volshow(Cerebro)
% figure,volshow(Craneo)

  

