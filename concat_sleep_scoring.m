

% % Load Rat folder from sleep scoring folders
% % iterate through study days
% % remove zeros
% % append NaNs if size<2700
% % limit states to 2700
% % append 300 7s for trial wake labelling
% % concat all
% % save concatenated scoring array
% % 
x=[];
Trial_Wake=ones(1,300)*7; states_before_PT5=[];
root='/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring';
root_dir=dir(root);
root_dir=root_dir([root_dir(:).isdir]);
rat_folders = root_dir(~ismember({root_dir(:).name},{'.','..'}));
rat_folder_names=extractfield(rat_folders,'name');

for i=1:length(rat_folder_names)
    A=strcat(root,'/',rat_folder_names{i});
    cd(A)
    study_day_dir= dir(A);
    study_day_dir= study_day_dir([study_day_dir(:).isdir]);
    study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));
    study_day_folder_names=natsort(extractfield(study_day_folders,'name'));
    
    for j=1:length(study_day_folder_names)
        
        states_before_PT5=[];
       
        B=strcat(A,'/',study_day_folder_names{j});
        cd(B)
        sleep_scoring_files=dir('*.mat');
        sleep_scoring_files=natsort(extractfield(sleep_scoring_files,'name'));
        
         for k=1:length(sleep_scoring_files)
%             states_with_trial_wake=[];
            File=load(sleep_scoring_files{k});
            states=File.states;
            states_corrected_prelim=corrected_states(states); %% removes zeros plus invalid error bouts between two similar sleep stages
            
            
            if k<length(sleep_scoring_files)%% Every file except post trial 5
                 
                if  size(states_corrected_prelim,2)<2700
                    difference=2700-size(states_corrected_prelim,2);
                    states_corrected_prelim=[states_corrected_prelim, NaN(1,difference)];
                    
                else
                     states_corrected_prelim=states_corrected_prelim(1:2700);
                    
                end
                
                
                states_with_trial_wake=[states_corrected_prelim,Trial_Wake];
                
                states_before_PT5=[states_before_PT5,states_with_trial_wake];
                
            else %% Post trial 5 is 3 hrs 
                
                states_PT5=states_corrected_prelim;
                
                if  size(states_PT5,2)<10800
                    difference2=10800-size(states_PT5,2);
                    states_corrected_PT5=[states_PT5, NaN(1,difference2)];
                    
                else
                    
                    states_corrected_PT5=states_PT5(1:10800);
 
                end
                
                 %% Exactly 3 hours
                
                states_with_PT5=[states_before_PT5,states_corrected_PT5]; %% Appending the rest of the day to post trial 5
                
                states_corrected_MA=find_MA(states_with_PT5); %% Assigns MicroArousal State ('2') to bout durations of quiet wake less than or equal to 15ms
                
%                 states_corrected_NREM=find_short_nrem(states_corrected_MA);%% Assigns short NREM States ('6') to bout durations of nrem less than or equal to 40ms
%                 states_corrected_Intermediate=find_short_intermediate(states_corrected_NREM);%% Assigns short NREM States ('8') to bout durations of nrem less than or equal to 25 ms
%                 states_corrected_REM=find_short_rem(states_corrected_Intermediate);%% Assigns short REM States ('10') to bout durations of rem less than or equal to 40 ms
                
                states_corrected_final=states_corrected_MA;
                
                
                
            end

         end
         save(strcat('Concatenated_Sleep_Scores','_',study_day_folder_names{j},'.mat'),'states_corrected_final') %% Save file after final operation
%           delete(strcat('Concatenated_Sleep_Scores','_',study_day_folder_names{j},'.mat')) %% Save file after final operation

%            X=load('states_corrected_final.mat'); %% Save file after final operation
%            
%            if size(X,2)~=25800
%                x=sprintf("%s is not properly concatenated ",study_day_folder_names{j});
%                
%            end    
    end
    
    
    
    
end

