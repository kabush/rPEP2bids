%%========================================
%%========================================
%%
%% Ivan Messias (2020)
%% Univ. of Arkansas for Medical Sciences
%% Brain Imaging Research Center (BIRC)
%%
%% Modified by Keith A. Bush (2020) - read times
%% from logfile
%%
%%========================================
%%========================================

function [] = physio_mat2tsv(proj,subj_study,name,task,run_id)

file_path = [];
if(strcmp(task,'Rest'))
    file_path = [proj.path.raw_data,subj_study,'/physio/',subj_study,'_',name,'/',...
                 subj_study,'_',name,'_',task,'.mat'];
else

    if(strcmp(name,'027') ~=0 || strcmp(name,'028') ~=0 || strcmp(name,'030') ~=0)
        file_path = [proj.path.raw_data,subj_study,'/physio/',subj_study,'_',name,'/',...
                     subj_study,'_',name,'_',task,'_run_',num2str(run_id),'.mat'];
    else
        if(strcmp(task,'Identify')~=0)
            file_path = [proj.path.raw_data,subj_study,'/physio/',subj_study,'_',name,'/',...
                         subj_study,'_',name,'_run',num2str(run_id),'_acquisition.mat'];
        end

        if(strcmp(task,'Modulate')~=0)
            file_path = [proj.path.raw_data,subj_study,'/physio/',subj_study,'_',name,'/',...
                         subj_study,'_',name,'_run',num2str(run_id),'_modulation.mat'];
        end
    end

end

disp(file_path);

try

    % load raw physio
    load(file_path);

    % partition data by physio role
    cardiac = data(:,1);
    respiratory = data(:,2);
    scr = data(:,3);

    % construct table (full precision)
    physio_table = table(cardiac,...
                   respiratory,...
                   scr);

    % write data to file
    func_path = [proj.path.data,'sub-',name,'/func/'];
    if(strcmp(task,'Rest'))
        file_name = ['sub-',name,'_task-',lower(task),'_physio.tsv'];
    else
        file_name = ['sub-',name,'_task-',lower(task),num2str(run_id),'_physio.tsv'];
    end

    writetable(physio_table,fullfile(func_path,file_name),...
               'FileType','text','Delimiter','\t',...
               'WriteVariableNames',false);

catch
    logger([file_path,' not found!!!'],proj.path.logfile);
end
