%load('2020_12_03_Mia PehrsonSDB.mat')
Vcon=Info.Iconv;
options.BlackWhite=false;
options.FrangiScaleRatio=2;
options.FrangiScaleRange=[1 6];
options.FrangiAlpha=0.9;
options.FrangiBetaTwo = 15;
options.verbose=0;
Fy=0*Vcon;
for i=1:size(Vcon,2)
    i
    Fy(:,i,:)=FrangiFilter2D(squeeze(Vcon(:,i,:)),options);
end


umbral=prctile(Fy(:),95);
VIM=Fy>umbral;
LABEL=bwlabeln(VIM);
ind=find(LABEL==162);
[x,y,z]=ind2sub(size(LABEL),ind);

s   = regionprops3(logical(VIM),VIM,"Volume","VoxelIdxList",'Centroid');
[kk,or]=sort(s.Volume,'descend');
VSEG=0*LABEL;
dim=size(VIM);
for i=3:100
    idx = s.VoxelIdxList{or(i)};
    centro=s.Centroid(or(i),:);
    if centro(2)<0.6*dim(2)
        VSEG(idx)=1;
    end
end

iterations=100;
lambda=0.2;
rad=10;
[VSEG1,lz] = sfm_local_chanvese(imcomplement(Info.rdata),VSEG,iterations,lambda,rad,0);

save kk VSEG VSEG1

 figure,
 
 plot3(x,y,z,'.');
 axis equal
 


