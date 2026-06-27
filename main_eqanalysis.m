clc; clear; close all;

%% Adding Custom Libraries and Data Path for Easy Access
addpath(genpath('data')); %data path
addpath(genpath('library')); %function library

%% Main Settings
eqFolderName='20_07_2017_bodrum'; %place your data folder name that you got from AFAD to 'data' folder,
                                  %rename csv design spectra files as earthquake data name with '_ds_h' or '_ds_v' at end of the filenames
    
plotSettings.file_name=[eqFolderName '/' eqFolderName];
plotSettings.postfix=['_' char(datetime('now','Format','yyyyMMddHHmm'))]; %run timestamp _YYYYMMDDHHMM
plotSettings.event=eqFolderName; %shown in the figure header
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

arlSettings.range=50; %site range from source in km

%% Run Options (toggle stages on/off instead of commenting code out)
opt.spectra          = {'welch'};       % any of: 'welch','aryule','dft'
opt.attenuation      = {'campbell'};    % any of: 'campbell','boore_A','boore_B','boore_C'
opt.plot_waveform    = true;            % Arias/accel/velocity/displacement
opt.plot_spectra     = true;            % one figure per method in opt.spectra
opt.plot_asr         = false;           % absolute spectral response
opt.plot_attenuation = false;           % attenuation map (all opt.attenuation on one figure)

%% Reading Raw Data and Extracting, Filtering, Downsampling Data
eqData=readAFAD(eqFolderName);
avxData=extractAVXdata(extractSettings, eqData);

%% Extracting Frequency Domain Data (one entry per selected method)
welData=struct();
for s=1:numel(opt.spectra)
    spcSettings.type=opt.spectra{s};
    welData.(opt.spectra{s})=extractFRQdata(spcSettings, avxData{1});
end

%% Extracting Absolute Spectral Response data
asrData=extractASRdata(asrSettings, avxData{1}, eqData{1});

%% Extracting Attenuation Relationship Data (one entry per selected model)
arlData=cell(1,numel(opt.attenuation));
for a=1:numel(opt.attenuation)
    sel=opt.attenuation{a};
    if strcmpi(sel,'campbell')
        arlSettings.type='campbell';
    else %'boore_A' / 'boore_B' / 'boore_C'
        arlSettings.type='boore';
        arlSettings.boore_site_class=upper(sel(end));
    end
    arlData{a}=extractARLdata(arlSettings, avxData);
end

%% Plotting and Saving Graphs
if opt.plot_waveform
    plotAVXdata(plotSettings, avxData{1});
end
if opt.plot_spectra
    for s=1:numel(opt.spectra)
        plotFRQdata(plotSettings, welData.(opt.spectra{s}));
    end
end
if opt.plot_asr
    plotASRdata(plotSettings, asrData);
end
if opt.plot_attenuation
    plotARLdata(plotSettings, arlData);
end