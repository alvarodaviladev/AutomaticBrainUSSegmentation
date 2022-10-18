function L = Segmentacion_RW2(Im,h)
p = mfilename('fullpath');
[filepath,~,~] = fileparts(p);
addpath(fullfile(filepath,'random_Walk'));

h_interior = drawellipse('Center',h.Center,'SemiAxes',[h.SemiAxes(1)*0.8, h.SemiAxes(2)*0.8],'StripeColor','r','Visible','on');
h_exterior = drawellipse('Center',h.Center,'SemiAxes',[h.SemiAxes(1)*1.2, h.SemiAxes(2)*1.2],'StripeColor','r','Visible','on');

%mascara interior
mask = createMask(h_interior, Im);
ind=find(mask==1);
idx=[ind'];
labels=[ones(1,length(ind))];
 
%mascara exterior
mask = ~createMask(h_exterior, Im);
ind2=find(mask==1);
labels=[labels,2*ones(1,length(ind2))];
idx=[idx,ind2'];

[~, L]=segmenta_cerebro1(Im,idx,labels);
L = L==1;
end