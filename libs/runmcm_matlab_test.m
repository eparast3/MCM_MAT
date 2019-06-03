function migv=runmcm_matlab_test(trace,mcm,search,earthquake)
% This function is used to set up and run MCM Matlab test version.
% X-North  Y-East  Z-Depth(Vertical down)
%
% INPUT--------------------------------------------------------------------
% trace: matlab structure, contains seismic data information;
% trace.data: seismic data, 2D array, nre*nt;
% trace.dt: time sampling interval, in second;
% trace.travelp: P-wave traveltime table, 2D array, nsr*nre;
% trace.travels: S-wave traveltime table, 2D array, nsr*nre;
% trace.recp: assambled station positions, 2D array, n_sta*3, N-E-D in meters;
% mcm: matlab structure, contains MCM parameters;
% mcm.phasetp: specify seismic phase used for migration, scalar;
% mcm.tpwind: P-phase time window length in second, scalar;
% mcm.tswind: S-phase time window length in second, scalar;
% mcm.st0: searched origin times of MCM, in second (relative to start time
% of input seismic data), vector, nst0*1;
% mcm.dt0: time sampling interval of searching origin times in second;
% search: matlab structure, describe the imaging area,
% search.north: 1*2, imaging area in the north direction, in meter,
% search.east: 1*2, imaging area in the east direction, in meter,
% search.depth: 1*2, imaging area in the depth direction, in meter;
% search.dn: spatial interval in the north direction, in meter;
% search.de: spatial interval in the east direction, in meter;
% search.dd: spatial interval in the depth direction, in meter;
% search.soup: source imaging positions, 2D array, ns*3, in meter;
% search.nsnr: number of imaging points in the north direction, scalar;
% search.nser: number of imaging points in the east direction, scalar;
% search.nsdr: number of imaging points in the depth direction, scalar;
% earthquake: matlab structure, contains the location and origin time of the earthquake;
% earthquake.north: scalar, earthquake location in north direction, in meter;
% earthquake.east: scalar, earthquake location in east direction, in meter;
% earthquake.depth: scalar, earthquake location in depth direction, in meter;
% earthquake.t0: scalar, relative earthquake origin time, in second,
% relative to the origin time of the seismic data;
%
% OUTPUT-------------------------------------------------------------------
% migv: migration volume, 4D array, shape: nsnr*nser*nsdr*nst0.



% run the MCM test
if mcm.phasetp==2
    % use both P and S phase
    fprintf('Use P-phase of %f s window and S-phase of %f s window for MCM.\n',mcm.tpwind,mcm.tswind);
    migv=wave_migration_kernel(trace,mcm,search);
elseif mcm.phasetp==0
    % use only P-phase
    fprintf('Use P-phase of %f s window for MCM.\n',mcm.tpwind);
    mcm.txwind=mcm.tpwind;
    trace.travelx=trace.travelp;
    migv=wave_migration_kernel_x(trace,mcm,search);
elseif mcm.phasetp==1
    % use only S-phase
    fprintf('Use S-phase of %f s window for MCM.\n',mcm.tswind);
    mcm.txwind=mcm.tswind;
    trace.travelx=trace.travels;
    migv=wave_migration_kernel_x(trace,mcm,search);
else
    error('Incorrect input for mcm.phasetp, only accept: 0, 1, 2.');
end


% show and compare results

wfmstk_c=permute(migv,[4 1 2 3]); % note here exchange dimensions

soup_cata=[earthquake.north earthquake.east earthquake.depth]; % location of the earthquake, in meter

[tn,xn,yn,zn]=migmaxplt(wfmstk_c,soup_cata/1000,search.north/1000,search.east/1000,search.depth/1000); % note the unit transfer, m->km

idse=sub2ind([search.nsnr search.nser search.nsdr],xn,yn,zn); % location index for the MCM

fprintf('Maximum coherence value: %f.\n',max(wfmstk_c(:))); % maximum coherency value in the volume
fprintf('Origin time: %f s.\n',mcm.st0(tn)); % located event origin time
fprintf('Event location: %f, %f, %f m.\n',search.soup(idse,:)); % located event locations


lwin=30; % left window length for showing seismic data, in second
rwin=60; % right window length for showing seismic data, in second

nre=size(trace.data,1); % number of stations used in MCM



% Display results, for MCM without origin tima calibration
% display the arrival times of seismic event on the recorded seismic data
et0=mcm.st0(tn); % the located origin time
net0r=round((et0-lwin)/trace.dt+1):round((et0+rwin)/trace.dt+1); % origin time for the MCM
exwfm=transpose(trace.data(:,net0r)); % extracted waveforms
for ire=1:nre
    figure; plot((net0r-1)*trace.dt,exwfm(:,ire),'k'); hold on;
    plot([trace.travelp(idse,ire)+et0   trace.travelp(idse,ire)+et0],[min(exwfm(:,ire)) max(exwfm(:,ire))],'b','linewidth',1.2); hold on;
    plot([trace.travels(idse,ire)+et0   trace.travels(idse,ire)+et0],[min(exwfm(:,ire)) max(exwfm(:,ire))],'r','linewidth',1.2); hold on;
    xlabel('Time');ylabel('Amplitude');title('MCM');axis tight;
end
seisrsdisp(exwfm,trace.dt); % display the waveforms of different stations all together

% record section for MCM, without origin time calibration
soup_mcm=search.soup(idse,:)/1000;
dispwfscn(trace.data',trace.recp/1000,soup_mcm,trace.dt,et0,trace.travelp(idse,:),trace.travels(idse,:)); % note unit transfer
title('Record section (MCM)');



% Display results, for MCM with origin tima calibration
tphase=0.45; % period of the seismic phase, in second
et0=mcm.st0(tn)+mcm.tpwind-tphase; % the calibrated origin time
net0r=round((et0-lwin)/trace.dt+1):round((et0+rwin)/trace.dt+1); % origin time for the MCM
exwfm=transpose(trace.data(:,net0r)); % extracted waveforms
for ire=1:nre
    figure; plot((net0r-1)*trace.dt,exwfm(:,ire),'k'); hold on;
    plot([trace.travelp(idse,ire)+et0   trace.travelp(idse,ire)+et0],[min(exwfm(:,ire)) max(exwfm(:,ire))],'b','linewidth',1.2); hold on;
    plot([trace.travels(idse,ire)+et0   trace.travels(idse,ire)+et0],[min(exwfm(:,ire)) max(exwfm(:,ire))],'r','linewidth',1.2); hold on;
    xlabel('Time');ylabel('Amplitude');title('MCM');axis tight;
end
seisrsdisp(exwfm,trace.dt); % display the waveforms of different stations all together

% record section for MCM, with origin time calibration
soup_mcm=search.soup(idse,:)/1000;
dispwfscn(trace.data',trace.recp/1000,soup_mcm,trace.dt,et0,trace.travelp(idse,:),trace.travels(idse,:)); % note unit transfer, m->km
title('Record section (MCM with t0 calibrated)');



% Display results, for the catalog
% determine catalog event index in the soup, by using minimal distance--approximate
[~,idseca]=min(sum((search.soup-soup_cata).^2,2));

% display the arrival times of seismic event on the recorded seismic data
et0ca=earthquake.t0;
net0r=round((et0ca-lwin)/trace.dt+1):round((et0ca+rwin)/trace.dt+1); % origin time for the catalogue
exwfmca=transpose(trace.data(:,net0r)); % extracted waveforms
for ire=1:nre
    figure; plot((net0r-1)*trace.dt,exwfmca(:,ire),'k'); hold on;
    plot([trace.travelp(idseca,ire)+et0ca   trace.travelp(idseca,ire)+et0ca],[min(exwfmca(:,ire)) max(exwfmca(:,ire))],'b','linewidth',1.2); hold on;
    plot([trace.travels(idseca,ire)+et0ca   trace.travels(idseca,ire)+et0ca],[min(exwfmca(:,ire)) max(exwfmca(:,ire))],'r','linewidth',1.2); hold on;
    xlabel('Time');ylabel('Amplitude');title('Catalogue');axis tight;
end
seisrsdisp(exwfmca,trace.dt); % display the waveforms of different stations all together

% record section of catalogue
dispwfscn(trace.data',trace.recp/1000,soup_cata/1000,trace.dt,et0ca,trace.travelp(idseca,:),trace.travels(idseca,:)); % note unit transfer, m->km
title('Record section (Catalog)');

end