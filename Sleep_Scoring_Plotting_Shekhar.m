% Load corrected waveform for spiketimes
% load sleep boouts function
% find ranges for each state (1 3 5 7)
% plot

Rat_3_WFM=Spike_Times_Correction('/media/irene/MD04_RAT_SPIKE/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152','RAT_3_TEMP_SD_BEST_WFM.mat');

% get all study days
A='/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring/Rat3_357152';
study_day_dir= dir(A);
study_day_dir= study_day_dir([study_day_dir(:).isdir]);
study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));
study_day_folder_names=natsort(extractfield(study_day_folders,'name'));

% CHoose Study Day
disp(study_day_folder_names)
SD_INDEX= input('enter study day number index ');

cd (strcat(A,'/',study_day_folder_names{SD_INDEX}))

% Preprocessed sleep states for the study day, removes all zeros, all sizes are 2700 and are appended with 300 7s after each postrial period except posttrial 5
states_concatenated=load(strcat('Concatenated_Sleep_Scores','_',study_day_folder_names{SD_INDEX},'.mat'));

states=states_concatenated.concat_sleep_scoring_final; %file used for the bout_ranges function

% Presleep
states_presleep=states(1:2700);
% Post trial 1
states_PT1=states(3001:5700);
% Post trial2 
states_PT2=states(6001:8700);
% Post trial 3
states_PT3=states(9001:11700);
% Post trial 4
states_PT4=states(12001:14700);
% Post trial 5
states_PT5=states(15001:end);
%% Neuron
units=Rat_3_WFM(54).curSpikeTimes;

%% presleep_analysis
%[ranges_sleep_wake,ranges_NREM,ranges_intermediate,ranges_REM,ranges_trial_wake_final]=bout_ranges(states_presleep);


 
% %% All states testing
% All_Trials=[{states_presleep},{states_PT1},{states_PT2},{states_PT3},{states_PT4},{states_PT5}];
% % Avg_Firing_Rate_Current_Stage=[];
% PS=[];PT1=[];PT2=[];PT3=[];PT4=[];PT5=[];
% 
% for trial_index=1:length(All_Trials)
%     Current_Trial=All_Trials{trial_index}; %% Selecting a post trial
%     
%     [ranges_sleep_wake,ranges_NREM,ranges_intermediate,ranges_REM]=bout_ranges(Current_Trial);
%     
%     Current_Trial_Stages=[{ranges_sleep_wake},{ranges_NREM},{ranges_intermediate},{ranges_REM}]; %% Getting ranges for all sleep stages
%     
%     for sleep_stages=1:length(Current_Trial_Stages)
%         Current_Sleep_Stage=Current_Trial_Stages{sleep_stages};
%         
%         duration_bout=[]; %% These three vars need to be empty before we start calculating them
%         Avg_Firing_Rate=[];
%         Avg_Firing_Rate_Current_Bout=[];
%         
%         for index_inside_sleep_stage=1:size(Current_Sleep_Stage,2)
%             
%             idx1=Current_Sleep_Stage(index_inside_sleep_stage).Samples_Start;
%             idx2=Current_Sleep_Stage(index_inside_sleep_stage).Samples_End;
%             range=(units(:)> idx1) &   (units(:) < idx2);
%             units_spliced=units(range);
%             
%             duration_bout(index_inside_sleep_stage)= (idx2-idx1)/30000;
%             Avg_Firing_Rate(index_inside_sleep_stage)= size(units_spliced,1)/duration_bout(index_inside_sleep_stage);
%             
%             Avg_Firing_Rate_Current_Bout=[Avg_Firing_Rate_Current_Bout; Avg_Firing_Rate(index_inside_sleep_stage)];
%             
%         end   
%         switch sleep_stages
%             case 1
%                 Sleep_Wake_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
%             case 2
%                 NREM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
%             case 3
%                 Intermediate_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
%             case 4
%                 REM_Avg_Firing_Rate=mean([Avg_Firing_Rate_Current_Bout]);
%         end    
%     end
%     
%     switch trial_index
%         
%         case 1
%             PS.Sleep_Wake_Avg_Firing_Rate=Sleep_Wake_Avg_Firing_Rate;
%             PS.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
%             PS.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
%             PS.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
%             
%         case 2    
%             PT1.Sleep_Wake_Avg_Firing_Rate=Sleep_Wake_Avg_Firing_Rate;
%             PT1.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
%             PT1.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
%             PT1.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
%             
%         case 3
%             PT2.Sleep_Wake_Avg_Firing_Rate=Sleep_Wake_Avg_Firing_Rate;
%             PT2.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
%             PT2.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
%             PT2.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
%             
%         case 4
%             PT3.Sleep_Wake_Avg_Firing_Rate=Sleep_Wake_Avg_Firing_Rate;
%             PT3.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
%             PT3.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
%             PT3.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
%             
%         case 5
%             PT4.Sleep_Wake_Avg_Firing_Rate=Sleep_Wake_Avg_Firing_Rate;
%             PT4.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
%             PT4.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
%             PT4.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
%             
%         case 6
%             PT5.Sleep_Wake_Avg_Firing_Rate=Sleep_Wake_Avg_Firing_Rate;
%             PT5.NREM_Avg_Firing_Rate=NREM_Avg_Firing_Rate;
%             PT5.Intermediate_Avg_Firing_Rate=Intermediate_Avg_Firing_Rate;
%             PT5.REM_Avg_Firing_Rate=REM_Avg_Firing_Rate;
%     end    
%     
% end 

%% PT1 analysis
[ranges_sleep_wake,ranges_NREM,ranges_intermediate,ranges_REM]=bout_ranges(states_PT1);
PT1=[];
Avg_Firing_Rate_Current_Stage=[];

for sleep_stages=1:length(Post_Trial_1)
     
    Current_Stage=Post_Trial_1(sleep_stages); 
    
    for i=1:size(Current_Stage,2)
       
    idx1=Current_Stage(i).Samples_Start;
    idx2=Current_Stage(i).Samples_End;
    range=(units(:)> idx1) &   (units(:) < idx2);
    units_spliced=units(range);
    
    duration_bout(i)= (idx2-idx1)/30000;
    Avg_Firing_Rate(i)= size(units_spliced,1)/duration_bout(i);
    
    Avg_Firing_Rate_Current_Stage=[Avg_Firing_Rate_Current_Stage; Avg_Firing_Rate];
    end
    
    if sleep_stages==1
        
        %PT1(sleep_stages).Sleep_Stage='Sleep Wake: 1';
        PT1.Avg_Firing_Rate_Sleep_Wake=mean([Avg_Firing_Rate_Current_Stage]);
        
        Avg_Firing_Rate_Current_Stage=[];
        
    elseif sleep_stages==2
        %PT1(sleep_stages).Sleep_Stage='NREM: 3';
        PT1.Avg_Firing_Rate_NREM=mean([Avg_Firing_Rate_Current_Stage]);
        Avg_Firing_Rate_Current_Stage=[];
        
    elseif sleep_stages==3
        %PT1(sleep_stages).Sleep_Stage='Intermediate: 4';
        PT1.Avg_Firing_Rate_Intermediate=mean([Avg_Firing_Rate_Current_Stage]);
        Avg_Firing_Rate_Current_Stage=[];
        
    elseif sleep_stages==4
        %PT1(sleep_stages).Sleep_Stage='REM: 5';
        PT1.Avg_Firing_Rate_REM=mean([Avg_Firing_Rate_Current_Stage]);
        Avg_Firing_Rate_Current_Stage=[];
        
    end
    
    
    
end    
    

%% PT2




%% ranges NREM









post_trials=[states_presleep,states_PT1,states_PT2,states_PT3,states_PT4,states_PT5];
ranges_all=[];

% for post_trial_number=1:length(post_trials)
%     [ranges_sleep_wake,ranges_NREM,ranges_intermediate,ranges_REM,ranges_trial_wake_final]=bout_ranges(post_trials(post_trial_number));
%     
%     ranges_all=[ranges_sleep_wake,ranges_NREM,ranges_intermediate,ranges_REM,ranges_trial_wake_final];
%     
%     if post_trial_number==1
%         units_spliced_SW=[];
%         duration_bout_SW=[];
%         Avg_Firing_Rate_SW=[];
%         PT1_Data=[];
%         
%         for i=1:length(ranges_sleep_wake)
%             idx_SW=ranges_sleep_wake(i,:);
%             units_spliced_SW(i)=units( units(:)> idx_SW(1,1) & units(:) < idx_SW(1,2));
%             duration_bout_SW(i)= (idx_SW(1,2)-idx_SW(1,1)/30000);
%             Avg_Firing_Rate_SW(i)= size(units_spliced_SW(i),1)/duration_bout(i);
%         end    
%         PT1_Data.NREM_Avg_Firing_Rate=mean([Avg_Firing_Rate_SW]);
%        
%         
%    
%         
%     end    
%     
%     
% end    



% ranges function returns a struct with range bouts that are labelled accoding to their activity returns [ranges_sleep_wake_final, ranges_NREM_final,ranges_intermediate_final, ranges_REM_final,ranges_trial_wake_final]
[ranges_sleep_wake,ranges_NREM,ranges_intermediate,ranges_REM,ranges_trial_wake_final]=bout_ranges(states);

ranges_stacked=[ranges_sleep_wake;ranges_NREM;ranges_intermediate;ranges_REM;ranges_trial_wake_final]; %  struct for used for establishing continuity later

%% Arranging samples as they occurred in real time
sorted_ranges_stacked_temp=nestedSortStruct(ranges_stacked,'Samples_Start');
sorted_ranges_stacked_final=nestedSortStruct(sorted_ranges_stacked_temp,'Samples_End');




%% Choosing a neuron from SD8, Avg Firing Rate~= 21
units=Rat_3_WFM(54).curSpikeTimes;
WFM_Title=Rat_3_WFM(54).WFM_Titles;

NREM_Bout=sorted_ranges_stacked_final(18);
% % REM_Bout=sorted_ranges_stacked_final(39);
% 
idx1=NREM_Bout.Samples_Start;
idx2=NREM_Bout.Samples_End;



units_spliced=units( (units(:)>=idx1 & units(:) <=idx2) );
avg_firing_rate_NREM_bout=size(units_spliced,1)/((idx2-idx1)/30000);

ax                  = figure();
% ax=figure()
nbins               = int16(floor((idx2-idx1))/30000); %One bout at a time
h                   = histogram(units_spliced/30000,nbins);
h.FaceColor         = 'black';
mVal                = max(h.Values)+round(max(h.Values)*.1);

xlim=[idx1/30000 idx2/30000]; 
ylim=[0 mVal];

xlabel('Time[s]');
ylabel('Firing Rate');
title(strcat(WFM_Title,':','NREM Bout'),'Interpreter','none');


xline(idx1/30000,'b',{'NREM Start'},'LabelOrientation' ,'horizontal');
xline(idx1/30000,'LineWidth', 2, 'Color', 'b')

xline(idx2/30000,'b',{'NREM End'},'LabelOrientation' ,'horizontal');
xline(idx2/30000,'LineWidth', 2, 'Color', 'b')





