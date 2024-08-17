function extract_fes_data(matfile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this function extracts the fes2014b tidal harmonic 
%%% (amplitudes and phases) of ['K1';'K2';'M2';'N2';'O1';'S2'] 
%%% constituents in the region delimited by user. Data of each contituents
%%% is saved in a defined txt file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global lon_min lon_max lat_min lat_max
name={'K1';'K2';'M2';'N2';'O1';'S2'};
freq=[0.041780746 0.083561492 0.080511401 0.078999249 0.038730654 0.083333333];
for m=1:6
    fes=matfile.fes2014(1,m);           
    lon=fes.longitude; lat=fes.latitude;
    amp=fes.amplitude; pha=fes.phase;
    i=dsearchn(lon,lon_min);j=dsearchn(lon,lon_max);
    k=dsearchn(lat,lat_min);l=dsearchn(lat,lat_max);
    [LON,LAT]=meshgrid(lon(i:j),lat(k:l));
    if j<i
        ind=[i:length(lon) 1:j];
        [LON,LAT]=meshgrid(lon(ind),lat(k:l));
        amp=amp(ind,k:l);
        pha=pha(ind,k:l);
    else
        amp=amp(i:j,k:l);
        pha=pha(i:j,k:l);
    end
    amp=amp'; amp=rot90(amp,4);
    pha=pha'; pha=rot90(pha,4);
    % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    LAT=LAT(:);LON=LON(:);amp=amp(:);pha=pha(:);
    ind=find(amp>=10000); amp(ind)=nan;LON(ind)=nan;
    LAT(ind)=nan;pha(ind)=nan;
    nonans = find(~isnan(amp));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    FREQ=ones(length(nonans),1).*freq(m);
    A=[LAT(nonans) LON(nonans) amp(nonans) pha(nonans) FREQ];
    filename=sprintf('fes_onde_%s.txt',name{m});
    writematrix(A,filename);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    subplot 121
    geobasemap ('streets')
    s=geoscatter(LAT(nonans),LON(nonans),10,amp(nonans),'filled');
    datatipRow = dataTipTextRow('Amplitude',amp(nonans));
    s.DataTipTemplate.DataTipRows(end+1) = datatipRow;
    colormap turbo
    c = colorbar;
    tmp=sprintf('%s amplitude [m]',name{m});
    title(tmp);
    subplot 121
    geobasemap ('streets')
    s=geoscatter(LAT(nonans),LON(nonans),10,pha(nonans),'filled');
    datatipRow = dataTipTextRow('Phase',pha(nonans));
    s.DataTipTemplate.DataTipRows(end+1) = datatipRow;
    colormap turbo
    c = colorbar;
    tmp=sprintf('%s phase [°]',name{m});
    title(tmp);
end
