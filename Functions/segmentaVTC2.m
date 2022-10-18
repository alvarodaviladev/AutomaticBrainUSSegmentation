function [VSEG]=segmentaVTC2(VOL,net)

f = waitbar(0,'\fontsize{12}Calculando volumen. Espere');
V=medfilt3(VOL,[3,3,3]);
DIM=size(V);
V=permute(V,[2,3,1]);
V=imresize3(V,[200,200,size(V,3)]);
Vseg=categorical(zeros(size(V)));
for j=2:size(V,3)-1
       f = waitbar(j/size(V,3),f,'\fontsize{12}Calculando volumen. Espere');
       image=squeeze(V(:,:,j-1:j+1));
       C = semanticseg(image, net);
       Vseg(:,:,j)= C;
end 
close(f)

VSEG=imresize3(permute(Vseg,[3,1,2]),DIM,'nearest');

%VSEG=imerode(VSEG=='cerebro',ones(5,5,5));

stats = regionprops3(VSEG=='cerebro','Volume','VoxelIdxList','PrincipalAxisLength','BoundingBox');
[~,or]=sort(stats.Volume,'descend');
for i=2:length(or)
    VSEG(stats.VoxelIdxList{or(i)})='fondo';
end

VSEG=(VSEG=='cerebro');
