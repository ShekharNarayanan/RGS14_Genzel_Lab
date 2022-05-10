%% Loading Input Data
RGS_Phase=load('Phase_Vector_Slow_Wave_Pyr_RGS_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_RGS_Session_1 ;
Veh_Phase=load('Phase_Vector_Slow_Wave_Pyr_Veh_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_Veh_Session_1 ;

%% Correcting for Outliers Lisa found

% Loading excel sheets and collecting Neuron IDs and Wake firing rates
% used for new threshold for groups
Corrected_Var_RGS= table2struct(readtable('Stage_Wise_Unit_Wise_FR_Data_Both_Treatments_wexclusion.xlsx','Sheet',1));
RGS_Useful_Data= [{{Corrected_Var_RGS(:).NeuronIDs}'} ,{[Corrected_Var_RGS.Wake]'}];
Corrected_Var_Veh= table2struct(readtable('Stage_Wise_Unit_Wise_FR_Data_Both_Treatments_wexclusion.xlsx','Sheet',2));
Veh_Useful_Data= [{{Corrected_Var_Veh(:).NeuronIDs}'} ,{[Corrected_Var_Veh.Wake]'}];

%% Name collection for corrected Data
% RGS
RGS_Phase_Temp=[]; Veh_Phase_Temp =[];
for i1=1:length(RGS_Useful_Data{1})
    Names=RGS_Useful_Data{1};
    Name=Names{i1};
    for i2=1:length(RGS_Phase)
        if strcmp(RGS_Phase(i2).WFM_Titles,Name)
            RGS_Phase_Temp=[RGS_Phase_Temp; RGS_Phase(i2)];
        end    
    end
    
    
end    

%Veh
for i1=1:length(Veh_Useful_Data{1})
    Names=Veh_Useful_Data{1};
    Name=Names{i1};
    for i2=1:length(Veh_Phase)
        if strcmp(Veh_Phase(i2).WFM_Titles,Name)
            Veh_Phase_Temp=[Veh_Phase_Temp; Veh_Phase(i2)];
        end    
    end
    
    
end 

%% Replacing Data with Temp Data
% doing this ^ helps us run the remaining part (relevant) of the script
% without changing local variables
RGS_Phase = RGS_Phase_Temp';
Veh_Phase = Veh_Phase_Temp';

%% Combing Data
Combined_RGS=vertcat(RGS_Phase.NREM_SW_Phases);
Combined_Veh=vertcat(Veh_Phase.NREM_SW_Phases);

%% Plotting Combined Data (Averaged but not normalized)
% % Collecting Average Counts
Counts_Avg_RGS_Temp=[]; 
for i=1:size(RGS_Phase,2)

hist_RGS=histogram(RGS_Phase(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_RGS_Avg=hist_RGS.BinCounts;

diff_count=360-size(Counts_RGS_Avg,2);% fixing number of bins to 360- meaningful for phase analysis
Counts_RGS_Avg=[Counts_RGS_Avg nan(1,diff_count)];
Counts_Avg_RGS_Temp=[Counts_Avg_RGS_Temp  Counts_RGS_Avg'];   %collecting bincounts for each neuron                        
end

Counts_Avg_RGS_Final=[]; % averaging across neurons in this loop
for ii=1:size(Counts_Avg_RGS_Temp',2)
    
    Counts_Avg_RGS_Final=[Counts_Avg_RGS_Final; nanmean(Counts_Avg_RGS_Temp(ii,:))];

    
end

% Vehicle
Counts_Avg_Veh_Temp=[];
for i=1:size(Veh_Phase,2)

hist_Veh=histogram(Veh_Phase(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_Veh=hist_Veh.BinCounts;

diff_count=360-size(Counts_Veh,2);
Counts_Veh=[Counts_Veh nan(1,diff_count)];
Counts_Avg_Veh_Temp=[Counts_Avg_Veh_Temp  Counts_Veh'];                           
end

Counts_Avg_Veh_Final=[];
for ii=1:size(Counts_Avg_Veh_Temp',2)
    
    Counts_Avg_Veh_Final=[Counts_Avg_Veh_Final; nanmean(Counts_Avg_Veh_Temp(ii,:))];

    
end



figure('Name','RGS Combined')
subplot(1,2,1)
Avg_hist_RGS=histogram(Combined_RGS,360,'BinWidth',1);Avg_hist_RGS.BinCounts=Counts_Avg_RGS_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM Histogram \n Units:%d',size(RGS_Phase,2)))
ylim([0 120])
subplot(1,2,2)
hist_polar_RGS_combined=polarhistogram(deg2rad(Combined_RGS), 18, 'FaceColor','g');
title(sprintf("All RGS14 Pyr Units Combined \n Units:%d",size(RGS_Phase,2)))

figure('Name','Veh Combined')
subplot(1,2,1)
Avg_hist_Veh=histogram(Combined_Veh,360,'BinWidth',1);Avg_hist_Veh.BinCounts=Counts_Avg_Veh_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM Histogram \n Units:%d',size(Veh_Phase,2)))

subplot(1,2,2)
hist_polar_Veh_combined=polarhistogram(deg2rad(Combined_Veh), 18, 'FaceColor','b');
title(sprintf("All Veh Pyr Units Combined \n Units:%d",size(Veh_Phase,2)))

%% Normalized Approach

% Collecting Normalized Counts

% RGS
Counts_Norm_RGS_Temp=[]; 
for i=1:size(RGS_Phase,2)

hist_RGS=histogram(RGS_Phase(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_RGS_Norm=hist_RGS.BinCounts;

Counts_RGS_Norm=Counts_RGS_Norm/max(Counts_RGS_Norm); %% Normalization step- dividing each bincount by the max count

diff_count=360-size(Counts_RGS_Norm,2); % fixing total number of bins to 360
Counts_RGS_Norm=[Counts_RGS_Norm nan(1,diff_count)];
Counts_Norm_RGS_Temp=[Counts_Norm_RGS_Temp  Counts_RGS_Norm'];                           
end

Counts_Norm_RGS_Final=[]; 
for ii=1:size(Counts_Norm_RGS_Temp',2)
    
    Counts_Norm_RGS_Final=[Counts_Norm_RGS_Final; nanmean(Counts_Norm_RGS_Temp(ii,:))];

    
end

% Vehicle
Counts_Norm_Veh_Temp=[];
for i=1:size(Veh_Phase,2)

hist_Veh=histogram(Veh_Phase(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_Veh=hist_Veh.BinCounts;

Counts_Veh=Counts_Veh/max(Counts_Veh); %% Normalization step

diff_count=360-size(Counts_Veh,2);
Counts_Veh=[Counts_Veh nan(1,diff_count)];
Counts_Norm_Veh_Temp=[Counts_Norm_Veh_Temp  Counts_Veh'];                           
end

Counts_Norm_Veh_Final=[];
for ii=1:size(Counts_Norm_Veh_Temp',2)
    
    Counts_Norm_Veh_Final=[Counts_Norm_Veh_Final; nanmean(Counts_Norm_Veh_Temp(ii,:))];

    
end

%% Plotting Norm Data
figure('Name','Normalized Histograms -RGS')
% subplot(1,2,2)
hold on;
Norm_hist_RGS=histogram(Combined_RGS,360); Norm_hist_RGS.BinCounts=Counts_Norm_RGS_Final';
title(sprintf('RGS Phase Spike normalized Plot \n RGS Units: %d',size(RGS_Phase,2)))
ylim([0 1])
xlabel('Phase: 0-360')
ylabel('Normalized Spike Counts')

figure('Name','Normalized Histograms -Veh')
% subplot(1,2,1)
Norm_hist_Veh=histogram(Combined_Veh,360,'FaceColor','k'); Norm_hist_Veh.BinCounts=Counts_Norm_Veh_Final';
title(sprintf('Veh Phase Spike normalized Plot \n Units: %d',size(Veh_Phase,2)))
xlabel('Phase: 0-360')
ylabel('Normalized Spike Counts')
ylim([0 1])