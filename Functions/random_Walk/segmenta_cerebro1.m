function [posteriors, V]=segmenta_cerebro1(Im,idx,labels)
p = mfilename('fullpath');
[path,~,~] = fileparts(p);
addpath(fullfile(path,'algorithms'));

[L,N] = superpixels(Im,500);
Im1=0*Im;
idx1=label2idx(L);
for i=1:N
    ind=idx1{i};
    Im1(ind)=mean(Im(ind));
end
% ind=find(Im1>prctile(Im1,95));
% idx=[idx,ind'];
% labels=[labels,2*ones(1,length(ind))];
Im1(find(Im1<20))=max(Im1(:));
nei = 1;            % 0: 4-neighbors, 1: 8-neighbors
c = 1e-4;          %  % restarting probability of RWR
sigma_c = 60; %prctile(Im1(:),5) %std(Im1(:))/2;       % color variance

[posteriors, V] = do_segmentation(Im1,idx,labels,c,nei,sigma_c);

