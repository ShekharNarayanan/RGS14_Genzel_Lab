function [Final_Rat_Struct]=Firing_Rate_Trials_SW(Spike_Corrected_WFM,threshold_vector_for_treatment)


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
idx1_all=[];idx2_all=[];
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
    
    [Sleep_Dir,SD_Folder_Name]=find_dict_rat(Rat_Number_Input,SD_Number_Input,'sleep_scoring');
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
                
                duration_bout=[]; %% These three vars need to be empty before we start calculating them
                Avg_Firing_Rate=[];
                Avg_Firing_Rate_Current_Bout=[];
                bout_duration_sleep_stage=[];
                spikes_in_sleep_stage=[];
                
                for index_inside_sleep_stage=1:size(Current_Sleep_Stage,2)
                    
                    idx1=Current_Sleep_Stage(index_inside_sleep_stage).Samples_Start;
                    idx2=Current_Sleep_Stage(index_inside_sleep_stage).Samples_End;
                    
                    
                    
                    
                    range=(units(:)> idx1) &   (units(:) < idx2);
                    %disp(range)
                    units_spliced=units(range);
                    %disp(strcat('size of spikes',string(size(units_spliced,1))))
                    
                    
                    spikes_in_sleep_stage=[spikes_in_sleep_stage; units_spliced];
                    
                end
                
               
                
                switch sleep_stages
                    case 1               
                        
                        Quiet_Wake_Spikes=spikes_in_sleep_stage;
   
                        Quiet_Wake_Spike_Times=Quiet_Wake_Spikes;
                        
                    case 2
                       
                        Microarousal_Spikes=spikes_in_sleep_stage;
                       
                        Microarousal_Spike_Times=Microarousal_Spikes;
                        
                    case 3
                        
              
                        NREM_Spikes=spikes_in_sleep_stage;
                    
                        NREM_Spike_Times=NREM_Spikes;
                    case 4
                        
                        
                        Intermediate_Spikes=spikes_in_sleep_stage;
                        
                        Intermediate_Spike_Times=Intermediate_Spikes;
                        
                    case 5
    
                        REM_Spikes=spikes_in_sleep_stage;
                      
                        REM_Spike_Times=REM_Spikes;
                        
                    case 6
                        Wake_Spikes=spikes_in_sleep_stage;
                        Wake_Duration=bout_duration_sleep_stage;
                        Wake_Spike_Times=Wake_Spikes;
                        
                        
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
                    duration_bout=[]; %% These three vars need to be empty before we start calculating them
                    Avg_Firing_Rate=[];
                    Avg_Firing_Rate_Current_Bout=[];
                    bout_duration_sleep_stage=[];
                    spikes_in_sleep_stage=[];
                    
                    for index_inside_sleep_stage=1:size(Current_Sleep_Stage_PT5,2) %%% finding firing rate for a sleep stage
                        
                        idx1=Current_Sleep_Stage_PT5(index_inside_sleep_stage).Samples_Start;
                        idx2=Current_Sleep_Stage_PT5(index_inside_sleep_stage).Samples_End;
                        
                        idx1_all=[idx1_all; idx1];
                        idx2_all=[idx2_all; idx2];
                        
                        range=(units(:)> idx1) &   (units(:) < idx2);
                        
                        
                        %                                 disp(range)
                        units_spliced=units(range);
                        
                        %                                 disp(strcat('size of spikes',string(size(units_spliced,1))))
                        
                      
                        
                        spikes_in_sleep_stage=[spikes_in_sleep_stage; units_spliced];
                        
                    end
                    
                    
                    
                    switch PT5_index
                        case 1
                            
                            switch sleep_stages
                                case 1
                                    
                                    Quiet_Wake_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_1.Quiet_Wake_Spike_Times=Quiet_Wake_Spikes;

                                    
                                case 2
                                    
                                    Microarousal_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_1.Microarousal_Spike_Times=Microarousal_Spikes;
 
                                    
                                case 3
                                    
                                    NREM_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_1.NREM_Spike_Times=NREM_Spikes;
                                    
                                  
                                    
                                    
                                case 4
                                    
                                    Intermediate_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_1.Intermediate_Spike_Times=Intermediate_Spikes;
                                    
                                    
                                    
                                    
                                case 5
                                    
                                    REM_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_1.REM_Spike_Times=REM_Spikes;
            
                                    
                                    
                            end
                            
                        case 2
                            
                            switch sleep_stages
                                
                                case 1
                                    
                                    Quiet_Wake_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_2.Quiet_Wake_Spike_Times=Quiet_Wake_Spikes;

                                    
                                case 2
                                    
                                    Microarousal_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_2.Microarousal_Spike_Times=Microarousal_Spikes;

                                    
                                   
                                    
                                    
                                case 3
                                    
                                    NREM_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_2.NREM_Spike_Times=NREM_Spikes;
                                    
                                  
                                    
                                    
                                case 4
                                    
                                    Intermediate_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_2.Intermediate_Spike_Times=Intermediate_Spikes;
                                    
                                    
                                    
                                    
                                case 5
                                    
                                    REM_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_2.REM_Spike_Times=REM_Spikes;
                                    
                                    
                            end
                            
                        case 3
                            
                            switch sleep_stages
                                
                                case 1
                                    
                                    Quiet_Wake_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_3.Quiet_Wake_Spike_Times=Quiet_Wake_Spikes;

                                    
                                case 2
                                    
                                    Microarousal_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_3.Microarousal_Spike_Times=Microarousal_Spikes;

                                    
                                   
                                    
                                    
                                case 3
                                    
                                    NREM_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_3.NREM_Spike_Times=NREM_Spikes;
                                    
                                  
                                    
                                    
                                case 4
                                    
                                    Intermediate_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_3.Intermediate_Spike_Times=Intermediate_Spikes;
                                    
                                    
                                    
                                    
                                case 5
                                    
                                    REM_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_3.REM_Spike_Times=REM_Spikes;
                                    
                                    
                            end
                            
                        case 4
                            
                            switch sleep_stages
                                
                                case 1
                                    
                                    Quiet_Wake_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_4.Quiet_Wake_Spike_Times=Quiet_Wake_Spikes;

                                    
                                case 2
                                    
                                    Microarousal_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_4.Microarousal_Spike_Times=Microarousal_Spikes;

                                    
                                   
                                    
                                    
                                case 3
                                    
                                    NREM_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_4.NREM_Spike_Times=NREM_Spikes;
                                    
                                  
                                    
                                    
                                case 4
                                    
                                    Intermediate_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_4.Intermediate_Spike_Times=Intermediate_Spikes;
                                    
                                    
                                    
                                    
                                case 5
                                    
                                    REM_Spikes=spikes_in_sleep_stage;                                 
                                    PT5_Part_4.REM_Spike_Times=REM_Spikes;
                                    
                                    
                            end
                            
                    end
                    
                end
            end
            
            
            %end
            
            
        end
        
        switch trial_index
            
            case 1
               
                PS.Quiet_Wake_Spikes=Quiet_Wake_Spike_Times;
                PS.Microarousal_Spikes=Microarousal_Spike_Times;
                PS.NREM_Spikes=NREM_Spike_Times;
                PS.Intermediate_Spikes=Intermediate_Spike_Times;
                PS.REM_Spikes=REM_Spike_Times;
               
                
                
                
            case 2
                
                T1.Wake_Spikes=Wake_Spike_Times;
                
                
                
            case 3
                PT1.Quiet_Wake_Spikes=Quiet_Wake_Spike_Times;
                PT1.Microarousal_Spikes=Microarousal_Spike_Times;
                PT1.NREM_Spikes=NREM_Spike_Times;
                PT1.Intermediate_Spikes=Intermediate_Spike_Times;
                PT1.REM_Spikes=REM_Spike_Times;
                
            case 4
                T2.Wake_Spikes=Wake_Spike_Times;
                
                
            case 5
                PT2.Quiet_Wake_Spikes=Quiet_Wake_Spike_Times;
                PT2.Microarousal_Spikes=Microarousal_Spike_Times;
                PT2.NREM_Spikes=NREM_Spike_Times;
                PT2.Intermediate_Spikes=Intermediate_Spike_Times;
                PT2.REM_Spikes=REM_Spike_Times;
                
            case 6
                 T3.Wake_Spikes=Wake_Spike_Times;
                
                
            case 7
                
                PT3.Quiet_Wake_Spikes=Quiet_Wake_Spike_Times;
                PT3.Microarousal_Spikes=Microarousal_Spike_Times;
                PT3.NREM_Spikes=NREM_Spike_Times;
                PT3.Intermediate_Spikes=Intermediate_Spike_Times;
                PT3.REM_Spikes=REM_Spike_Times;
                
            case 8
                 T4.Wake_Spikes=Wake_Spike_Times;
                
                
                
            case 9
                
                PT4.Quiet_Wake_Spikes=Quiet_Wake_Spike_Times;
                PT4.Microarousal_Spikes=Microarousal_Spike_Times;
                PT4.NREM_Spikes=NREM_Spike_Times;
                PT4.Intermediate_Spikes=Intermediate_Spike_Times;
                PT4.REM_Spikes=REM_Spike_Times;
                
            case 10
                 T5.Wake_Spikes=Wake_Spike_Times;
                
                
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
   
idx_all=[idx1_all,idx2_all];
Final_Rat_Struct=Units;
end




