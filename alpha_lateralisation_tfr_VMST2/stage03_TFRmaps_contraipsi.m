% 
run('00_setup_li_power.m');

resultsFolder = 'results_tfr_maps';
if ~exist(resultsFolder,'dir')
    mkdir(resultsFolder);
end

resultsFile = fullfile(resultsFolder, 'tfr_maps_results.mat');

tfrData = struct();

for subjectIndex = 1:numel(subjectlist)
    subjectname = subjectlist{subjectIndex};

    for loadIndex = 1:numel(loads)
        for targetIndex = 1:numel(targets)

            currentLoad   = loads{loadIndex};
            currentTarget = targets{targetIndex};

            leftFile  = sprintf('tf_data/%s.tf.%s.left.%s.mat', subjectname, currentTarget, currentLoad);
            rightFile = sprintf('tf_data/%s.tf.%s.right.%s.mat', subjectname, currentTarget, currentLoad);

            load(leftFile,  'freq');  freqLeft  = freq;
            load(rightFile, 'freq');  freqRight = freq;

            timeVector    = freqLeft.time;
            freqVector    = freqLeft.freq;
            channelLabels = freqLeft.label;

            leftIndex  = find(ismember(channelLabels, leftChannels));
            rightIndex = find(ismember(channelLabels, rightChannels));

            baselineMask = timeVector >= baselineWindow(1) & timeVector <= baselineWindow(2);
            baselineLeft  = mean(freqLeft.powspctrm(:,:,:,baselineMask), 4);
            baselineRight = mean(freqRight.powspctrm(:,:,:,baselineMask), 4);

            freqLeft.powspctrm  = 10 .* log10(freqLeft.powspctrm  ./ (baselineLeft + 1e-10));
            freqRight.powspctrm = 10 .* log10(freqRight.powspctrm ./ (baselineRight + 1e-10));

            ipsiLeftTrials   = freqLeft.powspctrm(:, leftIndex,  :, :);
            contraLeftTrials = freqLeft.powspctrm(:, rightIndex, :, :);

            ipsiRightTrials   = freqRight.powspctrm(:, rightIndex, :, :);
            contraRightTrials = freqRight.powspctrm(:, leftIndex,  :, :);

            ipsiLeft   = squeeze(mean(mean(ipsiLeftTrials,   1), 2));
            contraLeft = squeeze(mean(mean(contraLeftTrials, 1), 2));

            ipsiRight   = squeeze(mean(mean(ipsiRightTrials,   1), 2));
            contraRight = squeeze(mean(mean(contraRightTrials, 1), 2));

            ipsiCombined   = (ipsiLeft + ipsiRight) / 2;
            contraCombined = (contraLeft + contraRight) / 2;
            diffCombined   = contraCombined - ipsiCombined;

            tfrData.(currentLoad).(currentTarget).ipsi(subjectIndex,:,:)   = ipsiCombined;
            tfrData.(currentLoad).(currentTarget).contra(subjectIndex,:,:) = contraCombined;
            tfrData.(currentLoad).(currentTarget).diff(subjectIndex,:,:)   = diffCombined;

        end
    end
end

save(resultsFile, ...
    'tfrData', 'timeVector', 'freqVector', 'channelLabels', ...
    'subjectlist', 'loads', 'targets', ...
    'alphaBand', 'baselineWindow', ...
    'leftChannels', 'rightChannels', ...
    '-v7.3');
