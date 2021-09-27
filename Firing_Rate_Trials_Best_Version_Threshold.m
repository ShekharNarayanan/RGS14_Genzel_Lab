function [Final_Rat_Struct]=Firing_Rate_Trials_Best_Version_Threshold(Spike_Corrected_WFM,threshold_vector_for_treatment)


% % Get the concantenated sleep scoring file  for each study day for the rat
% % For a study day, get waveforms of that study day
% % define specific post trial period durations
% % for each post trial duration get ranges
% % get ranges(1,1) and ranges(1,2) as idx1 and idx2 (idx2-idx1)/30000 is the bout duration
% % definining units as spiketimes of that unit, write units_spliced as needed
% % size(units_spliced,1)/bout duration is the firing rate during that bout; average across the number of bouts for that stage in the post trial
% % combine all post trial structs for a unit in one struct; do this for each unit in that study day
% % combine data from all study days to get Final_Rat_Struct
% 


%% Initializing global variables

PS=[];T1=[];PT1=[];T2=[];PT2=[];T3=[];PT3=[];T4=[];PT4=[];T5=[];PT5=[]; PT5_Part_1=[];PT5_Part_2=[];PT5_Part_3=[];PT5_Part_4=[]; PT5_1=[]; PT5_2=[];PT5_3=[];PT5_4=[]; PT5_Final=[];Post_Trial_5=[];
fs=30000;

Units=[];

% Rat_Data=load(BEST_WFM).Stored_WFMs;

%Rat_x_Data=Spike_Times_Correction(Standard_Rat_Directory,BEST_WFM);
Rat_x_Data=Spike_Corrected_WFM;

for rat_data_index=1:size(Rat_x_Data,1)
    WFM_Title=Rat_x_Data(rat_data_index).WFM_Titles;
    WFM_Title=convertStringsToChars(WFM_Title);
    Rat_Number=strfind(WFM_Title,'_Rn');
    
    Rat_Number_Input=strcat('Rat',WFM_Title(Rat_Number+3));
    
    
    
    Find_SD=strfind(WFM_Title,'_SD');
    SD_Number=WFM_Title(Find_SD+3:Find_SD+5);
    SD_Temp=regexp(SD_Number,'_','split');
    SD_Number_Input=strcat('SD',SD_Temp{1});
    
    PT5_1=[]; PT5_2=[];PT5_3=[];PT5_4=[];
    
    Current_unitID_Name=Rat_x_Data(rat_data_index).WFM_Titles;
    
    %             Names=[Names; Current_unitID_Name];
    
    Current_UnitID_spiketimes=Rat_x_Data(rat_data_index).curSpikeTimes;
    units=Current_UnitID_spiketimes;
    
    [Sleep_Dir,SD_Folder_Name]=sleep_dict_rat(Rat_Number_Input,SD_Number_Input);
    cd(Sleep_Dir)
    
    
    %% Entering the main analysis
    states_all=load(strcat('Concatenated_Sleep_Scores','_',SD_Folder_Name,'.mat')).states_corrected_final;
    disp(strcat('states loaded for study day',SD_Number_Input))
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
            
            
            [ranges_quiet_wake,ranges_microarousal,ranges_NREM,ranges_intermediate,ranges_REM,ranges_wake]=bout_ranges_per_trial(Current_Trial,trial_index,threshold_vector_for_treatment);
            
            Current_Trial_Stages=[{ranges_quiet_wake},{ranges_microarousal},{ranges_NREM},{ranges_intermediate},{ranges_REM},{ranges_wake}]; %% Getting ranges for all sleep stages
            
            for sleep_stages=1:length(Current_Trial_Stages)
                Current_Sleep_Stage=Current_Trial_Stages{sleep_stages};
                
                x=floor(threshold_vector_for_treatment(sleep_stages)/2); % x decides how long the starting and ending segments are for a particular bout duration

                bout_duration_sleep_stage_first=[];
                bout_duration_sleep_stage_last=[];
                spikes_in_sleep_stage_first=[];
                spikes_in_sleep_stage_last=[];
                
                for index_inside_sleep_stage=1:size(Current_Sleep_Stage,2)
                    
                    idx1_first=Current_Sleep_Stage(index_inside_sleep_stage).Samples_Start;
                    idx2_first=idx1_first+x*fs;
                    
                    idx1_last=Current_Sleep_Stage(index_inside_sleep_stage).Samples_End-(x*fs);
                    idx2_last=Current_Sleep_Stage(index_inside_sleep_stage).Samples_End;
                    
                    
                    range_first=(units(:)> idx1_first) &   (units(:) < idx2_first);
                    range_last=(units(:)> idx1_last) &   (units(:) < idx2_last);
                    %disp(range)
                    units_spliced_first=units(range_first);
                    units_spliced_last=units(range_last);
                    %disp(strcat('size of spikes',string(size(units_spliced,1))))
                    
                    duration_bout_first(index_inside_sleep_stage)= (idx2_first-idx1_first)/30000;
                    bout_duration_sleep_stage_first=[bout_duration_sleep_stage_first; duration_bout_first(index_inside_sleep_stage)];
                    
                    duration_bout_last(index_inside_sleep_stage)= (idx2_last-idx1_last)/30000;
                    bout_duration_sleep_stage_last=[bout_duration_sleep_stage_last; duration_bout_last(index_inside_sleep_stage)];

                    
                    spikes_in_sleep_stage_first=[spikes_in_sleep_stage_first; size(units_spliced_first,1)];
                    spikes_in_sleep_stage_last=[spikes_in_sleep_stage_last; size(units_spliced_last,1)];
                    
                end
                
                
                switch sleep_stages
                    case 1
                        
                        Quiet_Wake_Spikes_First=spikes_in_sleep_stage_first;
                        Quiet_Wake_Duration_First=bout_duration_sleep_stage_first;
                        
                        Quiet_Wake_Spikes_Last=spikes_in_sleep_stage_last;
                        Quiet_Wake_Duration_Last=bout_duration_sleep_stage_last;
                        
                        
                        
                    case 2
                        
                        
                        Microarousal_Spikes_First=spikes_in_sleep_stage_first;
                        Microarousal_Duration_First=bout_duration_sleep_stage_first;
                        
                        Microarousal_Spikes_Last=spikes_in_sleep_stage_last;
                        Microarousal_Duration_Last=bout_duration_sleep_stage_last;
                        
                        
                        
                    case 3
                        
                        NREM_Spikes_First=spikes_in_sleep_stage_first;
                        NREM_Duration_First=bout_duration_sleep_stage_first;
                        
                        NREM_Spikes_Last=spikes_in_sleep_stage_last;
                        NREM_Duration_Last=bout_duration_sleep_stage_last;
                        
                       
                    case 4
                        
                        Intermediate_Spikes_First=spikes_in_sleep_stage_first;
                        Intermediate_Duration_First=bout_duration_sleep_stage_first;
                        
                        Intermediate_Spikes_Last=spikes_in_sleep_stage_last;
                        Intermediate_Duration_Last=bout_duration_sleep_stage_last;
                        
                    case 5
                        
                        REM_Spikes_First=spikes_in_sleep_stage_first;
                        REM_Duration_First=bout_duration_sleep_stage_first;
                        
                        REM_Spikes_Last=spikes_in_sleep_stage_last;
                        REM_Duration_Last=bout_duration_sleep_stage_last;
                          
                    case 6
                        Wake_Spikes=spikes_in_sleep_stage_first;
                        Wake_Duration=bout_duration_sleep_stage_first;
                       
                        
                        
                end
                
                
                
            end
            
            
        else
            
            Current_Trial=All_Trials{trial_index}; %% Selecting a post trial
            
            
            [ranges_quiet_wake,ranges_microarousal,ranges_NREM,ranges_intermediate,ranges_REM,ranges_wake]=bout_ranges_per_trial(Current_Trial,trial_index,threshold_vector_for_treatment);
            
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
                    %                 duration_bout_first=[]; %% These three vars need to be empty before we start calculating them
                    %                 duration_bout_last=[];
                    
                    
                    bout_duration_sleep_stage_first=[];
                    bout_duration_sleep_stage_last=[];
                    spikes_in_sleep_stage_first=[];
                    spikes_in_sleep_stage_last=[];
                    
                    for index_inside_sleep_stage=1:size(Current_Sleep_Stage_PT5,2) %%% finding firing rate for a sleep stage
                        
                        idx1_first=Current_Sleep_Stage_PT5(index_inside_sleep_stage).Samples_Start;
                        idx2_first=idx1_first+10*fs;
                        
                        idx1_last=Current_Sleep_Stage_PT5(index_inside_sleep_stage).Samples_End-(10*fs);
                        idx2_last=Current_Sleep_Stage_PT5(index_inside_sleep_stage).Samples_End;
                        
                        
                        range_first=(units(:)> idx1_first) &   (units(:) < idx2_first);
                        range_last=(units(:)> idx1_last) &   (units(:) < idx2_last);
                        
                        units_spliced_first=units(range_first);
                        units_spliced_last=units(range_last);
                        
                        
                        duration_bout_first(index_inside_sleep_stage)= (idx2_first-idx1_first)/30000;
                        bout_duration_sleep_stage_first=[bout_duration_sleep_stage_first; duration_bout_first(index_inside_sleep_stage)];
                        
                        duration_bout_last(index_inside_sleep_stage)= (idx2_last-idx1_last)/30000;
                        bout_duration_sleep_stage_last=[bout_duration_sleep_stage_last; duration_bout_last(index_inside_sleep_stage)];
                        
                        
                        spikes_in_sleep_stage_first=[spikes_in_sleep_stage_first; size(units_spliced_first,1)];
                        spikes_in_sleep_stage_last=[spikes_in_sleep_stage_last; size(units_spliced_last,1)];
                        
                    end
           
                    
                    switch PT5_index
                        case 1
                            
                            switch sleep_stages
                                case 1
  
                                    Quiet_Wake_Spikes_First=spikes_in_sleep_stage_first;
                                    Quiet_Wake_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Quiet_Wake_Spikes_Last=spikes_in_sleep_stage_last;
                                    Quiet_Wake_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_1.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                                    PT5_Part_1.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                                    
                                    PT5_Part_1.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                                    PT5_Part_1.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                                    
                                    
                                    
                                    
                                    
                                    
                                case 2
                                    
                                    Microarousal_Spikes_First=spikes_in_sleep_stage_first;
                                    Microarousal_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Microarousal_Spikes_Last=spikes_in_sleep_stage_last;
                                    Microarousal_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_1.Microarousal_Spikes_First=Microarousal_Spikes_First;
                                    PT5_Part_1.Microarousal_Duration_First=Microarousal_Duration_First;
                                    
                                    PT5_Part_1.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                                    PT5_Part_1.Microarousal_Duration_Last=Microarousal_Duration_Last;
                                    
                                   
                                    
                                    
                                case 3
                                    
                                    NREM_Spikes_First=spikes_in_sleep_stage_first;
                                    NREM_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    NREM_Spikes_Last=spikes_in_sleep_stage_last;
                                    NREM_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_1.NREM_Spikes_First=NREM_Spikes_First;
                                    PT5_Part_1.NREM_Duration_First=NREM_Duration_First;
                                    
                                    PT5_Part_1.NREM_Spikes_Last=NREM_Spikes_Last;
                                    PT5_Part_1.NREM_Duration_Last=NREM_Duration_Last;
                                    
                                  
                                    
                                    
                                case 4
                                    
                                    Intermediate_Spikes_First=spikes_in_sleep_stage_first;
                                    Intermediate_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Intermediate_Spikes_Last=spikes_in_sleep_stage_last;
                                    Intermediate_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_1.Intermediate_Spikes_First=Intermediate_Spikes_First;
                                    PT5_Part_1.Intermediate_Duration_First=Intermediate_Duration_First;
                                    
                                    PT5_Part_1.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                                    PT5_Part_1.Intermediate_Duration_Last=Intermediate_Duration_Last;
                                    
                                    
                                    
                                    
                                case 5
                                    
                                    REM_Spikes_First=spikes_in_sleep_stage_first;
                                    REM_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    REM_Spikes_Last=spikes_in_sleep_stage_last;
                                    REM_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_1.REM_Spikes_First=REM_Spikes_First;
                                    PT5_Part_1.REM_Duration_First=REM_Duration_First;
                                    
                                    PT5_Part_1.REM_Spikes_Last=REM_Spikes_Last;
                                    PT5_Part_1.REM_Duration_Last=REM_Duration_Last;
                                    
                               
                                    
                                    
                            end
                            
                        case 2
                            
                            switch sleep_stages
                                case 1
  
                                    Quiet_Wake_Spikes_First=spikes_in_sleep_stage_first;
                                    Quiet_Wake_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Quiet_Wake_Spikes_Last=spikes_in_sleep_stage_last;
                                    Quiet_Wake_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_2.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                                    PT5_Part_2.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                                    
                                    PT5_Part_2.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                                    PT5_Part_2.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                                    
                                    
                                    
                                    
                                    
                                    
                                case 2
                                    
                                    Microarousal_Spikes_First=spikes_in_sleep_stage_first;
                                    Microarousal_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Microarousal_Spikes_Last=spikes_in_sleep_stage_last;
                                    Microarousal_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_2.Microarousal_Spikes_First=Microarousal_Spikes_First;
                                    PT5_Part_2.Microarousal_Duration_First=Microarousal_Duration_First;
                                    
                                    PT5_Part_2.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                                    PT5_Part_2.Microarousal_Duration_Last=Microarousal_Duration_Last;
                                    
                                   
                                    
                                    
                                case 3
                                    
                                    NREM_Spikes_First=spikes_in_sleep_stage_first;
                                    NREM_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    NREM_Spikes_Last=spikes_in_sleep_stage_last;
                                    NREM_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_2.NREM_Spikes_First=NREM_Spikes_First;
                                    PT5_Part_2.NREM_Duration_First=NREM_Duration_First;
                                    
                                    PT5_Part_2.NREM_Spikes_Last=NREM_Spikes_Last;
                                    PT5_Part_2.NREM_Duration_Last=NREM_Duration_Last;
                                    
                                  
                                    
                                    
                                case 4
                                    
                                    Intermediate_Spikes_First=spikes_in_sleep_stage_first;
                                    Intermediate_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Intermediate_Spikes_Last=spikes_in_sleep_stage_last;
                                    Intermediate_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_2.Intermediate_Spikes_First=Intermediate_Spikes_First;
                                    PT5_Part_2.Intermediate_Duration_First=Intermediate_Duration_First;
                                    
                                    PT5_Part_2.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                                    PT5_Part_2.Intermediate_Duration_Last=Intermediate_Duration_Last;
                                    
                                    
                                    
                                    
                                case 5
                                    
                                    REM_Spikes_First=spikes_in_sleep_stage_first;
                                    REM_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    REM_Spikes_Last=spikes_in_sleep_stage_last;
                                    REM_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_2.REM_Spikes_First=REM_Spikes_First;
                                    PT5_Part_2.REM_Duration_First=REM_Duration_First;
                                    
                                    PT5_Part_2.REM_Spikes_Last=REM_Spikes_Last;
                                    PT5_Part_2.REM_Duration_Last=REM_Duration_Last;
                                    
                                
                                    
                                    
                            end
                            
                        case 3
                            
                            
                            switch sleep_stages
                                case 1
  
                                    Quiet_Wake_Spikes_First=spikes_in_sleep_stage_first;
                                    Quiet_Wake_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Quiet_Wake_Spikes_Last=spikes_in_sleep_stage_last;
                                    Quiet_Wake_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_3.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                                    PT5_Part_3.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                                    
                                    PT5_Part_3.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                                    PT5_Part_3.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                                    
                                    
                                    
                                    
                                    
                                    
                                case 2
                                    
                                    Microarousal_Spikes_First=spikes_in_sleep_stage_first;
                                    Microarousal_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Microarousal_Spikes_Last=spikes_in_sleep_stage_last;
                                    Microarousal_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_3.Microarousal_Spikes_First=Microarousal_Spikes_First;
                                    PT5_Part_3.Microarousal_Duration_First=Microarousal_Duration_First;
                                    
                                    PT5_Part_3.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                                    PT5_Part_3.Microarousal_Duration_Last=Microarousal_Duration_Last;
                                    
                                   
                                    
                                    
                                case 3
                                    
                                    NREM_Spikes_First=spikes_in_sleep_stage_first;
                                    NREM_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    NREM_Spikes_Last=spikes_in_sleep_stage_last;
                                    NREM_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_3.NREM_Spikes_First=NREM_Spikes_First;
                                    PT5_Part_3.NREM_Duration_First=NREM_Duration_First;
                                    
                                    PT5_Part_3.NREM_Spikes_Last=NREM_Spikes_Last;
                                    PT5_Part_3.NREM_Duration_Last=NREM_Duration_Last;
                                    
                                  
                                    
                                    
                                case 4
                                    
                                    Intermediate_Spikes_First=spikes_in_sleep_stage_first;
                                    Intermediate_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Intermediate_Spikes_Last=spikes_in_sleep_stage_last;
                                    Intermediate_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_3.Intermediate_Spikes_First=Intermediate_Spikes_First;
                                    PT5_Part_3.Intermediate_Duration_First=Intermediate_Duration_First;
                                    
                                    PT5_Part_3.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                                    PT5_Part_3.Intermediate_Duration_Last=Intermediate_Duration_Last;
                                    
                                    
                                    
                                    
                                case 5
                                    
                                    REM_Spikes_First=spikes_in_sleep_stage_first;
                                    REM_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    REM_Spikes_Last=spikes_in_sleep_stage_last;
                                    REM_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_3.REM_Spikes_First=REM_Spikes_First;
                                    PT5_Part_3.REM_Duration_First=REM_Duration_First;
                                    
                                    PT5_Part_3.REM_Spikes_Last=REM_Spikes_Last;
                                    PT5_Part_3.REM_Duration_Last=REM_Duration_Last;
                                    
                                
                                    
                                    
                            end
                            
                        case 4
                            
                            
                            
                            switch sleep_stages
                                case 1
  
                                    Quiet_Wake_Spikes_First=spikes_in_sleep_stage_first;
                                    Quiet_Wake_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Quiet_Wake_Spikes_Last=spikes_in_sleep_stage_last;
                                    Quiet_Wake_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_4.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                                    PT5_Part_4.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                                    
                                    PT5_Part_4.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                                    PT5_Part_4.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                                    
                                    
                                    
                                    
                                    
                                    
                                case 2
                                    
                                    Microarousal_Spikes_First=spikes_in_sleep_stage_first;
                                    Microarousal_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Microarousal_Spikes_Last=spikes_in_sleep_stage_last;
                                    Microarousal_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_4.Microarousal_Spikes_First=Microarousal_Spikes_First;
                                    PT5_Part_4.Microarousal_Duration_First=Microarousal_Duration_First;
                                    
                                    PT5_Part_4.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                                    PT5_Part_4.Microarousal_Duration_Last=Microarousal_Duration_Last;
                                    
                                   
                                    
                                    
                                case 3
                                    
                                    NREM_Spikes_First=spikes_in_sleep_stage_first;
                                    NREM_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    NREM_Spikes_Last=spikes_in_sleep_stage_last;
                                    NREM_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_4.NREM_Spikes_First=NREM_Spikes_First;
                                    PT5_Part_4.NREM_Duration_First=NREM_Duration_First;
                                    
                                    PT5_Part_4.NREM_Spikes_Last=NREM_Spikes_Last;
                                    PT5_Part_4.NREM_Duration_Last=NREM_Duration_Last;
                                    
                                  
                                    
                                    
                                case 4
                                    
                                    Intermediate_Spikes_First=spikes_in_sleep_stage_first;
                                    Intermediate_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    Intermediate_Spikes_Last=spikes_in_sleep_stage_last;
                                    Intermediate_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_4.Intermediate_Spikes_First=Intermediate_Spikes_First;
                                    PT5_Part_4.Intermediate_Duration_First=Intermediate_Duration_First;
                                    
                                    PT5_Part_4.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                                    PT5_Part_4.Intermediate_Duration_Last=Intermediate_Duration_Last;
                                    
                                    
                                    
                                    
                                case 5
                                    
                                    REM_Spikes_First=spikes_in_sleep_stage_first;
                                    REM_Duration_First=bout_duration_sleep_stage_first;
                                    
                                    REM_Spikes_Last=spikes_in_sleep_stage_last;
                                    REM_Duration_Last=bout_duration_sleep_stage_last;
                                    
                                    PT5_Part_4.REM_Spikes_First=REM_Spikes_First;
                                    PT5_Part_4.REM_Duration_First=REM_Duration_First;
                                    
                                    PT5_Part_4.REM_Spikes_Last=REM_Spikes_Last;
                                    PT5_Part_4.REM_Duration_Last=REM_Duration_Last;
                                    
                                
                                    
                                    
                            end
                            
                    end
                    
                end
            end
            
            
            %end
            
            
        end
        
        switch trial_index
            
            case 1
                
                PS.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                PS.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                PS.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                PS.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                
                PS.Microarousal_Spikes_First=Microarousal_Spikes_First;
                PS.Microarousal_Duration_First=Microarousal_Duration_First;
                PS.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                PS.Microarousal_Duration_Last=Microarousal_Duration_Last;
                
                PS.NREM_Spikes_First=NREM_Spikes_First;
                PS.NREM_Duration_First=NREM_Duration_First;
                PS.NREM_Spikes_Last=NREM_Spikes_Last;
                PS.NREM_Duration_Last=NREM_Duration_Last;
                
                PS.Intermediate_Spikes_First=Intermediate_Spikes_First;
                PS.Intermediate_Duration_First=Intermediate_Duration_First;
                PS.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                PS.Intermediate_Duration_Last=Intermediate_Duration_Last;
                
                PS.REM_Spikes_First=REM_Spikes_First;
                PS.REM_Duration_First=REM_Duration_First;
                PS.REM_Spikes_Last=REM_Spikes_Last;
                PS.REM_Duration_Last=REM_Duration_Last;
                
                
                
            case 2
                
                T1.Wake_Spikes=Wake_Spikes;
                T1.Wake_Duration=Wake_Duration;
                
                
            case 3
                PT1.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                PT1.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                PT1.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                PT1.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                
                PT1.Microarousal_Spikes_First=Microarousal_Spikes_First;
                PT1.Microarousal_Duration_First=Microarousal_Duration_First;
                PT1.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                PT1.Microarousal_Duration_Last=Microarousal_Duration_Last;
                
                PT1.NREM_Spikes_First=NREM_Spikes_First;
                PT1.NREM_Duration_First=NREM_Duration_First;
                PT1.NREM_Spikes_Last=NREM_Spikes_Last;
                PT1.NREM_Duration_Last=NREM_Duration_Last;
                
                PT1.Intermediate_Spikes_First=Intermediate_Spikes_First;
                PT1.Intermediate_Duration_First=Intermediate_Duration_First;
                PT1.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                PT1.Intermediate_Duration_Last=Intermediate_Duration_Last;
                
                PT1.REM_Spikes_First=REM_Spikes_First;
                PT1.REM_Duration_First=REM_Duration_First;
                PT1.REM_Spikes_Last=REM_Spikes_Last;
                PT1.REM_Duration_Last=REM_Duration_Last;
                
            case 4
                
                T2.Wake_Spikes=Wake_Spikes;
                T2.Wake_Duration=Wake_Duration;
                
                
            case 5
                PT2.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                PT2.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                PT2.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                PT2.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                
                PT2.Microarousal_Spikes_First=Microarousal_Spikes_First;
                PT2.Microarousal_Duration_First=Microarousal_Duration_First;
                PT2.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                PT2.Microarousal_Duration_Last=Microarousal_Duration_Last;
                
                PT2.NREM_Spikes_First=NREM_Spikes_First;
                PT2.NREM_Duration_First=NREM_Duration_First;
                PT2.NREM_Spikes_Last=NREM_Spikes_Last;
                PT2.NREM_Duration_Last=NREM_Duration_Last;
                
                PT2.Intermediate_Spikes_First=Intermediate_Spikes_First;
                PT2.Intermediate_Duration_First=Intermediate_Duration_First;
                PT2.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                PT2.Intermediate_Duration_Last=Intermediate_Duration_Last;
                
                PT2.REM_Spikes_First=REM_Spikes_First;
                PT2.REM_Duration_First=REM_Duration_First;
                PT2.REM_Spikes_Last=REM_Spikes_Last;
                PT2.REM_Duration_Last=REM_Duration_Last;
                
            case 6
               
                T3.Wake_Spikes=Wake_Spikes;
                T3.Wake_Duration=Wake_Duration;
                
                
            case 7
                
                PT3.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                PT3.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                PT3.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                PT3.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                
                PT3.Microarousal_Spikes_First=Microarousal_Spikes_First;
                PT3.Microarousal_Duration_First=Microarousal_Duration_First;
                PT3.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                PT3.Microarousal_Duration_Last=Microarousal_Duration_Last;
                
                PT3.NREM_Spikes_First=NREM_Spikes_First;
                PT3.NREM_Duration_First=NREM_Duration_First;
                PT3.NREM_Spikes_Last=NREM_Spikes_Last;
                PT3.NREM_Duration_Last=NREM_Duration_Last;
                
                PT3.Intermediate_Spikes_First=Intermediate_Spikes_First;
                PT3.Intermediate_Duration_First=Intermediate_Duration_First;
                PT3.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                PT3.Intermediate_Duration_Last=Intermediate_Duration_Last;
                
                PT3.REM_Spikes_First=REM_Spikes_First;
                PT3.REM_Duration_First=REM_Duration_First;
                PT3.REM_Spikes_Last=REM_Spikes_Last;
                PT3.REM_Duration_Last=REM_Duration_Last;
                
            case 8
               
                T4.Wake_Spikes=Wake_Spikes;
                T4.Wake_Duration=Wake_Duration;
                
                
                
            case 9
                
                PT4.Quiet_Wake_Spikes_First=Quiet_Wake_Spikes_First;
                PT4.Quiet_Wake_Duration_First=Quiet_Wake_Duration_First;
                PT4.Quiet_Wake_Spikes_Last=Quiet_Wake_Spikes_Last;
                PT4.Quiet_Wake_Duration_Last=Quiet_Wake_Duration_Last;
                
                PT4.Microarousal_Spikes_First=Microarousal_Spikes_First;
                PT4.Microarousal_Duration_First=Microarousal_Duration_First;
                PT4.Microarousal_Spikes_Last=Microarousal_Spikes_Last;
                PT4.Microarousal_Duration_Last=Microarousal_Duration_Last;
                
                PT4.NREM_Spikes_First=NREM_Spikes_First;
                PT4.NREM_Duration_First=NREM_Duration_First;
                PT4.NREM_Spikes_Last=NREM_Spikes_Last;
                PT4.NREM_Duration_Last=NREM_Duration_Last;
                
                PT4.Intermediate_Spikes_First=Intermediate_Spikes_First;
                PT4.Intermediate_Duration_First=Intermediate_Duration_First;
                PT4.Intermediate_Spikes_Last=Intermediate_Spikes_Last;
                PT4.Intermediate_Duration_Last=Intermediate_Duration_Last;
                
                PT4.REM_Spikes_First=REM_Spikes_First;
                PT4.REM_Duration_First=REM_Duration_First;
                PT4.REM_Spikes_Last=REM_Spikes_Last;
                PT4.REM_Duration_Last=REM_Duration_Last;
                
            case 10
                
                T5.Wake_Spikes=Wake_Spikes;
                T5.Wake_Duration=Wake_Duration;
                
                
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
    
    
    %         end
    
    
    
end
   

Final_Rat_Struct=Units;
end




