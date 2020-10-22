 %%========================================
%%========================================
%%
%% Keith Bush, PhD (2020)
%% Univ. of Arkansas for Medical Sciences
%% Brain Imaging Research Center (BIRC)
%%
%% Co-authors: Ivan Messias (2019)
%%             Kevin Fialkowski (2019)
%%
%%========================================
%%========================================

%% Initialize log section
logger(['************************************************'],proj.path.logfile);
logger([' Map Subj-level Identify Event files from Logs  '],proj.path.logfile);
logger(['************************************************'],proj.path.logfile);

%% ========================================
%% This script merges three independent logs created
%% during the rPEP real-time processing.
%% ========================================

%% Load in path data
load('proj.mat');

%% Create the subjects to be analyzed (possible multiple studies)
subjs = load_subjs(proj);

%% ========================================
%% Preprocess fMRI of each subject in subjects list 
%% ========================================
%%
%% Special Cases ***NOT*** Handled by code (Hand Edit!!!)
%%
%% Run 1 (miss-logged feedback)

%% Run 2 (miss-logged feedback)
%% N/A

for i = 1:1 %numel(subjs)

    %%  Assign file paths
    design_path = proj.path.design;  %raw design
    log_path = proj.path.log;  %log
    tmp_path = [proj.path.code,'tmp/'];
    
    %% extract subject info
    subj_study = subjs{i}.study;
    name = subjs{i}.name;

    %% debug
    logger([subj_study,':',name],proj.path.logfile);

    %% ----------------------------------------
    %% Pull Identify 1 log data below
    
    %% % Load in design files
    %% load([design_path,'run1_design.mat']);
    
    % Creat a list of log files for study and subject
    cmd = ['! ls ',proj.path.raw_data,subj_study,'/logfile/', ...
           subj_study,'_',name,'/logfile_experiment*.log > ',tmp_path,subj_study,'_', ...
           name,'_log_list.txt'];
    disp(cmd);
    eval(cmd);

    % Extract name of Modulate 1
    cmd = ['! sed -n ''1{p;q}'' ',tmp_path,subj_study,'_',name,...
           '_log_list.txt > ',tmp_path,'modulate_1_logfile.txt'];
    disp(cmd);
    eval(cmd);
    
    fid = fopen([tmp_path,'modulate_1_logfile.txt'],'r');
    filename = fscanf(fid,'%s');
    fclose(fid);
    
    % Read the correct logfile
    cmd = ['! tail ',filename,' -n +2 > ',tmp_path,'modulate_1_log.txt'];
    disp(cmd);
    eval(cmd);
    raw_log_data = csvread([tmp_path,'modulate_1_log.txt']);
    raw_log_data

    % Pull the logfile's data
    [mod1_log_table] = mod_log2tsv(proj,raw_log_data);
    mod1_log_table

%%     % Transfer table to text file
%%     file_name = ['sub-',name,'_task-identify1_events.tsv'];
%%     func_path = [proj.path.data,'sub-',name,'/func/'];
%%     writetable(id1_log_table,fullfile(func_path,file_name),...
%%                'FileType','text','Delimiter','\t');







%     %%  Assign file paths
%     design_path = proj.path.mod_design;  %raw design
%     log_path = proj.path.log;  %log
%     tmp_path = [proj.path.code,'tmp/'];
%     
%     %% extract subject info
%     subj_study = subjs{i}.study;
%     name = subjs{i}.name;
% 
%     %% debug
%     logger([subj_study,':',name],proj.path.logfile);
% 
%     % ----------------------------------------
%     % Modulate 1 Log table
%     logger(['  Mod 1'],proj.path.logfile);
%     run_id = 1;
%     load([design_path,'run',num2str(run_id),'_design.mat']);
%     design = run1_design;
%     [mod1_log_table] = mod_log2tsv(proj,design,subj_study,name,run_id);
% 
%     file_name = ['sub-',name,'_task-modulate1_events.tsv'];
%     func_path = [proj.path.data,'sub-',name,'/func/'];
%     writetable(mod1_log_table,fullfile(func_path,file_name),'FileType','text','Delimiter','\t');
% 
%     % ----------------------------------------
%     % Modulate 2 Log table
%     logger(['  Mod 2'],proj.path.logfile);
%     run_id = 2;
%     load([design_path,'run',num2str(run_id),'_design.mat']);
%     design = run2_design;
%     [mod2_log_table] = mod_log2tsv(proj,design,subj_study,name,run_id);
% 
%     file_name = ['sub-',name,'_task-modulate2_events.tsv'];
%     func_path = [proj.path.data,'sub-',name,'/func/'];
%     writetable(mod2_log_table,fullfile(func_path,file_name),'FileType','text','Delimiter','\t');

end
