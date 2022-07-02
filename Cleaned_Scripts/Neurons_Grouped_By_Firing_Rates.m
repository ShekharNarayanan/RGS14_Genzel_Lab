% This script visualizes the different neuron groups based on their firing
% rates. This is done for both treatments.

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

%% Making Veh Groups
Units_NREM_Veh_Less_Than_Data=[];

Units_NREM_Veh_More_Than_T1_Data=[];

Units_NREM_Veh_More_Than_T2_Data=[];

Units_NREM_Veh_More_Than_T3_Data=[];

Units_NREM_Veh_More_Than_T4_Data=[];

Wake_Veh=Pyr_Veh_Unit_Wise_Data(:,6); % Wake Firing Rates that decide threshold

%% Deciding Threshold Points
threshold_vec=quantile(Wake_Veh,[0.2 0.4 0.6 0.8]);


for ii=1:size(Wake_Veh,1)
    
    if Wake_Veh(ii)<=threshold_vec(1)
        Units_NREM_Veh_Less_Than_Data=[Units_NREM_Veh_Less_Than_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        
    elseif (Wake_Veh(ii)>threshold_vec(1)) && (Wake_Veh(ii)<=threshold_vec(2))
        Units_NREM_Veh_More_Than_T1_Data=[Units_NREM_Veh_More_Than_T1_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
    
    elseif (Wake_Veh(ii)>threshold_vec(2)) && (Wake_Veh(ii)<=threshold_vec(3))
        Units_NREM_Veh_More_Than_T2_Data=[Units_NREM_Veh_More_Than_T2_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        
    elseif (Wake_Veh(ii)>threshold_vec(3)) && (Wake_Veh(ii)<threshold_vec(4))
        Units_NREM_Veh_More_Than_T3_Data=[Units_NREM_Veh_More_Than_T3_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        
    elseif Wake_Veh(ii)>threshold_vec(4)
        Units_NREM_Veh_More_Than_T4_Data=[Units_NREM_Veh_More_Than_T4_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];       
     
    end
        
end


%% Making RGS Groups
Units_NREM_RGS_Less_Than_Data=[];

Units_NREM_RGS_More_Than_T1_Data=[];

Units_NREM_RGS_More_Than_T2_Data=[];

Units_NREM_RGS_More_Than_T3_Data=[];

Units_NREM_RGS_More_Than_T4_Data=[];

Wake_RGS=Pyr_RGS_Unit_Wise_Data(:,6);

% RGS neurons are split by vehicle thresholds
for ii=1:size(Wake_RGS,1)
    
    if Wake_RGS(ii)<=threshold_vec(1)
        Units_NREM_RGS_Less_Than_Data=[Units_NREM_RGS_Less_Than_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        
    elseif (Wake_RGS(ii)>threshold_vec(1)) && (Wake_RGS(ii)<=threshold_vec(2))
        Units_NREM_RGS_More_Than_T1_Data=[Units_NREM_RGS_More_Than_T1_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
    
    elseif (Wake_RGS(ii)>threshold_vec(2)) && (Wake_RGS(ii)<=threshold_vec(3))
        Units_NREM_RGS_More_Than_T2_Data=[Units_NREM_RGS_More_Than_T2_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        
    elseif (Wake_RGS(ii)>threshold_vec(3)) && (Wake_RGS(ii)<threshold_vec(4))
        Units_NREM_RGS_More_Than_T3_Data=[Units_NREM_RGS_More_Than_T3_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        
    elseif Wake_RGS(ii)>threshold_vec(4)
        Units_NREM_RGS_More_Than_T4_Data=[Units_NREM_RGS_More_Than_T4_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];       
     
    end
        
end

%% Unit Distribution Pie Chart
figure('Name','Unit Distribution')

subplot(1,2,2)
rgs=pie([size(Units_NREM_RGS_Less_Than_Data,1),size(Units_NREM_RGS_More_Than_T1_Data,1),size(Units_NREM_RGS_More_Than_T2_Data,1),...
    size(Units_NREM_RGS_More_Than_T3_Data,1),size(Units_NREM_RGS_More_Than_T4_Data,1)]);
legend('0-20 percent','20-40 percent','40-60 percent','60-80 percent','80-100 percent','Location',"northeastoutside")
title(sprintf('RGS14 Unit Distribution \n Total Units: %d',size(Pyr_RGS,1)))

%setting colors
patchHand = findobj(rgs, 'Type', 'Patch');
patchHand(1).FaceColor = 'r';
patchHand(2).FaceColor = 'g';
patchHand(3).FaceColor = 'y';
patchHand(4).FaceColor = 'k';
patchHand(5).FaceColor = 'b';


subplot(1,2,1)
veh=pie([size(Units_NREM_Veh_Less_Than_Data,1),size(Units_NREM_Veh_More_Than_T1_Data,1),size(Units_NREM_Veh_More_Than_T2_Data,1),...
    size(Units_NREM_Veh_More_Than_T3_Data,1),size(Units_NREM_Veh_More_Than_T4_Data,1)]);
legend('0-20 percent','20-40 percent','40-60 percent','60-80 percent','80-100 percent','Location',"northeastoutside")
title(sprintf('Veh Unit Distribution \n Total Units: %d',size(Pyr_Veh,1)))

%setting colors
patchHand = findobj(veh, 'Type', 'Patch');
patchHand(1).FaceColor = 'r';
patchHand(2).FaceColor = 'g';
patchHand(3).FaceColor = 'y';
patchHand(4).FaceColor = 'k';
patchHand(5).FaceColor = 'b';
