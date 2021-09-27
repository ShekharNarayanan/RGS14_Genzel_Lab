function [Unit_Wise_Data]=FR_Analysis_Threshold(Input_WFM,threshold_vector,varargin)


Rat_Data=Input_WFM; 

Units_New=Firing_Rate_Trials_Best_Version_Threshold(Rat_Data,threshold_vector); %No threshold in this function
Units_For_Wake=Firing_Rate_Trials_Best_Version(Rat_Data,threshold_vector); %No threshold in this function





%% Unit Wise Data

Data_First=[];Data_Last=[]; MA_All=[];

for unit_index=1:size(Units_New,2)
    
    %% Rest Periods
    Presleep=Units_New(unit_index).Presleep;
    Post_trial_1=Units_New(unit_index).Post_Trial_1;
    Post_trial_2=Units_New(unit_index).Post_Trial_2;
    Post_trial_3=Units_New(unit_index).Post_Trial_3;
    Post_trial_4=Units_New(unit_index).Post_Trial_4;
    
    Post_trial_5=[Units_New(unit_index).Post_Trial_5_All];
    
    PT5_1=[Post_trial_5.PT5_Part_1];
    PT5_2=[Post_trial_5.PT5_Part_2];
    PT5_3=[Post_trial_5.PT5_Part_3];
    PT5_4=[Post_trial_5.PT5_Part_4];
    
    %% Trials
    Trial_1=Units_For_Wake(unit_index).Trial_1;
    Trial_2=Units_For_Wake(unit_index).Trial_2;
    Trial_3=Units_For_Wake(unit_index).Trial_3;
    Trial_4=Units_For_Wake(unit_index).Trial_4;
    Trial_5=Units_For_Wake(unit_index).Trial_5;
    
    %     Wake_FR_Combined=[Trial_1.Wake_Avg_Firing_Rate Trial_2.Wake_Avg_Firing_Rate Trial_3.Wake_Avg_Firing_Rate Trial_4.Wake_Avg_Firing_Rate Trial_5.Wake_Avg_Firing_Rate];
    
    Rest_Periods=[{Presleep}, {Post_trial_1} , {Post_trial_2}, {Post_trial_3} , {Post_trial_4},  {PT5_1}, {PT5_2} , {PT5_3}, {PT5_4}];
    Trial_Periods_RP=[{Trial_1}, {Trial_2} ,{Trial_3} ,{Trial_4} ,{Trial_5}];
    
    %% Normalization Value per Unit
         Wake_Spikes_Vector_RP=[];
     Wake_Duration_Vector_RP=[];
     
     
     for i=1:length(Trial_Periods_RP)
         Wake_Spikes_Vector_RP=[Wake_Spikes_Vector_RP nansum(Trial_Periods_RP{i}.Wake_Spikes)];
         Wake_Duration_Vector_RP=[Wake_Duration_Vector_RP  nansum(Trial_Periods_RP{i}.Wake_Duration)];
         
     end
     
     
     Wake_Spikes_RP=nansum(Wake_Spikes_Vector_RP);
     Wake_Duration_RP=nansum(Wake_Duration_Vector_RP);
     
     Wake_FR_RP(unit_index)=Wake_Spikes_RP/Wake_Duration_RP; %% Getting the firing rat across all trials for the ith neuron
     
     
     
     if strcmp(varargin,'norm')
         
         x=Wake_FR_RP(unit_index);
     else 
         x=1;
         
     end    
     
    
    %% Defining Data Sets
    
    %% Quiet Wake
%     First 10 seconds
    QW_Spikes_Vector_First=[];
    QW_Duration_Vector_First=[];
    
    for i=1:length(Rest_Periods)
        QW_Spikes_Vector_First=[QW_Spikes_Vector_First nansum(Rest_Periods{i}.Quiet_Wake_Spikes_First)];
        QW_Duration_Vector_First=[QW_Duration_Vector_First  nansum(Rest_Periods{i}.Quiet_Wake_Duration_First)];
        
    end
    QW_Spikes_First=nansum(QW_Spikes_Vector_First);
    QW_Duration_First=nansum(QW_Duration_Vector_First);
    
%     Last 10 seconds
%   
    QW_Spikes_Vector_Last=[];
    QW_Duration_Vector_Last=[];
    
    for i=1:length(Rest_Periods)
        QW_Spikes_Vector_Last=[QW_Spikes_Vector_Last nansum(Rest_Periods{i}.Quiet_Wake_Spikes_Last)];
        QW_Duration_Vector_Last=[QW_Duration_Vector_Last  nansum(Rest_Periods{i}.Quiet_Wake_Duration_Last)];
        
    end
    QW_Spikes_Last=nansum(QW_Spikes_Vector_Last);
    QW_Duration_Last=nansum(QW_Duration_Vector_Last);
    
    
    
    %% MicroArousal
    %     First 10 seconds
    MA_Spikes_Vector_First=[];
    MA_Duration_Vector_First=[];
    
    for i=1:length(Rest_Periods)
        MA_Spikes_Vector_First=[MA_Spikes_Vector_First nansum(Rest_Periods{i}.Microarousal_Spikes_First)];
        MA_Duration_Vector_First=[MA_Duration_Vector_First  nansum(Rest_Periods{i}.Microarousal_Duration_First)];
        
    end
    MA_Spikes_First=nansum(MA_Spikes_Vector_First);
    MA_Duration_First=nansum(MA_Duration_Vector_First);
    
%     Last 10 seconds
%   
    MA_Spikes_Vector_Last=[];
    MA_Duration_Vector_Last=[];
    
    for i=1:length(Rest_Periods)
        MA_Spikes_Vector_Last=[MA_Spikes_Vector_Last nansum(Rest_Periods{i}.Microarousal_Spikes_Last)];
        MA_Duration_Vector_Last=[MA_Duration_Vector_Last  nansum(Rest_Periods{i}.Microarousal_Duration_Last)];
        
    end
    MA_Spikes_Last=nansum(MA_Spikes_Vector_Last);
    MA_Duration_Last=nansum(MA_Duration_Vector_Last);
    
    %% NREM
    %     First 10 seconds
    NREM_Spikes_Vector_First=[];
    NREM_Duration_Vector_First=[];
    
    for i=1:length(Rest_Periods)
        NREM_Spikes_Vector_First=[NREM_Spikes_Vector_First nansum(Rest_Periods{i}.NREM_Spikes_First)];
        NREM_Duration_Vector_First=[NREM_Duration_Vector_First  nansum(Rest_Periods{i}.NREM_Duration_First)];
        
    end
    NREM_Spikes_First=nansum(NREM_Spikes_Vector_First);
    NREM_Duration_First=nansum(NREM_Duration_Vector_First);
    
%     Last 10 seconds
%   
    NREM_Spikes_Vector_Last=[];
    NREM_Duration_Vector_Last=[];
    
    for i=1:length(Rest_Periods)
        NREM_Spikes_Vector_Last=[NREM_Spikes_Vector_Last nansum(Rest_Periods{i}.NREM_Spikes_Last)];
        NREM_Duration_Vector_Last=[NREM_Duration_Vector_Last  nansum(Rest_Periods{i}.NREM_Duration_Last)];
        
    end
    NREM_Spikes_Last=nansum(NREM_Spikes_Vector_Last);
    NREM_Duration_Last=nansum(NREM_Duration_Vector_Last);
    
    %% Intermediate
    %     First 10 seconds
    Intermediate_Spikes_Vector_First=[];
    Intermediate_Duration_Vector_First=[];
    
    for i=1:length(Rest_Periods)
        Intermediate_Spikes_Vector_First=[Intermediate_Spikes_Vector_First nansum(Rest_Periods{i}.Intermediate_Spikes_First)];
        Intermediate_Duration_Vector_First=[Intermediate_Duration_Vector_First  nansum(Rest_Periods{i}.Intermediate_Duration_First)];
        
    end
    Intermediate_Spikes_First=nansum(Intermediate_Spikes_Vector_First);
    Intermediate_Duration_First=nansum(Intermediate_Duration_Vector_First);
    
%     Last 10 seconds
%   
    Intermediate_Spikes_Vector_Last=[];
    Intermediate_Duration_Vector_Last=[];
    
    for i=1:length(Rest_Periods)
        Intermediate_Spikes_Vector_Last=[Intermediate_Spikes_Vector_Last nansum(Rest_Periods{i}.Intermediate_Spikes_Last)];
        Intermediate_Duration_Vector_Last=[Intermediate_Duration_Vector_Last  nansum(Rest_Periods{i}.Intermediate_Duration_Last)];
        
    end
    Intermediate_Spikes_Last=nansum(Intermediate_Spikes_Vector_Last);
    Intermediate_Duration_Last=nansum(Intermediate_Duration_Vector_Last);
    
    
    %% REM
    %     First 10 seconds
    REM_Spikes_Vector_First=[];
    REM_Duration_Vector_First=[];
    
    for i=1:length(Rest_Periods)
        REM_Spikes_Vector_First=[REM_Spikes_Vector_First nansum(Rest_Periods{i}.REM_Spikes_First)];
        REM_Duration_Vector_First=[REM_Duration_Vector_First  nansum(Rest_Periods{i}.REM_Duration_First)];
        
    end
    REM_Spikes_First=nansum(REM_Spikes_Vector_First);
    REM_Duration_First=nansum(REM_Duration_Vector_First);
    
%     Last 10 seconds
%   
    REM_Spikes_Vector_Last=[];
    REM_Duration_Vector_Last=[];
    
    for i=1:length(Rest_Periods)
        REM_Spikes_Vector_Last=[REM_Spikes_Vector_Last nansum(Rest_Periods{i}.REM_Spikes_Last)];
        REM_Duration_Vector_Last=[REM_Duration_Vector_Last  nansum(Rest_Periods{i}.REM_Duration_Last)];
        
    end
    REM_Spikes_Last=nansum(REM_Spikes_Vector_Last);
    REM_Duration_Last=nansum(REM_Duration_Vector_Last);
    
%     %% Wake
%     Wake_Spikes_Vector=[];
%     Wake_Duration_Vector=[];
%     
%     for i=1:length(Trial_Periods)
%         Wake_Spikes_Vector=[Wake_Spikes_Vector nansum(Trial_Periods{i}.Wake_Spikes)];
%         Wake_Duration_Vector=[Wake_Duration_Vector  nansum(Trial_Periods{i}.Wake_Duration)];
%         
%     end
%     Wake_Spikes=nansum(Wake_Spikes_Vector);
%     Wake_Duration=nansum(Wake_Duration_Vector);
    
    
    
    %% Average Firing Rate
    Quiet_Wake_FR_First=QW_Spikes_First/QW_Duration_First; Quiet_Wake_FR_Last=QW_Spikes_Last/QW_Duration_Last;
    
    Microarousal_FR_First=MA_Spikes_First/MA_Duration_First; Microarousal_FR_Last=MA_Spikes_Last/MA_Duration_Last;
    
    NREM_FR_First=NREM_Spikes_First/NREM_Duration_First; NREM_FR_Last=NREM_Spikes_Last/NREM_Duration_Last;
    
    Intermediate_FR_First=Intermediate_Spikes_First/Intermediate_Duration_First; Intermediate_FR_Last=Intermediate_Spikes_Last/Intermediate_Duration_Last;
    
    REM_FR_First=REM_Spikes_First/REM_Duration_First; REM_FR_Last=REM_Spikes_Last/REM_Duration_Last;
    
    
    FR_Data_Combined_First=[(Quiet_Wake_FR_First/x)  (Microarousal_FR_First/x) (NREM_FR_First/x)  (Intermediate_FR_First/x)  (REM_FR_First/x)];
    FR_Data_Combined_Last=[(Quiet_Wake_FR_Last/x)  (Microarousal_FR_Last/x) (NREM_FR_Last/x)  (Intermediate_FR_Last/x)  (REM_FR_Last/x)];
    
    MA_All=[MA_All; Microarousal_FR_First];
    Data_First=[Data_First; FR_Data_Combined_First];
    Data_Last=[Data_Last; FR_Data_Combined_Last];

end


Unit_Wise_Data.First_10=Data_First;
Unit_Wise_Data.Last_10=Data_Last;




end

