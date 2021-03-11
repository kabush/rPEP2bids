%%========================================
%%========================================
%%
%% Keith Bush (2020)
%% Univ. of Arkansas for Medical Sciences
%% Brain Imaging Research Center (BIRC)
%%
%%========================================
%%========================================

function [log_table] = mod_log2tsv(proj,data)

log_table = table();

Nvols = 228;
TR = 2.0;

curr_state = data(1,3);
curr_onset = data(1,9);
curr_vol = data(1,2);
curr_fb = data(1,4);
curr_trans = data(1,8)

cnt = 1;
all_onsets{cnt} = curr_onset;
all_vols{cnt} = curr_vol;
all_fbs{cnt} = curr_fb;
all_trans{cnt} = curr_trans;
all_types{cnt} = 'stims_rst';

convert_type = 0;
for i=2:size(data,1)

    if(data(i,3)~=curr_state)

        old_state = curr_state;
        curr_state = data(i,3);
        curr_onset = data(i,9);
        curr_vol = data(i,2);
        curr_fb = 0.0;
        curr_trans = 0.0;
        cnt = cnt + 1;
        convert_type = 1;
        
    else

        if(curr_state==65 | curr_state==70 | curr_state==75 | curr_state==80)

            curr_onset = data(i,9);
            curr_vol = data(i,2);
            curr_fb = data(i,4); % true fb from tabs
            curr_trans = data(i,8);
            cnt = cnt + 1;
            convert_type = 1;
        
        end

    end

    all_onsets{cnt} = curr_onset;
    all_vols{cnt} = curr_vol;
    all_fbs{cnt} = curr_fb;
    all_trans{cnt} = curr_trans;

    if(convert_type)

        if(curr_state == 50)
           all_types{cnt} = 'instr_aro';
        end

        if(curr_state == 55)
           all_types{cnt} = 'instr_sup';
        end

        if(curr_state == 75)
           all_types{cnt} = 'stims_aro';
        end

        if(curr_state == 80)
           all_types{cnt} = 'stims_sup';
        end

        if(curr_state == 15)
           all_types{cnt} = 'stims_rst';
        end

        if(curr_state == 20)
           all_types{cnt} = 'stims_fin';
        end

        if(curr_state == 40)
           all_types{cnt} = 'instr_fba';
        end

        if(curr_state == 45)
           all_types{cnt} = 'instr_fbs';
        end

        if(curr_state == 65)
           all_types{cnt} = 'stims_fba';
        end

        if(curr_state == 70)
           all_types{cnt} = 'stims_fbs';
        end

        convert_type = 0;
 
    end      

end

cnt = cnt + 1;

%% Compute true duration times
tmp_all_onsets = [cell2mat(all_onsets),Nvols*TR];
all_dur_t = diff(tmp_all_onsets);

%% Compute designed duration times
tmp_all_vols = [cell2mat(all_vols),Nvols-1];
all_dsgn_dur_t = diff(tmp_all_vols)*TR;

%% Convert to cell
for i=1:numel(all_onsets)
    cell_dur_t{i} = all_dur_t(i);
    cell_dsgn_dur_t{i} = all_dsgn_dur_t(i);
end

for i=1:numel(all_onsets)
    onset{i} = sprintf('%5.3f',all_onsets{i});
    duration{i} = sprintf('%5.3f',cell_dur_t{i});
    dsgn_onset{i} = sprintf('%5.1f',all_vols{i}*TR);
    dsgn_duration{i} = sprintf('%5.1f',cell_dsgn_dur_t{i});
    feedback{i} = sprintf('%5.3f',all_fbs{i});
    transparency{i} = sprintf('%5.3f',all_trans{i});
end
trial_type = all_types;

onset = onset';
duration = duration';
dsgn_onset = dsgn_onset';
dsgn_duration = dsgn_duration';
feedback = feedback';
transparency = transparency';

trial_type = trial_type';

log_table = table(onset,...
                  duration,...
                  dsgn_onset,...
                  dsgn_duration,...
                  trial_type,...
                  feedback,...
                  transparency);
