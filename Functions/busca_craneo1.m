function [Vcraneal]=busca_craneo(V)

color = [255 0 0];
mapa = jet(256);
filter_size = [3 3];

Vsegx=0*V;
for i=1:size(V,1)
    img=squeeze(V(i,:,:));
    A = medfilt2(img,filter_size);
    if ismatrix(A) 
       A=ind2rgb(A,mapa);
    end
   % AJUSTAR EL CONTRASTE DE CADA CANAL
    A(:,:,1)=imadjust(A(:,:,1));
    A(:,:,2)=imadjust(A(:,:,2));
    A(:,:,3)=imadjust(A(:,:,3));

    % OBTENER EL GRADIENTE DE CADA CANAL, SY LOS SUMAMOS
    [Gxa, Gya] = imgradientxy(A(:,:,1),'central');
    [Gxb, Gyb] = imgradientxy(A(:,:,2),'central');
    [Gxc, Gyc] = imgradientxy(A(:,:,3),'central');
    [Gmaga, ~] = imgradient(Gxa, Gya);
    [Gmagb, ~] = imgradient(Gxb, Gyb);
    [Gmagc, ~] = imgradient(Gxc, Gyc);
    Gmag = Gmaga + Gmagb + Gmagc;
    Threshold    = multithresh(Gmag,3);
    Vsegx(i,:,:)=squeeze(Gmag>Threshold(3));
end

Vsegz=0*V;
for i=1:size(V,3)
    img=squeeze(V(:,:,i));
    A = medfilt2(img,filter_size);
    if ismatrix(A) 
       A=ind2rgb(A,mapa);
    end
   % AJUSTAR EL CONTRASTE DE CADA CANAL
    A(:,:,1)=imadjust(A(:,:,1));
    A(:,:,2)=imadjust(A(:,:,2));
    A(:,:,3)=imadjust(A(:,:,3));

    % OBTENER EL GRADIENTE DE CADA CANAL, SY LOS SUMAMOS
    [Gxa, Gya] = imgradientxy(A(:,:,1),'central');
    [Gxb, Gyb] = imgradientxy(A(:,:,2),'central');
    [Gxc, Gyc] = imgradientxy(A(:,:,3),'central');
    [Gmaga, ~] = imgradient(Gxa, Gya);
    [Gmagb, ~] = imgradient(Gxb, Gyb);
    [Gmagc, ~] = imgradient(Gxc, Gyc);
    Gmag = Gmaga + Gmagb + Gmagc;
    Threshold    = multithresh(Gmag,3);
    Vsegz(:,:,i)=squeeze(Gmag>Threshold(3));
end
Vseg=Vsegz+Vsegx;

MASK=V>0;
MASK=imerode(MASK,strel('cuboid',[25,25,25]));
MASK(1:15,:,:)=0;
MASK(end-15:end,:,:)=0;
MASK(:,1:15,:)=0;
MASK(:,end-15:end,:)=0;
MASK(:,:,1:15)=0;
MASK(:,:,end-15:end)=0;
Vseg=Vseg.*MASK;
Vcraneal=imopen(Vseg,strel('cuboid',[3,3,3]));
   

