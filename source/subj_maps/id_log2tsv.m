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

function [log_table] = id_log2tsv(proj,data,Nrun);

log_data = struct();

% Using design structure to pull log data
instr_aro_log_ids = find(data(:,3)==50); 
instr_sup_log_ids = find(data(:,3)==55); 
stims_aro_log_ids = find(data(:,3)==75); 
stims_sup_log_ids = find(data(:,3)==80);
stims_rst_log_ids = find(data(:,3)==15);
stims_fin_log_ids = find(data(:,3)==20);

if(Nrun==1)

    log_cnt = 1;
    log_data.type{log_cnt} = 'instr_aro';
    log_data.dsgn_t{log_cnt} = data(instr_aro_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(stims_aro_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(instr_aro_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(stims_aro_log_ids(1),4)-log_data.true_t{log_cnt};
    
    log_cnt = 2;
    log_data.type{log_cnt} = 'stims_aro';
    log_data.dsgn_t{log_cnt} = data(stims_aro_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(stims_rst_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(stims_aro_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(stims_rst_log_ids(1),4)-log_data.true_t{log_cnt};
    
    log_cnt = 3;
    log_data.type{log_cnt} = 'stims_rst';
    log_data.dsgn_t{log_cnt} = data(stims_rst_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(instr_sup_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(stims_rst_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(instr_sup_log_ids(1),4)-log_data.true_t{log_cnt};
    
    log_cnt = 4;
    log_data.type{log_cnt} = 'instr_sup';
    log_data.dsgn_t{log_cnt} = data(instr_sup_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(stims_sup_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(instr_sup_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(stims_sup_log_ids(1),4)-log_data.true_t{log_cnt};

    log_cnt = 5;
    log_data.type{log_cnt} = 'stims_sup';
    log_data.dsgn_t{log_cnt} = data(stims_sup_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(stims_fin_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(stims_sup_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(stims_fin_log_ids(1),4)-log_data.true_t{log_cnt};

    log_cnt = 6;
    Nvols = size(data,1);
    log_data.type{log_cnt} = 'stims_fin';
    log_data.dsgn_t{log_cnt} = data(stims_fin_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(Nvols,2)*2-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(stims_fin_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(Nvols,4)-log_data.true_t{log_cnt};

else

    log_cnt = 1;
    log_data.type{log_cnt} = 'instr_sup';
    log_data.dsgn_t{log_cnt} = data(instr_sup_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(stims_sup_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(instr_sup_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(stims_sup_log_ids(1),4)-log_data.true_t{log_cnt};

    log_cnt = 2;
    log_data.type{log_cnt} = 'stims_sup';
    log_data.dsgn_t{log_cnt} = data(stims_sup_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(stims_rst_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(stims_sup_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(stims_rst_log_ids(1),4)-log_data.true_t{log_cnt};

    log_cnt = 3;
    log_data.type{log_cnt} = 'stims_rst';
    log_data.dsgn_t{log_cnt} = data(stims_rst_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(instr_aro_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(stims_rst_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(instr_aro_log_ids(1),4)-log_data.true_t{log_cnt};
    
    log_cnt = 4;
    log_data.type{log_cnt} = 'instr_aro';
    log_data.dsgn_t{log_cnt} = data(instr_aro_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(stims_aro_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(instr_aro_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(stims_aro_log_ids(1),4)-log_data.true_t{log_cnt};
    
    log_cnt = 5;
    log_data.type{log_cnt} = 'stims_aro';
    log_data.dsgn_t{log_cnt} = data(stims_aro_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(stims_fin_log_ids(1),2)*2.0-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(stims_aro_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(stims_fin_log_ids(1),4)-log_data.true_t{log_cnt};
    
    log_cnt = 6;
    Nvols = size(data,1);
    log_data.type{log_cnt} = 'stims_fin';
    log_data.dsgn_t{log_cnt} = data(stims_fin_log_ids(1),2)*2.0;
    log_data.dsgn_dur_t{log_cnt} = data(Nvols,2)*2-log_data.dsgn_t{log_cnt};
    log_data.true_t{log_cnt} = data(stims_fin_log_ids(1),4);
    log_data.true_dur_t{log_cnt} = data(Nvols,4)-log_data.true_t{log_cnt};

end

% reformat the floating point numbers so that table writes
% to file cleanly
for i=1:numel(log_data.true_t)
    log_data.true_t{i} = sprintf('%05.3f',log_data.true_t{i});
    log_data.true_dur_t{i} = sprintf('%05.3f',log_data.true_dur_t{i});
    log_data.dsgn_t{i} = sprintf('%05.3f',log_data.dsgn_t{i});
    log_data.dsgn_dur_t{i} = sprintf('%05.3f',log_data.dsgn_dur_t{i});
end

onset = log_data.true_t';
duration = log_data.true_dur_t';
dsgn_onset = log_data.dsgn_t';
dsgn_duration = log_data.dsgn_dur_t';
trial_type = log_data.type';

log_table = table(onset,...
                  duration,...
                  dsgn_onset,...
                  dsgn_duration,...
                  trial_type);
