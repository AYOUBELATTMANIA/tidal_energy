function plot_tide_energy(latitude,longitude,energy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this function is used to plot the results 
%%% of tidal energy on a geographic map. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
geobasemap ('streets')
s=geoscatter(latitude,longitude,10,energy,'filled');
datatipRow = dataTipTextRow('Energy',energy);
s.DataTipTemplate.DataTipRows(end+1) = datatipRow;
colormap turbo
c = colorbar;
tmp=sprintf('Annual potential energy [Kwh/m²]');
title(tmp);
end