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
logger([' Map Subject-level MRI data          '],proj.path.logfile);
logger(['************************************************'],proj.path.logfile);

%% Load in path data
load('proj.mat');

%% Create the subjects to be analyzed (possible multiple studies)
subjs = load_subjs(proj);

%% Preprocess fMRI of each subject in subjects list 
for i=1:numel(subjs)

    %% extract subject info
    subj_study = subjs{i}.study;
    name = subjs{i}.name;

    %% ----------------------------------------
    %% Adjust for R5 upgrade to Phillips
    pre_name = '';
    if(str2num(name)<25)
        pre_name = '_SENSE';
    end

    %% debug
    logger([subj_study,':',name],proj.path.logfile);

    %% ----------------------------------------
    %% Adjust for scan numbering change (???)
    start_num = 4;
    if(str2num(name)<21)
        start_num = 5;

        if(str2num(name)==10)
            start_num = 6;
        end

        if(str2num(name)==16)
            start_num = 9;
        end

    else
        if(str2num(name)==27)
            start_num = 5;
        end
    end

    %% ----------------------------------------
    %% Adjust name of study for typo
    subj_study_file = 'rPEP';
    if(str2num(name)==6)
        subj_study_file = 'rtPEP';
    end



    %% ----------------------------------------
    %% map anatomical mri (anat directory)

    % define location
    anat_path = [proj.path.data,'sub-',name,'/anat/'];

    % *** TICKET ***
    % place DEFACED T1 in directory (SLOW)
    cmd = ['! /usr/local/miniconda3/bin/python ',...
           '/home/kabush/workspace/code/pydeface/pydeface --outfile ',...
           anat_path,'sub-',name,'_T1w.nii ',...
           proj.path.raw_data,proj.path.data_name,'/',subj_study,'_',name,'/',...
           subj_study_file,'_',name,'_sT1W*.nii '];
    disp(cmd);
    eval(cmd);

%     % do without deface for now
%     cmd = ['! cp ',proj.path.raw_data,proj.path.data_name,'/',...
%            subj_study,'_',name,'/',subj_study_file,'_',name,'_sT1W*.nii ',...
%            anat_path,'sub-',name,'_T1w.nii'];
%     disp(cmd);
%     eval(cmd);

    % gzip
    cmd = ['! gzip ',anat_path,'sub-',name,'_T1w.nii'];
    disp(cmd);
    eval(cmd);    

    %% ----------------------------------------
    %% map functional mri (func directory)

    % define location
    func_path = [proj.path.data,'sub-',name,'/func/'];

    % copy raw identify 1 (and rename)
    cmd = ['! cp ',proj.path.raw_data,proj.path.data_name,'/',subj_study,'_',name,'/',...
           subj_study_file,'_',name,'_trauma_acquire',pre_name,'_',num2str(start_num),'_1.nii ',func_path,...
           'sub-',name,'_task-identify1_bold.nii'];
    disp(cmd);
    eval(cmd);

    % copy raw identify 2 (and rename)
    cmd = ['! cp ',proj.path.raw_data,proj.path.data_name,'/',subj_study,'_',name,'/',...
           subj_study_file,'_',name,'_trauma_acquire',pre_name,'_',num2str(start_num+1),'_1.nii ',func_path,...
           'sub-',name,'_task-identify2_bold.nii'];
    disp(cmd);
    eval(cmd);

    % copy raw modulata 1A (and rename)
    cmd = ['! cp ',proj.path.raw_data,proj.path.data_name,'/',subj_study,'_',name,'/',...
           subj_study_file,'_',name,'_modulate_A',pre_name,'_',num2str(start_num+2),'_1.nii ',func_path,...
           'sub-',name,'_task-modulate1_bold.nii'];
    disp(cmd);
    eval(cmd);


    if(strcmp(name,'028') ~=0 | strcmp(name,'013') ~= 0)

        % copy raw modulata 1B (and rename)
        cmd = ['! cp ',proj.path.raw_data,proj.path.data_name,'/',subj_study,'_',name,'/',...
               subj_study_file,'_',name,'_modulate_B',pre_name,'_',num2str(start_num+4),'_1.nii ',func_path,...
               'sub-',name,'_task-modulate2_bold.nii'];
        disp(cmd);
        eval(cmd);

    else
        % copy raw modulata 1B (and rename)
        cmd = ['! cp ',proj.path.raw_data,proj.path.data_name,'/',subj_study,'_',name,'/',...
               subj_study_file,'_',name,'_modulate_B',pre_name,'_',num2str(start_num+3),'_1.nii ',func_path,...
               'sub-',name,'_task-modulate2_bold.nii'];
        disp(cmd);
        eval(cmd);

    end

    %% logger('*** TICKET **** uncomment before using for real!',proj.path.logfile);
    
    % gzip all files
    cmd = ['! gzip ',func_path,'*'];
    disp(cmd);
    eval(cmd);    

end
