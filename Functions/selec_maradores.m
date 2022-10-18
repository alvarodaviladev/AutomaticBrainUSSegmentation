function V1=selec_maradores(V)

Vc=convn(V,ones(5,5,5),'same')/(5*5*5);
options.BlackWhite=false;
options.FrangiScaleRatio=2;
options.FrangiScaleRange=[1 6];
options.FrangiAlpha=0.9;
options.FrangiBetaTwo = 15;
options.verbose=0;
 Vf=0*Vc;
 for i=1:size(Vc,3)
     Vf(:,:,i)=FrangiFilter2D(Vc(:,:,i),options);
 end
 
Vfu=Vf>0.5;
s = regionprops3(logical(Vfu),Vfu,"Volume","VoxelIdxList");
[volumes,or] = sort(s.Volume,'descend'); %Ordeno de mayor a menor las regiones medidas
IndList = s.VoxelIdxList; %Matriz con la lista de los voxeles contenidos en cada volúmen
IndList = IndList(or); %reordena segun los indices "or"
V1=0*Vf;
for i=2:5
    V1(IndList{i})=1;
end



