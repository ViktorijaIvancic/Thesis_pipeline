close all;
clearvars;
clc;

subjectlist = {'ppn_000001','ppn_000002','ppn_000003','ppn_000004','ppn_000005', ...
               'ppn_000006','ppn_000008','ppn_000009','ppn_000013','ppn_000015', ...
               'ppn_000016','ppn_000017','ppn_000019','ppn_000021','ppn_000022', ...
               'ppn_000023','ppn_000036','ppn_000037','ppn_000047','ppn_000053', ...
               'ppn_000054','ppn_000058','ppn_000060','ppn_000062','ppn_000067', ...
               'ppn_000069','ppn_000070'};

loads   = {'load2','load8'}; % memory load condition 
targets = {'present','absent'}; % target presence condition 


% predefined analysis window and electrode pairs 

alphaBand      = [8 12];
baselineWindow = [-0.4 -0.2]; 
analysisWindow = [0.4 0.6];

leftChannels  = {'PO3','PO7','P5','P7'};
rightChannels = {'PO4','PO8','P6', 'P8'};

layoutFile = 'dcc_customized_acticap64.mat';

resultsFolder = 'alpha_lateralisation_tfr_VMST2';
if ~exist(resultsFolder,'dir')
    mkdir(resultsFolder);
end

resultsFile = fullfile(resultsFolder, 'alpha_lateralisation_tfr_VMST2.mat');

