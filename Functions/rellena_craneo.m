function Vseg=rellena_craneo(V)
Vseg=0*V;

for i=1:size(V,1)
    bw=squeeze(V(i,:,:));
% close all
% figure,imshow(bw,[])
    bw=imcomplement(bw);
    D = bwdist(~bw); 
%figure, imshow(D,[]) ,title('Distance Transform of Binary Image')
    D = -D;
%figure,imshow(D,[]), title('Complement of Distance Transform')
    L = watershed(D); L(~bw) = 0;
    L = imclearborder(L);
%     figure,imshow(L,[]),
%     pause,close
    Vseg(i,:,:)=imclose(L>0,strel('square',20));
end

