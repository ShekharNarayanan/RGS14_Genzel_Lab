function Final_Rat_Struct=Firing_Rate_Trials_Hypnogram(Sleep_Scoring_Directory_For_Rat,Spike_Corrected_WFM,window_size,overlap)
% % function Final_Rat_Struct=Firing_Rate_Trials(Sleep_Scoring_Directory_For_Rat,Standard_Rat_Directory,BEST_WFM)
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
fs=30000;
PS=[];T1=[];PT1=[];T2=[];PT2=[];T3=[];PT3=[];T4=[];PT4=[];T5=[];PT5=[];

Units=[]; spikes=[]; Average_Bout_Length=[];
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

for SD_Names=4%:length(study_day_folder_names) %% test for SD1
    for rat_data_index=1%:size(Rat_x_Data,1)
        if contains(Rat_x_Data(rat_data_index).WFM_Titles,Study_Day_Names{SD_Names})
            
            Current_unitID_Name=Rat_x_Data(rat_data_index).WFM_Titles;
            Current_UnitID_spiketimes=Rat_x_Data(rat_data_index).curSpikeTimes;
            units=Current_UnitID_spiketimes;
            
            Sleep_Dir=strcat(A,'/',study_day_folder_names{SD_Names});
            cd(Sleep_Dir)
            %% Entering the main analysis
            states_all=load(strcat('Concatenated_Sleep_Scores','_',study_day_folder_names{SD_Names},'.mat'))..states_corrected_final;
            
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
                        
                        bout_length=(idx2-idx1); %% length in samples
                        

                         
                        n_windows=int8(number_of_windows(bout_length,window_size,overlap)); %% 33 percent overlap
                        
                        
                        idx1_temp=idx1;
                        idx2_temp=idx1+window_size;
                        range=(units(:)> idx1_temp) &   (units(:) < idx2_temp);
                        
                        units_spliced=units(range);
                        spikes=[spikes ; units_spliced];
                        duration_bout(index_inside_sleep_stage)= (idx2_temp-idx1_temp)/30000;
                        
                        Avg_Firing_Rate(index_inside_sleep_stage)= size(units_spliced,1)/duration_bout(index_inside_sleep_stage);
                        
                        Avg_Firing_Rate_Current_Bout=[Avg_Firing_Rate_Current_Bout; Avg_Firing_Rate(index_inside_sleep_stage)];
                        
                        while idx2_temp<=idx2

                            idx1_temp=idx1_temp+(window_size-overlap);
                            idx2_temp=idx1_temp+window_size;
                            
                            disp(idx1_temp)
                            range=(units(:)> idx1_temp) &   (units(:) < idx2_temp);
                            
                            units_spliced=units(range);
                            spikes=[spikes ; units_spliced];
                            duration_bout(index_inside_sleep_stage)= (idx2_temp-idx1_temp)/30000;
                            
                            Avg_Firing_Rate(index_inside_sleep_stage)= size(units_spliced,1)/duration_bout(index_inside_sleep_stage);
                            
                            Avg_Firing_Rate_Current_Bout=[Avg_Firing_Rate_Current_Bout; Avg_Firing_Rate(index_inside_sleep_stage)];
                            
                        end
                        



                            
%                             if idx2_temp>bout_length
%                                 disp('window too big')
%                                 break
%                             else
%                                 disp(strcat('window fits fine','size of bout is:',' ',string(bout_length),' ','size of window is',' ', string(window_size)))
%                             end
                            

                       
                        
%                         for windows=1:n_windows
% %                             idx1_temp=(idx1+(20*fs)*(windows-1))/fs;
% 
% %                             idx1_temp=(idx1+(overlap*(windows-1)));
%                             idx1_temp=idx1+overlap*(n_windows-1);
%                             idx2_temp=(idx1+window_size);
%                             
%                             range=(units(:)> idx1_temp) &   (units(:) < idx2_temp);
%                             
%                             units_spliced=units(range);
%                             spikes=[spikes ; units_spliced];
%                             duration_bout(index_inside_sleep_stage)= (idx2_temp-idx1_temp)/30000;
%                             
%                             Avg_Firing_Rate(index_inside_sleep_stage)= size(units_spliced,1)/duration_bout(index_inside_sleep_stage);
%                             
%                             Avg_Firing_Rate_Current_Bout=[Avg_Firing_Rate_Current_Bout; Avg_Firing_Rate(index_inside_sleep_stage)];
%                             
%                             
%                         end    
%                         L=bout_length;
%                         
%                         %if sleep stage conditon
%                         nbins=30;
%                         for split_bins=1:nbins
%                             if L*split_bins<bout_length
%                                 
%                                 idx1_temp=idx1+(split_bins-1)*bout_length/nbins;
%                                 idx2_temp=idx1_temp+(bout_length/nbins);
%                                 range=(units(:)> idx1_temp) &   (units(:) < idx2_temp);
%                                 
%                             end
%                             
%                         
%                         end
                        
                        

%                         duration_bout(index_inside_sleep_stage)= (idx2-idx1)/30000;
%                         Avg_Firing_Rate(index_inside_sleep_stage)= size(units_spliced,1)/duration_bout(index_inside_sleep_stage);
%                         
%                         Avg_Firing_Rate_Current_Bout=[Avg_Firing_Rate_Current_Bout; Avg_Firing_Rate(index_inside_sleep_stage)];
                        
                    end
                    
                    switch sleep_stages
                        case 1
                            
                            Quiet_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                            Quiet_Wake_Average_Bout_Length=mean(Average_Bout_Length);
                            Quiet_Wake_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                            
                        case 2
                            Microarousal_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                            Microarousal_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                            
                        case 3
                            
                            NREM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                            NREM_Average_Bout_Length=mean(Average_Bout_Length);
                            NREM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                        case 4
                            
                            Intermediate_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                            Intermediate_Average_Bout_Length=mean(Average_Bout_Length);
                            Intermediate_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                        case 5
                            
                            REM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                            REM_Average_Bout_Length=mean(Average_Bout_Length);
                            REM_Bout_Wise_Firing_Rate=Avg_Firing_Rate_Current_Bout;
                            
                        case 6  
                            Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
                            Wake_Average_Bout_Length=mean(Average_Bout_Length);
                            
                    end
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
                        
                        PT5.Quiet_Wake_Avg_Firing_Rate=Quiet_Wake_Avg_Firing_Rate;
                        PT5.Quiet_Wake_Bout_Wise_Firing_Rate=Quiet_Wake_Bout_Wise_Firing_Rate;
                        
                        PT5.Microarousal_Avg_Firing_Rate=Microarousal_Avg_Firing_Rate;
                        PT5.Microarousal_Bout_Wise_Firing_Rate=Microarousal_Bout_Wise_Firing_Rate;
                        
                        PT5.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
                        PT5.NREM_Bout_Wise_Firing_Rate=NREM_Bout_Wise_Firing_Rate;
                        
                        PT5.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
                        PT5.Intermediate_Bout_Wise_Firing_Rate=Intermediate_Bout_Wise_Firing_Rate;
                        
                        PT5.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
                        PT5.REM_Bout_Wise_Firing_Rate=REM_Bout_Wise_Firing_Rate;
                end
                
            end
            
            
            
                   Units(rat_data_index).WFM_Title=Current_unitID_Name;
                   Units.N_Win=n_windows;
                   Units(rat_data_index).spikes_utilized=spikes;
                   
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
                   Units(rat_data_index).Post_Trial_5=PT5;
            
            
            
        end    
    end    
end    


Final_Rat_Struct=Units;

end