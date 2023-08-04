% This program is used to prepare the input dataset for MCM.
% Coordinate systerm: Cartesian coordinate, X-North, Y-East, Z-Vertical down.
% For vertical down axis, it is relative to the sea-level.
clear;
tic
% Parameter setting--------------------------------------------------------

% set file names
file.seismic ='C:\Users\....\Documents\MATLAB\MCM_new\fileName'; % path and file name of the seismic data
file.stations='C:\Users\....\Documents\MATLAB\MCM_new\fileName'; % path and file name of the station information
file.velocity='C:\Users\....\Documents\MATLAB\MCM_new\ifileName'; % path and file name of the velocity model

%set required parameters
search.north=[0 5000]; % North component range for source imaging points, in meter
search.east=[0 5000]; % East component range for source imaging points, in meter
search.depth=[0 4000]; % Depth range for source imaging points, in meter
search.dn=500; % spatial interval of source imaging points in the North direction, in meter
search.de=500; % spatial interval of source imaging points in the East direction, in meter
search.dd=500; % spatial interval of source imaging points in the Depth direction, in meter

% search.north=[-750 1750]; % North component range for source imaging points, in meter
% search.east=[1250 3750]; % East component range for source imaging points, in meter
% search.depth=[-250 2250]; % Depth range for source imaging points, in meter
% search.dn=250; % spatial interval of source imaging points in the North direction, in meter
% search.de=250; % spatial interval of source imaging points in the East direction, in meter
% search.dd=250; % spatial interval of source imaging points in the Depth direction, in meter

% search.north=[125 1375]; % North component range for source imaging points, in meter
% search.east=[1875 3125]; % East component range for source imaging points, in meter
% search.depth=[375 1625]; % Depth range for source imaging points, in meter
% search.dn=125; % spatial interval of source imaging points in the North direction, in meter
% search.de=125; % spatial interval of source imaging points in the East direction, in meter
% search.dd=125

% mcm parameters
mcm.migtp=0; % migration method; 0 for MCM, 1 for conventional migration.
mcm.phasetp=2; % phase used for migration; 0 for P-phase only, 1 for S-phase only, 2 for P+S-phases.
mcm.cfuntp=1; % characteristic function; 0 for original data, 1 for envelope, 2 for absolute value, 3 for non-negative value, 4 for square value
mcm.tpwind=0.44; % P-phase time window length in second (s) used for migration.
mcm.tswind=0.44; % S-phase time window length in second (s) used for migration.
mcm.dt0=1.49e-3; % time sampling interval of searching origin times in second (s).
mcm.mcmdim=2; % the dimension of MCM
mcm.workfolder='folder'; % the working folder for output and MCM program
mcm.output='filename_1.txt'
mcm.run=3; % specify which MCM program to run: -1 for generating MCM binary files; 0 for testing MCM parameters; 1 for MCM frequency band testing; 2 for MCM Matlab testing with catalog input; 3 for MCM Matlab testing with input time range; 4 for Run MCM Matlab program
mcm.plot=2; % plot migration results; 0 no plots, 1 migration plots, 2 waveforms with picking and migration time, 3 both waveforms and migration plots
mcm.output_old='C:\Users\....\Documents\MATLAB\MCM_gs\folder\filename_1.txt';
mcm.iterative=1; % 0 for geometry collaping grid; 1 for Multiple maxima 
mcm.itN=1; %iteration number 2 for second iteration, 3 for third  

if mcm.itN~=1 

dx=search.dn

search=iterative_solution(mcm,search)

end


% %optional input parameters
% mcm.filter.freq=[10 20]; % frequency band used to filter the seismic data, a vector containing 1 or 2 elements, in Hz
% mcm.filter.type='bandpass'; % filter type, can be 'low', 'bandpass', 'high', 'stop'
% mcm.filter.order=4; % order of Butterworth filter, for bandpass and bandstop designs are of order 2n
% mcm.prefile='/home/shipe/projects_going/Aquila_data/mcm_cata/traveltimes/stations_traveltime_search.mat'; % file name of the pre-calculated traveltime tables and the related station and search information
% mcm.datat0=datetime('2009-04-03 00:00:00'); % The starting time of all traces, reset the t0 if the t0 in the input seismic files are not correct
% mcm.stationid=1; % show the seismogram and spectrogram of this station
% 


% generate input files for MCM
[trace,search,mcm]=mcm_genei(file,search,mcm);
toc
