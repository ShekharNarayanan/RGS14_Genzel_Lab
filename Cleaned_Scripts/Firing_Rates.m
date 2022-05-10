%% Loading Data
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

