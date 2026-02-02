% 
run('00_setup_li_power.m');

resultsFolder = 'results_tfr_maps';
resultsFile = fullfile(resultsFolder, 'tfr_maps_results.mat');

loaded = load(resultsFile, 'tfrData', 'loads', 'targets', 'timeVector', 'freqVector', 'alphaBand', 'subjectlist');
tfrData = loaded.tfrData;
loads = loaded.loads;
targets = loaded.targets;
timeVector = loaded.timeVector;
freqVector = loaded.freqVector;
alphaBand = loaded.alphaBand;
subjectlist = loaded.subjectlist;

conditionLabels = cell(1, numel(loads)*numel(targets));
conditionCounter = 1;
for loadIndex = 1:numel(loads)
    for targetIndex = 1:numel(targets)
        conditionLabels{conditionCounter} = sprintf('%s-%s', loads{loadIndex}, targets{targetIndex});
        conditionCounter = conditionCounter + 1;
    end
end

figure('Position',[50 50 1800 500]);

for conditionIndex = 1:numel(conditionLabels)

    loadName   = loads{ceil(conditionIndex/numel(targets))};
    targetName = targets{mod(conditionIndex-1,numel(targets))+1};

    grandIpsi   = squeeze(mean(tfrData.(loadName).(targetName).ipsi,   1, 'omitnan'));
    grandContra = squeeze(mean(tfrData.(loadName).(targetName).contra, 1, 'omitnan'));
    grandDiff   = squeeze(mean(tfrData.(loadName).(targetName).diff,   1, 'omitnan'));

    subplot(3,numel(conditionLabels), conditionIndex);
    imagesc(timeVector, freqVector, grandIpsi);
    axis xy;
    colormap(flipud(brewermap([], 'RdBu')));
    colorbar;
    title(sprintf('Ipsi %s-%s', loadName, targetName));
    xlabel('Time (s)'); ylabel('Frequency (Hz)');
    xlim([-0.2 1]); ylim([5 30]);
    hold on;
    plot(xlim,[alphaBand(1) alphaBand(1)],'k--');
    plot(xlim,[alphaBand(2) alphaBand(2)],'k--');
    hold off;

    subplot(3,numel(conditionLabels), conditionIndex + numel(conditionLabels));
    imagesc(timeVector, freqVector, grandContra);
    axis xy;
    colormap(flipud(brewermap([], 'RdBu')));
    colorbar;
    title(sprintf('Contra %s-%s', loadName, targetName));
    xlabel('Time (s)'); ylabel('Frequency (Hz)');
    xlim([-0.2 1]); ylim([5 30]);
    hold on;
    plot(xlim,[alphaBand(1) alphaBand(1)],'k--');
    plot(xlim,[alphaBand(2) alphaBand(2)],'k--');
    hold off;

    subplot(3,numel(conditionLabels), conditionIndex + 2*numel(conditionLabels));
    imagesc(timeVector, freqVector, grandDiff);
    axis xy;
    colormap(flipud(brewermap([], 'RdBu')));
    colorbar;
    title(sprintf('Diff %s-%s', loadName, targetName));
    xlabel('Time (s)'); ylabel('Frequency (Hz)');
    xlim([-0.2 1]); ylim([5 30]);
    hold on;
    plot(xlim,[alphaBand(1) alphaBand(1)],'k--');
    plot(xlim,[alphaBand(2) alphaBand(2)],'k--');
    hold off;

end

sgtitle(sprintf('TFRs by Load and Target (n=%d)', numel(subjectlist)), 'FontSize',16,'FontWeight','bold');
