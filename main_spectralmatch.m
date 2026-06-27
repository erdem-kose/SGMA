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

smaSettings.zeta=0.1; %damping ratio
smaSettings.T_min= 0;% minimum natural period (sec)
smaSettings.T_max= 8;% maximum natural period (sec)
smaSettings.T_step=0.05;% maximum period step size
%asr selection will be automaticaly done if you put more than one observations in the data folder

%% Reading Raw Data and Extracting, Filtering, Downsampling Data
eqData=readAFAD(eqFolderName);
avxData=extractAVXdata(extractSettings, eqData);
    
%% Spectral Match
smaData=extractSMAdata(smaSettings, spcSettings, avxData, eqData);

%% Plot
plotASRdata(plotSettings, smaData);