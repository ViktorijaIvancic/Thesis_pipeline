% creating bipolar pairs of EOG 
clear; clc;
run('00_setup.m');

stageInFolder  = fullfile(preprocessed_folder,'stage02_reref_reject');
stageFolder = fullfile(preprocessed_folder,'stage03_eog_append');
if ~exist(stageFolder,'dir'); mkdir(stageFolder); end

for subjectIndex = 1:numel(subjectlist)
participant = subjectlist{subjectIndex};


inFile = fullfile(stageInFolder, [participant '_stage02.mat']);
loaded = load(inFile, 'data_rej');
data_rej = loaded.data_rej;


cfg                         = [];
cfg.channel                 = {'EOGvT' 'EOGvB'};
cfg.reref                   = 'yes';
cfg.implicitref             = [];
cfg.refchannel              = {'EOGvT'};
eogv                        = ft_selectdata(cfg, data_rej);

cfg                         = [];
cfg.channel                 = 'EOGvT';
eogv                        = ft_selectdata(cfg, eogv);
eogv.label                  = {'EOGv'};

cfg                         = [];
cfg.channel                 = {'HEOGL' 'HEOGR'};
cfg.reref                   = 'yes';
cfg.implicitref             = [];
cfg.refchannel              = {'HEOGL'};
eogh                        = ft_preprocessing(cfg, data_rej);

cfg                         = [];
cfg.channel                 = 'HEOGR';
eogh                        = ft_selectdata(cfg, eogh);
eogh.label                  = {'EOGh'};

cfg                         = [];
cfg.channel                 = setdiff(1:63, [1, 31, 37, 54]); % chose the n for your EOG electrodes 
data_rej                    = ft_selectdata(cfg, data_rej);

cfg                         = [];
data_rej                    = ft_appenddata(cfg, data_rej, eogv, eogh);

cfg             = [];
cfg.layout      = dcclayout;
layout          = ft_prepare_layout(cfg);

outFile = fullfile(stageFolder, [participant '_stage03.mat']);
save(outFile, 'data_rej', 'layout', '-v7.3');

end
