load('2020_12_03_Mia PehrsonSDB.mat')
Vcon=B;%Info.Iconv;
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

s   = regionprops3(logical(VIM),VIM,"VoxelList","Volume","VoxelIdxList");
[kk,or]=sort(s.Volume,'descend');
VSEG=0*LABEL;
for i=1:50
    idx = s.VoxelIdxList{or(i)};
    VSEG(idx)=1;
end
save kk VSEG

 figure,
 
 plot3(x,y,z,'.');
 axis equal
 


