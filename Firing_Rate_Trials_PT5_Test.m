function [Final_Rat_Struct,bout_duration_all,firing_rate_per_bout_all]=Firing_Rate_Trials_PT5_Test(Sleep_Scoring_Directory_For_Rat,Spike_Corrected_WFM)

% % [Final_Rat_Struct]=Firing_Rate_Trials_PT5_Test('/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring/Rat3_357152',Rat_3_SP_Corrected_WFM);
%  Rat3_Data=Firing_Rate_Trials('/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring/Rat3_357152','/media/irene/MD04_RAT_SPIKE/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152','RAT_3_TEMP_SD_BEST_WFM.mat');
% % Get the concantenated sleep scoring file  for each study day for the rat
% % For a study day, get waveforms of that study day
% % define specific post trial period durations
% % for each post trial duration get ranges
% % get ranges(1,1) and ranges(1,2) as idx1 and idx2 (idx2-idx1)/30000 is the bout duration
% % definining units as spiketimes of that unit, write units_spliced as needed
% % size(units_spliced,1)/bout duration is the firing rate during that bout; average across the number of bouts for that stage in the post trial
% % combine all post trial structs for a unit in one struct; do this for each unit in that study day
% % combine data from all study days to get Final_Rat_Struct

A=Sleep_Scoring_Directory_For_Rat; %'/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring/Rat3_357152';
study_day_dir= dir(A);
study_day_dir= study_day_dir([study_day_dir(:).isdir]);
study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));
study_day_folder_names=natsort(extractfield(study_day_folders,'name'));

%% Initializing global variables

PS=[];T1=[];PT1=[];T2=[];PT2=[];T3=[];PT3=[];T4=[];PT4=[];T5=[];PT5=[]; PT5_Part_1=[];PT5_Part_2=[];PT5_Part_3=[];PT5_Part_4=[]; PT5_1=[]; PT5_2=[];PT5_3=[];PT5_4=[]; PT5_Final=[];Post_Trial_5=[];
bout_duration_all=[];
firing_rate_per_bout_all=[];
Units=[];
% Rat_Data=load(BEST_WFM).Stored_WFMs;

%Rat_x_Data=Spike_Times_Correction(Standard_Rat_Directory,BEST_WFM);
Rat_x_Data=Spike_Corrected_WFM;

Study_Day_Names=[];

for a=1:length(study_day_folder_names)
    K=strfind(study_day_folder_names{a},'_SD');
    SD=study_day_folder_names{a};
    SD=SD(K+3:K+4);
    SD=regexp(SD,'_','split');
    Study_Day_Names=[Study_Day_Names {strcat('SD',SD{1})}];
end

for SD_Names=1:length(study_day_folder_names) %% test for SD1
    for rat_data_index=1:size(Rat_x_Data,1)
        Name_Rat_Data=Rat_x_Data(rat_data_index).WFM_Titles;
        Name_Rat_Data=convertStringsToChars(Name_Rat_Data);
        Find_SD=strfind(Name_Rat_Data,'_SD');
        
        SD_Number=Name_Rat_Data(Find_SD+3:Find_SD+5);
        SD_Temp=regexp(SD_Number,'_','split');
        SD_Final_Rat_Data=strcat('SD',SD_Temp{1});
        
        if strcmp(SD_Final_Rat_Data,Study_Day_Names{SD_Names})
        
        %if contains(Rat_x_Data(rat_data_index).WFM_Titles,Study_Day_Names{SD_Names})
            
              disp(rat_data_index)
%             count=count+1;
%             disp(strcat('unit count:',string(count)))
            PT5_1=[]; PT5_2=[];PT5_3=[];PT5_4=[];
            
            Current_unitID_Name=Rat_x_Data(rat_data_index).WFM_Titles;
            
%             Names=[Names; Current_unitID_Name];
            
            Current_UnitID_spiketimes=Rat_x_Data(rat_data_index).curSpikeTimes;
            units=Current_UnitID_spiketimes;
            
            Sleep_Dir=strcat(A,'/',study_day_folder_names{SD_Names});
            cd(Sleep_Dir)
            %% Entering the main analysis
            states_all=load(strcat('Concatenated_Sleep_Scores','_',study_day_folder_names{SD_Names},'.mat')).states_corrected_final;
            
            % Presleep
            states_presleep=states_all(1:2700);
            
            % Trial 1
            states_trial_1=states_all(2701:3000);
            % Post trial 1
            states_PT1=states_all(3001:5700);
            
            % Trial 2
            states_trial_2=states_all(5701:6000);
            % Post trial2
            states_PT2=states_all(6001:8700);
            
            % Trial 3
            states_trial_3=states_all(8701:9000);
            % Post trial 3
            states_PT3=states_all(9001:11700);
            
            % Trial 4
            states_trial_4=states_all(11701:12000);
            % Post trial 4
            states_PT4=states_all(12001:14700);
            
            % Trial 5
            states_trial_5=states_all(14701:15000);
            % Post trial 5
            states_PT5=states_all(15001:end);
            
            All_Trials=[{states_presleep},{states_trial_1},{states_PT1},{states_trial_2},{states_PT2},{states_trial_3},{states_PT3},{states_trial_4},{states_PT4},{states_trial_5},{states_PT5}];
            
            for trial_index=1:length(All_Trials)
                
                if trial_index<length(All_Trials)
                    
                    Current_Trial=All_Trials{trial_index}; %% Selecting a post trial
                    
                    
                    [ranges_quiet_wake,ranges_microarousal,ranges_NREM,ranges_intermediate,ranges_REM,ranges_wake]=bout_ranges_per_trial(Current_Trial,trial_index);%,threshold_vector_for_treatment);
                    
                    Current_Trial_Stages=[{ranges_quiet_wake},{ranges_microarousal},{ranges_NREM},{ranges_intermediate},{ranges_REM},{ranges_wake}]; %% Getting ranges for all sleep stages
                    
                    for sleep_stages=1:length(Current_Trial_Stages)
                        Current_Sleep_Stage=Current_Trial_Stages{sleep_stages};
                        
                        duration_bout=[]; %% These three vars need to be empty before we start calculating them
                        Avg_Firing_Rate=[];
                        Avg_Firing_Rate_Current_Bout=[];
                        
                        for index_inside_sleep_stage=1:size(Current_Sleep_Stage,2)
                            
                            idx1=Current_Sleep_Stage(index_inside_sleep_stage).Samples_Start;
                            idx2=Current_Sleep_Stage(index_inside_sleep_stage).Samples_End;
                            
                            range=(units(:)> idx1) &   (units(:) < idx2);
                            %disp(range)
                            units_spliced=units(range);
                            %disp(strcat('size of spikes',string(size(units_spliced,1))))
                            
                            duration_bout(index_inside_sleep_stage)= (idx2-idx1)/30000;
                            
                            bout_duration_all=[bout_duration_all; duration_bout(index_inside_sleep_stage)];
                            
                            Avg_Firing_Rate(index_inside_sleep_stage)= size(units_spliced,1)/duration_bout(index_inside_sleep_stage);
                            
                            Avg_Firing_Rate_Current_Bout=[Avg_Firing_Rate_Current_Bout; Avg_Firing_Rate(index_inside_sleep_stage)];
                            
                            firing_rate_per_bout_all=[firing_rate_per_bout_all;Avg_Firing_Rate(index_inside_sleep_stage)];
                            
                        end
                        
                        switch sleep_stages
                            case 1
                                
                                Quiet_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                Quiet_Wake_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                
                            case 2
                                Microarousal_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                
                                Microarousal_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                
                            case 3
                                
                                NREM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                
                                NREM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                            case 4
                                
                                Intermediate_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                
                                Intermediate_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                            case 5
                                
                                REM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                
                                REM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                
                            case 6
                                Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                
                                
                        end
                        
                        
                        
                    end
                    
                    
                else
                    
                    Current_Trial=All_Trials{trial_index}; %% Selecting a post trial
                    
                    
                    [ranges_quiet_wake,ranges_microarousal,ranges_NREM,ranges_intermediate,ranges_REM,ranges_wake]=bout_ranges_per_trial(Current_Trial,trial_index);%,threshold_vector_for_treatment);
                    
                    Current_Trial_Stages=[{ranges_quiet_wake},{ranges_microarousal},{ranges_NREM},{ranges_intermediate},{ranges_REM},{ranges_wake}]; %% Getting ranges for all sleep stages
%                     disp(Current_Trial_Stages{1}.state_1)
                    
                    for empty_trial_index=1:length(Current_Trial_Stages)

                        
                        if cellfun(@isempty,Current_Trial_Stages(empty_trial_index))
                            
                           
                            PT5_1=[PT5_1, {[]}];
                            PT5_2=[PT5_2, {[]}];
                            PT5_3=[PT5_3, {[]}];
                            PT5_4=[PT5_4, {[]}];
                        
                        else
                            PT5_1=[PT5_1 , {Current_Trial_Stages{empty_trial_index}.state_1}];
                            PT5_2=[PT5_2 , {Current_Trial_Stages{empty_trial_index}.state_2}];
                            PT5_3=[PT5_3 , {Current_Trial_Stages{empty_trial_index}.state_3}];
                            PT5_4=[PT5_4 , {Current_Trial_Stages{empty_trial_index}.state_4}];
                            
                        end    
                    end    
%                     PT5_1=[{Current_Trial_Stages{1}.state_1},{Current_Trial_Stages{2}.state_1},{Current_Trial_Stages{3}.state_1}];%,{Current_Trial_Stages{4}.state_1},{Current_Trial_Stages{5}.state_1},{Current_Trial_Stages{6}.state_1}]; %% Account for empty cells
%                     PT5_2=[{ranges_quiet_wake.state_2},{ranges_microarousal.state_2},{ranges_NREM.state_2},{ranges_intermediate.state_2},{ranges_REM.state_2},{ranges_wake.state_2}];
%                     PT5_3=[{ranges_quiet_wake.state_3},{ranges_microarousal.state_3},{ranges_NREM.state_3},{ranges_intermediate.state_3},{ranges_REM.state_3},{ranges_wake.state_3}];
%                     PT5_4=[{ranges_quiet_wake.state_4},{ranges_microarousal.state_4},{ranges_NREM.state_4},{ranges_intermediate.state_4},{ranges_REM.state_4},{ranges_wake.state_4}];
                    
                    PT5=[{PT5_1};{PT5_2};{PT5_3};{PT5_4}];
%                     Post_Trial_5=[Post_Trial_5; {PT5}];
                  
                    %                     for index_PT5=1:4
                    
                    for PT5_index=1:size(PT5,1)
                        
                        
                        Current_PT5_state=PT5{PT5_index};%% PT5_1
                        
                        %                             if isempty(Current_Sleep_Stage)
                        %                                  continue
                        %                             end
                        
                        for sleep_stages=1:length(Current_PT5_state)%% sleep stages inside a 45 min bin
                            
                            Current_Sleep_Stage_PT5=Current_PT5_state{sleep_stages} ;
                            duration_bout=[]; %% These three vars need to be empty before we start calculating them
                            Avg_Firing_Rate=[];
                            Avg_Firing_Rate_Current_Bout=[];
                            
                            for index_inside_sleep_stage=1:size(Current_Sleep_Stage_PT5,2) %%% finding firing rate for a sleep stage
                                
                                idx1=Current_Sleep_Stage_PT5(index_inside_sleep_stage).Samples_Start;
                                idx2=Current_Sleep_Stage_PT5(index_inside_sleep_stage).Samples_End;
                                
                                range=(units(:)> idx1) &   (units(:) < idx2);
                                
                                
%                                 disp(range)
                                units_spliced=units(range);
                                
%                                 disp(strcat('size of spikes',string(size(units_spliced,1))))

                                duration_bout(index_inside_sleep_stage)= (idx2-idx1)/30000;
                                
                                bout_duration_all=[bout_duration_all; duration_bout(index_inside_sleep_stage)];
                                
                                Avg_Firing_Rate(index_inside_sleep_stage)= size(units_spliced,1)/duration_bout(index_inside_sleep_stage);
                                
                                Avg_Firing_Rate_Current_Bout=[Avg_Firing_Rate_Current_Bout; Avg_Firing_Rate(index_inside_sleep_stage)];
                                
                                firing_rate_per_bout_all=[firing_rate_per_bout_all;Avg_Firing_Rate(index_inside_sleep_stage)];
                                
                            end
                            
                            switch PT5_index
                                case 1
                                    
                                    switch sleep_stages
                                        case 1
                                            
                                            PT5_1_Quiet_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_1_Quiet_Wake_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_1.Quiet_Wake_Avg_Firing_Rate=PT5_1_Quiet_Wake_Avg_Firing_Rate;
                                            PT5_Part_1.Quiet_Wake_Bout_Wise_Firing_Rate=PT5_1_Quiet_Wake_Bout_Wise_Firing_Rate;
                                            
                                        case 2
                                            
                                            PT5_1_Microarousal_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_1_Microarousal_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_1.Microarousal_Avg_Firing_Rate=PT5_1_Microarousal_Avg_Firing_Rate;
                                            PT5_Part_1.Microarousal_Bout_Wise_Firing_Rate=PT5_1_Microarousal_Bout_Wise_Firing_Rate;
                                            
                                            
                                        case 3
                                            
                                            PT5_1_NREM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_1_NREM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_1.NREM_Avg_Firing_Rate=PT5_1_NREM_Avg_Firing_Rate;
                                            PT5_Part_1.NREM_Bout_Wise_Firing_Rate=PT5_1_NREM_Bout_Wise_Firing_Rate;
                                        case 4
                                            
                                            PT5_1_Intermediate_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_1_Intermediate_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_1.Intermediate_Avg_Firing_Rate=PT5_1_Intermediate_Avg_Firing_Rate;
                                            PT5_Part_1.Intermediate_Bout_Wise_Firing_Rate=PT5_1_Intermediate_Bout_Wise_Firing_Rate;
                                            
                                        case 5
                                            
                                            PT5_1_REM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_1_REM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_1.REM_Avg_Firing_Rate=PT5_1_REM_Avg_Firing_Rate;
                                            PT5_Part_1.REM_Bout_Wise_Firing_Rate=PT5_1_REM_Bout_Wise_Firing_Rate;
                                            
                                        case 6
                                            PT5_1_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            
                                            
                                    end
                                    
                                case 2
                                    
                                    switch sleep_stages
                                        case 1
                                            
                                            PT5_2_Quiet_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_2_Quiet_Wake_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_2.Quiet_Wake_Avg_Firing_Rate=PT5_2_Quiet_Wake_Avg_Firing_Rate;
                                            PT5_Part_2.Quiet_Wake_Bout_Wise_Firing_Rate=PT5_2_Quiet_Wake_Bout_Wise_Firing_Rate;
                                            
                                        case 2
                                            PT5_2_Microarousal_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_2_Microarousal_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_2.Microarousal_Avg_Firing_Rate=PT5_2_Microarousal_Avg_Firing_Rate;
                                            PT5_Part_2.Microarousal_Bout_Wise_Firing_Rate=PT5_2_Microarousal_Bout_Wise_Firing_Rate;
                                            
                                        case 3
                                            
                                            PT5_2_NREM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_2_NREM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_2.NREM_Avg_Firing_Rate=PT5_2_NREM_Avg_Firing_Rate;
                                            PT5_Part_2.NREM_Bout_Wise_Firing_Rate=PT5_2_NREM_Bout_Wise_Firing_Rate;
                                            
                                            
                                            
                                        case 4
                                            
                                            PT5_2_Intermediate_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_2_Intermediate_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_2.Intermediate_Avg_Firing_Rate=PT5_2_Intermediate_Avg_Firing_Rate;
                                            PT5_Part_2.Intermediate_Bout_Wise_Firing_Rate=PT5_2_Intermediate_Bout_Wise_Firing_Rate;
                                        case 5
                                            
                                            PT5_2_REM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_2_REM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_2.REM_Avg_Firing_Rate=PT5_2_REM_Avg_Firing_Rate;
                                            PT5_Part_2.REM_Bout_Wise_Firing_Rate=PT5_2_REM_Bout_Wise_Firing_Rate;
                                            
                                        case 6
                                            PT5_2_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            
                                            
                                    end
                                    
                                case 3
                                    
                                    switch sleep_stages
                                        case 1
                                            
                                            PT5_3_Quiet_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_3_Quiet_Wake_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_3.Quiet_Wake_Avg_Firing_Rate=PT5_3_Quiet_Wake_Avg_Firing_Rate;
                                            PT5_Part_3.Quiet_Wake_Bout_Wise_Firing_Rate=PT5_3_Quiet_Wake_Bout_Wise_Firing_Rate;
                                            
                                        case 2
                                            PT5_3_Microarousal_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_3_Microarousal_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_3.Microarousal_Avg_Firing_Rate=PT5_3_Microarousal_Avg_Firing_Rate;
                                            PT5_Part_3.Microarousal_Bout_Wise_Firing_Rate=PT5_3_Microarousal_Bout_Wise_Firing_Rate;
                                            
                                        case 3
                                            
                                            PT5_3_NREM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_3_NREM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_3.NREM_Avg_Firing_Rate=PT5_3_NREM_Avg_Firing_Rate;
                                            PT5_Part_3.NREM_Bout_Wise_Firing_Rate=PT5_3_NREM_Bout_Wise_Firing_Rate;
                                            
                                            
                                        case 4
                                            
                                            PT5_3_Intermediate_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_3_Intermediate_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_3.Intermediate_Avg_Firing_Rate=PT5_3_Intermediate_Avg_Firing_Rate;
                                            PT5_Part_3.Intermediate_Bout_Wise_Firing_Rate=PT5_3_Intermediate_Bout_Wise_Firing_Rate;
                                            
                                        case 5
                                            
                                            PT5_3_REM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_3_REM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_3.REM_Avg_Firing_Rate=PT5_3_REM_Avg_Firing_Rate;
                                            PT5_Part_3.REM_Bout_Wise_Firing_Rate=PT5_3_REM_Bout_Wise_Firing_Rate;
                                            
                                        case 6
                                            PT5_3_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            
                                            
                                    end
                                    
                                case 4
                                    
                                    switch sleep_stages
                                        case 1
                                            
                                            PT5_4_Quiet_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_4_Quiet_Wake_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_4.Quiet_Wake_Avg_Firing_Rate=PT5_4_Quiet_Wake_Avg_Firing_Rate;
                                            PT5_Part_4.Quiet_Wake_Bout_Wise_Firing_Rate=PT5_4_Quiet_Wake_Bout_Wise_Firing_Rate;
                                            
                                        case 2
                                            PT5_4_Microarousal_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_4_Microarousal_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_4.Microarousal_Avg_Firing_Rate=PT5_4_Microarousal_Avg_Firing_Rate;
                                            PT5_Part_4.Microarousal_Bout_Wise_Firing_Rate=PT5_4_Microarousal_Bout_Wise_Firing_Rate;
                                            
                                        case 3
                                            
                                            PT5_4_NREM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_4_NREM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_4.NREM_Avg_Firing_Rate=PT5_4_NREM_Avg_Firing_Rate;
                                            PT5_Part_4.NREM_Bout_Wise_Firing_Rate=PT5_4_NREM_Bout_Wise_Firing_Rate;
                                            
                                            
                                        case 4
                                            
                                            PT5_4_Intermediate_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_4_Intermediate_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_4.Intermediate_Avg_Firing_Rate=PT5_4_Intermediate_Avg_Firing_Rate;
                                            PT5_Part_4.Intermediate_Bout_Wise_Firing_Rate=PT5_4_Intermediate_Bout_Wise_Firing_Rate;
                                        case 5
                                            
                                            PT5_4_REM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            PT5_4_REM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                                            
                                            PT5_Part_4.REM_Avg_Firing_Rate=PT5_4_REM_Avg_Firing_Rate;
                                            PT5_Part_4.REM_Bout_Wise_Firing_Rate=PT5_4_REM_Bout_Wise_Firing_Rate;
                                            
                                        case 6
                                            PT5_4_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                                            
                                            
                                    end
                                    
                            end
                            
                        end
                    end
                    
                    
                    %end
                    
                    
                end
                
                switch trial_index
                    
                    case 1
                        PS.Quiet_Wake_Avg_Firing_Rate=Quiet_Wake_Avg_Firing_Rate;
                        PS.Quiet_Wake_Bout_Wise_Firing_Rate=Quiet_Wake_Bout_Wise_Firing_Rate;
                        
                        PS.Microarousal_Avg_Firing_Rate=Microarousal_Avg_Firing_Rate;
                        PS.Microarousal_Bout_Wise_Firing_Rate=Microarousal_Bout_Wise_Firing_Rate;
                        
                        PS.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
                        PS.NREM_Bout_Wise_Firing_Rate=NREM_Bout_Wise_Firing_Rate;
                        
                        PS.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
                        PS.Intermediate_Bout_Wise_Firing_Rate=Intermediate_Bout_Wise_Firing_Rate;
                        
                        PS.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
                        PS.REM_Bout_Wise_Firing_Rate=REM_Bout_Wise_Firing_Rate;
                        
                        
                        
                    case 2
                        T1.Wake_Avg_Firing_Rate=Wake_Avg_Firing_Rate;
                        
                        
                    case 3
                        PT1.Quiet_Wake_Avg_Firing_Rate=Quiet_Wake_Avg_Firing_Rate;
                        PT1.Quiet_Wake_Bout_Wise_Firing_Rate=Quiet_Wake_Bout_Wise_Firing_Rate;
                        
                        PT1.Microarousal_Avg_Firing_Rate=Microarousal_Avg_Firing_Rate;
                        PT1.Microarousal_Bout_Wise_Firing_Rate=Microarousal_Bout_Wise_Firing_Rate;
                        
                        PT1.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
                        PT1.NREM_Bout_Wise_Firing_Rate=NREM_Bout_Wise_Firing_Rate;
                        
                        PT1.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
                        PT1.Intermediate_Bout_Wise_Firing_Rate=Intermediate_Bout_Wise_Firing_Rate;
                        
                        PT1.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
                        PT1.REM_Bout_Wise_Firing_Rate=REM_Bout_Wise_Firing_Rate;
                        
                    case 4
                        T2.Wake_Avg_Firing_Rate=Wake_Avg_Firing_Rate;
                        
                        
                    case 5
                        PT2.Quiet_Wake_Avg_Firing_Rate=Quiet_Wake_Avg_Firing_Rate;
                        PT2.Quiet_Wake_Bout_Wise_Firing_Rate=Quiet_Wake_Bout_Wise_Firing_Rate;
                        
                        PT2.Microarousal_Avg_Firing_Rate=Microarousal_Avg_Firing_Rate;
                        PT2.Microarousal_Bout_Wise_Firing_Rate=Microarousal_Bout_Wise_Firing_Rate;
                        
                        PT2.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
                        PT2.NREM_Bout_Wise_Firing_Rate=NREM_Bout_Wise_Firing_Rate;
                        
                        PT2.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
                        PT2.Intermediate_Bout_Wise_Firing_Rate=Intermediate_Bout_Wise_Firing_Rate;
                        
                        PT2.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
                        PT2.REM_Bout_Wise_Firing_Rate=REM_Bout_Wise_Firing_Rate;
                        
                    case 6
                        T3.Wake_Avg_Firing_Rate=Wake_Avg_Firing_Rate;
                        
                        
                    case 7
                        
                        PT3.Quiet_Wake_Avg_Firing_Rate=Quiet_Wake_Avg_Firing_Rate;
                        PT3.Quiet_Wake_Bout_Wise_Firing_Rate=Quiet_Wake_Bout_Wise_Firing_Rate;
                        
                        PT3.Microarousal_Avg_Firing_Rate=Microarousal_Avg_Firing_Rate;
                        PT3.Microarousal_Bout_Wise_Firing_Rate=Microarousal_Bout_Wise_Firing_Rate;
                        
                        PT3.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
                        PT3.NREM_Bout_Wise_Firing_Rate=NREM_Bout_Wise_Firing_Rate;
                        
                        PT3.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
                        PT3.Intermediate_Bout_Wise_Firing_Rate=Intermediate_Bout_Wise_Firing_Rate;
                        
                        PT3.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
                        PT3.REM_Bout_Wise_Firing_Rate=REM_Bout_Wise_Firing_Rate;
                        
                    case 8
                        T4.Wake_Avg_Firing_Rate=Wake_Avg_Firing_Rate;
                        
                        
                        
                    case 9
                        
                        PT4.Quiet_Wake_Avg_Firing_Rate=Quiet_Wake_Avg_Firing_Rate;
                        PT4.Quiet_Wake_Bout_Wise_Firing_Rate=Quiet_Wake_Bout_Wise_Firing_Rate;
                        
                        PT4.Microarousal_Avg_Firing_Rate=Microarousal_Avg_Firing_Rate;
                        PT4.Microarousal_Bout_Wise_Firing_Rate=Microarousal_Bout_Wise_Firing_Rate;
                        
                        PT4.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
                        PT4.NREM_Bout_Wise_Firing_Rate=NREM_Bout_Wise_Firing_Rate;
                        
                        PT4.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
                        PT4.Intermediate_Bout_Wise_Firing_Rate=Intermediate_Bout_Wise_Firing_Rate;
                        
                        PT4.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
                        PT4.REM_Bout_Wise_Firing_Rate=REM_Bout_Wise_Firing_Rate;
                        
                    case 10
                        T5.Wake_Avg_Firing_Rate=Wake_Avg_Firing_Rate;
                        
                        
                    case 11
                        
                        PT5_Final.PT5_Part_1=PT5_Part_1;
                        PT5_Final.PT5_Part_2=PT5_Part_2;
                        
                        PT5_Final.PT5_Part_3=PT5_Part_3;
                        PT5_Final.PT5_Part_4=PT5_Part_4;
                        
                        
                end

                
                
            end
            
            Units(rat_data_index).WFM_Title=Current_unitID_Name;
        
            Units(rat_data_index).Presleep=PS;
            
            
            Units(rat_data_index).Trial_1=T1;
            Units(rat_data_index).Post_Trial_1=PT1;
            
            Units(rat_data_index).Trial_2=T2;
            Units(rat_data_index).Post_Trial_2=PT2;
            
            Units(rat_data_index).Trial_3=T3;
            Units(rat_data_index).Post_Trial_3=PT3;
            
            Units(rat_data_index).Trial_4=T4;
            Units(rat_data_index).Post_Trial_4=PT4;
            
            Units(rat_data_index).Trial_5=T5;
            Units(rat_data_index).Post_Trial_5_All=PT5_Final;
            
            
        end
           

        
    end
   
    
end
Final_Rat_Struct=Units;
end




