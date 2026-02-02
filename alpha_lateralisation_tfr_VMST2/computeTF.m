clear;


% find all datasets
mkdir tf_data
% find all datasets
filelist                        = dir('derivatives\preproc\*.mat');

% loop through them
for nsub = 1:length(filelist)

    suj                         = strsplit(filelist(nsub).name,'_cleaned.mat');
    subjectname                 = suj{1}; clear suj

    fname_in                    = [filelist(nsub).folder filesep filelist(nsub).name];
    fprintf('Loading %s\n',fname_in);
    load(fname_in);

    % this goes back to rawdataset and brings information about
    % correct/incorrect responses if they're not there

    if ~isfield(data_clean,'correct')
        new_trialinfo               = func_go_get_correct(subjectname,data_clean);
        data_clean.trialinfo        = new_trialinfo ; clear new_trialinfo;
    end

    list_target                     = {'absent' 'present'};
    list_side                       = {'left' 'right'};

    for nload = [2 8]
        for n_target = [0 1]
            for n_side = [1 2]

                name_cond           = [list_target{n_target+1} '.' list_side{n_side} '.load' num2str(nload)];
                fname_out           = ['tf_data/' subjectname '.tf.' name_cond '.mat'];

                if ~exist(fname_out)

                    % choose trials
                    trial_index     = find(data_clean.trialinfo.target == n_target ...
                        & data_clean.trialinfo.side == n_side ...
                        & data_clean.trialinfo.load == nload ...
                        & data_clean.trialinfo.correct == 212);

                    cfg             = [] ;
                    cfg.output      = 'pow';
                    cfg.method      = 'mtmconvol';
                    cfg.keeptrials  = 'yes';
                    cfg.pad         = 'maxperlen';
                    cfg.taper       = 'hanning';
                    cfg.trials      = trial_index;
                    cfg.foi         = 1:1:40;
                    cfg.t_ftimwin   = 4./cfg.foi; % 4 cycles
                    cfg.tapsmofrq   = 0.2 *cfg.foi;
                    cfg.toi         = -2:0.02:2;
                    freq            = ft_freqanalysis(cfg,data_clean);
                    freq            = rmfield(freq,'cfg');


                    fprintf('Saving %s\n',fname_out);
                    save(fname_out,'freq','-v7.3');

                end
            end
        end
    end
end