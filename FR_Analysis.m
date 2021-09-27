function [Rest_Period_Data, Unit_Wise_Data, Units]=FR_Analysis(Input_WFM,varargin)

% addpath('/home/irene/Downloads/RGS14_all_Shekhar/Sessions_Folder')
nrem_spikes=[];


Rat_Data=Input_WFM; 

Units=Firing_Rate_Trials_Best_Version(Rat_Data,[0 0 0 0 0 0]); %No threshold in this function, change as per requirement

%% Rest Period Centric Data
QW_FR_RP_Temp=[]; QW_FR_RP_Final=[];
MA_FR_RP_Temp=[]; MA_FR_RP_Final=[];  
NREM_FR_RP_Temp=[]; NREM_FR_RP_Final=[];
Intermediate_FR_RP_Temp=[];Intermediate_FR_RP_Final=[];
REM_FR_RP_Temp=[]; REM_FR_RP_Final=[];
Wake_FR_RP_Temp=[]; Wake_FR_RP_Final=[];


Wake_Clubbed=[]; 
 for unit_index=1:size(Units,2)
    
     %% Rest Periods
     Presleep=Units(unit_index).Presleep;
     Post_trial_1=Units(unit_index).Post_Trial_1;
     Post_trial_2=Units(unit_index).Post_Trial_2;
     Post_trial_3=Units(unit_index).Post_Trial_3;
     Post_trial_4=Units(unit_index).Post_Trial_4;
     
     Post_trial_5=[Units(unit_index).Post_Trial_5_All];
     
     PT5_1=[Post_trial_5.PT5_Part_1];
     PT5_2=[Post_trial_5.PT5_Part_2];
     PT5_3=[Post_trial_5.PT5_Part_3];
     PT5_4=[Post_trial_5.PT5_Part_4];
     
     %% Trials
     Trial_1=Units(unit_index).Trial_1;
     Trial_2=Units(unit_index).Trial_2;
     Trial_3=Units(unit_index).Trial_3;
     Trial_4=Units(unit_index).Trial_4;
     Trial_5=Units(unit_index).Trial_5;
     
     
     
     Rest_Periods=[{Presleep}, {Post_trial_1} , {Post_trial_2}, {Post_trial_3} , {Post_trial_4},  {PT5_1}, {PT5_2} , {PT5_3}, {PT5_4}];
     Trial_Periods_RP=[{Trial_1}, {Trial_2} ,{Trial_3} ,{Trial_4} ,{Trial_5}];
     
     %% Defining Data Sets
     %% Wake Data for Normalization
     Wake_Spikes_Vector_RP=[];
     Wake_Duration_Vector_RP=[];
     
     
     for i=1:length(Trial_Periods_RP)
         Wake_Spikes_Vector_RP=[Wake_Spikes_Vector_RP nansum(Trial_Periods_RP{i}.Wake_Spikes)];
         Wake_Duration_Vector_RP=[Wake_Duration_Vector_RP  nansum(Trial_Periods_RP{i}.Wake_Duration)];
         
     end
     
     
     Wake_Spikes_RP=nansum(Wake_Spikes_Vector_RP);
     Wake_Duration_RP=nansum(Wake_Duration_Vector_RP);
     
     Wake_FR_RP(unit_index)=Wake_Spikes_RP/Wake_Duration_RP; %% Getting the firing rat across all trials for the ith neuron
     
     Wake_FR_RP_Temp=[Wake_FR_RP_Temp; (Wake_Spikes_Vector_RP./Wake_Duration_Vector_RP)./Wake_FR_RP(unit_index)]; %% Divinding all 5 values from trials by the value obtained above
     
     Wake_Clubbed=[Wake_Clubbed; Wake_FR_RP(unit_index)];
     
%      Wake_norm_per_neuron=[Wake_norm_per_neuron; ];
     
     %% Quiet Wake
     QW_Spikes_Vector=[];
     QW_Duration_Vector=[];
     
     for i=1:length(Rest_Periods)
         QW_Spikes_Vector=[QW_Spikes_Vector nansum(Rest_Periods{i}.Quiet_Wake_Spikes)];
         QW_Duration_Vector=[QW_Duration_Vector  nansum(Rest_Periods{i}.Quiet_Wake_Duration)];
         
     end
     
      QW_FR_RP_Temp=[QW_FR_RP_Temp; (QW_Spikes_Vector./QW_Duration_Vector)./Wake_FR_RP(unit_index)];
      
      nrem_spikes=[nrem_spikes; QW_Spikes_Vector];
     %% MicroArousal
     MA_Spikes_Vector=[];
     MA_Duration_Vector=[];
     
     for i=1:length(Rest_Periods)
         MA_Spikes_Vector=[MA_Spikes_Vector nansum(Rest_Periods{i}.Microarousal_Spikes)];
         MA_Duration_Vector=[MA_Duration_Vector  nansum(Rest_Periods{i}.Microarousal_Duration)];
         
     end
     
     MA_FR_RP_Temp=[MA_FR_RP_Temp; (MA_Spikes_Vector./MA_Duration_Vector)./Wake_FR_RP(unit_index)];

     
     %% NREM
     NREM_Spikes_Vector=[];
     NREM_Duration_Vector=[];
     
     for i=1:length(Rest_Periods)
         NREM_Spikes_Vector=[NREM_Spikes_Vector nansum(Rest_Periods{i}.NREM_Spikes)]; % Spikes from each resting period (PT1, PT2......PT5_4)
         NREM_Duration_Vector=[NREM_Duration_Vector  nansum(Rest_Periods{i}.NREM_Duration)];% Duration from each resting period (PT1, PT2......PT5_4)
         
     end
     
     NREM_FR_RP_Temp=[NREM_FR_RP_Temp; (NREM_Spikes_Vector./NREM_Duration_Vector)./Wake_FR_RP(unit_index)]; % One row in this vector has 9 values, each divided by the wake normalization for that neuron

     nrem_spikes=[nrem_spikes; NREM_Spikes_Vector];
     %% Intermediate
     Intermediate_Spikes_Vector=[];
     Intermediate_Duration_Vector=[];
     
     for i=1:length(Rest_Periods)
         Intermediate_Spikes_Vector=[Intermediate_Spikes_Vector nansum(Rest_Periods{i}.Intermediate_Spikes)];
         Intermediate_Duration_Vector=[Intermediate_Duration_Vector  nansum(Rest_Periods{i}.Intermediate_Duration)];
         
     end
     
     Intermediate_FR_RP_Temp=[Intermediate_FR_RP_Temp; (Intermediate_Spikes_Vector./Intermediate_Duration_Vector)./Wake_FR_RP(unit_index)];

     %% REM
     REM_Spikes_Vector=[];
     REM_Duration_Vector=[];
     
     for i=1:length(Rest_Periods)
         REM_Spikes_Vector=[REM_Spikes_Vector nansum(Rest_Periods{i}.REM_Spikes)];
         REM_Duration_Vector=[REM_Duration_Vector  nansum(Rest_Periods{i}.REM_Duration)];
         
     end
     
     REM_FR_RP_Temp=[REM_FR_RP_Temp; (REM_Spikes_Vector./REM_Duration_Vector)./Wake_FR_RP(unit_index)];
     
     
  
 end  
 
 

 QW_SEM=[];MA_SEM=[];NREM_SEM=[];InterM_SEM=[];REM_SEM=[];Wake_SEM=[];
 
%  QW_FR_RP_Temp(isnan(QW_FR_RP_Temp))=0;  MA_FR_RP_Temp(isnan(MA_FR_RP_Temp))=0;  NREM_FR_RP_Temp(isnan(NREM_FR_RP_Temp))=0; 
%  Intermediate_FR_RP_Temp(isnan(Intermediate_FR_RP_Temp))=0;  REM_FR_RP_Temp(isnan(REM_FR_RP_Temp))=0;
 
 Wake_FR_RP_Temp(isnan(Wake_FR_RP_Temp))=0;
 

 
 for i=1:size(QW_FR_RP_Temp,2)
     QW_FR_RP_Final=[QW_FR_RP_Final nanmean(QW_FR_RP_Temp(:,i))];
     QW_SEM=[QW_SEM SEM_Shekhar(rmmissing(QW_FR_RP_Temp(:,i)))];
     
     MA_FR_RP_Final=[MA_FR_RP_Final nanmean(MA_FR_RP_Temp(:,i))];
     MA_SEM=[MA_SEM SEM_Shekhar(rmmissing(MA_FR_RP_Temp(:,i)))];
     
     NREM_FR_RP_Final=[NREM_FR_RP_Final nanmean(NREM_FR_RP_Temp(:,i))];
     NREM_SEM=[NREM_SEM SEM_Shekhar(rmmissing(NREM_FR_RP_Temp(:,i)))];
     
     Intermediate_FR_RP_Final=[Intermediate_FR_RP_Final nanmean(Intermediate_FR_RP_Temp(:,i))];
     InterM_SEM=[InterM_SEM SEM_Shekhar(rmmissing(Intermediate_FR_RP_Temp(:,i)))];
     
     REM_FR_RP_Final=[REM_FR_RP_Final nanmean(REM_FR_RP_Temp(:,i))];
     REM_SEM=[REM_SEM SEM_Shekhar(rmmissing(REM_FR_RP_Temp(:,i)))];
     
 end
 
 for j=1:size(Wake_FR_RP_Temp,2)
     Wake_FR_RP_Final=[Wake_FR_RP_Final nanmean(Wake_FR_RP_Temp(:,j))];
     Wake_SEM=[Wake_SEM SEM_Shekhar(rmmissing(Wake_FR_RP_Temp(:,j)))];
 end

 


Rest_Period_Data.Post_Trial_Vector=[QW_FR_RP_Final' MA_FR_RP_Final' NREM_FR_RP_Final' Intermediate_FR_RP_Final' REM_FR_RP_Final'];
Rest_Period_Data.Wake_Vector= Wake_FR_RP_Final';
Rest_Period_Data.SEM_PT=[QW_SEM' MA_SEM' NREM_SEM' InterM_SEM' REM_SEM']; 
Rest_Period_Data.SEM_Wake=Wake_SEM';

Rest_Period_Data.PT_Temp_Data=[{QW_FR_RP_Temp},{MA_FR_RP_Temp},{NREM_FR_RP_Temp},{Intermediate_FR_RP_Temp},{REM_FR_RP_Temp}];
Rest_Period_Data.Wake_Temp_Data=Wake_FR_RP_Temp;


%% Unit Wise Data

Unit_Wise_Data=[];

for unit_index=1:size(Units,2)
    
    %% Rest Periods
    Presleep=Units(unit_index).Presleep;
    Post_trial_1=Units(unit_index).Post_Trial_1;
    Post_trial_2=Units(unit_index).Post_Trial_2;
    Post_trial_3=Units(unit_index).Post_Trial_3;
    Post_trial_4=Units(unit_index).Post_Trial_4;
    
    Post_trial_5=[Units(unit_index).Post_Trial_5_All];
    
    PT5_1=[Post_trial_5.PT5_Part_1];
    PT5_2=[Post_trial_5.PT5_Part_2];
    PT5_3=[Post_trial_5.PT5_Part_3];
    PT5_4=[Post_trial_5.PT5_Part_4];
    
    %% Trials
    Trial_1=Units(unit_index).Trial_1;
    Trial_2=Units(unit_index).Trial_2;
    Trial_3=Units(unit_index).Trial_3;
    Trial_4=Units(unit_index).Trial_4;
    Trial_5=Units(unit_index).Trial_5;
    
    %     Wake_FR_Combined=[Trial_1.Wake_Avg_Firing_Rate Trial_2.Wake_Avg_Firing_Rate Trial_3.Wake_Avg_Firing_Rate Trial_4.Wake_Avg_Firing_Rate Trial_5.Wake_Avg_Firing_Rate];
    
    Rest_Periods=[{Presleep}, {Post_trial_1} , {Post_trial_2}, {Post_trial_3} , {Post_trial_4},  {PT5_1}, {PT5_2} , {PT5_3}, {PT5_4}];
    Trial_Periods=[{Trial_1}, {Trial_2} ,{Trial_3} ,{Trial_4} ,{Trial_5}];
    
    %% Defining Data Sets
    
    %% Quiet Wake
    QW_Spikes_Vector=[];
    QW_Duration_Vector=[];
    
    for i=1:length(Rest_Periods)
        QW_Spikes_Vector=[QW_Spikes_Vector nansum(Rest_Periods{i}.Quiet_Wake_Spikes)];
        QW_Duration_Vector=[QW_Duration_Vector  nansum(Rest_Periods{i}.Quiet_Wake_Duration)];
        
    end
    QW_Spikes=nansum(QW_Spikes_Vector);
    QW_Duration=nansum(QW_Duration_Vector);
    
    
    
    %% MicroArousal
    MA_Spikes_Vector=[];
    MA_Duration_Vector=[];
    
    for i=1:length(Rest_Periods)
        MA_Spikes_Vector=[MA_Spikes_Vector nansum(Rest_Periods{i}.Microarousal_Spikes)];
        MA_Duration_Vector=[MA_Duration_Vector  nansum(Rest_Periods{i}.Microarousal_Duration)];
        
    end
    MA_Spikes=nansum(MA_Spikes_Vector);
    MA_Duration=nansum(MA_Duration_Vector);
    
    %% NREM
    NREM_Spikes_Vector=[];
    NREM_Duration_Vector=[];
    
    for i=1:length(Rest_Periods)
        NREM_Spikes_Vector=[NREM_Spikes_Vector nansum(Rest_Periods{i}.NREM_Spikes)];
        NREM_Duration_Vector=[NREM_Duration_Vector  nansum(Rest_Periods{i}.NREM_Duration)];
        
    end
    NREM_Spikes=nansum(NREM_Spikes_Vector);
    NREM_Duration=nansum(NREM_Duration_Vector);
    
    %% Intermediate
    Intermediate_Spikes_Vector=[];
    Intermediate_Duration_Vector=[];
    
    for i=1:length(Rest_Periods)
        Intermediate_Spikes_Vector=[Intermediate_Spikes_Vector nansum(Rest_Periods{i}.Intermediate_Spikes)];
        Intermediate_Duration_Vector=[Intermediate_Duration_Vector  nansum(Rest_Periods{i}.Intermediate_Duration)];
        
    end
    Intermediate_Spikes=nansum(Intermediate_Spikes_Vector);
    Intermediate_Duration=nansum(Intermediate_Duration_Vector);
    %% REM
    REM_Spikes_Vector=[];
    REM_Duration_Vector=[];
    
    for i=1:length(Rest_Periods)
        REM_Spikes_Vector=[REM_Spikes_Vector nansum(Rest_Periods{i}.REM_Spikes)];
        REM_Duration_Vector=[REM_Duration_Vector  nansum(Rest_Periods{i}.REM_Duration)];
        
    end
    REM_Spikes=nansum(REM_Spikes_Vector);
    REM_Duration=nansum(REM_Duration_Vector);
    
    %% Wake
    Wake_Spikes_Vector=[];
    Wake_Duration_Vector=[];
    
    for i=1:length(Trial_Periods)
        Wake_Spikes_Vector=[Wake_Spikes_Vector nansum(Trial_Periods{i}.Wake_Spikes)];
        Wake_Duration_Vector=[Wake_Duration_Vector  nansum(Trial_Periods{i}.Wake_Duration)];
        
    end
    Wake_Spikes=nansum(Wake_Spikes_Vector);
    Wake_Duration=nansum(Wake_Duration_Vector);
    
    
    
    %% Average Firing Rate
    
    Wake_Average_FR=Wake_Spikes/Wake_Duration;
    
    Quiet_Wake_Average_FR=QW_Spikes/QW_Duration;
    
    Microarousal_Average_FR=MA_Spikes/MA_Duration;
    
    NREM_Average_FR=NREM_Spikes/NREM_Duration;
    
    Intermediate_Average_FR=Intermediate_Spikes/Intermediate_Duration;
    
    REM_Average_FR=REM_Spikes/REM_Duration;
    
    if strcmp(varargin,'norm')
        
        x=Wake_FR_RP(unit_index);
    else
        x=1;
        
    end
    
    
    FR_Data_Combined=[mean(Quiet_Wake_Average_FR/x)  mean(Microarousal_Average_FR/x) mean(NREM_Average_FR/x)  mean(Intermediate_Average_FR/x)...
        mean(REM_Average_FR/x) mean(Wake_Average_FR/x)];

    
    Unit_Wise_Data=[Unit_Wise_Data; FR_Data_Combined];

end





end

