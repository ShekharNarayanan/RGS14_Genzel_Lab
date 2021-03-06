
%% Cortex
%% Ripple Histogram
%% Start to Split in Groups



%% Getting Ripple Response Data
Ripple_Analysis_RGS_Pyr=Ripple_Analysis_All('rgs');
Ripple_Analysis_Veh_Pyr=Ripple_Analysis_All('Veh');

%% Average Response: All groups combined
%% RGS
Angles_RGS=vertcat(Ripple_Analysis_RGS_Pyr.Ripple_Spike_Times_Normalized);
Angles_RGS=[Angles_RGS{:}];
%% Vehicle
Angles_Veh=vertcat(Ripple_Analysis_Veh_Pyr.Ripple_Spike_Times_Normalized);
Angles_Veh=[Angles_Veh{:}];

%% Quest for averaging and normalizing

%% Veh  
Counts_Avg_Veh_Temp=[]; Counts_Norm_Veh_Temp=[]; 

for ii=1:size(Ripple_Analysis_Veh_Pyr,2)
    
    current_unit=vertcat(Ripple_Analysis_Veh_Pyr(ii).Ripple_Spike_Times_Normalized);
    current_unit=[current_unit{:}];
   
%     Hist_Veh_Per_Unit=histogram(current_unit);Hist_Veh_Per_Unit.BinWidth=0.01;
%     Counts_Veh_Avg=discretize(current_unit,-1:0.01:1);
    Counts_Veh_Avg=histcounts(current_unit,-1:0.01:1);
    
    Counts_Veh_Norm=zscore(Counts_Veh_Avg); %z normalizing bin counts
%     Counts_Veh_Avg=Hist_Veh_Per_Unit.BinCounts;
    
    Counts_Norm_Veh_Temp=[Counts_Norm_Veh_Temp Counts_Veh_Norm'];
    
    Counts_Avg_Veh_Temp=[Counts_Avg_Veh_Temp  Counts_Veh_Avg'];
    
    
end

Counts_Avg_Veh_Final=[]; Counts_Norm_Veh_Final=[];
for ii=1:size(Counts_Avg_Veh_Temp',2)
    
    Counts_Avg_Veh_Final=[Counts_Avg_Veh_Final; nanmean(Counts_Avg_Veh_Temp(ii,:))];
    Counts_Norm_Veh_Final=[Counts_Norm_Veh_Final; nanmean(Counts_Norm_Veh_Temp(ii,:))];
    
end


%% RGS 
Counts_Avg_RGS_Temp=[]; Counts_Norm_RGS_Temp=[]; 

for ii=1:size(Ripple_Analysis_RGS_Pyr,2)
    
    current_unit=vertcat(Ripple_Analysis_RGS_Pyr(ii).Ripple_Spike_Times_Normalized);
    
    current_unit=[current_unit{:}];
   
    Counts_RGS_Avg=histcounts(current_unit,-1:0.01:1);
    Counts_RGS_Norm=zscore(Counts_RGS_Avg);%z normalizing bin counts
    
    Counts_Avg_RGS_Temp=[Counts_Avg_RGS_Temp  Counts_RGS_Avg'];
    Counts_Norm_RGS_Temp=[Counts_Norm_RGS_Temp Counts_RGS_Norm'];
    
    
end

Counts_Avg_RGS_Final=[]; Counts_Norm_RGS_Final=[];
for ii=1:size(Counts_Avg_RGS_Temp',2)
    
    Counts_Avg_RGS_Final=[Counts_Avg_RGS_Final; nanmean(Counts_Avg_RGS_Temp(ii,:))];
    Counts_Norm_RGS_Final=[Counts_Norm_RGS_Final; nanmean(Counts_Norm_RGS_Temp(ii,:))];
    
end



%% Plots: Averaged- All Groups
%% Veh
% figure('Name','Veh: Ripple Response')
figure('Name','RGS14 vs Vehicle: Averaged Ripple Response')
subplot(1,2,1)
Hist_Veh_Avg=histogram(Angles_Veh);Hist_Veh_Avg.BinWidth=0.01;
%% Changing Bincounts to test avg
Hist_Veh_Avg.BinCounts=Counts_Avg_Veh_Final';
title('Cortical Ripple Response: Veh')
xlabel('Window Around the Ripple')
ylabel('Average Number Of Spikes Across All Neurons')
% ylabel('Absolute Number Of Spikes Across All Neurons')

xline(0,'LineWidth',3)
% ylim([0 10000])

%% RGS
subplot(1,2,2)
Hist_RGS_Avg=histogram(Angles_RGS);Hist_RGS_Avg.BinWidth=0.01;

%% Changing Bincounts to test avg
Hist_RGS_Avg.BinCounts=Counts_Avg_RGS_Final';
title('Cortical Ripple Response: RGS14')
xlabel('Window Around the Ripple')
ylabel('Average Number Of Spikes Across All Neurons')
% ylabel('Absolute Number Of Spikes Across All Neurons')
xline(0,'LineWidth',3)

%% Z norm plots
figure('Name', 'Z-Norm Plots: All Groups')
x1=plot(Counts_Norm_RGS_Final); hold on;
x2=plot(Counts_Norm_Veh_Final);
xlabel('Window Around Ripple')
ylabel('Z-Normalized Bin Counts')
legend([x1,x2],{'RGS','Veh'})
xline(100,'LineWidth',2,'HandleVisibility','off')
title('Z-Normalized Plots: RGS vs Veh')

%% PETH Attempt
imagesc(sort(Counts_Avg_RGS_Temp))



%% Making Groups

%% Veh
%% Loading Data For Further Analysis (This segment is for binning the data in 5 groups)
load('RGS_Session_1.mat')
% load('RGS_Pyr_S1_No_Rn3.mat')
load('Vehicle_Session_1.mat') 


Pyr_RGS=RGS14_Session_1.Pyramidal_Cells;
Pyr_Veh=Vehicle_Session_1.Pyramidal_Cells;

Temp_Pyr_RGS=[];
% Removing Outliers
for i=1:size(Pyr_RGS,1)
    if (i==41) || (i==61) || (i==71) %|| (i==55) %possible outiers: 41, 55, 61, 71
        
        continue
    else
        Temp_Pyr_RGS=[Temp_Pyr_RGS; Pyr_RGS(i)];
        
    end    
end 

Pyr_RGS=Temp_Pyr_RGS;

[ ~, Pyr_RGS_Unit_Wise_Data, ~]=FR_Analysis(Pyr_RGS);
[ ~, Pyr_Veh_Unit_Wise_Data, ~]=FR_Analysis(Pyr_Veh);


%% Splitting Units using Threshold
Wake_Veh=Pyr_Veh_Unit_Wise_Data(:,6);

% Deciding Threshold Points
threshold_vec=quantile(Wake_Veh,[0.2 0.4 0.6 0.8]);

% Split for Veh NREM

Units_NREM_Veh_Less_Than_Avg_Counts=[]; Units_NREM_Veh_Less_Than_Data=[];      Units_NREM_Veh_Less_Than_Norm_Counts=[];

Units_NREM_Veh_More_Than_T1_Avg_Counts=[];Units_NREM_Veh_More_Than_T1_Data=[]; Units_NREM_Veh_More_Than_T1_Norm_Counts=[];

Units_NREM_Veh_More_Than_T2_Avg_Counts=[];Units_NREM_Veh_More_Than_T2_Data=[]; Units_NREM_Veh_More_Than_T2_Norm_Counts=[];

Units_NREM_Veh_More_Than_T3_Avg_Counts=[];Units_NREM_Veh_More_Than_T3_Data=[]; Units_NREM_Veh_More_Than_T3_Norm_Counts=[];

Units_NREM_Veh_More_Than_T4_Avg_Counts=[];Units_NREM_Veh_More_Than_T4_Data=[]; Units_NREM_Veh_More_Than_T4_Norm_Counts=[];


for ii=1:size(Wake_Veh,1)
    
    if Wake_Veh(ii)<=threshold_vec(1)
        Units_NREM_Veh_Less_Than_Data=[Units_NREM_Veh_Less_Than_Data; Ripple_Analysis_Veh_Pyr(ii)];
        Units_NREM_Veh_Less_Than_Avg_Counts=[Units_NREM_Veh_Less_Than_Avg_Counts Counts_Avg_Veh_Temp(:,ii)]; %collecting avg counts
        Units_NREM_Veh_Less_Than_Norm_Counts=[Units_NREM_Veh_Less_Than_Norm_Counts Counts_Norm_Veh_Temp(:,ii)];%collecting norm counts
        
    elseif (Wake_Veh(ii)>threshold_vec(1)) && (Wake_Veh(ii)<=threshold_vec(2))
        Units_NREM_Veh_More_Than_T1_Data=[Units_NREM_Veh_More_Than_T1_Data; Ripple_Analysis_Veh_Pyr(ii)];
        Units_NREM_Veh_More_Than_T1_Avg_Counts=[Units_NREM_Veh_More_Than_T1_Avg_Counts Counts_Avg_Veh_Temp(ii)];
        Units_NREM_Veh_More_Than_T1_Norm_Counts=[Units_NREM_Veh_More_Than_T1_Norm_Counts Counts_Norm_Veh_Temp(:,ii)];
    
    elseif (Wake_Veh(ii)>threshold_vec(2)) && (Wake_Veh(ii)<=threshold_vec(3))
        Units_NREM_Veh_More_Than_T2_Data=[Units_NREM_Veh_More_Than_T2_Data; Ripple_Analysis_Veh_Pyr(ii)];
        Units_NREM_Veh_More_Than_T2_Avg_Counts=[Units_NREM_Veh_More_Than_T2_Avg_Counts Counts_Avg_Veh_Temp(ii)]; 
        Units_NREM_Veh_More_Than_T2_Norm_Counts=[Units_NREM_Veh_More_Than_T2_Norm_Counts Counts_Norm_Veh_Temp(:,ii)];
        
    elseif (Wake_Veh(ii)>threshold_vec(3)) && (Wake_Veh(ii)<threshold_vec(4))
        Units_NREM_Veh_More_Than_T3_Data=[Units_NREM_Veh_More_Than_T3_Data; Ripple_Analysis_Veh_Pyr(ii)];
        Units_NREM_Veh_More_Than_T3_Avg_Counts=[Units_NREM_Veh_More_Than_T3_Avg_Counts Counts_Avg_Veh_Temp(ii)];  
        Units_NREM_Veh_More_Than_T3_Norm_Counts=[Units_NREM_Veh_More_Than_T3_Norm_Counts Counts_Norm_Veh_Temp(:,ii)];
        
    elseif Wake_Veh(ii)>threshold_vec(4)
        Units_NREM_Veh_More_Than_T4_Data=[Units_NREM_Veh_More_Than_T4_Data; Ripple_Analysis_Veh_Pyr(ii)];
        Units_NREM_Veh_More_Than_T4_Avg_Counts=[Units_NREM_Veh_More_Than_T4_Avg_Counts Counts_Avg_Veh_Temp(ii)];   
        Units_NREM_Veh_More_Than_T4_Norm_Counts=[Units_NREM_Veh_More_Than_T4_Norm_Counts Counts_Norm_Veh_Temp(:,ii)];
     
    end
    
    
end


%% RGS

Wake_RGS=Pyr_RGS_Unit_Wise_Data(:,6);

Units_NREM_RGS_Less_Than_Avg_Counts=[]; Units_NREM_RGS_Less_Than_Data=[];      Units_NREM_RGS_Less_Than_Norm_Counts=[];

Units_NREM_RGS_More_Than_T1_Avg_Counts=[];Units_NREM_RGS_More_Than_T1_Data=[]; Units_NREM_RGS_More_Than_T1_Norm_Counts=[];

Units_NREM_RGS_More_Than_T2_Avg_Counts=[];Units_NREM_RGS_More_Than_T2_Data=[]; Units_NREM_RGS_More_Than_T2_Norm_Counts=[];

Units_NREM_RGS_More_Than_T3_Avg_Counts=[];Units_NREM_RGS_More_Than_T3_Data=[]; Units_NREM_RGS_More_Than_T3_Norm_Counts=[];

Units_NREM_RGS_More_Than_T4_Avg_Counts=[];Units_NREM_RGS_More_Than_T4_Data=[]; Units_NREM_RGS_More_Than_T4_Norm_Counts=[];


for ii=1:size(Wake_RGS,1)
    
    if Wake_RGS(ii)<=threshold_vec(1)
        Units_NREM_RGS_Less_Than_Data=[Units_NREM_RGS_Less_Than_Data; Ripple_Analysis_RGS_Pyr(ii)];
        Units_NREM_RGS_Less_Than_Avg_Counts=[Units_NREM_RGS_Less_Than_Avg_Counts Counts_Avg_RGS_Temp(:,ii)]; %collecting avg counts
        Units_NREM_RGS_Less_Than_Norm_Counts=[Units_NREM_RGS_Less_Than_Norm_Counts Counts_Norm_RGS_Temp(:,ii)];%collecting norm counts
        
    elseif (Wake_RGS(ii)>threshold_vec(1)) && (Wake_RGS(ii)<=threshold_vec(2))
        Units_NREM_RGS_More_Than_T1_Data=[Units_NREM_RGS_More_Than_T1_Data; Ripple_Analysis_RGS_Pyr(ii)];
        Units_NREM_RGS_More_Than_T1_Avg_Counts=[Units_NREM_RGS_More_Than_T1_Avg_Counts Counts_Avg_RGS_Temp(ii)];
        Units_NREM_RGS_More_Than_T1_Norm_Counts=[Units_NREM_RGS_More_Than_T1_Norm_Counts Counts_Norm_RGS_Temp(:,ii)];
    
    elseif (Wake_RGS(ii)>threshold_vec(2)) && (Wake_RGS(ii)<=threshold_vec(3))
        Units_NREM_RGS_More_Than_T2_Data=[Units_NREM_RGS_More_Than_T2_Data; Ripple_Analysis_RGS_Pyr(ii)];
        Units_NREM_RGS_More_Than_T2_Avg_Counts=[Units_NREM_RGS_More_Than_T2_Avg_Counts Counts_Avg_RGS_Temp(ii)]; 
        Units_NREM_RGS_More_Than_T2_Norm_Counts=[Units_NREM_RGS_More_Than_T2_Norm_Counts Counts_Norm_RGS_Temp(:,ii)];
        
    elseif (Wake_RGS(ii)>threshold_vec(3)) && (Wake_RGS(ii)<threshold_vec(4))
        Units_NREM_RGS_More_Than_T3_Data=[Units_NREM_RGS_More_Than_T3_Data; Ripple_Analysis_RGS_Pyr(ii)];
        Units_NREM_RGS_More_Than_T3_Avg_Counts=[Units_NREM_RGS_More_Than_T3_Avg_Counts Counts_Avg_RGS_Temp(ii)];  
        Units_NREM_RGS_More_Than_T3_Norm_Counts=[Units_NREM_RGS_More_Than_T3_Norm_Counts Counts_Norm_RGS_Temp(:,ii)];
        
    elseif Wake_RGS(ii)>threshold_vec(4)
        Units_NREM_RGS_More_Than_T4_Data=[Units_NREM_RGS_More_Than_T4_Data; Ripple_Analysis_RGS_Pyr(ii)];
        Units_NREM_RGS_More_Than_T4_Avg_Counts=[Units_NREM_RGS_More_Than_T4_Avg_Counts Counts_Avg_RGS_Temp(ii)];   
        Units_NREM_RGS_More_Than_T4_Norm_Counts=[Units_NREM_RGS_More_Than_T4_Norm_Counts Counts_Norm_RGS_Temp(:,ii)];
     
    end
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end of making groups %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% Collecting Average Counts and Plotting: Vehicle vs RGS
%% Group 1
%Veh
hist_data_less_than_Veh=vertcat(Units_NREM_Veh_Less_Than_Data.Ripple_Spike_Times_Normalized);
hist_data_less_than_Veh=[hist_data_less_than_Veh{:}];

%RGS
hist_data_less_than_RGS=vertcat(Units_NREM_RGS_Less_Than_Data.Ripple_Spike_Times_Normalized);
hist_data_less_than_RGS=[hist_data_less_than_RGS{:}];

%% Group 2
%Veh
hist_data_more_than_T1_Veh=vertcat(Units_NREM_Veh_More_Than_T1_Data.Ripple_Spike_Times_Normalized);
hist_data_more_than_T1_Veh=[hist_data_more_than_T1_Veh{:}];


%RGS
hist_data_more_than_T1_RGS=vertcat(Units_NREM_RGS_More_Than_T1_Data.Ripple_Spike_Times_Normalized);
hist_data_more_than_T1_RGS=[hist_data_more_than_T1_RGS{:}];


%% Group 3
%Veh
hist_data_more_than_T2_Veh=vertcat(Units_NREM_Veh_More_Than_T2_Data.Ripple_Spike_Times_Normalized);
hist_data_more_than_T2_Veh=[hist_data_more_than_T2_Veh{:}];


%RGS
hist_data_more_than_T2_RGS=vertcat(Units_NREM_RGS_More_Than_T2_Data.Ripple_Spike_Times_Normalized);
hist_data_more_than_T2_RGS=[hist_data_more_than_T2_RGS{:}];

%% Group 4
%Veh
hist_data_more_than_T3_Veh=vertcat(Units_NREM_Veh_More_Than_T3_Data.Ripple_Spike_Times_Normalized);
hist_data_more_than_T3_Veh=[hist_data_more_than_T3_Veh{:}];


%RGS
hist_data_more_than_T3_RGS=vertcat(Units_NREM_RGS_More_Than_T3_Data.Ripple_Spike_Times_Normalized);
hist_data_more_than_T3_RGS=[hist_data_more_than_T3_RGS{:}];

%% Group 5

%Veh
hist_data_more_than_T4_Veh=vertcat(Units_NREM_Veh_More_Than_T4_Data.Ripple_Spike_Times_Normalized);
hist_data_more_than_T4_Veh=[hist_data_more_than_T4_Veh{:}];


%RGS
hist_data_more_than_T4_RGS=vertcat(Units_NREM_RGS_More_Than_T4_Data.Ripple_Spike_Times_Normalized);
hist_data_more_than_T4_RGS=[hist_data_more_than_T4_RGS{:}];


%% Plotting
 %% Group 1
 
 

