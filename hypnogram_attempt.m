%% Selecting SD 6 from Rat 3
load('Rat_3_SP_Corrected_WFM.mat')
Rat_3_SD6=Rat_3_SP_Corrected_WFM(54:103);
%% Bout Threshold
threshold_vector_rgs=[400 30 3 30];
%% Running the Firing Rate Trials funcion to get all Fr activity (Will be modified to X bins for REM and Y bins for NREM)
Rat3_SD6_Unchanged_Bouts=Firing_Rate_Trials('/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring/Rat3_357152',Rat_3_SD6,threshold_vector_rgs);
%% After Windowing

%Final_Rat_Struct=Firing_Rate_Trials_Hypnogram(Sleep_Scoring_Directory_For_Rat,Spike_Corrected_WFM,threshold_vector_for_treatment,window_size,overlap)
fs=30000;
Rat3_SD6_Changed_Bouts=Firing_Rate_Trials_Hypnogram ('/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring/Rat3_357152',Rat_3_SD6,threshold_vector_rgs,5*fs,0);
%% Avergae Firing Rate
Avg_Firing_Rate_Vector=extractfield(Rat_3_SD6,'Avg_Firing_Rate');

%% Quintile Distribuition
quantiles=quantile(Avg_Firing_Rate_Vector,[0.2 0.4 0.6 0.8 1]);


%% Cell Classification Function Here

%% Presleep
PS_Unchanged=Rat3_SD6_Changed_Bouts.Presleep; PS_Changed=Rat3_SD6_Changed_Bouts.Presleep;
%% Getting Histograms for Windowed bouts
PT1_Changed=Rat3_SD6_Changed_Bouts.Post_Trial_1;
PT2_Changed=Rat3_SD6_Changed_Bouts.Post_Trial_2;
PT3_Changed=Rat3_SD6_Changed_Bouts.Post_Trial_3;
PT4_Changed=Rat3_SD6_Changed_Bouts.Post_Trial_4;
PT5_Changed=Rat3_SD6_Changed_Bouts.Post_Trial_5;

%% Getting Histograms for Uchanged Bouts
PT1_Unchanged=Rat3_SD6_Unchanged_Bouts.Post_Trial_1;
PT2_Unchanged=Rat3_SD6_Unchanged_Bouts.Post_Trial_2;
PT3_Unchanged=Rat3_SD6_Unchanged_Bouts.Post_Trial_3;
PT4_Unchanged=Rat3_SD6_Unchanged_Bouts.Post_Trial_4;
PT5_Unchanged=Rat3_SD6_Unchanged_Bouts.Post_Trial_5;

%% Plotting Number of Bouts per stage 

%% NREM
hold on;

h1=bar(categorical({'PT5',}),size(PT5_Changed.NREM_Bout_Wise_Firing_Rate,1),0.5,'FaceColor','b');
bar(categorical({'PT4',}),size(PT4_Changed.NREM_Bout_Wise_Firing_Rate,1),0.5,'FaceColor','b');
bar(categorical({'PT3',}),size(PT3_Changed.NREM_Bout_Wise_Firing_Rate,1),0.5,'FaceColor','b');
bar(categorical({'PT2',}),size(PT2_Changed.NREM_Bout_Wise_Firing_Rate,1),0.5,'FaceColor','b');
bar(categorical({'PT1',}),size(PT1_Changed.NREM_Bout_Wise_Firing_Rate,1),0.5,'FaceColor','b');

%% REM
h6=bar(categorical({'PT5',}),size(PT5_Changed.REM_Bout_Wise_Firing_Rate,1),0.4,'FaceColor','r');
bar(categorical({'PT4',}),size(PT4_Changed.REM_Bout_Wise_Firing_Rate,1),0.4,'FaceColor','r');
bar(categorical({'PT3',}),size(PT3_Changed.REM_Bout_Wise_Firing_Rate,1),0.4,'FaceColor','r');
bar(categorical({'PT2',}),size(PT2_Changed.REM_Bout_Wise_Firing_Rate,1),0.4,'FaceColor','r');
bar(categorical({'PT1',}),size(PT1_Changed.REM_Bout_Wise_Firing_Rate,1),0.4,'FaceColor','r');

%% Intermediate
h31 = bar(categorical({'PT5',}),size(PT5_Changed.Intermediate_Bout_Wise_Firing_Rate,1),0.3,'FaceColor','g');
bar(categorical({'PT4',}),size(PT4_Changed.Intermediate_Bout_Wise_Firing_Rate,1),0.3,'FaceColor','g');
bar(categorical({'PT3',}),size(PT3_Changed.Intermediate_Bout_Wise_Firing_Rate,1),0.3,'FaceColor','g');
bar(categorical({'PT2',}),size(PT2_Changed.Intermediate_Bout_Wise_Firing_Rate,1),0.3,'FaceColor','g');
bar(categorical({'PT1',}),size(PT1_Changed.Intermediate_Bout_Wise_Firing_Rate,1),0.3,'FaceColor','g');

%% Quiet Wake
h41 = bar(categorical({'PT5',}),size(PT5_Changed.Quiet_Wake_Bout_Wise_Firing_Rate,1),0.2,'FaceColor','y');
bar(categorical({'PT4',}),size(PT4_Changed.Quiet_Wake_Bout_Wise_Firing_Rate,1),0.2,'FaceColor','y');
bar(categorical({'PT3',}),size(PT3_Changed.Quiet_Wake_Bout_Wise_Firing_Rate,1),0.2,'FaceColor','y');
bar(categorical({'PT2',}),size(PT2_Changed.Quiet_Wake_Bout_Wise_Firing_Rate,1),0.2,'FaceColor','y');
bar(categorical({'PT1',}),size(PT1_Changed.Quiet_Wake_Bout_Wise_Firing_Rate,1),0.2,'FaceColor','y');

legend([h1, h6, h31, h41], {'NREM','REM','Intermediate','Quiet Wake'})
ylabel('Number of Bouts');xlabel('Rest Periods')
title(strcat('threshold matrix=','[400 30 3 30]',' , ','window size=','5s',',', ' ','overlap=',num2str(0)),'Interpreter','none')