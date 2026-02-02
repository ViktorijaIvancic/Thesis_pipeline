% load variables and subjects

close all;

run('00_setup_li_power.m');
loaded = load(resultsFile, ...
    'allSubjectsLI','loads','targets','leftChannels','rightChannels','channelLabels','layoutFile');

allSubjectsLI = loaded.allSubjectsLI;
loads = loaded.loads;
targets = loaded.targets;
leftChannels = loaded.leftChannels;
rightChannels = loaded.rightChannels;
channelLabels = loaded.channelLabels;
layoutFile = loaded.layoutFile;

for loadIndex = 1:numel(loads)
    for targetIndex = 1:numel(targets)

        currentLoad   = loads{loadIndex};
        currentTarget = targets{targetIndex};

        groupLI = mean(allSubjectsLI.(currentLoad).(currentTarget), 1, 'omitnan');  % average LI across subjects

        topoVector = zeros(numel(channelLabels),1);

        for channelIndex = 1:numel(leftChannels)  % assign LI values to their corresponding left/right electrodes
            leftLabel  = leftChannels{channelIndex};
            rightLabel = rightChannels{channelIndex};

            leftChanIndex  = find(strcmp(channelLabels, leftLabel));
            rightChanIndex = find(strcmp(channelLabels, rightLabel));

            topoVector(leftChanIndex)  = -groupLI(channelIndex);
            topoVector(rightChanIndex) =  groupLI(channelIndex);
        end

        topoData = [];
        topoData.label  = channelLabels;
        topoData.avg    = topoVector;
        topoData.dimord = 'chan';

        cfg = [];
        cfg.layout       = layoutFile;
        cfg.zlim         = 'maxabs'; % or limit from -n to n 
        cfg.colormap     = brewermap(256,'*RdBu'); % you need to add this package, or can just use default MALTAB colormap
        cfg.marker       = 'off';
        cfg.comment      = 'no';
        cfg.style        = 'both';
        cfg.contournum   = 8;
        cfg.interplimits = 'head';
        cfg.shading      = 'interp';

        figure;
        ft_topoplotER(cfg, topoData);
        title(sprintf('Group LI %s - %s (alpha 8–14 Hz, 0.4–0.6 s)', currentLoad, currentTarget));

    end
end
