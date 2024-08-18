function [lon,lat,E]=compute_tide_energy (A,B,C,D,E,F,date1,date2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this function calculates tidal energy according to predictions
%%% based on start and end dates. The result is then stored in a txt file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
longitude=[];latitude=[];E_annual=[];
for i=1:length(A)
longitude=[longitude;A(i,2)]; latitude=[latitude;A(i,1)];
M=struct;
M.freq=[A(i,end);B(i,end);C(i,end);D(i,end);E(i,end);F(i,end)];
M.name={'K1';'K2';'M2';'N2';'O1';'S2'};
M.type='nodal';
con=ones(6,4);
con(:,1)=[A(i,3);B(i,3);C(i,3);D(i,3);E(i,3);F(i,3)].*0.01;
con(:,3)=[A(i,4);B(i,4);C(i,4);D(i,4);E(i,4);F(i,4)];
M.tidecon=con; 
date_start=datenum(date1,'dd-mmm-yyyy');
date_end=datenum(date2,'dd-mmm-yyyy');
time=10;tmp=time/(60*24); x=date_start:tmp:date_end; lat=A(i,1);
H_level=t_predic(x,M,'latitude',lat,'synthesis',0);%%% 0 synthesis
H_level=H_level+10; %% eviter valeur negative
%%%%%%  Computing tidal range
[pk1,lk1] = findpeaks(H_level,x,'MinPeakDistance',6/24);
[pk2,lk2] = findpeaks(-H_level,x,'MinPeakDistance',6/24);
t_sort=sort([lk2';lk1']);l_sort=zeros(length(t_sort),1);
[c,i_min,ib] = intersect(t_sort,lk2,'stable');
[c,i_max,ib] = intersect(t_sort,lk1,'stable');
l_sort(i_min)=-pk2; l_sort(i_max)=pk1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
steps = length(t_sort)-1;
diff_time=diff(t_sort);
marnage=[];time_marnage =[];
    for i=1:steps
        if 0.1<diff_time(i) && diff_time(i)<0.37
           marnage_tmp=abs(l_sort(i+1)-l_sort(i));
           marnage=[marnage marnage_tmp];
           indice=find(t_sort(i)<x & x<t_sort(i+1));
           L=length(indice); L=round((L/2))+indice(1);
           time_marnage_tmp=x(L);
           time_marnage=[time_marnage time_marnage_tmp];
        end
    end
 EN=(1.4).*(marnage.^2); E_annual_tmp=sum(EN); E_annual=[E_annual;E_annual_tmp];
end
E=E_annual.*0.001;
lon=longitude; lat=latitude;
A=[longitude latitude E_annual.*0.001];
filename=sprintf('annual_energy.txt');
dir = uigetdir('','Add path');
cd (dir);
writematrix(A,filename);
end