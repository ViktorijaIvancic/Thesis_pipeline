% compute LI  
close all;

run('00_setup_li_power.m');

allSubjectsLI = struct();
powerLeftStimIpsi   = struct();
powerLeftStimContra = struct();
powerRightStimIpsi  = struct();
powerRightStimContra = struct();

for subjectIndex = 1:numel(subjectlist)
    subjectname = subjectlist{subjectIndex};

    for loadIndex = 1:numel(loads)
        for targetIndex = 1:numel(targets)

            currentLoad   = loads{loadIndex};
            currentTarget = targets{targetIndex};

            leftFile  = sprintf('tf_data/%s.tf.%s.left.%s.mat', subjectname, currentTarget, currentLoad);  % load time–frequency data for trials where stimulus was on the LEFT vs on the RIGHT
            rightFile = sprintf('tf_data/%s.tf.%s.right.%s.mat', subjectname, currentTarget, currentLoad);

            load(leftFile,  'freq');  freqLeft  = freq;
            load(rightFile, 'freq');  freqRight = freq;

            timeVector    = freqLeft.time;
            freqVector    = freqLeft.freq;
            channelLabels = freqLeft.label;

            leftIndex  = find(ismember(channelLabels, leftChannels));
            rightIndex = find(ismember(channelLabels, rightChannels));

            baselineMask = timeVector >= baselineWindow(1) & timeVector <= baselineWindow(2); % compute dB baseline relative to a prestimulus window

            baselineLeft  = mean(freqLeft.powspctrm(:,:,:,baselineMask), 4);
            baselineRight = mean(freqRight.powspctrm(:,:,:,baselineMask), 4);

            freqLeft.powspctrm  = 10 .* log10(freqLeft.powspctrm  ./ baselineLeft); 
            freqRight.powspctrm = 10 .* log10(freqRight.powspctrm ./ baselineRight);

            ipsiLeft   = freqLeft.powspctrm(:, leftIndex,  :, :); % LI index 
            contraLeft = freqLeft.powspctrm(:, rightIndex, :, :);

            ipsiRight   = freqRight.powspctrm(:, rightIndex, :, :);
            contraRight = freqRight.powspctrm(:, leftIndex,  :, :);

            liLeft  = contraLeft  - ipsiLeft; % LI per condition
            liRight = contraRight - ipsiRight;

            liMean = mean(cat(1, liLeft, liRight), 1, 'omitnan'); % combine left- and right-stimulus LIs
            liMean = squeeze(liMean);

            alphaMask = freqVector >= alphaBand(1) & freqVector <= alphaBand(2);
            liAlpha = mean(liMean(:, alphaMask, :), 2);
            liAlpha = squeeze(liAlpha);

            timeMask = timeVector >= analysisWindow(1) & timeVector <= analysisWindow(2);
            liWindow = mean(liAlpha(:, timeMask), 2);

            allSubjectsLI.(currentLoad).(currentTarget)(subjectIndex,:) = liWindow;

            leftIpsi = mean(mean(freqLeft.powspctrm(:, leftIndex, alphaMask, :), 3), 2);
            leftIpsi = squeeze(mean(leftIpsi, 1));

            leftContra = mean(mean(freqLeft.powspctrm(:, rightIndex, alphaMask, :), 3), 2);
            leftContra = squeeze(mean(leftContra, 1));

            rightIpsi = mean(mean(freqRight.powspctrm(:, rightIndex, alphaMask, :), 3), 2);
            rightIpsi = squeeze(mean(rightIpsi, 1));

            rightContra = mean(mean(freqRight.powspctrm(:, leftIndex, alphaMask, :), 3), 2);
            rightContra = squeeze(mean(rightContra, 1));

            powerLeftStimIpsi.(currentLoad).(currentTarget)(subjectIndex,:)   = leftIpsi; % store power time courses: subjects x time for each load/target condition
            powerLeftStimContra.(currentLoad).(currentTarget)(subjectIndex,:) = leftContra;
            powerRightStimIpsi.(currentLoad).(currentTarget)(subjectIndex,:)  = rightIpsi;
            powerRightStimContra.(currentLoad).(currentTarget)(subjectIndex,:) = rightContra;

        end
    end
end

save(resultsFile, ...
    'allSubjectsLI', ...
    'powerLeftStimIpsi', 'powerLeftStimContra', ...
    'powerRightStimIpsi', 'powerRightStimContra', ...
    'timeVector', 'freqVector', 'channelLabels', ...
    'loads', 'targets', 'leftChannels', 'rightChannels', ...
    'alphaBand', 'baselineWindow', 'analysisWindow', ...
    'layoutFile', ...
    '-v7.3');
