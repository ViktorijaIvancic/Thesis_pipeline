% setup 
close all;
clearvars;
clc;

restoredefaultpath;
addpath('fieldtrip-20250518');
ft_defaults;

%%

EEG_recording_folder = 'eeg_data_experiment_YA';
preprocessed_folder = 'preprocessed_VMST2';

if ~exist(preprocessed_folder,'dir')
    mkdir(preprocessed_folder);
end

subjectlist = {'ppn_000001' 'ppn_000002' 'ppn_000003' 'ppn_000004' 'ppn_000005' ...
               'ppn_000006' 'ppn_000008' 'ppn_000009' 'ppn_000013' 'ppn_000015' ...
               'ppn_000016' 'ppn_000017' 'ppn_000019' 'ppn_000021' 'ppn_000022' ...
               'ppn_000023' 'ppn_000036' 'ppn_000037' 'ppn_000047' 'ppn_000053' ...
               'ppn_000054' 'ppn_000058' 'ppn_000060' 'ppn_000062' 'ppn_000067' ...
               'ppn_000069' 'ppn_000070'};

dcclayout = 'dcc_customized_acticap64.mat'; 