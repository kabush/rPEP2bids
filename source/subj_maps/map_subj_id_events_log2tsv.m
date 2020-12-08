%%========================================
%%========================================
%%
%% Keith Bush, PhD (2020)
%% Univ. of Arkansas for Medical Sciences
%% Brain Imaging Research Center (BIRC)
%%
%%========================================
%%========================================

%% Initialize log section
logger(['************************************************'],proj.path.logfile);
logger([' Map Subj-level Identify Event files from Logs  '],proj.path.logfile);
logger(['************************************************'],proj.path.logfile);

%% Load in path data
load('proj.mat');

%% Create the subjects to be analyzed (possible multiple studies)
subjs = load_subjs(proj);

for i=1:numel(subjs)

    %%  Assign file paths
    log_path = proj.path.log;  %log
    tmp_path = [proj.path.code,'tmp/'];
    
    %% extract subject info
    subj_study = subjs{i}.study;
    name = subjs{i}.name;

    %% debug
    logger([subj_study,':',name],proj.path.logfile);

    %% ----------------------------------------
    %% Pull Identify 1 log data below
        
    % Creat a list of log files for study and subject
    cmd = ['! ls ',proj.path.raw_data,subj_study,'/logfile/', ...
           subj_study,'_',name,'/logfile_collection*.log > ',tmp_path,subj_study,'_', ...
           name,'_log_list.txt'];
    disp(cmd);
    eval(cmd);

    % Extract name of Identify 1
    cmd = ['! sed -n ''1{p;q}'' ',tmp_path,subj_study,'_',name,...
           '_log_list.txt > ',tmp_path,'identify_1_logfile.txt'];
    disp(cmd);
    eval(cmd);
    
    fid = fopen([tmp_path,'identify_1_logfile.txt'],'r');
    filename = fscanf(fid,'%s');
    fclose(fid);
    
    % Read the correct logfile
    cmd = ['! tail ',filename,' -n +2 > ',tmp_path,'identify_1_log.txt'];
    disp(cmd);
    eval(cmd);
    raw_log_data = csvread([tmp_path,'identify_1_log.txt']);
    
    % Pull the logfile's data
    [id1_log_table] = id_log2tsv(proj,raw_log_data,1);
    % id1_log_table

    % Transfer table to text file
    file_name = ['sub-',name,'_task-identify1_events.tsv'];
    func_path = [proj.path.data,'sub-',name,'/func/'];
    writetable(id1_log_table,fullfile(func_path,file_name),...
               'FileType','text','Delimiter','\t');

    % debug
    disp(' ');
    disp(' ');
    disp(' ');
    
    %% ----------------------------------------
    %% Pull Identify 2 log data below
    
    % Creat a list of log files for study and subject
    cmd = ['! ls ',proj.path.raw_data,subj_study,'/logfile/', ...
           subj_study,'_',name,'/logfile_collection*.log > ',tmp_path,subj_study,'_', ...
           name,'_log_list.txt'];
    disp(cmd);
    eval(cmd);

    % Extract name of Identify 2
    cmd = ['! sed -n ''2{p;q}'' ',tmp_path,subj_study,'_',name,...
           '_log_list.txt > ',tmp_path,'identify_2_logfile.txt'];
    disp(cmd);
    eval(cmd);

    
    fid = fopen([tmp_path,'identify_2_logfile.txt'],'r');
    filename = fscanf(fid,'%s');
    fclose(fid);
    
    % Read the correct logfile
    cmd = ['! tail ',filename,' -n +2 > ',tmp_path,'identify_2_log.txt'];
    disp(cmd);
    eval(cmd);
    raw_log_data = csvread([tmp_path,'identify_2_log.txt']);
    
    % Pull the logfile's data
    [id2_log_table] = id_log2tsv(proj,raw_log_data,2);
    % id2_log_table    

    % Transfer table to text file
    file_name = ['sub-',name,'_task-identify2_events.tsv'];
    func_path = [proj.path.data,'sub-',name,'/func/'];
    writetable(id2_log_table,fullfile(func_path,file_name),...
               'FileType','text','Delimiter','\t');

    % Clean-up
    eval(['! rm ',tmp_path,'*']);

end
