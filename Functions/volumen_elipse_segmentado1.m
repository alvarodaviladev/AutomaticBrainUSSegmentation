function [BW1,BW13,BW123]=volumen_elipse_segmentado1(V)
BW1=0*V;
for i=1:size(V,1)
    
    aux = bwperim(squeeze(V(i,:,:)));
    s=regionprops(aux,'Area','PixelIdxList');
    A=[s(1:end).Area];
    if length(A)>1
        [kk,n]=sort(A,'descend');
        for j=2:length(A)
            aux(s(n(j)).PixelIdxList)=0;
        end
    end
    
    [F,C]=size(aux);
    [y,x]=ind2sub(size(aux),find(aux==1));
     if ~isempty(y) && length(y)>20
        [ellipse_t,P1] = fit_ellipse( x,y ,1);
        P1=round(P1);
        if ~isempty(P1)
             BW1(i,:,:)=elipse_mask(aux,ellipse_t);
        end    
     end    
end


BW3=0*V;
for i=1:size(V,3)
    
    aux = bwperim(squeeze(V(:,:,i)));
    s=regionprops(aux,'Area','PixelIdxList');
    A=[s(1:end).Area];
    if length(A)>1
        [kk,n]=sort(A,'descend');
        for j=2:length(A)
             aux(s(n(j)).PixelIdxList)=0;
        end
    end
    [F,C]=size(aux);
    [y,x]=ind2sub(size(aux),find(aux==1));
     if ~isempty(y) && length(y)>20
        [ellipse_t,P1] = fit_ellipse( x,y ,1);
        P1=round(P1);
        if ~isempty(P1)
            BW3(:,:,i)=elipse_mask(aux,ellipse_t);
        end    
     end
    
end

BW2=0*V;
for i=1:size(V,2)
    
    aux = bwperim(squeeze(V(:,i,:)));
    [F,C]=size(aux);
    [y,x]=ind2sub(size(aux),find(aux==1));
     if ~isempty(y) && length(y)>200
        [ellipse_t,P1] = fit_ellipse( x,y ,1);
        P1=round(P1);
        if ~isempty(P1)
            BW2(:,i,:)=elipse_mask(aux,ellipse_t);
%             figure,imshow(aux,[]),hold on,
%             visboundaries(squeeze(BW2(:,i,:))),
%             pause(1),close
        end    
     end
end
BW123=BW1+BW2+BW3;
BW123=imopen(BW123,ones(10,10,10));
BW123=(BW123>0);
BW13=BW1+BW3;
BW13=imopen(BW13,ones(10,10,10));
BW13=(BW13>0);

