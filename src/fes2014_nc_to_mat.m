function fes2014_nc_to_mat (path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this function transforms the nc files of the fes2014b 
%%%  model into a single .mat structure 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FileName= uigetfile('*.nc','Select One or More Files', ...
   'MultiSelect', 'on');
fes2014= struct('longitude',[],'latitude',[],'amplitude',[],'phase',[],'name',[]);
for i=1:length(FileName)
filename=char(FileName(i)); name=filename(1:end-3);
lon=ncread(filename,'lon');lon=rem((lon+180),360)-180;
lat=ncread(filename,'lat');
amp=ncread(filename,'amplitude');pha=ncread(filename,'phase');
A=cat(3,amp);B=cat(3,pha);
fes2014(i).longitude=lon; fes2014(i).latitude=lat;
fes2014(i).amplitude=A; fes2014(i).phase=B;
fes2014(i).name=name;
end
dir = uigetdir('','Add path');
cd (dir);
save ('FES_M2_S2_N2_k2_K1_O1.mat','fes2014','-v7.3');
end


