clc; clear; close all;

%% Adding Custom Libraries and Data Path for Easy Access
addpath(genpath('data')); %data path
addpath(genpath('library')); %function library

%% Main Settings
eqFolderName='20_07_2017_bodrum'; %place your data folder name that you got from AFAD to 'data' folder,
                                  %rename csv design spectra files as earthquake data name with '_ds_h' or '_ds_v' at end of the filenames
    
plotSettings.file_name=[eqFolderName '/' eqFolderName];
plotSettings.postfix=['_' char(datetime('now','Format','yyyyMMddHHmm'))]; %run timestamp _YYYYMMDDHHMM
plotSettings.line_width=1;
plotSettings.line_colors={'r','g','b'}; %colors can be learnt from 'help plot'
plotSettings.font_size=12;

extractSettings.filter_order=4;
extractSettings.filter_cutoff=20;%Hertz

spcSettings.type='welch';%'welch' for Welch method or 'aryule' for Yule-Walker Autoregressive method, otherwise dft will be active
spcSettings.windowing=1; % 1 for using Hamming window, 0 for disabling window
spcSettings.welch_window_dur=5;% in seconds; short durations give less noisy spectrums
spcSettings.welch_overlap_rat=0.75; % [0-1] ratio;
spcSettings.aryule_p=32; %order, even value

asrSettings.zeta=0.05; %damping ratio
asrSettings.T_min= 0;% minimum natural period (sec)
asrSettings.T_max= 8;% maximum natural period (sec)
asrSettings.T_step=0.1;% maximum period step size
asrSettings.T_scale=2; %Absolute Spectral Response scaling point at time axis in seconds.
%asr selection will be automaticaly done if you put more than one observations in the data folder

arlSettings.type='campbell';%'boore' or 'campbell'
arlSettings.boore_site_class='C'; % Boore attenuation relationship site class
arlSettings.range=50; %site range from source in km

%% Reading Raw Data and Extracting, Filtering, Downsampling Data
eqData=readAFAD(eqFolderName);
avxData=extractAVXdata(extractSettings, eqData);

%% Extracting Frequency Domain Data
 spcSettings.type='welch';
 welData=extractFRQdata(spcSettings, avxData{1});
% spcSettings.type='aryule';
% aryData=extractFRQdata(spcSettings, avxData{1});
% spcSettings.type='dft';
% dftData=extractFRQdata(spcSettings, avxData{1});

%% Extracting Absolute Spectral Response data
asrData=extractASRdata(asrSettings, avxData{1}, eqData{1});

%% Extracting Attenuation Relationship Data
 arlSettings.type='campbell';
 arlDataCampbell = extractARLdata(arlSettings,avxData);
% arlSettings.type='boore';
% arlSettings.boore_site_class='A';
% arlDataBooreA = extractARLdata(arlSettings,avxData);
% arlSettings.boore_site_class='B';
% arlDataBooreB = extractARLdata(arlSettings,avxData);
% arlSettings.boore_site_class='C';
% arlDataBooreC = extractARLdata(arlSettings,avxData);

%% Extracting Attenuation Relationship Video

%% Plotting and Saving Graphs
 plotAVXdata(plotSettings, avxData{1});
 plotFRQdata(plotSettings, welData);
% plotFRQdata(plotSettings, aryData);
% plotFRQdata(plotSettings, dftData);
%plotASRdata(plotSettings, asrData);
% plotARLdata(plotSettings, {arlDataCampbell, arlDataBooreA, arlDataBooreB, arlDataBooreC});