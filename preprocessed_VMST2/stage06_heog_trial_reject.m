% step function for removing HEOG 
clear; clc;
run('00_setup.m');

stageInFolder  = fullfile(preprocessed_folder,'stage05_remove_components');
stageFolder = fullfile(preprocessed_folder,'stage06_heog_trial_reject');
if ~exist(stageFolder,'dir'); mkdir(stageFolder); end

for subjectIndex = 1:numel(subjectlist)
participant = subjectlist{subjectIndex};

inFile = fullfile(stageInFolder, [participant '_stage05.mat']);
loaded = load(inFile, 'data_cleaned');
data_cleaned = loaded.data_cleaned;

cfg                 = [];
cfg.keeptrials      = 'yes';
cfg.channel         = {'EOGh'};
d_eogh              = ft_timelockanalysis(cfg, data_cleaned);

epochStartMs        = 0;
epochEndMs          = 230; % chose the window in which you want to remove the HEOG
stepWindowMs        = 20;
thresholdMicrovolt  = 40; % lower it if you want to capture saccades 

if iscell(d_eogh.time)
    timeVector = d_eogh.time{1};
else
    timeVector = d_eogh.time;
end

timeStepSeconds   = mean(diff(timeVector));
samplingFrequency = round(1 / timeStepSeconds);

[~, zeroSampleIndex] = min(abs(timeVector - 0));

numberOfSamplesWindow = floor(epochEndMs / 1000 * samplingFrequency) + 1;

epochStartSampleIndex = zeroSampleIndex;
epochEndSampleIndex   = epochStartSampleIndex + numberOfSamplesWindow - 1;

stepWindowSamples = round(stepWindowMs / 1000 * samplingFrequency);

horizontalChannelIndex = find(strcmp(d_eogh.label, 'EOGh'));
if isempty(horizontalChannelIndex)
    error('Could not find EOGh channel in d_eogh.label');
end

numberOfTrials   = size(d_eogh.trial, 1);
badTrialsLogical = false(numberOfTrials, 1);

for trialIndex = 1:numberOfTrials

    horizontalSignal = squeeze( ...
        d_eogh.trial(trialIndex, horizontalChannelIndex, ...
                     epochStartSampleIndex:epochEndSampleIndex) ...
    )';

    segmentLength = numel(horizontalSignal);

    if segmentLength <= stepWindowSamples
        continue
    end

    differenceValues = abs( ...
        horizontalSignal(1:segmentLength - stepWindowSamples) - ...
        horizontalSignal(1 + stepWindowSamples:segmentLength));

    if any(differenceValues > thresholdMicrovolt)
        badTrialsLogical(trialIndex) = true;
    end
end

select_config           = [];
select_config.trials    = find(~badTrialsLogical);

data_no_artifacts       = ft_selectdata(select_config, data_cleaned);

outFile = fullfile(stageFolder, [participant '_stage06.mat']);
save(outFile, 'data_no_artifacts', '-v7.3');

end
