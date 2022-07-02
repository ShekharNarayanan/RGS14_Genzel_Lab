% This script visualizes the firing activity of neurons in different sleep stages per
% treatment.


%% Loading Data
load('RGS_Session_1.mat')
% load('RGS_Pyr_S1_No_Rn3.mat')
load('Vehicle_Session_1.mat') 


Pyr_RGS=RGS14_Session_1.Pyramidal_Cells;
Pyr_Veh=Vehicle_Session_1.Pyramidal_Cells;


%% Correcting for Outliers Lisa found

% Loading excel sheets and collecting Neuron IDs and Wake firing rates
% used for new threshold for groups
Corrected_Var_RGS= table2struct(readtable('Stage_Wise_Unit_Wise_FR_Data_Both_Treatments_wexclusion.xlsx','Sheet',1));
RGS_Useful_Data= [{{Corrected_Var_RGS(:).NeuronIDs}'} ,{[Corrected_Var_RGS.Wake]'}];
Corrected_Var_Veh= table2struct(readtable('Stage_Wise_Unit_Wise_FR_Data_Both_Treatments_wexclusion.xlsx','Sheet',2));
Veh_Useful_Data= [{{Corrected_Var_Veh(:).NeuronIDs}'} ,{[Corrected_Var_Veh.Wake]'}];

%% Name collection for corrected Data
% RGS
Temp_Pyr_RGS=[]; Temp_Pyr_Veh =[];
for i1=1:length(RGS_Useful_Data{1})
    Names=RGS_Useful_Data{1};
    Name=Names{i1};
    for i2=1:length(Pyr_RGS)
        if strcmp(Pyr_RGS(i2).WFM_Titles,Name)
            Temp_Pyr_RGS=[Temp_Pyr_RGS; Pyr_RGS(i2)];
        end
    end
       
end

%Veh
for i1=1:length(Veh_Useful_Data{1})
    Names=Veh_Useful_Data{1};
    Name=Names{i1};
    for i2=1:length(Pyr_Veh)
        if strcmp(Pyr_Veh(i2).WFM_Titles,Name)
            Temp_Pyr_Veh=[Temp_Pyr_Veh; Pyr_Veh(i2)];
        end
    end
       
end

%% Replacing Data with Temp Data
% doing this ^ helps us run the remaining part (relevant) of the script
% without changing local variables

Pyr_RGS= Temp_Pyr_RGS;
Pyr_Veh= Temp_Pyr_Veh;


% Acquiring data for the plots
[ Pyr_RGS_RP_Data, Pyr_RGS_Unit_Wise_Data, Pyr_RGS_Session_1_Units]=FR_Analysis(Pyr_RGS);
[ Pyr_Veh_RP_Data, Pyr_Veh_Unit_Wise_Data, Pyr_Veh_Session_1_Units]=FR_Analysis(Pyr_Veh);

%% Swarm Charts ALL (per unit activity) %% Modify according to what Lisa said (Wake, NREM - NREM, REM- REM)

%RGS
figure('Name','Swarm Charts ALL RGS')
plotSpread(Pyr_RGS_Unit_Wise_Data,'xNames',{'QW','MA','NREM','InterM','REM','Wake'},'distributionColors',{'r','g','b','y','c',[0.3 0.2 0.5]},'yLabel','Firing Rate Across Study Day')
title('FR vs Sleep Stages: Swarm Plot-RGS14')
ylim([0 15])

% Vehicle
figure('Name','Swarm Charts ALL Veh')
plotSpread(Pyr_Veh_Unit_Wise_Data,'xNames',{'QW','MA','NREM','InterM','REM','Wake'},'distributionColors',{'r','g','b','y','c',[0.3 0.2 0.5]},'yLabel','Firing Rate Across Study Day')
title('FR vs Sleep Stages: Swarm Plot- Vehicle')
ylim([0 15])

