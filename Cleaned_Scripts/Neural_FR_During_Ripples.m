% This script generates ripple data for ripple response type and visualizes firing activity centered around ripples.
% Note:  Variables Counts_Norm_RGS_Temp and Counts_Norm_Veh_Temp were used
% to create response type plots on GraphPad.
% Functions used: Ripple_Analysis_All.m, Ripple_Colorplot.m


%% Loading Input Data
% Variables contain the NREM sleep spikes and corresponding phases for each neuron in the entire study day

RGS_Phase=load('Phase_Vector_Slow_Wave_Pyr_RGS_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_RGS_Session_1;
Veh_Phase=load('Phase_Vector_Slow_Wave_Pyr_Veh_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_Veh_Session_1;

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



%% Getting Ripple Response Data: Extracting NREM firing centered around Ripples!
Ripple_Analysis_RGS_Pyr=Ripple_Analysis_All(RGS_Phase,'rgs');
Ripple_Analysis_Veh_Pyr=Ripple_Analysis_All(Veh_Phase,'Veh');

% Quest for averaging and normalizing-- accounting for the difference in
% sample size per treatment

% Veh
Counts_Avg_Veh_Temp=[]; Counts_Norm_Veh_Temp=[];

for ii=1:size(Ripple_Analysis_Veh_Pyr,2)
    
    % concatenating activity for a single unit
    current_unit=vertcat(Ripple_Analysis_Veh_Pyr(ii).Ripple_Spike_Times_Normalized);
    current_unit=[current_unit{:}];
    
    % collecting counts per unit
    Counts_Veh_Avg=histcounts(current_unit,-1:0.01:1); % fixing the number of bins to 200
    
    % z normalized counts
    Counts_Veh_Norm=zscore(Counts_Veh_Avg); %z normalizing bin counts
    
    
    Counts_Norm_Veh_Temp=[Counts_Norm_Veh_Temp Counts_Veh_Norm']; % data per neuron
    
    Counts_Avg_Veh_Temp=[Counts_Avg_Veh_Temp  Counts_Veh_Avg'];
    
    
end

Counts_Avg_Veh_Final=[]; Counts_Norm_Veh_Final=[]; % Averaging across all neurons
for ii=1:size(Counts_Avg_Veh_Temp',2)
    
    Counts_Avg_Veh_Final=[Counts_Avg_Veh_Final; nanmean(Counts_Avg_Veh_Temp(ii,:))];
    Counts_Norm_Veh_Final=[Counts_Norm_Veh_Final; nanmean(Counts_Norm_Veh_Temp(ii,:))];
    
end


% RGS (same procedure as above)
Counts_Avg_RGS_Temp=[]; Counts_Norm_RGS_Temp=[];

for ii=1:size(Ripple_Analysis_RGS_Pyr,2)
    
    current_unit=vertcat(Ripple_Analysis_RGS_Pyr(ii).Ripple_Spike_Times_Normalized);
    
    current_unit=[current_unit{:}];
    
    Counts_RGS_Avg=histcounts(current_unit,-1:0.01:1);
    Counts_RGS_Norm=zscore(Counts_RGS_Avg);%z normalizing bin counts
    
    Counts_Avg_RGS_Temp=[Counts_Avg_RGS_Temp  Counts_RGS_Avg']; % data per neuron
    Counts_Norm_RGS_Temp=[Counts_Norm_RGS_Temp Counts_RGS_Norm'];
    
    
end

Counts_Avg_RGS_Final=[]; Counts_Norm_RGS_Final=[];
for ii=1:size(Counts_Avg_RGS_Temp',2)
    
    Counts_Avg_RGS_Final=[Counts_Avg_RGS_Final; nanmean(Counts_Avg_RGS_Temp(ii,:))];
    Counts_Norm_RGS_Final=[Counts_Norm_RGS_Final; nanmean(Counts_Norm_RGS_Temp(ii,:))];
    
end


%% Z norm plots: Smooth x 2
smooth_data_RGS = smooth(smooth(Counts_Norm_RGS_Final));
smooth_data_Veh = smooth(smooth(Counts_Norm_Veh_Final));

figure('Name', 'Z-Norm Plots: All Groups')
x_axis=linspace(-1,1,200);
x1=plot(x_axis,smooth_data_RGS); hold on;
x2=plot(x_axis,smooth_data_Veh);
xlabel('Window Around Ripple')
ylabel('Z-Normalized Bin Counts')
legend([x1,x2],{'RGS ','Veh'})
xline(0,'LineWidth',2,'HandleVisibility','off')
title('Z-Normalized Plots: RGS vs Veh')


%% imagesc plot
%% PRTH -RGS vs Veh (inverted in the paper)
figure('Name','RGS vs Veh Imagesc')
subplot 121
imagesc_all_RGS=Ripple_Colorplot(Ripple_Analysis_RGS_Pyr,'RGS',200);
title('RGS','Interpreter','none') 

subplot 122
imagesc_all_Veh=Ripple_Colorplot(Ripple_Analysis_Veh_Pyr,'Veh',200);
title('Veh','Interpreter','none')

