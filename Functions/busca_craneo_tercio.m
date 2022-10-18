function [Craneo]=busca_craneo_tercio(V)


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
for i=1:size(V,3)
    img=squeeze(V(:,:,i));
    A = FrangiFilter2D(img,options); 
    A=imadjust(A);
    Threshold    = multithresh(A,2);
    A = imhmin(A,Threshold(2));
    kk = A>Threshold(2);
    Vsegz(:,:,i)= kk;
end
Vsegy=0*V;
for i=1:size(V,2)
    img=squeeze(V(:,i,:));
    A = FrangiFilter2D(img,options); 
    A=imadjust(A);
    Threshold    = multithresh(A,2);
    A = imhmin(A,Threshold(2));
    kk = A>Threshold(2);
    Vsegy(:,i,:)= kk;
end

Vc=Vsegx+Vsegy+Vsegz;
DIM=round(size(V)*0.2);
MASK=V>0;
MASK=imerode(MASK,strel('cuboid',DIM));
MASK(1:DIM(1),:,:)=0;
MASK(end-DIM(1):end,:,:)=0;
MASK(:,1:DIM(2),:)=0;
MASK(:,end-DIM(2):end,:)=0;
MASK(:,:,1:DIM(3))=0;
MASK(:,:,end-DIM(3):end)=0;
Vc=(Vc>1).*MASK;
s=regionprops3(Vc>0,Vc,"Volume",'VoxelIdxList');
[vol,or]=sort(s.Volume,'descend');
IDX=s.VoxelIdxList(or);
 Craneo=0*Vc;
 Craneo(IDX{1})=1;


