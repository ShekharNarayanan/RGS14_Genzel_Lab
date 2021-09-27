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

%% Writing Data to Excel Sheet
% filename='Unit_Wise_Data_Both_Treatments.xlsx';
% Unit_Count_RGS14=[]; 
% for i=1:size(Pyr_RGS_Unit_Wise_Data,1)
%     Unit_Count_RGS14=[Unit_Count_RGS14;i];
% end   
% 
% Unit_Count_Veh=[];
% for i=1:size(Pyr_Veh_Unit_Wise_Data,1)
%     Unit_Count_Veh=[Unit_Count_Veh;i];
% end 

% RGS14=array2table([Unit_Count_RGS14   Pyr_RGS_Unit_Wise_Data]);
% RGS14.Properties.VariableNames={'Index','Quiet Wake','Microarousal','NonREM','Intermediate','REM','Wake'};
% writetable(RGS14,filename,'Sheet','RGS14')
% 
% Vehicle=array2table([Unit_Count_Veh Pyr_Veh_Unit_Wise_Data]);
% Vehicle.Properties.VariableNames={'Index','Quiet Wake','Microarousal','NonREM','Intermediate','REM','Wake'};
% writetable(Vehicle,filename,'Sheet','Vehicle')

% %% Writing Normalized Data
% % Acquiring data for the plots
% [~, Pyr_RGS_Unit_Wise_Data, ~,~]=FR_Analysis(Pyr_RGS,'norm');
% [ ~, Pyr_Veh_Unit_Wise_Data, ~]=FR_Analysis(Pyr_Veh,'norm');
% 
% %% Writing Data to Excel Sheet
% filename='Unit_Wise_Data_Both_Treatments.xlsx';
% Unit_Count_RGS14=[]; 
% for i=1:size(Pyr_RGS_Unit_Wise_Data,1)
%     Unit_Count_RGS14=[Unit_Count_RGS14;i];
% end   
% 
% Unit_Count_Veh=[];
% for i=1:size(Pyr_Veh_Unit_Wise_Data,1)
%     Unit_Count_Veh=[Unit_Count_Veh;i];
% end 
% 
% RGS14=array2table([Unit_Count_RGS14   Pyr_RGS_Unit_Wise_Data]);
% RGS14.Properties.VariableNames={'Index','Quiet Wake','Microarousal','NonREM','Intermediate','REM','Wake'};
% writetable(RGS14,filename,'Sheet','RGS14_Norm')
% 
% Vehicle=array2table([Unit_Count_Veh Pyr_Veh_Unit_Wise_Data]);
% Vehicle.Properties.VariableNames={'Index','Quiet Wake','Microarousal','NonREM','Intermediate','REM','Wake'};
% writetable(Vehicle,filename,'Sheet','Vehicle_Norm')



%% Outlier check
%Rest Periods
Temp_Data_PT_RGS=[Pyr_RGS_RP_Data.PT_Temp_Data];
% Temp_Data_PT_Veh=[Pyr_Veh_RP_Data.PT_Temp_Data];
title_heading={'Quiet Wake ','Microarousal ','NREM ','Intermediate ', 'REM '};

for i=1:size(Temp_Data_PT_RGS,2)
    Sleep_State_rgs=Temp_Data_PT_RGS{i};
%     Sleep_State_veh=Temp_Data_PT_Veh{i};
    subplot(2,3,i)
    
    for j=1:size(Sleep_State_rgs,2)
    hold on;
    end

    imagesc(Sleep_State_rgs(:,j))
%     imagesc(Sleep_State_veh(:,j))
    colormap(jet)
    a=colorbar();
    
    a.Label.String = 'Firing Rate(Hz)';
    caxis([0 350])
%     ylim([0 400])
    ylabel('Neuron Index')
%     ylabel('Average Firing Rate')
    title(strcat('RGS: ',title_heading{i}))
%     legend('RGS14','Vehicle','Location','northwest')
    hold off;
end


%% Plotting Data

figure(1)
dataLabels = {'Quiet Wake', 'Microarousal', 'NREM', 'Intermediate', 'REM'};

%% Swarm Charts ALL (per unit activity) %% Modify according to what Lisa said (Wake, NREM - NREM, REM- REM)
%RGS
figure(20)
plotSpread(Pyr_RGS_Unit_Wise_Data,'xNames',{'QW','MA','NREM','InterM','REM','Wake'},'distributionColors',{'r','g','b','y','c',[0.3 0.2 0.5]},'yLabel','Firing Rate Across Study Day')
title('FR vs Sleep Stages: Swarm Plot-RGS14')
ylim([0 10])

% %Vehicle
% plotSpread(Pyr_Veh_Unit_Wise_Data,'xNames',{'QW','MA','NREM','InterM','REM','Wake'},'distributionColors',{'r','g','b','y','c',[0.3 0.2 0.5]},'yLabel','Firing Rate Across Study Day')
% title('FR vs Sleep Stages: Swarm Plot- Vehicle')
% ylim([0 10])


%% Scatter Line (Wake to NREM veh)
Units_NREM_Veh_Less_Than_Names=[]; Units_NREM_Veh_Less_Than_Data=[];

Units_NREM_Veh_More_T1_Than_Names=[];Units_NREM_Veh_More_Than_T1_Data=[];

Units_NREM_Veh_More_T2_Than_Names=[];Units_NREM_Veh_More_Than_T2_Data=[];

Units_NREM_Veh_More_T3_Than_Names=[];Units_NREM_Veh_More_Than_T3_Data=[];

Units_NREM_Veh_More_T4_Than_Names=[];Units_NREM_Veh_More_Than_T4_Data=[];
Wake_Veh=Pyr_Veh_Unit_Wise_Data(:,6);

%% Deciding Threshold Points
threshold_vec=quantile(Wake_Veh,[0.2 0.4 0.6 0.8]);



for ii=1:size(Wake_Veh,1)
    
    if Wake_Veh(ii)<=threshold_vec(1)
        Units_NREM_Veh_Less_Than_Data=[Units_NREM_Veh_Less_Than_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_NREM_Veh_Less_Than_Names=[Units_NREM_Veh_Less_Than_Names; Pyr_Veh(ii)];
        
    elseif (Wake_Veh(ii)>threshold_vec(1)) && (Wake_Veh(ii)<=threshold_vec(2))
        Units_NREM_Veh_More_Than_T1_Data=[Units_NREM_Veh_More_Than_T1_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_NREM_Veh_More_T1_Than_Names=[Units_NREM_Veh_More_T1_Than_Names; Pyr_Veh(ii)];
    
    elseif (Wake_Veh(ii)>threshold_vec(2)) && (Wake_Veh(ii)<=threshold_vec(3))
        Units_NREM_Veh_More_Than_T2_Data=[Units_NREM_Veh_More_Than_T2_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_NREM_Veh_More_T2_Than_Names=[Units_NREM_Veh_More_T2_Than_Names; Pyr_Veh(ii)]; 
        
    elseif (Wake_Veh(ii)>threshold_vec(3)) && (Wake_Veh(ii)<threshold_vec(4))
        Units_NREM_Veh_More_Than_T3_Data=[Units_NREM_Veh_More_Than_T3_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_NREM_Veh_More_T3_Than_Names=[Units_NREM_Veh_More_T3_Than_Names; Pyr_Veh(ii)];  
        
    elseif Wake_Veh(ii)>threshold_vec(4)
        Units_NREM_Veh_More_Than_T4_Data=[Units_NREM_Veh_More_Than_T4_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_NREM_Veh_More_T4_Than_Names=[Units_NREM_Veh_More_T4_Than_Names; Pyr_Veh(ii)];        
     
    end
    
    
end



%% Plotting Segregated Data <20% (Veh)
fh1=figure('Name','Veh <20%')
NREM_Veh=Units_NREM_Veh_Less_Than_Data(:,3);
wake_Veh=Units_NREM_Veh_Less_Than_Data(:,6);
[~,p_Veh_value_lesser]=kstest2(NREM_Veh,wake_Veh);
x=nan(size(NREM_Veh,1),1);
both=[NREM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: NREM to Wake- Wake FR <%f \n p value:%d \n range:0-20 percent',threshold_vec(1),p_Veh_value_lesser))

NREM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(NREM_Veh_jitter, 1)
  plot([NREM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[NREM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting Segregated Data 20-40 %(Veh)
figure('Name','Veh =20-40%')
NREM_Veh=Units_NREM_Veh_More_Than_T1_Data(:,3);
wake_Veh=Units_NREM_Veh_More_Than_T1_Data(:,6);
[~,p_Veh_value_greater_T1]=kstest2(NREM_Veh,wake_Veh);

x=nan(size(NREM_Veh,1),1);
both=[NREM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: NREM to Wake- Wake FR <%f \n p value:%d \n range:20-40 percent',threshold_vec(2),p_Veh_value_greater_T1))

NREM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(NREM_Veh_jitter, 1)
  plot([NREM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[NREM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end


%% Plotting Veh Data 40-60%
figure('Name','Veh 40-60%')
NREM_Veh=Units_NREM_Veh_More_Than_T2_Data(:,3);
wake_Veh=Units_NREM_Veh_More_Than_T2_Data(:,6);
[~,p_Veh_value_greater_T2]=kstest2(NREM_Veh,wake_Veh);

x=nan(size(NREM_Veh,1),1);
both=[NREM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: NREM to Wake- Wake FR <%f  \n p value:%d \n range:40-60 percent',threshold_vec(3),p_Veh_value_greater_T2))

NREM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(NREM_Veh_jitter, 1)
  plot([NREM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[NREM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end


%% Plotting Veh Data 60-80%
figure('Name','Veh 60-80%')
NREM_Veh=Units_NREM_Veh_More_Than_T3_Data(:,3);
wake_Veh=Units_NREM_Veh_More_Than_T3_Data(:,6);
[~,p_Veh_value_greater_T3]=kstest2(NREM_Veh,wake_Veh);

x=nan(size(NREM_Veh,1),1);
both=[NREM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: NREM to Wake- Wake FR <%f \n p value:%d \n range:60-80 percent',threshold_vec(4),p_Veh_value_greater_T3))

NREM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(NREM_Veh_jitter, 1)
  plot([NREM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[NREM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting Veh Data >80%
figure('Name','Veh >80%')
NREM_Veh=Units_NREM_Veh_More_Than_T4_Data(:,3);
wake_Veh=Units_NREM_Veh_More_Than_T4_Data(:,6);
[~,p_Veh_value_greater_T4]=kstest2(NREM_Veh,wake_Veh);

x=nan(size(NREM_Veh,1),1);
both=[NREM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: NREM to Wake- Wake FR >%f  \n p value:%d \n range:80-100 percent',threshold_vec(4),p_Veh_value_greater_T4))

NREM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(NREM_Veh_jitter, 1)
  plot([NREM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[NREM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Combined Plots
% Veh_Data_Combined={Units_NREM_Veh_Less_Than_Data(:,6),Units_NREM_Veh_Less_Than_Data(:,3),...
%     Units_NREM_Veh_More_Than_T1_Data(:,6),Units_NREM_Veh_More_Than_T1_Data(:,3),...
%     Units_NREM_Veh_More_Than_T2_Data(:,6),Units_NREM_Veh_More_Than_T2_Data(:,3),...
%     Units_NREM_Veh_More_Than_T3_Data(:,6),Units_NREM_Veh_More_Than_T3_Data(:,3),...
%     Units_NREM_Veh_More_Than_T4_Data(:,6),Units_NREM_Veh_More_Than_T4_Data(:,3)};

% [~,Jitter_Data_Points_Veh_Combined]=plotSpread(Veh_Data_Combined,'xNames',{'Wake','NREM','Wake','NREM','Wake','NREM','Wake','NREM','Wake','NREM'},...
%     'distributionColors',{[0 0 1],'c',[0 0 1],'c',[0 0 1],'c',[0 0 1],'c',[0 0 1],'c'},'yLabel','Firing Rate Across Study Day');
% xlabel('Wake to NREM Transition in Vehicle Groups')
% title('Wake to NREM: Vehicle')

Veh_Data_Combined_Wake=vertcat(Units_NREM_Veh_Less_Than_Data(:,6),Units_NREM_Veh_More_Than_T1_Data(:,6),Units_NREM_Veh_More_Than_T2_Data(:,6),...
    Units_NREM_Veh_More_Than_T3_Data(:,6));%,Units_NREM_Veh_More_Than_T4_Data(:,6));

Veh_Data_Combined_NREM=vertcat(Units_NREM_Veh_Less_Than_Data(:,3),Units_NREM_Veh_More_Than_T1_Data(:,3),Units_NREM_Veh_More_Than_T2_Data(:,3),...
    Units_NREM_Veh_More_Than_T3_Data(:,3));%,Units_NREM_Veh_More_Than_T4_Data(:,3));

Veh_Data_Combined_Vertcat={Veh_Data_Combined_Wake,Veh_Data_Combined_NREM};


figure('Name','Vehicle Combined')
[~,Jitter_Data_Points_Veh_Combined_Vertcat]=plotSpread(Veh_Data_Combined_Vertcat,'xNames',{'Wake','NREM'},'distributionColors',{[0 0 1],'c'},'yLabel','Firing Rate Across Study Day');
xlabel('Wake to NREM Transition in Vehicle Groups')


%Connecting Lines
data_1_Jitter=Jitter_Data_Points_Veh_Combined_Vertcat{1};
data_2_Jitter=Jitter_Data_Points_Veh_Combined_Vertcat{2};
[~,ks_veh_pval]=kstest2(Veh_Data_Combined_Wake,Veh_Data_Combined_NREM);

for ii=1:size(data_1_Jitter,1)
    
    if ii<=12
        
        u=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'rs-', 'MarkerSize', 15);
        hold on
        
    elseif (ii>12 && ii<=24)
        x=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'gs-', 'MarkerSize', 15);
        hold on
        
   elseif (ii>24 && ii<=37)
        y=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'ys-', 'MarkerSize', 15);
        hold on  
        
    elseif (ii>37 && ii<=59)
        z=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'ks-', 'MarkerSize', 15);
        hold on
        
%     elseif ii>59 && ii<=59
%         plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
%             'bs-', 'MarkerSize', 5);
%         hold on
        
        
    
    end    
    
end
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'r');
h(2) = plot(NaN,NaN,'g');
h(3) = plot(NaN,NaN,'y');
h(4) = plot(NaN,NaN,'k');

title(sprintf('Wake to NREM: Vehicle \n pval:%f',ks_veh_pval))
legend(h,'0-20%','20-40%','40-60%','60-80%');

%% Scatter Line (Wake to NREM RGS)
% figure('Name','RGS NREM Line scatter plot')
% NREM_RGS=Pyr_RGS_Unit_Wise_Data(:,3);
% wake_RGS=Pyr_RGS_Unit_Wise_Data(:,6);
% x=nan(87,1);
% both=[NREM_RGS x wake_RGS];
% [~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');
% 
% title('RGS14: NREM to Wake')
% ylim([0 80])
% 
% NREM_RGS_jitter=Jitter_Data_Points_RGS{1};
% wake_RGS_jitter=Jitter_Data_Points_RGS{3};
% 
% for k = 1 : size(NREM_RGS_jitter, 1)
%   plot([NREM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[NREM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
%     'rs-', 'MarkerSize', 5);
%   hold on
% end

%% Segregating rgs units less and more than 1.5 Hz
Units_NREM_RGS_Less_Than_Names=[]; Units_NREM_RGS_Less_Than_Data=[];

Units_NREM_RGS_More_T1_Than_Names=[];Units_NREM_RGS_More_Than_T1_Data=[];

Units_NREM_RGS_More_T2_Than_Names=[];Units_NREM_RGS_More_Than_T2_Data=[];

Units_NREM_RGS_More_T3_Than_Names=[];Units_NREM_RGS_More_Than_T3_Data=[];

Units_NREM_RGS_More_T4_Than_Names=[];Units_NREM_RGS_More_Than_T4_Data=[];

Wake_RGS=Pyr_RGS_Unit_Wise_Data(:,6);


for ii=1:size(Wake_RGS,1)
    
    if Wake_RGS(ii)<=threshold_vec(1)
        Units_NREM_RGS_Less_Than_Data=[Units_NREM_RGS_Less_Than_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_NREM_RGS_Less_Than_Names=[Units_NREM_RGS_Less_Than_Names; Pyr_RGS(ii)];
        
    elseif (Wake_RGS(ii)>threshold_vec(1)) && (Wake_RGS(ii)<=threshold_vec(2))
        Units_NREM_RGS_More_Than_T1_Data=[Units_NREM_RGS_More_Than_T1_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_NREM_RGS_More_T1_Than_Names=[Units_NREM_RGS_More_T1_Than_Names; Pyr_RGS(ii)];
    
    elseif (Wake_RGS(ii)>threshold_vec(2)) && (Wake_RGS(ii)<=threshold_vec(3))
        Units_NREM_RGS_More_Than_T2_Data=[Units_NREM_RGS_More_Than_T2_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_NREM_RGS_More_T2_Than_Names=[Units_NREM_RGS_More_T2_Than_Names; Pyr_RGS(ii)]; 
        
    elseif (Wake_RGS(ii)>threshold_vec(3)) && (Wake_RGS(ii)<threshold_vec(4))
        Units_NREM_RGS_More_Than_T3_Data=[Units_NREM_RGS_More_Than_T3_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_NREM_RGS_More_T3_Than_Names=[Units_NREM_RGS_More_T3_Than_Names; Pyr_RGS(ii)];  
        
    elseif Wake_RGS(ii)>threshold_vec(4)
        Units_NREM_RGS_More_Than_T4_Data=[Units_NREM_RGS_More_Than_T4_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_NREM_RGS_More_T4_Than_Names=[Units_NREM_RGS_More_T4_Than_Names; Pyr_RGS(ii)];        
     
    end
    
    
end



%% Plotting Segregated Data <20% (RGS)
figure('Name','RGS <20%')
NREM_RGS=Units_NREM_RGS_Less_Than_Data(:,3);
wake_RGS=Units_NREM_RGS_Less_Than_Data(:,6);
[~,p_RGS_value_lesser]=kstest2(NREM_RGS,wake_RGS);
x=nan(size(NREM_RGS,1),1);
both=[NREM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: NREM to Wake- Wake FR < %d \n p value:%d \n range:0-20 percent',threshold_vec(1),p_RGS_value_lesser))

NREM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(NREM_RGS_jitter, 1)
  plot([NREM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[NREM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting Segregated Data 20-40 %(RGS)
figure('Name','RGS =20-40%')
NREM_RGS=Units_NREM_RGS_More_Than_T1_Data(:,3);
wake_RGS=Units_NREM_RGS_More_Than_T1_Data(:,6);
[~,p_RGS_value_greater_T1]=kstest2(NREM_RGS,wake_RGS);

x=nan(size(NREM_RGS,1),1);
both=[NREM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: NREM to Wake- Wake FR <%f \n p value:%d \n range:20-40 percent',threshold_vec(2),p_RGS_value_greater_T1))

NREM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(NREM_RGS_jitter, 1)
  plot([NREM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[NREM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting RGS Data 40-60%
figure('Name','RGS 40-60%')
NREM_RGS=Units_NREM_RGS_More_Than_T2_Data(:,3);
wake_RGS=Units_NREM_RGS_More_Than_T2_Data(:,6);
[~,p_RGS_value_greater_T2]=kstest2(NREM_RGS,wake_RGS);

x=nan(size(NREM_RGS,1),1);
both=[NREM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: NREM to Wake- Wake FR <%f \n p value:%d \n range:40-60 percent',threshold_vec(3),p_RGS_value_greater_T2))

NREM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(NREM_RGS_jitter, 1)
  plot([NREM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[NREM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end


%% Plotting RGS Data 60-80%
figure('Name','RGS 60-80%')
NREM_RGS=Units_NREM_RGS_More_Than_T3_Data(:,3);
wake_RGS=Units_NREM_RGS_More_Than_T3_Data(:,6);
[~,p_RGS_value_greater_T3]=kstest2(NREM_RGS,wake_RGS);

x=nan(size(NREM_RGS,1),1);
both=[NREM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: NREM to Wake- Wake FR <%f \n p value:%d \n range:60-80 percent',threshold_vec(4),p_RGS_value_greater_T3))

NREM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(NREM_RGS_jitter, 1)
  plot([NREM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[NREM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting RGS Data >80%
figure('Name','RGS >80%')
NREM_RGS=Units_NREM_RGS_More_Than_T4_Data(:,3);
wake_RGS=Units_NREM_RGS_More_Than_T4_Data(:,6);
[~,p_RGS_value_greater_T4]=kstest2(NREM_RGS,wake_RGS);

x=nan(size(NREM_RGS,1),1);
both=[NREM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'NREM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: NREM to Wake- Wake FR >%f \n p value:%d \n range:80-100 percent',threshold_vec(4),p_RGS_value_greater_T4))

NREM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(NREM_RGS_jitter, 1)
  plot([NREM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[NREM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% RGS NREM to Wake Combined PLots
figure('Name','RGS Wake to NREM Combined Plot')
RGS_Data_Combined_Wake=vertcat(Units_NREM_RGS_Less_Than_Data(:,6),Units_NREM_RGS_More_Than_T1_Data(:,6),Units_NREM_RGS_More_Than_T2_Data(:,6),...
    Units_NREM_RGS_More_Than_T3_Data(:,6));%,Units_NREM_RGS_More_Than_T4_Data(:,6));

RGS_Data_Combined_NREM=vertcat(Units_NREM_RGS_Less_Than_Data(:,3),Units_NREM_RGS_More_Than_T1_Data(:,3),Units_NREM_RGS_More_Than_T2_Data(:,3),...
    Units_NREM_RGS_More_Than_T3_Data(:,3));%,Units_NREM_RGS_More_Than_T4_Data(:,3));

RGS_Data_Combined_Vertcat={RGS_Data_Combined_Wake,RGS_Data_Combined_NREM};


[~,Jitter_Data_Points_RGS_Combined_Vertcat]=plotSpread(RGS_Data_Combined_Vertcat,'xNames',{'Wake','NREM'},'distributionColors',{[0 0 1],'c'},'yLabel','Firing Rate Across Study Day');
xlabel('Wake to NREM Transition in RGS14 Groups')


%Connecting Lines
data_1_Jitter=Jitter_Data_Points_RGS_Combined_Vertcat{1};
data_2_Jitter=Jitter_Data_Points_RGS_Combined_Vertcat{2};
[~,ks_rgs_pval]=kstest2(RGS_Data_Combined_Wake,RGS_Data_Combined_NREM);

for ii=1:size(data_1_Jitter,1)
    
    if ii<=size(Units_NREM_RGS_Less_Than_Data,1)
        
        u=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'rs-', 'MarkerSize', 15);
        hold on
        
    elseif (ii>41 && ii<=62)
        x=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'gs-', 'MarkerSize', 15);
        hold on
        
   elseif (ii>62 && ii<=69)
        y=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'ys-', 'MarkerSize', 15);
        hold on  
        
    elseif (ii>69 && ii<=76)
        z=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'ks-', 'MarkerSize', 15);
        hold on
        
%     elseif ii>59 && ii<=59
%         plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
%             'bs-', 'MarkerSize', 5);
%         hold on
        
        
    
    end    
    
end
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'r');
h(2) = plot(NaN,NaN,'g');
h(3) = plot(NaN,NaN,'y');
h(4) = plot(NaN,NaN,'k');

title(sprintf('Wake to NREM: RGS14 \n pval:%f',ks_rgs_pval))
legend(h,'0-20%','20-40%','40-60%','60-80%');
ylim([0 8])

%% Unit Distribution Pie Chart
figure('Name','Unit Distribution')

subplot(1,2,1)
rgs=pie([size(Units_NREM_RGS_Less_Than_Names,1),size(Units_NREM_RGS_More_T1_Than_Names,1),size(Units_NREM_RGS_More_T2_Than_Names,1),size(Units_NREM_RGS_More_T3_Than_Names,1),size(Units_NREM_RGS_More_T4_Than_Names,1)]);
legend('0-20 percent','20-40 percent','40-60 percent','60-80 percent','80-100 percent','Location',"northeastoutside")
title(sprintf('RGS14 Unit Distribution \n Total Units: %d',size(Pyr_RGS,1)))

%setting colors
patchHand = findobj(rgs, 'Type', 'Patch');
patchHand(1).FaceColor = 'r';
patchHand(2).FaceColor = 'g';
patchHand(3).FaceColor = 'y';
patchHand(4).FaceColor = 'k';
patchHand(5).FaceColor = 'b';


subplot(1,2,2)
veh=pie([size(Units_NREM_Veh_Less_Than_Names,1),size(Units_NREM_Veh_More_T1_Than_Names,1),size(Units_NREM_Veh_More_T2_Than_Names,1),...
    size(Units_NREM_Veh_More_T3_Than_Names,1),size(Units_NREM_Veh_More_T4_Than_Names,1)],'%.3f%%');
legend('0-20 percent','20-40 percent','40-60 percent','60-80 percent','80-100 percent','Location',"northeastoutside")
title(sprintf('Vehicle Unit Distribution \n Total Units:%d',size(Pyr_Veh,1)))

%setting colors
patchHand = findobj(veh, 'Type', 'Patch');
patchHand(1).FaceColor = 'r';
patchHand(2).FaceColor = 'g';
patchHand(3).FaceColor = 'y';
patchHand(4).FaceColor = 'k';
patchHand(5).FaceColor = 'b';



%% Scatter Line (Wake to REM veh)

Units_REM_Veh_Less_Than_Names=[]; Units_REM_Veh_Less_Than_Data=[];

Units_REM_Veh_More_T1_Than_Names=[];Units_REM_Veh_More_Than_T1_Data=[];

Units_REM_Veh_More_T2_Than_Names=[];Units_REM_Veh_More_Than_T2_Data=[];

Units_REM_Veh_More_T3_Than_Names=[];Units_REM_Veh_More_Than_T3_Data=[];

Units_REM_Veh_More_T4_Than_Names=[];Units_REM_Veh_More_Than_T4_Data=[];
Wake_Veh=Pyr_Veh_Unit_Wise_Data(:,6);
 

for ii=1:size(Wake_Veh,1)
    
    if Wake_Veh(ii)<=threshold_vec(1)
        Units_REM_Veh_Less_Than_Data=[Units_REM_Veh_Less_Than_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_REM_Veh_Less_Than_Names=[Units_REM_Veh_Less_Than_Names; Pyr_Veh(ii)];
        
    elseif (Wake_Veh(ii)>threshold_vec(1)) && (Wake_Veh(ii)<=threshold_vec(2))
        Units_REM_Veh_More_Than_T1_Data=[Units_REM_Veh_More_Than_T1_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_REM_Veh_More_T1_Than_Names=[Units_REM_Veh_More_T1_Than_Names; Pyr_Veh(ii)];
    
    elseif (Wake_Veh(ii)>threshold_vec(2)) && (Wake_Veh(ii)<=threshold_vec(3))
        Units_REM_Veh_More_Than_T2_Data=[Units_REM_Veh_More_Than_T2_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_REM_Veh_More_T2_Than_Names=[Units_REM_Veh_More_T2_Than_Names; Pyr_Veh(ii)]; 
        
    elseif (Wake_Veh(ii)>threshold_vec(3)) && (Wake_Veh(ii)<threshold_vec(4))
        Units_REM_Veh_More_Than_T3_Data=[Units_REM_Veh_More_Than_T3_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_REM_Veh_More_T3_Than_Names=[Units_REM_Veh_More_T3_Than_Names; Pyr_Veh(ii)];  
        
    elseif Wake_Veh(ii)>threshold_vec(4)
        Units_REM_Veh_More_Than_T4_Data=[Units_REM_Veh_More_Than_T4_Data; Pyr_Veh_Unit_Wise_Data(ii,:)];
        Units_REM_Veh_More_T4_Than_Names=[Units_REM_Veh_More_T4_Than_Names; Pyr_Veh(ii)];        
     
    end
    
    
end



%% Plotting Segregated Data <20% (Veh)
figure('Name','Veh <20%')
REM_Veh=Units_REM_Veh_Less_Than_Data(:,5);
wake_Veh=Units_REM_Veh_Less_Than_Data(:,6);
[~,p_Veh_value_lesser]=kstest2(REM_Veh,wake_Veh);
x=nan(size(REM_Veh,1),1);
both=[REM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: REM to Wake- Wake FR <%f \n p value:%d',threshold_vec(1),p_Veh_value_lesser))

REM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(REM_Veh_jitter, 1)
  plot([REM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[REM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting Segregated Data 20-40 %(Veh)
figure('Name','Veh =20-40%')
REM_Veh=Units_REM_Veh_More_Than_T1_Data(:,5);
wake_Veh=Units_REM_Veh_More_Than_T1_Data(:,6);
[~,p_Veh_value_greater_T1]=kstest2(REM_Veh,wake_Veh);

x=nan(size(REM_Veh,1),1);
both=[REM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: REM to Wake- Wake FR <%f \n p value:%d',threshold_vec(2),p_Veh_value_greater_T1))

REM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(REM_Veh_jitter, 1)
  plot([REM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[REM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting Veh Data 40-60%
figure('Name','Veh 40-60%')
REM_Veh=Units_REM_Veh_More_Than_T2_Data(:,5);
wake_Veh=Units_REM_Veh_More_Than_T2_Data(:,6);
[~,p_Veh_value_greater_T2]=kstest2(REM_Veh,wake_Veh);

x=nan(size(REM_Veh,1),1);
both=[REM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: REM to Wake- Wake FR <%f \n p value:%d',threshold_vec(3),p_Veh_value_greater_T2))

REM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(REM_Veh_jitter, 1)
  plot([REM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[REM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end


%% Plotting Veh Data 60-80%
figure('Name','Veh 60-80%')
REM_Veh=Units_REM_Veh_More_Than_T3_Data(:,5);
wake_Veh=Units_REM_Veh_More_Than_T3_Data(:,6);
[~,p_Veh_value_greater_T3]=kstest2(REM_Veh,wake_Veh);

x=nan(size(REM_Veh,1),1);
both=[REM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: REM to Wake- Wake FR <%f \n p value:%d',threshold_vec(4),p_Veh_value_greater_T3))

REM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(REM_Veh_jitter, 1)
  plot([REM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[REM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting Veh Data >80%
figure('Name','Veh >80%')
REM_Veh=Units_REM_Veh_More_Than_T4_Data(:,5);
wake_Veh=Units_REM_Veh_More_Than_T4_Data(:,6);
[~,p_Veh_value_greater_T4]=kstest2(REM_Veh,wake_Veh);

x=nan(size(REM_Veh,1),1);
both=[REM_Veh x wake_Veh];
[~,Jitter_Data_Points_Veh]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('Veh: REM to Wake- Wake FR >%d \n p value:%d',threshold_vec(4),p_Veh_value_greater_T4))

REM_Veh_jitter=Jitter_Data_Points_Veh{1};
wake_Veh_jitter=Jitter_Data_Points_Veh{3};

for k = 1 : size(REM_Veh_jitter, 1)
  plot([REM_Veh_jitter(k,1), wake_Veh_jitter(k,1)],[REM_Veh_jitter(k,2), wake_Veh_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end



%% Combined Plots Vehicle Wake to REM
% Veh_Data_Combined={Units_NREM_Veh_Less_Than_Data(:,6),Units_NREM_Veh_Less_Than_Data(:,3),...
%     Units_NREM_Veh_More_Than_T1_Data(:,6),Units_NREM_Veh_More_Than_T1_Data(:,3),...
%     Units_NREM_Veh_More_Than_T2_Data(:,6),Units_NREM_Veh_More_Than_T2_Data(:,3),...
%     Units_NREM_Veh_More_Than_T3_Data(:,6),Units_NREM_Veh_More_Than_T3_Data(:,3),...
%     Units_NREM_Veh_More_Than_T4_Data(:,6),Units_NREM_Veh_More_Than_T4_Data(:,3)};

% [~,Jitter_Data_Points_Veh_Combined]=plotSpread(Veh_Data_Combined,'xNames',{'Wake','NREM','Wake','NREM','Wake','NREM','Wake','NREM','Wake','NREM'},...
%     'distributionColors',{[0 0 1],'c',[0 0 1],'c',[0 0 1],'c',[0 0 1],'c',[0 0 1],'c'},'yLabel','Firing Rate Across Study Day');
% xlabel('Wake to NREM Transition in Vehicle Groups')
% title('Wake to NREM: Vehicle')

Veh_Data_Combined_Wake=vertcat(Units_REM_Veh_Less_Than_Data(:,6),Units_REM_Veh_More_Than_T1_Data(:,6),Units_REM_Veh_More_Than_T2_Data(:,6),...
    Units_REM_Veh_More_Than_T3_Data(:,6));%,Units_REM_Veh_More_Than_T4_Data(:,6));

Veh_Data_Combined_REM=vertcat(Units_REM_Veh_Less_Than_Data(:,5),Units_REM_Veh_More_Than_T1_Data(:,5),Units_REM_Veh_More_Than_T2_Data(:,5),...
    Units_REM_Veh_More_Than_T3_Data(:,5));%,Units_REM_Veh_More_Than_T4_Data(:,3));

Veh_Data_Combined_Vertcat={Veh_Data_Combined_Wake,Veh_Data_Combined_REM};


figure('Name','Vehicle Combined Wake to REM')
[~,Jitter_Data_Points_Veh_Combined_Vertcat]=plotSpread(Veh_Data_Combined_Vertcat,'xNames',{'Wake','REM'},'distributionColors',{[0 0 1],'c'},'yLabel','Firing Rate Across Study Day');
xlabel('Wake to REM Transition in Vehicle Groups')


%Connecting Lines
data_1_Jitter=Jitter_Data_Points_Veh_Combined_Vertcat{1};
data_2_Jitter=Jitter_Data_Points_Veh_Combined_Vertcat{2};
[~,ks_veh_pval]=kstest2(Veh_Data_Combined_Wake,Veh_Data_Combined_REM);

for ii=1:size(data_1_Jitter,1)
    
    if ii<=12
        
        u=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'rs-', 'MarkerSize', 15);
        hold on
        
    elseif (ii>12 && ii<=24)
        x=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'gs-', 'MarkerSize', 15);
        hold on
        
   elseif (ii>24 && ii<=37)
        y=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'ys-', 'MarkerSize', 15);
        hold on  
        
    elseif (ii>37 && ii<=59)
        z=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'ks-', 'MarkerSize', 15);
        hold on
        
%     elseif ii>59 && ii<=59
%         plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
%             'bs-', 'MarkerSize', 5);
%         hold on
        
        
    
    end    
    
end
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'r');
h(2) = plot(NaN,NaN,'g');
h(3) = plot(NaN,NaN,'y');
h(4) = plot(NaN,NaN,'k');
title(sprintf('Wake to REM: Vehicle \n pval:%f',ks_veh_pval))
legend(h,'0-20%','20-40%','40-60%','60-80%');
ylim([0 8])


%% Scatter line REM to Wake (RGS14)

Units_REM_RGS_Less_Than_Names=[]; Units_REM_RGS_Less_Than_Data=[];

Units_REM_RGS_More_T1_Than_Names=[];Units_REM_RGS_More_Than_T1_Data=[];

Units_REM_RGS_More_T2_Than_Names=[];Units_REM_RGS_More_Than_T2_Data=[];

Units_REM_RGS_More_T3_Than_Names=[];Units_REM_RGS_More_Than_T3_Data=[];

Units_REM_RGS_More_T4_Than_Names=[];Units_REM_RGS_More_Than_T4_Data=[];
Wake_RGS=Pyr_RGS_Unit_Wise_Data(:,6);
 

for ii=1:size(Wake_RGS,1)
    
    if Wake_RGS(ii)<=threshold_vec(1)
        Units_REM_RGS_Less_Than_Data=[Units_REM_RGS_Less_Than_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_REM_RGS_Less_Than_Names=[Units_REM_RGS_Less_Than_Names; Pyr_RGS(ii)];
        
    elseif (Wake_RGS(ii)>threshold_vec(1)) && (Wake_RGS(ii)<=threshold_vec(2))
        Units_REM_RGS_More_Than_T1_Data=[Units_REM_RGS_More_Than_T1_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_REM_RGS_More_T1_Than_Names=[Units_REM_RGS_More_T1_Than_Names; Pyr_RGS(ii)];
    
    elseif (Wake_RGS(ii)>threshold_vec(2)) && (Wake_RGS(ii)<=threshold_vec(3))
        Units_REM_RGS_More_Than_T2_Data=[Units_REM_RGS_More_Than_T2_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_REM_RGS_More_T2_Than_Names=[Units_REM_RGS_More_T2_Than_Names; Pyr_RGS(ii)]; 
        
    elseif (Wake_RGS(ii)>threshold_vec(3)) && (Wake_RGS(ii)<threshold_vec(4))
        Units_REM_RGS_More_Than_T3_Data=[Units_REM_RGS_More_Than_T3_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_REM_RGS_More_T3_Than_Names=[Units_REM_RGS_More_T3_Than_Names; Pyr_RGS(ii)];  
        
    elseif Wake_RGS(ii)>threshold_vec(4)
        Units_REM_RGS_More_Than_T4_Data=[Units_REM_RGS_More_Than_T4_Data; Pyr_RGS_Unit_Wise_Data(ii,:)];
        Units_REM_RGS_More_T4_Than_Names=[Units_REM_RGS_More_T4_Than_Names; Pyr_RGS(ii)];        
     
    end
    
    
end



%% Plotting Segregated Data <20% (RGS)
figure('Name','RGS <20%')
REM_RGS=Units_REM_RGS_Less_Than_Data(:,5);
wake_RGS=Units_REM_RGS_Less_Than_Data(:,6);
[~,p_RGS_value_lesser]=kstest2(REM_RGS,wake_RGS);
x=nan(size(REM_RGS,1),1);
both=[REM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: REM to Wake- Wake FR <%f \n p value:%d',threshold_vec(1),p_RGS_value_lesser))

REM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(REM_RGS_jitter, 1)
  plot([REM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[REM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting Segregated Data 20-40 %(RGS)
figure('Name','RGS =20-40%')
REM_RGS=Units_REM_RGS_More_Than_T1_Data(:,5);
wake_RGS=Units_REM_RGS_More_Than_T1_Data(:,6);
[~,p_RGS_value_greater_T1]=kstest2(REM_RGS,wake_RGS);

x=nan(size(REM_RGS,1),1);
both=[REM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: REM to Wake- Wake FR <%f \n p value:%d',threshold_vec(2),p_RGS_value_greater_T1))

REM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(REM_RGS_jitter, 1)
  plot([REM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[REM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting RGS Data 40-60%
figure('Name','RGS 40-60%')
REM_RGS=Units_REM_RGS_More_Than_T2_Data(:,5);
wake_RGS=Units_REM_RGS_More_Than_T2_Data(:,6);
[~,p_RGS_value_greater_T2]=kstest2(REM_RGS,wake_RGS);

x=nan(size(REM_RGS,1),1);
both=[REM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: REM to Wake- Wake FR <%f \n p value:%d',threshold_vec(3),p_RGS_value_greater_T2))

REM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(REM_RGS_jitter, 1)
  plot([REM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[REM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end


%% Plotting RGS Data 60-80%
figure('Name','RGS 60-80%')
REM_RGS=Units_REM_RGS_More_Than_T3_Data(:,5);
wake_RGS=Units_REM_RGS_More_Than_T3_Data(:,6);
[~,p_RGS_value_greater_T3]=kstest2(REM_RGS,wake_RGS);

x=nan(size(REM_RGS,1),1);
both=[REM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: REM to Wake- Wake FR <%f \n p value:%d',threshold_vec(4),p_RGS_value_greater_T3))

REM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(REM_RGS_jitter, 1)
  plot([REM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[REM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end

%% Plotting RGS Data >80%
figure('Name','RGS >80%')
REM_RGS=Units_REM_RGS_More_Than_T4_Data(:,5);
wake_RGS=Units_REM_RGS_More_Than_T4_Data(:,6);
[~,p_RGS_value_greater_T4]=kstest2(REM_RGS,wake_RGS);

x=nan(size(REM_RGS,1),1);
both=[REM_RGS x wake_RGS];
[~,Jitter_Data_Points_RGS]=plotSpread(both,'xNames',{'REM','.','Wake'},'distributionColors',{[0 0 1],[1 1 1],'c'},'yLabel','Firing Rate Across Study Day');

title(sprintf('RGS: REM to Wake- Wake FR >%f \n p value:%d',threshold_vec(4),p_RGS_value_greater_T4))


REM_RGS_jitter=Jitter_Data_Points_RGS{1};
wake_RGS_jitter=Jitter_Data_Points_RGS{3};

for k = 1 : size(REM_RGS_jitter, 1)
  plot([REM_RGS_jitter(k,1), wake_RGS_jitter(k,1)],[REM_RGS_jitter(k,2), wake_RGS_jitter(k,2)],...
    'rs-', 'MarkerSize', 5);
  hold on
end



%% RGS REM to Wake Combined Plot
figure('Name','RGS Wake to REM Combined Plot')
RGS_Data_Combined_Wake=vertcat(Units_REM_RGS_Less_Than_Data(:,6),Units_REM_RGS_More_Than_T1_Data(:,6),Units_REM_RGS_More_Than_T2_Data(:,6),...
    Units_REM_RGS_More_Than_T3_Data(:,6));%,Units_REM_RGS_More_Than_T4_Data(:,6));

RGS_Data_Combined_REM=vertcat(Units_REM_RGS_Less_Than_Data(:,5),Units_REM_RGS_More_Than_T1_Data(:,5),Units_REM_RGS_More_Than_T2_Data(:,5),...
    Units_REM_RGS_More_Than_T3_Data(:,5));%,Units_REM_RGS_More_Than_T4_Data(:,3));

RGS_Data_Combined_Vertcat={RGS_Data_Combined_Wake,RGS_Data_Combined_REM};


[~,Jitter_Data_Points_RGS_Combined_Vertcat]=plotSpread(RGS_Data_Combined_Vertcat,'xNames',{'Wake','REM'},'distributionColors',{[0 0 1],'c'},'yLabel','Firing Rate Across Study Day');
xlabel('Wake to REM Transition in RGS14 Groups')


%Connecting Lines
data_1_Jitter=Jitter_Data_Points_RGS_Combined_Vertcat{1};
data_2_Jitter=Jitter_Data_Points_RGS_Combined_Vertcat{2};
[~,ks_rgs_pval]=kstest2(RGS_Data_Combined_Wake,RGS_Data_Combined_REM);

for ii=1:size(data_1_Jitter,1)
    
    if ii<=size(Units_REM_RGS_Less_Than_Data,1)
        
        u=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'rs-', 'MarkerSize', 15);
        hold on
        
    elseif (ii>41 && ii<=62)
        x=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'gs-', 'MarkerSize', 15);
        hold on
        
   elseif (ii>62 && ii<=69)
        y=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'ys-', 'MarkerSize', 15);
        hold on  
        
    elseif (ii>69 && ii<=76)
        z=plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
            'ks-', 'MarkerSize', 15);
        hold on
        
%     elseif ii>59 && ii<=59
%         plot([data_1_Jitter(ii,1), data_2_Jitter(ii,1)],[data_1_Jitter(ii,2), data_2_Jitter(ii,2)],...
%             'bs-', 'MarkerSize', 5);
%         hold on
        
        
    
    end    
    
end
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'r');
h(2) = plot(NaN,NaN,'g');
h(3) = plot(NaN,NaN,'y');
h(4) = plot(NaN,NaN,'k');

title(sprintf('Wake to REM: RGS14 \n pval:%f',ks_rgs_pval))
legend(h,'0-20%','20-40%','40-60%','60-80%');
ylim([0 8])
% Combined_SEM=[QW_SEM; MA_SEM; REM_SEM; Intermediate_SEM; REM_SEM]; 
%% Line Plots

%% General Trend
figure(1)
markercell=[{'square'},{'o'},{'^'},{'*'},{'p'}];
x_axis=categorical([{'PS'},{'PT1'},{'PT2'},{'PT3'},{'PT4'},{'PT5-1'},{'PT5-2'},{'PT5-3'},{'PT5-4'}]);
title_heading={'Quiet Wake ','Microarousal ','NREM ','Intermediate ', 'REM '};
for i=1:size(Pyr_RGS_RP_Data.Post_Trial_Vector,2)
    error_rgs=Pyr_RGS_RP_Data.SEM_PT(:,i);
    error_veh=Pyr_Veh_RP_Data.SEM_PT(:,i);
    subplot(2,3,i)
    hold on;
    
    errorbar(x_axis,Pyr_RGS_RP_Data.Post_Trial_Vector(:,i),error_rgs,'Marker',markercell{i},'MarkerSize',10,'LineWidth',2)
    
    errorbar(x_axis,Pyr_Veh_RP_Data.Post_Trial_Vector(:,i),error_veh,'Marker',markercell{i},'MarkerSize',10,'LineWidth',2)
    yline(1,'k','LineWidth',2)
    ylim([0 4])
   
%     plot(x_axis,Pyr_RGS_RP_Data.Post_Trial_Vector(:,i),'Marker',markercell{i},'MarkerSize',15,'LineWidth',2)
%     plot(x_axis,Pyr_Veh_RP_Data.Post_Trial_Vector(:,i),'Marker',markercell{i},'MarkerSize',15,'LineWidth',2)
%     ylim([0 450])
    xlabel('Rest Periods')
    ylabel('Average Firing Rate')
    title(title_heading{i})
    legend('RGS14','Vehicle','Location','northwest')
    hold off;
end

%% Combined Average Line Plots (One Value per Sleep Stage)
Mean_Veh_Stages=[]; Mean_Veh_SEM=[];
Mean_RGS_Stages=[]; Mean_RGS_SEM=[];



for i=1:size(Pyr_RGS_RP_Data.Post_Trial_Vector,2)
    Mean_RGS_Stages=[Mean_RGS_Stages mean(Pyr_RGS_RP_Data.Post_Trial_Vector(:,i))];
    Mean_RGS_SEM=[Mean_RGS_SEM mean(Pyr_RGS_RP_Data.SEM_PT(:,i))];
    
    Mean_Veh_Stages=[Mean_Veh_Stages mean(Pyr_Veh_RP_Data.Post_Trial_Vector(:,i))];
    Mean_Veh_SEM=[Mean_Veh_SEM mean(Pyr_Veh_RP_Data.SEM_PT(:,i))];

end
error_avg_rgs=Mean_RGS_SEM;
error_avg_veh=Mean_Veh_SEM;
hold on;
ax=gca();
errorbar(Mean_RGS_Stages,error_avg_rgs,'Marker','*','MarkerSize',10,'LineWidth',2)
errorbar(Mean_Veh_Stages,error_avg_veh,'Marker','o','MarkerSize',10,'LineWidth',2)
ax.XTickLabel={'Quiet Wake','','Microarousal','','NREM','','Intermediate','','REM'};
xlabel('Sleep Stages')
ylim([0 3])
ylabel('Average Normalized Firing Rate')
yline(1,'LineWidth',2)
title('Treatment wise comparison of sleep stage FR')
legend('RGS14','Vehicle')
text(1.2,2.8,sprintf("RGS14 Units: %d",size(Pyr_RGS,1)),'FontWeight','bold')
text(1.2,2.7,sprintf("Vehicle Units: %d",size(Pyr_Veh,1)),'FontWeight','bold')


%% Wake
figure(2)

x_axis_wake={'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5'}; 
x_axis_wake=categorical(x_axis_wake);

error_rgs_wake=Pyr_RGS_RP_Data.SEM_Wake;
error_veh_wake=Pyr_Veh_RP_Data.SEM_Wake;
%     subplot(2,3,i)
hold on;

    errorbar(x_axis_wake,Pyr_RGS_RP_Data.Wake_Vector,error_rgs_wake,'Marker',markercell{1},'MarkerSize',15,'LineWidth',2)
    errorbar(x_axis_wake,Pyr_Veh_RP_Data.Wake_Vector,error_veh_wake,'Marker',markercell{2},'MarkerSize',15,'LineWidth',2)
    yline(1,'k','LineWidth',2)
% plot(x_axis_wake,Pyr_RGS_RP_Data.Wake_Vector,'Marker',markercell{1},'MarkerSize',15,'LineWidth',2)
% plot(x_axis_wake,Pyr_Veh_RP_Data.Wake_Vector,'Marker',markercell{2},'MarkerSize',15,'LineWidth',2)
%     ylim([0 450])
xlabel('Rest Periods')
ylabel('Average Firing Rate')
title('Wake')
legend('RGS14','Vehicle','Location','northwest')
hold off;


%% Wake vs NREM treatmentwise (Study Day Variation)
hold on;
plot(Pyr_RGS_Unit_Wise_Data(:,3))
plot(Pyr_RGS_Unit_Wise_Data(:,6))

plot(Pyr_Veh_Unit_Wise_Data(:,3))







%% Wake

%% Condition Split Wake

x_axis_wake={'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5'}; 
x_axis_wake=categorical(x_axis_wake);
markercell_exp_cond=[{'square'},{'o'},{'^'},{'*'}];
Wake_Data_Combined_RGS=Pyr_RGS_RP_Data.Wake_Temp_Data;
Wake_Data_Combined_Veh=Pyr_Veh_RP_Data.Wake_Temp_Data;

Condition_Wise_Data_Wake_rgs=Condition_Split(Pyr_RGS_Session_1_Units, Wake_Data_Combined_RGS);
Condition_Wise_Data_Wake_veh=Condition_Split(Pyr_Veh_Session_1_Units, Wake_Data_Combined_Veh);
title_exp_cond={'OR','OD','HC','CON'};

for i=1:size(Condition_Wise_Data_Wake_rgs.FR_Data)
    
    plot_vec_rgs=[Condition_Wise_Data_Wake_rgs.FR_Data];
    plot_vec_veh=[Condition_Wise_Data_Wake_veh.FR_Data];
    
    error_wake_rgs=Condition_Wise_Data_Wake_rgs.SEM_Data;
    error_wake_veh=Condition_Wise_Data_Wake_veh.SEM_Data;
    subplot(2,2,i)
    hold on;
    errorbar(x_axis_wake,plot_vec_rgs(:,i),error_wake_rgs(:,i),'Marker',markercell_exp_cond{i},'MarkerSize',15,'LineWidth',2)
    errorbar(x_axis_wake,plot_vec_veh(:,i),error_wake_veh(:,i),'Marker',markercell_exp_cond{i},'MarkerSize',15,'LineWidth',2)
    yline(1,'k','LineWidth',3)
    xlabel('Trials')
    ylabel('Average Firing Rate')
    title(title_exp_cond{i})
    legend('RGS14','Vehicle','Location','northwest')
    hold off;
    
end    







%% KS Test Values
[h_KS_QW, p_KS_QW]=kstest2(Pyr_RGS_Unit_Wise_Data(:,1),[Pyr_Veh_Unit_Wise_Data(:,1)]);
[h_KS_MA, p_KS_MA]=kstest2(Pyr_RGS_Unit_Wise_Data(:,2),[Pyr_Veh_Unit_Wise_Data(:,2)]);
[h_KS_NREM, p_KS_NREM]=kstest2(Pyr_RGS_Unit_Wise_Data(:,3),[Pyr_Veh_Unit_Wise_Data(:,3)]);
[h_KS_Intermediate, p_KS_Intermediate]=kstest2(Pyr_RGS_Unit_Wise_Data(:,4),[Pyr_Veh_Unit_Wise_Data(:,4)]);
[h_KS_REM, p_KS_REM]=kstest2(Pyr_RGS_Unit_Wise_Data(:,5),[Pyr_Veh_Unit_Wise_Data(:,5)]);
[h_KS_Wake, p_KS_Wake]=kstest2(Pyr_RGS_Unit_Wise_Data(:,6),[Pyr_Veh_Unit_Wise_Data(:,6)]);
% 
% %% Wilcox Ranksum Test
% [p_W_QW]=W_Rank_Test_Inputs([Pyr_RGS_RP_Data.QW_All_Vec],[Pyr_Veh_RP_Data.QW_All_Vec]);
% [p_W_MA]=W_Rank_Test_Inputs([Pyr_RGS_RP_Data.MA_All_Vec],[Pyr_Veh_RP_Data.MA_All_Vec]);
% [p_W_NREM]=W_Rank_Test_Inputs([Pyr_RGS_RP_Data.NREM_All_vec],[Pyr_Veh_RP_Data.NREM_All_vec]);
% [ p_W_Intermediate]=W_Rank_Test_Inputs([Pyr_RGS_RP_Data.Intermediate_All_vec],[Pyr_Veh_RP_Data.Intermediate_All_vec]);
% [p_W_REM]=W_Rank_Test_Inputs([Pyr_RGS_RP_Data.REM_All_vec],[Pyr_Veh_RP_Data.REM_All_vec]);





%% Stage Wise Comparision (FR Comparision of RGS and VEh Firing Rates)
Periods={'Quiet Wake', 'Microarousal', 'NREM', 'Intermediate', 'REM','Wake'};
format long;
p_value_vector=[p_KS_QW p_KS_MA p_KS_NREM p_KS_Intermediate p_KS_REM p_KS_Wake];
bin_width=.6;
for i=1:6
    
    subplot(3,2,i)
    hold on;
    h_1=histogram(Pyr_RGS_Unit_Wise_Data(:,i),'FaceColor','b');h_1.BinWidth=bin_width;
    x1_temp=h_1.BinCounts; x1=sum(x1_temp(15:end)); x1_vec=15*ones(x1,1);
    
    histogram(x1_vec,'FaceColor','b','BinWidth',bin_width);
    
    h_2=histogram(Pyr_Veh_Unit_Wise_Data(:,i),'FaceColor','c');h_2.BinWidth=bin_width;
    x2_temp=h_1.BinCounts; x2=sum(x2_temp(15:end)); x2_vec=15*ones(x2,1);
    
    histogram(x2_vec,'FaceColor','c','BinWidth',bin_width);
    
    xlim([0 16])
    legend([h_1 h_2],'RGS14','Vehicle')
    xlabel('Firing Rate Across Rest Periods');ylabel('Number of Neurons');
    title(sprintf("%s : pvalue from KS Test= %d",Periods{i},p_value_vector(i)))
    hold off;
end




%% NREM & Wake Vehicle
[~,p_veh_NREM]=kstest2(Pyr_Veh_Unit_Wise_Data(:,3),Pyr_Veh_Unit_Wise_Data(:,6));
figure('Name','Vehicle')
hold on;
h_veh_nrem=histogram(Pyr_Veh_Unit_Wise_Data(:,3),'FaceColor','b');h_veh_nrem.BinWidth=.1;
h_veh_wake=histogram(Pyr_Veh_Unit_Wise_Data(:,6),'FaceColor','c');h_veh_wake.BinWidth=.1;
ylabel('Number of Neurons')
xlabel('Firing Rate Across the Day')
title(sprintf("Vehicle: NREM to Wake \n p value from KS Test %d",p_veh_NREM))
legend('NREM','Wake')
hold off;
%% NREM & Wake RGS14
[~,p_rgs_NREM]=kstest2(Pyr_RGS_Unit_Wise_Data(:,3),Pyr_RGS_Unit_Wise_Data(:,6));
figure('Name','RGS14')
hold on;
h_rgs_nrem=histogram(Pyr_RGS_Unit_Wise_Data(:,3),'FaceColor','b');h_rgs_nrem.BinWidth=.1;
h_rgs_wake=histogram(Pyr_RGS_Unit_Wise_Data(:,6),'FaceColor','c');h_rgs_wake.BinWidth=.1;
ylabel('Number of Neurons')
xlabel('Firing Rate Across the Day')
title(sprintf("RGS14: NREM to Wake \n p value from KS Test %d",p_rgs_NREM))
legend('NREM','Wake')
hold off;

%% NREM RGS & NREM Veh (Normalized)
[~,Pyr_RGS_Unit_Wise_Data_norm,~]=FR_Analysis(Pyr_RGS,'norm');
[~,Pyr_Veh_Unit_Wise_Data_norm,~]=FR_Analysis(Pyr_Veh,'norm');

[~,p_both]=kstest2(Pyr_RGS_Unit_Wise_Data_norm(:,3),Pyr_Veh_Unit_Wise_Data_norm(:,3));

figure('Name','RGS14 vs Vehicle')
hold on;
h_rgs_nrem_norm=histogram(Pyr_RGS_Unit_Wise_Data_norm(:,3),'FaceColor','b');h_rgs_nrem_norm.BinWidth=.1;
h_veh_nrem_norm=histogram(Pyr_Veh_Unit_Wise_Data_norm(:,3),'FaceColor','c');h_veh_nrem_norm.BinWidth=.1;
ylabel('Number of Neurons')
xlabel('Firing Rate Across the Day')
title(sprintf("RGS14 vs Vehicle: NREM  \n p value from KS Test %d",p_both))
legend('RGS14','Vehicle')
hold off;

%% REM & Wake Vehicle
[~,p_veh_REM]=kstest2(Pyr_Veh_Unit_Wise_Data(:,5),Pyr_Veh_Unit_Wise_Data(:,6));
figure('Name','Vehicle')
hold on;
h_veh_rem=histogram(Pyr_Veh_Unit_Wise_Data(:,5),'FaceColor','b');h_veh_rem.BinWidth=.5;
h_veh_wake=histogram(Pyr_Veh_Unit_Wise_Data(:,6),'FaceColor','c');h_veh_wake.BinWidth=.5;
ylabel('Number of Neurons')
xlabel('Firing Rate Across the Day')
title(sprintf("Vehicle: REM to Wake \n p value from KS Test %d",p_veh_REM))
legend('REM','Wake')
hold off;
%% REM & Wake RGS14
[~,p_rgs_REM]=kstest2(Pyr_RGS_Unit_Wise_Data(:,5),Pyr_RGS_Unit_Wise_Data(:,6));
figure('Name','RGS14')
hold on;
h_rgs_rem=histogram(Pyr_RGS_Unit_Wise_Data(:,5),'FaceColor','b');h_rgs_rem.BinWidth=.5;
h_rgs_wake=histogram(Pyr_RGS_Unit_Wise_Data(:,6),'FaceColor','c');h_rgs_wake.BinWidth=.5;
ylabel('Number of Neurons')
xlabel('Firing Rate Across the Day')
title(sprintf("RGS14: REM to Wake \n p value from KS Test %d",p_rgs_REM))
legend('REM','Wake')
hold off;







%% HC vs OR Histograms (Check Normalization of FR Analysis function )


Data_Combined_RGS=Pyr_RGS_Unit_Wise_Data;
Data_Combined_Veh=Pyr_Veh_Unit_Wise_Data;
Cond_String={'OR','OD','HC','CON'};



Cond_Split_Veh=Condition_Split_Histograms(Pyr_Veh,Data_Combined_Veh);

All_FR_Data=Cond_Split_Veh.FR_Data;

HC_Data=All_FR_Data{3};
OR_Data=All_FR_Data{1};

%% KS Test Values
[h_KS_QW, p_KS_QW]=kstest2(HC_Data(:,1),[OR_Data(:,1)]);
[h_KS_MA, p_KS_MA]=kstest2(HC_Data(:,2),[OR_Data(:,2)]);
[h_KS_NREM, p_KS_NREM]=kstest2(HC_Data(:,3),[OR_Data(:,3)]);
[h_KS_Intermediate, p_KS_Intermediate]=kstest2(HC_Data(:,4),[OR_Data(:,4)]);
[h_KS_REM, p_KS_REM]=kstest2(HC_Data(:,5),[OR_Data(:,5)]);

Periods={'Quiet Wake', 'Microarousal', 'NREM', 'Intermediate', 'REM','Wake'};
format long;
p_value_vector=[p_KS_QW p_KS_MA p_KS_NREM p_KS_Intermediate p_KS_REM];
bin_width=.1;
for i=1:5
    
    subplot(3,2,i)
    hold on;
    h_1=histogram(HC_Data(:,i),'FaceColor','b');h_1.BinWidth=bin_width;
    x1_temp=h_1.BinCounts; x1=sum(x1_temp(9:end)); x1_vec=9*ones(x1,1);
    
    histogram(x1_vec,'FaceColor','b','BinWidth',bin_width);
    
    h_2=histogram(OR_Data(:,i),'FaceColor','c');h_2.BinWidth=bin_width;
    x2_temp=h_1.BinCounts; x2=sum(x2_temp(9:end)); x2_vec=9*ones(x2,1);
    
    histogram(x2_vec,'FaceColor','c','BinWidth',bin_width);
    
    xlim([0 9.1])
    legend([h_1 h_2],'HC','OR')%,'Location','northwest')
    xlabel('Firing Rate Across Rest Periods');ylabel('Number of Neurons');
    title(sprintf("%s : pvalue from KS Test= %d",Periods{i},p_value_vector(i)))
    hold off;
end  









