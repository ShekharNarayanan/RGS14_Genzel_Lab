%% Loading Input Data
RGS_Phase=load('Phase_Vector_Slow_Wave_Pyr_RGS_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_RGS_Session_1 ;
Veh_Phase=load('Phase_Vector_Slow_Wave_Pyr_Veh_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_Veh_Session_1 ;



%% Combing Data
Combined_RGS=vertcat(RGS_Phase.NREM_SW_Phases);
Combined_Veh=vertcat(Veh_Phase.NREM_SW_Phases);

%% Plotting Combined Data (Averaged but not normalized)
% % Collecting Average Counts
Counts_Avg_RGS_Temp=[]; 
for i=1:size(RGS_Phase,2)

hist_RGS=histogram(RGS_Phase(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_RGS_Avg=hist_RGS.BinCounts;

diff_count=360-size(Counts_RGS_Avg,2);
Counts_RGS_Avg=[Counts_RGS_Avg nan(1,diff_count)];
Counts_Avg_RGS_Temp=[Counts_Avg_RGS_Temp  Counts_RGS_Avg'];                           
end

Counts_Avg_RGS_Final=[]; 
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

Counts_RGS_Norm=Counts_RGS_Norm/max(Counts_RGS_Norm); %% Normalization step

diff_count=360-size(Counts_RGS_Norm,2);
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
figure('Name','Normalized Histograms Comparison')
subplot(1,2,1)
Norm_hist_RGS=histogram(Combined_RGS,360); Norm_hist_RGS.BinCounts=Counts_Norm_RGS_Final';
title(sprintf('RGS Phase Spike normalized Plot \n Units: %d',size(RGS_Phase,2)))
ylim([0 1])
xlabel('Phase: 0-360')
ylabel('Normalized Spike Counts')

subplot(1,2,2)
Norm_hist_Veh=histogram(Combined_Veh,360); Norm_hist_Veh.BinCounts=Counts_Norm_Veh_Final';
title(sprintf('Veh Phase Spike normalized Plot \n Units: %d',size(Veh_Phase,2)))
xlabel('Phase: 0-360')
ylabel('Normalized Spike Counts')
ylim([0 1])


%% Phase Lock Analysis (Imagesc plots)

%% Loading Data For Further Analysis
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

Units_NREM_Veh_Less_Than_Names=[]; Units_NREM_Veh_Less_Than_Data=[];

Units_NREM_Veh_More_T1_Than_Names=[];Units_NREM_Veh_More_Than_T1_Data=[];

Units_NREM_Veh_More_T2_Than_Names=[];Units_NREM_Veh_More_Than_T2_Data=[];

Units_NREM_Veh_More_T3_Than_Names=[];Units_NREM_Veh_More_Than_T3_Data=[];

Units_NREM_Veh_More_T4_Than_Names=[];Units_NREM_Veh_More_Than_T4_Data=[];

for ii=1:size(Wake_Veh,1)
    
    if Wake_Veh(ii)<=threshold_vec(1)
        Units_NREM_Veh_Less_Than_Data=[Units_NREM_Veh_Less_Than_Data; Veh_Phase(ii)];
        Units_NREM_Veh_Less_Than_Names=[Units_NREM_Veh_Less_Than_Names; Pyr_Veh(ii)];
        
    elseif (Wake_Veh(ii)>threshold_vec(1)) && (Wake_Veh(ii)<=threshold_vec(2))
        Units_NREM_Veh_More_Than_T1_Data=[Units_NREM_Veh_More_Than_T1_Data; Veh_Phase(ii)];
        Units_NREM_Veh_More_T1_Than_Names=[Units_NREM_Veh_More_T1_Than_Names; Pyr_Veh(ii)];
    
    elseif (Wake_Veh(ii)>threshold_vec(2)) && (Wake_Veh(ii)<=threshold_vec(3))
        Units_NREM_Veh_More_Than_T2_Data=[Units_NREM_Veh_More_Than_T2_Data; Veh_Phase(ii)];
        Units_NREM_Veh_More_T2_Than_Names=[Units_NREM_Veh_More_T2_Than_Names; Pyr_Veh(ii)]; 
        
    elseif (Wake_Veh(ii)>threshold_vec(3)) && (Wake_Veh(ii)<threshold_vec(4))
        Units_NREM_Veh_More_Than_T3_Data=[Units_NREM_Veh_More_Than_T3_Data; Veh_Phase(ii)];
        Units_NREM_Veh_More_T3_Than_Names=[Units_NREM_Veh_More_T3_Than_Names; Pyr_Veh(ii)];  
        
    elseif Wake_Veh(ii)>threshold_vec(4)
        Units_NREM_Veh_More_Than_T4_Data=[Units_NREM_Veh_More_Than_T4_Data; Veh_Phase(ii)];
        Units_NREM_Veh_More_T4_Than_Names=[Units_NREM_Veh_More_T4_Than_Names; Pyr_Veh(ii)];        
     
    end
    
    
end


% Split for RGS NREM

Wake_RGS=Pyr_RGS_Unit_Wise_Data(:,6);

Units_NREM_RGS_Less_Than_Names=[]; Units_NREM_RGS_Less_Than_Data=[];

Units_NREM_RGS_More_T1_Than_Names=[];Units_NREM_RGS_More_Than_T1_Data=[];

Units_NREM_RGS_More_T2_Than_Names=[];Units_NREM_RGS_More_Than_T2_Data=[];

Units_NREM_RGS_More_T3_Than_Names=[];Units_NREM_RGS_More_Than_T3_Data=[];

Units_NREM_RGS_More_T4_Than_Names=[];Units_NREM_RGS_More_Than_T4_Data=[];

for ii=1:size(Wake_RGS,1)
    
    if Wake_RGS(ii)<=threshold_vec(1)
        Units_NREM_RGS_Less_Than_Data=[Units_NREM_RGS_Less_Than_Data; RGS_Phase(ii)];
        Units_NREM_RGS_Less_Than_Names=[Units_NREM_RGS_Less_Than_Names; Pyr_RGS(ii)];
        
    elseif (Wake_RGS(ii)>threshold_vec(1)) && (Wake_RGS(ii)<=threshold_vec(2))
        Units_NREM_RGS_More_Than_T1_Data=[Units_NREM_RGS_More_Than_T1_Data; RGS_Phase(ii)];
        Units_NREM_RGS_More_T1_Than_Names=[Units_NREM_RGS_More_T1_Than_Names; Pyr_RGS(ii)];
    
    elseif (Wake_RGS(ii)>threshold_vec(2)) && (Wake_RGS(ii)<=threshold_vec(3))
        Units_NREM_RGS_More_Than_T2_Data=[Units_NREM_RGS_More_Than_T2_Data; RGS_Phase(ii)];
        Units_NREM_RGS_More_T2_Than_Names=[Units_NREM_RGS_More_T2_Than_Names; Pyr_RGS(ii)]; 
        
    elseif (Wake_RGS(ii)>threshold_vec(3)) && (Wake_RGS(ii)<threshold_vec(4))
        Units_NREM_RGS_More_Than_T3_Data=[Units_NREM_RGS_More_Than_T3_Data; RGS_Phase(ii)];
        Units_NREM_RGS_More_T3_Than_Names=[Units_NREM_RGS_More_T3_Than_Names; Pyr_RGS(ii)];  
        
    elseif Wake_RGS(ii)>threshold_vec(4)
        Units_NREM_RGS_More_Than_T4_Data=[Units_NREM_RGS_More_Than_T4_Data; RGS_Phase(ii)];
        Units_NREM_RGS_More_T4_Than_Names=[Units_NREM_RGS_More_T4_Than_Names; Pyr_RGS(ii)];        
     
    end
    
    
end

%% NREM FR Column to sort neurons: RGS 

[X,X_Index]=sort(Pyr_RGS_Unit_Wise_Data(:,3),'ascend');

Counts_Norm_RGS_Ascend=Counts_Norm_RGS_Temp(:,X_Index);



[Y,Y_Index]=sort(Pyr_RGS_Unit_Wise_Data(:,3),'descend');

Counts_Norm_RGS_Descend=Counts_Norm_RGS_Temp(:,Y_Index);

%% Plotting Normalized NREM sorted FR histograms and Imagesc plots)
figure('Name','Imagesc plots for RGS Phase Lock Trend: Ascending & Descending')
subplot(1,2,1)
imagesc(Counts_Norm_RGS_Ascend);colorbar()
xlabel('Unit IDs in Ascending NREM FR');ylabel('Phase 0:360');title('Phase vs NREM FR Variation: RGS Ascending')
xline(size(Units_NREM_RGS_Less_Than_Names,1),'r','LineWidth',5)
xline([size(Units_NREM_RGS_Less_Than_Names,1)+size(Units_NREM_RGS_More_Than_T1_Data,1) ],'r','LineWidth',5)
xline([size(Units_NREM_RGS_Less_Than_Names,1)+size(Units_NREM_RGS_More_Than_T1_Data,1)+size(Units_NREM_RGS_More_Than_T2_Data,1) ],'r','LineWidth',5)
xline([size(Units_NREM_RGS_Less_Than_Names,1)+size(Units_NREM_RGS_More_Than_T1_Data,1)+size(Units_NREM_RGS_More_Than_T2_Data,1)+size(Units_NREM_RGS_More_Than_T3_Data,1)],'r','LineWidth',5)
xline([size(Units_NREM_RGS_Less_Than_Names,1)+size(Units_NREM_RGS_More_Than_T1_Data,1)+size(Units_NREM_RGS_More_Than_T2_Data,1)+size(Units_NREM_RGS_More_Than_T3_Data,1)+...
    size(Units_NREM_RGS_More_Than_T4_Data,1) ],'r','LineWidth',5)
caxis([0 1])

subplot(1,2,2)
imagesc(Counts_Norm_RGS_Descend);colorbar()
xlabel('Unit IDs in Ascending NREM FR');ylabel('Phase 0:360');title('Phase vs NREM FR Variation: RGS Descending')
xline(size(Units_NREM_RGS_Less_Than_Names,1),'r','LineWidth',5)
xline([size(Units_NREM_RGS_Less_Than_Names,1)+size(Units_NREM_RGS_More_Than_T1_Data,1) ],'r','LineWidth',5)
xline([size(Units_NREM_RGS_Less_Than_Names,1)+size(Units_NREM_RGS_More_Than_T1_Data,1)+size(Units_NREM_RGS_More_Than_T2_Data,1) ],'r','LineWidth',5)
xline([size(Units_NREM_RGS_Less_Than_Names,1)+size(Units_NREM_RGS_More_Than_T1_Data,1)+size(Units_NREM_RGS_More_Than_T2_Data,1)+size(Units_NREM_RGS_More_Than_T3_Data,1)],'r','LineWidth',5)
xline([size(Units_NREM_RGS_Less_Than_Names,1)+size(Units_NREM_RGS_More_Than_T1_Data,1)+size(Units_NREM_RGS_More_Than_T2_Data,1)+size(Units_NREM_RGS_More_Than_T3_Data,1)+...
    size(Units_NREM_RGS_More_Than_T4_Data,1) ],'r','LineWidth',5)

caxis([0 1])

%% NREM FR Column to sort neurons: Veh 

[X,X_Index]=sort(Pyr_Veh_Unit_Wise_Data(:,3),'ascend');

Counts_Norm_Veh_Ascend=Counts_Norm_Veh_Temp(:,X_Index);



[Y,Y_Index]=sort(Pyr_Veh_Unit_Wise_Data(:,3),'descend');

Counts_Norm_Veh_Descend=Counts_Norm_Veh_Temp(:,Y_Index);

%% Plotting Normalized NREM sorted FR histograms and Imagesc plots)
figure('Name','Imagesc plots for Veh Phase Lock Trend: Ascending & Descending')
subplot(1,2,1)
imagesc(Counts_Norm_Veh_Ascend);colorbar()
xlabel('Unit IDs in Ascending NREM FR');ylabel('Phase 0:360');title('Phase vs NREM FR Variation: Veh Ascending')
xline(size(Units_NREM_Veh_Less_Than_Names,1),'r','LineWidth',5)
xline([size(Units_NREM_Veh_Less_Than_Names,1)+size(Units_NREM_Veh_More_Than_T1_Data,1) ],'r','LineWidth',5)
xline([size(Units_NREM_Veh_Less_Than_Names,1)+size(Units_NREM_Veh_More_Than_T1_Data,1)+size(Units_NREM_Veh_More_Than_T2_Data,1) ],'r','LineWidth',5)
xline([size(Units_NREM_Veh_Less_Than_Names,1)+size(Units_NREM_Veh_More_Than_T1_Data,1)+size(Units_NREM_Veh_More_Than_T2_Data,1)+size(Units_NREM_Veh_More_Than_T3_Data,1)],'r','LineWidth',5)
xline([size(Units_NREM_Veh_Less_Than_Names,1)+size(Units_NREM_Veh_More_Than_T1_Data,1)+size(Units_NREM_Veh_More_Than_T2_Data,1)+size(Units_NREM_Veh_More_Than_T3_Data,1)+...
    size(Units_NREM_Veh_More_Than_T4_Data,1) ],'r','LineWidth',5)
caxis([0 1])

subplot(1,2,2)
imagesc(Counts_Norm_Veh_Descend);colorbar()
xlabel('Unit IDs in Ascending NREM FR');ylabel('Phase 0:360');title('Phase vs NREM FR Variation: Veh Descending')
xline(size(Units_NREM_Veh_Less_Than_Names,1),'r','LineWidth',5)
xline([size(Units_NREM_Veh_Less_Than_Names,1)+size(Units_NREM_Veh_More_Than_T1_Data,1) ],'r','LineWidth',5)
xline([size(Units_NREM_Veh_Less_Than_Names,1)+size(Units_NREM_Veh_More_Than_T1_Data,1)+size(Units_NREM_Veh_More_Than_T2_Data,1) ],'r','LineWidth',5)
xline([size(Units_NREM_Veh_Less_Than_Names,1)+size(Units_NREM_Veh_More_Than_T1_Data,1)+size(Units_NREM_Veh_More_Than_T2_Data,1)+size(Units_NREM_Veh_More_Than_T3_Data,1)],'r','LineWidth',5)
xline([size(Units_NREM_Veh_Less_Than_Names,1)+size(Units_NREM_Veh_More_Than_T1_Data,1)+size(Units_NREM_Veh_More_Than_T2_Data,1)+size(Units_NREM_Veh_More_Than_T3_Data,1)+...
    size(Units_NREM_Veh_More_Than_T4_Data,1) ],'r','LineWidth',5)
caxis([0 1])



% % Histograms for the imagesc plot
% RGS_Phase_Sort=RGS_Phase(X_Index);
% Combined_RGS_Sort=vertcat(RGS_Phase_Sort.NREM_SW);
% figure(2)
% subplot(1,2,1)
% imhist(Counts_Norm_RGS_Temp); %norm_hist_RGS.BinCounts=Counts_Avg_RGS_Final';
% xlabel('Unit IDs in Ascending NREM FR');ylabel('Phase 0:360');title('Phase vs NREM FR Variation: RGS')


% subplot(1,2,2)
% norm_hist_Veh=histogram(Combined_Veh_Sort,360); norm_hist_Veh.BinCounts=Counts_Avg_Veh_Final';
% title(sprintf('Veh Phase Spike normalized Plot \n Units: %d',size(Veh_Phase,2)))
% xlabel('Phase: 0-360')
% ylabel('Averaged Spike Counts')


%% Phase Analysis For Split Groups (RUN THIS SEGMENT SEPARATELY)

%% Less Than Group (0-20%)
% Collecting Normalized Counts

% RGS
Counts_Norm_RGS_Less_Than_Temp=[]; 
for i=1:size(Units_NREM_RGS_Less_Than_Data,1)

hist_RGS=histogram(Units_NREM_RGS_Less_Than_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_RGS_Norm=hist_RGS.BinCounts;

Counts_RGS_Norm=Counts_RGS_Norm/max(Counts_RGS_Norm); %% Normalization step

diff_count=360-size(Counts_RGS_Norm,2);
Counts_RGS_Norm=[Counts_RGS_Norm nan(1,diff_count)];

Counts_Norm_RGS_Less_Than_Temp=[Counts_Norm_RGS_Less_Than_Temp  Counts_RGS_Norm'];                           
end

Counts_Norm_RGS_Less_Than_Final=[]; 
for ii=1:size(Counts_Norm_RGS_Less_Than_Temp',2)
    
    Counts_Norm_RGS_Less_Than_Final=[Counts_Norm_RGS_Less_Than_Final; nanmean(Counts_Norm_RGS_Less_Than_Temp(ii,:))];

    
end

% Veh

Counts_Norm_Veh_Less_Than_Temp=[]; 
for i=1:size(Units_NREM_Veh_Less_Than_Data,1)

hist_Veh=histogram(Units_NREM_Veh_Less_Than_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_Veh_Norm=hist_Veh.BinCounts;

Counts_Veh_Norm=Counts_Veh_Norm/max(Counts_Veh_Norm); %% Normalization step

diff_count=360-size(Counts_Veh_Norm,2);
Counts_Veh_Norm=[Counts_Veh_Norm nan(1,diff_count)];

Counts_Norm_Veh_Less_Than_Temp=[Counts_Norm_Veh_Less_Than_Temp  Counts_Veh_Norm'];                           
end

Counts_Norm_Veh_Less_Than_Final=[]; 
for ii=1:size(Counts_Norm_Veh_Less_Than_Temp',2)
    
    Counts_Norm_Veh_Less_Than_Final=[Counts_Norm_Veh_Less_Than_Final; nanmean(Counts_Norm_Veh_Less_Than_Temp(ii,:))];

    
end


%% More Than T1 Group (20-40%)

% Collecting Normalized Counts

% RGS
Counts_Norm_RGS_More_Than_T1_Temp=[]; 
for i=1:size(Units_NREM_RGS_More_Than_T1_Data,1)
  
hist_RGS=histogram(Units_NREM_RGS_More_Than_T1_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_RGS_Norm=hist_RGS.BinCounts;

Counts_RGS_Norm=Counts_RGS_Norm/max(Counts_RGS_Norm); %% Normalization step

diff_count=360-size(Counts_RGS_Norm,2);
Counts_RGS_Norm=[Counts_RGS_Norm nan(1,diff_count)];

Counts_Norm_RGS_More_Than_T1_Temp=[Counts_Norm_RGS_More_Than_T1_Temp  Counts_RGS_Norm'];                           
end

Counts_Norm_RGS_More_Than_T1_Final=[]; 
for ii=1:size(Counts_Norm_RGS_More_Than_T1_Temp',2)
    
    Counts_Norm_RGS_More_Than_T1_Final=[Counts_Norm_RGS_More_Than_T1_Final; nanmean(Counts_Norm_RGS_More_Than_T1_Temp(ii,:))];

    
end

% Veh

Counts_Norm_Veh_More_Than_T1_Temp=[]; 
for i=1:size(Units_NREM_Veh_More_Than_T1_Data,1)

hist_Veh=histogram(Units_NREM_Veh_More_Than_T1_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_Veh_Norm=hist_Veh.BinCounts;

Counts_Veh_Norm=Counts_Veh_Norm/max(Counts_Veh_Norm); %% Normalization step

diff_count=360-size(Counts_Veh_Norm,2);
Counts_Veh_Norm=[Counts_Veh_Norm nan(1,diff_count)];

Counts_Norm_Veh_More_Than_T1_Temp=[Counts_Norm_Veh_More_Than_T1_Temp  Counts_Veh_Norm'];                           
end

Counts_Norm_Veh_More_Than_T1_Final=[]; 
for ii=1:size(Counts_Norm_Veh_More_Than_T1_Temp',2)
    
    Counts_Norm_Veh_More_Than_T1_Final=[Counts_Norm_Veh_More_Than_T1_Final; nanmean(Counts_Norm_Veh_More_Than_T1_Temp(ii,:))];

    
end

%% More Than T2 Group (40-60%)

% Collecting Normalized Counts

% RGS
Counts_Norm_RGS_More_Than_T2_Temp=[]; 
for i=1:size(Units_NREM_RGS_More_Than_T2_Data,1)

hist_RGS=histogram(Units_NREM_RGS_More_Than_T2_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_RGS_Norm=hist_RGS.BinCounts;

Counts_RGS_Norm=Counts_RGS_Norm/max(Counts_RGS_Norm); %% Normalization step

diff_count=360-size(Counts_RGS_Norm,2);
Counts_RGS_Norm=[Counts_RGS_Norm nan(1,diff_count)];

Counts_Norm_RGS_More_Than_T2_Temp=[Counts_Norm_RGS_More_Than_T2_Temp  Counts_RGS_Norm'];                           
end

Counts_Norm_RGS_More_Than_T2_Final=[]; 
for ii=1:size(Counts_Norm_RGS_More_Than_T2_Temp',2)
    
    Counts_Norm_RGS_More_Than_T2_Final=[Counts_Norm_RGS_More_Than_T2_Final; nanmean(Counts_Norm_RGS_More_Than_T2_Temp(ii,:))];

    
end

% Veh

Counts_Norm_Veh_More_Than_T2_Temp=[]; 
for i=1:size(Units_NREM_Veh_More_Than_T2_Data,1)

hist_Veh=histogram(Units_NREM_Veh_More_Than_T2_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_Veh_Norm=hist_Veh.BinCounts;

Counts_Veh_Norm=Counts_Veh_Norm/max(Counts_Veh_Norm); %% Normalization step

diff_count=360-size(Counts_Veh_Norm,2);
Counts_Veh_Norm=[Counts_Veh_Norm nan(1,diff_count)];

Counts_Norm_Veh_More_Than_T2_Temp=[Counts_Norm_Veh_More_Than_T2_Temp  Counts_Veh_Norm'];                           
end

Counts_Norm_Veh_More_Than_T2_Final=[]; 
for ii=1:size(Counts_Norm_Veh_More_Than_T2_Temp',2)
    
    Counts_Norm_Veh_More_Than_T2_Final=[Counts_Norm_Veh_More_Than_T2_Final; nanmean(Counts_Norm_Veh_More_Than_T2_Temp(ii,:))];

    
end

%% More Than T3 Group (60-80%)

% Collecting Normalized Counts

% RGS
Counts_Norm_RGS_More_Than_T3_Temp=[]; 
for i=1:size(Units_NREM_RGS_More_Than_T3_Data,1)

hist_RGS=histogram(Units_NREM_RGS_More_Than_T3_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_RGS_Norm=hist_RGS.BinCounts;

Counts_RGS_Norm=Counts_RGS_Norm/max(Counts_RGS_Norm); %% Normalization step

diff_count=360-size(Counts_RGS_Norm,2);
Counts_RGS_Norm=[Counts_RGS_Norm nan(1,diff_count)];

Counts_Norm_RGS_More_Than_T3_Temp=[Counts_Norm_RGS_More_Than_T3_Temp  Counts_RGS_Norm'];                           
end

Counts_Norm_RGS_More_Than_T3_Final=[]; 
for ii=1:size(Counts_Norm_RGS_More_Than_T3_Temp',2)
    
    Counts_Norm_RGS_More_Than_T3_Final=[Counts_Norm_RGS_More_Than_T3_Final; nanmean(Counts_Norm_RGS_More_Than_T3_Temp(ii,:))];

    
end

% Veh

Counts_Norm_Veh_More_Than_T3_Temp=[]; 
for i=1:size(Units_NREM_Veh_More_Than_T3_Data,1)

hist_Veh=histogram(Units_NREM_Veh_More_Than_T3_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_Veh_Norm=hist_Veh.BinCounts;

Counts_Veh_Norm=Counts_Veh_Norm/max(Counts_Veh_Norm); %% Normalization step

diff_count=360-size(Counts_Veh_Norm,2);
Counts_Veh_Norm=[Counts_Veh_Norm nan(1,diff_count)];

Counts_Norm_Veh_More_Than_T3_Temp=[Counts_Norm_Veh_More_Than_T3_Temp  Counts_Veh_Norm'];                           
end

Counts_Norm_Veh_More_Than_T3_Final=[]; 
for ii=1:size(Counts_Norm_Veh_More_Than_T3_Temp',2)
    
    Counts_Norm_Veh_More_Than_T3_Final=[Counts_Norm_Veh_More_Than_T3_Final; nanmean(Counts_Norm_Veh_More_Than_T3_Temp(ii,:))];

    
end

%% More Than T4 Group (80-100%)

% Collecting Normalized Counts

% RGS
Counts_Norm_RGS_More_Than_T4_Temp=[]; 
for i=1:size(Units_NREM_RGS_More_Than_T4_Data,1)

hist_RGS=histogram(Units_NREM_RGS_More_Than_T4_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_RGS_Norm=hist_RGS.BinCounts;

Counts_RGS_Norm=Counts_RGS_Norm/max(Counts_RGS_Norm); %% Normalization step

diff_count=360-size(Counts_RGS_Norm,2);
Counts_RGS_Norm=[Counts_RGS_Norm nan(1,diff_count)];

Counts_Norm_RGS_More_Than_T4_Temp=[Counts_Norm_RGS_More_Than_T4_Temp  Counts_RGS_Norm'];                           
end

Counts_Norm_RGS_More_Than_T4_Final=[]; 
for ii=1:size(Counts_Norm_RGS_More_Than_T4_Temp',2)
    
    Counts_Norm_RGS_More_Than_T4_Final=[Counts_Norm_RGS_More_Than_T4_Final; nanmean(Counts_Norm_RGS_More_Than_T4_Temp(ii,:))];

    
end

% Veh

Counts_Norm_Veh_More_Than_T4_Temp=[]; 
for i=1:size(Units_NREM_Veh_More_Than_T4_Data,1)

hist_Veh=histogram(Units_NREM_Veh_More_Than_T4_Data(i).NREM_SW_Phases,'FaceColor','k','BinWidth',1);

Counts_Veh_Norm=hist_Veh.BinCounts;

Counts_Veh_Norm=Counts_Veh_Norm/max(Counts_Veh_Norm); %% Normalization step

diff_count=360-size(Counts_Veh_Norm,2);
Counts_Veh_Norm=[Counts_Veh_Norm nan(1,diff_count)];

Counts_Norm_Veh_More_Than_T4_Temp=[Counts_Norm_Veh_More_Than_T4_Temp  Counts_Veh_Norm'];                           
end

Counts_Norm_Veh_More_Than_T4_Final=[]; 
for ii=1:size(Counts_Norm_Veh_More_Than_T4_Temp',2)
    
    Counts_Norm_Veh_More_Than_T4_Final=[Counts_Norm_Veh_More_Than_T4_Final; nanmean(Counts_Norm_Veh_More_Than_T4_Temp(ii,:))];

    
end

%% Plotting Phase Data for Different Groups (Run Separately)

%% Less_Than Data (0-20%)
figure('Name','RGS 0-20%')
subplot(1,2,1)

% Plotting Normalized Histogram
Norm_hist_RGS_Less_Than=histogram(vertcat(Units_NREM_RGS_Less_Than_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_RGS_Less_Than.BinCounts=Counts_Norm_RGS_Less_Than_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM RGS Histogram \n Units:%d \n Range:0-20 Percent ',size(Units_NREM_RGS_Less_Than_Data,1)))
ylim([0 1])
% Finding Mean and Resultant Vector

mean_Less_Than_RGS=[];
for ii=1:size(Units_NREM_RGS_Less_Than_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_RGS_Less_Than_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_Less_Than_RGS=[mean_Less_Than_RGS; mean_per_unit];
    
    
end    
    
resultant_Less_Than_RGS=[];

for ii=1:size(Units_NREM_RGS_Less_Than_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_RGS_Less_Than_Data(ii).NREM_SW_Phases));
    
    resultant_Less_Than_RGS=[resultant_Less_Than_RGS; res_per_unit];
    
    
end



% Plotting Phase Lock Information
subplot(1,2,2)
hist_polar_RGS_Less_Than_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_RGS_Less_Than_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All RGS Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_RGS_Less_Than_Data,1),mean(mean_Less_Than_RGS),mean(resultant_Less_Than_RGS)))

figure('Name','Veh 0-20%')
subplot(1,2,1)

% Plotting Normalized Histogram
Norm_hist_Veh_Less_Than=histogram(vertcat(Units_NREM_Veh_Less_Than_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_Veh_Less_Than.BinCounts=Counts_Norm_Veh_Less_Than_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM Veh Histogram \n Units:%d \n Range:0-20 Percent ',size(Units_NREM_Veh_Less_Than_Data,1)))
ylim([0 1])
% Finding Mean and Resultant Vector
mean_Less_Than_Veh=[];
for ii=1:size(Units_NREM_Veh_Less_Than_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_Veh_Less_Than_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_Less_Than_Veh=[mean_Less_Than_Veh; mean_per_unit];
    
    
end    
    
resultant_Less_Than_Veh=[];

for ii=1:size(Units_NREM_Veh_Less_Than_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_Veh_Less_Than_Data(ii).NREM_SW_Phases));
    
    resultant_Less_Than_Veh=[resultant_Less_Than_Veh; res_per_unit];
    
    
end

% Plotting Phase Lock Information
subplot(1,2,2)
hist_polar_Veh_Less_Than_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_Veh_Less_Than_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All Veh Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_Veh_Less_Than_Data,1),mean(mean_Less_Than_Veh),mean(resultant_Less_Than_Veh)))



%% More_Than_T1_ Data (20-40%)
figure('Name','RGS 20-40%')
% Normalized Histogram
subplot(1,2,1)

Norm_hist_RGS_More_Than_T1=histogram(vertcat(Units_NREM_RGS_More_Than_T1_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_RGS_More_Than_T1.BinCounts=Counts_Norm_RGS_More_Than_T1_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM RGS Histogram \n Units:%d \n Range:20-40 Percent ',size(Units_NREM_RGS_More_Than_T1_Data,1)))
ylim([0 1])
% Finding mean and resultant 
mean_More_Than_T1_RGS=[];
for ii=1:size(Units_NREM_RGS_More_Than_T1_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_RGS_More_Than_T1_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_More_Than_T1_RGS=[mean_More_Than_T1_RGS; mean_per_unit];
    
    
end    
    
resultant_More_Than_T1_RGS=[];

for ii=1:size(Units_NREM_RGS_More_Than_T1_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_RGS_More_Than_T1_Data(ii).NREM_SW_Phases));
    
    resultant_More_Than_T1_RGS=[resultant_More_Than_T1_RGS; res_per_unit];
    
    
end

% Phase Lock Info
subplot(1,2,2)
hist_polar_RGS_More_Than_T1_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_RGS_More_Than_T1_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All RGS Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_RGS_More_Than_T1_Data,1),mean(mean_More_Than_T1_RGS),mean(resultant_More_Than_T1_RGS)))


figure('Name','Veh 20-40%')
% Normalized Histogram
subplot(1,2,1)

Norm_hist_Veh_More_Than_T1=histogram(vertcat(Units_NREM_Veh_More_Than_T1_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_Veh_More_Than_T1.BinCounts=Counts_Norm_Veh_More_Than_T1_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM Veh Histogram \n Units:%d \n Range:20-40 Percent ',size(Units_NREM_Veh_More_Than_T1_Data,1)))
ylim([0 1])
% Finding mean and resultant
mean_More_Than_T1_Veh=[];
for ii=1:size(Units_NREM_Veh_More_Than_T1_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_Veh_More_Than_T1_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_More_Than_T1_Veh=[mean_More_Than_T1_Veh; mean_per_unit];
    
    
end    
    
resultant_More_Than_T1_Veh=[];

for ii=1:size(Units_NREM_Veh_More_Than_T1_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_Veh_More_Than_T1_Data(ii).NREM_SW_Phases));
    
    resultant_More_Than_T1_Veh=[resultant_More_Than_T1_Veh; res_per_unit];
    
    
end

% Phase Lock Info
subplot(1,2,2)
hist_polar_Veh_More_Than_T1_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_Veh_More_Than_T1_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All Veh Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_Veh_More_Than_T1_Data,1),mean(mean_More_Than_T1_Veh),mean(resultant_More_Than_T1_Veh)))



%% More_Than_T2 Data (40-60%)
figure('Name','RGS 40-60%')
% Normalized Histogram
subplot(1,2,1)

Norm_hist_RGS_More_Than_T2=histogram(vertcat(Units_NREM_RGS_More_Than_T2_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_RGS_More_Than_T2.BinCounts=Counts_Norm_RGS_More_Than_T2_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM RGS Histogram \n Units:%d \n Range:40-60 Percent ',size(Units_NREM_RGS_More_Than_T2_Data,1)))
ylim([0 1])
% Finding mean and resultant 
mean_More_Than_T2_RGS=[];
for ii=1:size(Units_NREM_RGS_More_Than_T2_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_RGS_More_Than_T2_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_More_Than_T2_RGS=[mean_More_Than_T2_RGS; mean_per_unit];
    
    
end    
    
resultant_More_Than_T2_RGS=[];

for ii=1:size(Units_NREM_RGS_More_Than_T2_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_RGS_More_Than_T2_Data(ii).NREM_SW_Phases));
    
    resultant_More_Than_T2_RGS=[resultant_More_Than_T2_RGS; res_per_unit];
    
    
end

% Phase Lock Info
subplot(1,2,2)
hist_polar_RGS_More_Than_T2_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_RGS_More_Than_T2_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All RGS Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_RGS_More_Than_T2_Data,1),mean(mean_More_Than_T2_RGS),mean(resultant_More_Than_T2_RGS)))



figure('Name','Veh 40-60%')
% Normalized Histogram
subplot(1,2,1)

Norm_hist_Veh_More_Than_T2=histogram(vertcat(Units_NREM_Veh_More_Than_T2_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_Veh_More_Than_T2.BinCounts=Counts_Norm_Veh_More_Than_T2_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM Veh Histogram \n Units:%d \n Range:40-60 Percent ',size(Units_NREM_Veh_More_Than_T2_Data,1)))
ylim([0 1])
% Finding mean and resultant
mean_More_Than_T2_Veh=[];
for ii=1:size(Units_NREM_Veh_More_Than_T2_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_Veh_More_Than_T2_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_More_Than_T2_Veh=[mean_More_Than_T2_Veh; mean_per_unit];
    
    
end    
    
resultant_More_Than_T2_Veh=[];

for ii=1:size(Units_NREM_Veh_More_Than_T2_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_Veh_More_Than_T2_Data(ii).NREM_SW_Phases));
    
    resultant_More_Than_T2_Veh=[resultant_More_Than_T2_Veh; res_per_unit];
    
    
end

% Phase Lock Info
subplot(1,2,2)
hist_polar_Veh_More_Than_T2_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_Veh_More_Than_T2_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All Veh Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_Veh_More_Than_T2_Data,1),mean(mean_More_Than_T2_Veh),mean(resultant_More_Than_T2_Veh)))



%% More_Than_T3 Data (60-80%)
figure('Name','RGS 60-80%')
% Normalized Histogram
subplot(1,2,1)

Norm_hist_RGS_More_Than_T3=histogram(vertcat(Units_NREM_RGS_More_Than_T3_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_RGS_More_Than_T3.BinCounts=Counts_Norm_RGS_More_Than_T3_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM RGS Histogram \n Units:%d \n Range:60-80 Percent ',size(Units_NREM_RGS_More_Than_T3_Data,1)))
ylim([0 1])
% Finding mean and resultant 
mean_More_Than_T3_RGS=[];
for ii=1:size(Units_NREM_RGS_More_Than_T3_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_RGS_More_Than_T3_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_More_Than_T3_RGS=[mean_More_Than_T3_RGS; mean_per_unit];
    
    
end    
    
resultant_More_Than_T3_RGS=[];

for ii=1:size(Units_NREM_RGS_More_Than_T3_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_RGS_More_Than_T3_Data(ii).NREM_SW_Phases));
    
    resultant_More_Than_T3_RGS=[resultant_More_Than_T3_RGS; res_per_unit];
    
    
end

% Phase Lock Info
subplot(1,2,2)
hist_polar_RGS_More_Than_T3_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_RGS_More_Than_T3_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All RGS Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_RGS_More_Than_T3_Data,1),mean(mean_More_Than_T3_RGS),mean(resultant_More_Than_T3_RGS)))



figure('Name','Veh 60-80%')
% Normalized Histogram
subplot(1,2,1)

Norm_hist_Veh_More_Than_T3=histogram(vertcat(Units_NREM_Veh_More_Than_T3_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_Veh_More_Than_T3.BinCounts=Counts_Norm_Veh_More_Than_T3_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM Veh Histogram \n Units:%d \n Range:60-80 Percent ',size(Units_NREM_Veh_More_Than_T3_Data,1)))
ylim([0 1])
% Finding mean and resultant
mean_More_Than_T3_Veh=[];
for ii=1:size(Units_NREM_Veh_More_Than_T3_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_Veh_More_Than_T3_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_More_Than_T3_Veh=[mean_More_Than_T3_Veh; mean_per_unit];
    
    
end    
    
resultant_More_Than_T3_Veh=[];

for ii=1:size(Units_NREM_Veh_More_Than_T3_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_Veh_More_Than_T3_Data(ii).NREM_SW_Phases));
    
    resultant_More_Than_T3_Veh=[resultant_More_Than_T3_Veh; res_per_unit];
    
    
end

% Phase Lock Info
subplot(1,2,2)
hist_polar_Veh_More_Than_T3_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_Veh_More_Than_T3_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All Veh Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_Veh_More_Than_T3_Data,1),mean(mean_More_Than_T3_Veh),mean(resultant_More_Than_T3_Veh)))


%% More_Than_T4 Data (>80%)
figure('Name','RGS >80%')
% Normalized Histogram
subplot(1,2,1)

Norm_hist_RGS_More_Than_T4=histogram(vertcat(Units_NREM_RGS_More_Than_T4_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_RGS_More_Than_T4.BinCounts=Counts_Norm_RGS_More_Than_T4_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM RGS Histogram \n Units:%d \n Range:>80 Percent ',size(Units_NREM_RGS_More_Than_T4_Data,1)))

% Finding mean and resultant 
mean_More_Than_T4_RGS=[];
for ii=1:size(Units_NREM_RGS_More_Than_T4_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_RGS_More_Than_T4_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_More_Than_T4_RGS=[mean_More_Than_T4_RGS; mean_per_unit];
    
    
end    
    
resultant_More_Than_T4_RGS=[];

for ii=1:size(Units_NREM_RGS_More_Than_T4_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_RGS_More_Than_T4_Data(ii).NREM_SW_Phases));
    
    resultant_More_Than_T4_RGS=[resultant_More_Than_T4_RGS; res_per_unit];
    
    
end

% Phase Lock Info
subplot(1,2,2)
hist_polar_RGS_More_Than_T4_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_RGS_More_Than_T4_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All RGS Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_RGS_More_Than_T4_Data,1),mean(mean_More_Than_T4_RGS),mean(resultant_More_Than_T4_RGS)))



figure('Name','Veh >80%')
% Normalized Histogram
subplot(1,2,1)

Norm_hist_Veh_More_Than_T4=histogram(vertcat(Units_NREM_Veh_More_Than_T4_Data.NREM_SW_Phases),360,'BinWidth',1);Norm_hist_Veh_More_Than_T4.BinCounts=Counts_Norm_Veh_More_Than_T4_Final';
xlabel('Phase : 0-360');ylabel('Average Spikes during NREM')
title(sprintf('NREM Veh Histogram \n Units:%d \n Range:>80 Percent ',size(Units_NREM_Veh_More_Than_T4_Data,1)))

% Finding mean and resultant
mean_More_Than_T4_Veh=[];
for ii=1:size(Units_NREM_Veh_More_Than_T4_Data,1)
    
    mean_per_unit=circ_mean(deg2rad(Units_NREM_Veh_More_Than_T4_Data(ii).NREM_SW_Phases));
    
    mean_per_unit=rad2deg(mean_per_unit);
    if mean_per_unit<0
        mean_per_unit=mean_per_unit+360;
    end
    
    mean_More_Than_T4_Veh=[mean_More_Than_T4_Veh; mean_per_unit];
    
    
end    
    
resultant_More_Than_T4_Veh=[];

for ii=1:size(Units_NREM_Veh_More_Than_T4_Data,1)
    
    res_per_unit=circ_r(deg2rad(Units_NREM_Veh_More_Than_T4_Data(ii).NREM_SW_Phases));
    
    resultant_More_Than_T4_Veh=[resultant_More_Than_T4_Veh; res_per_unit];
    
    
end

% Phase Lock Info
subplot(1,2,2)
hist_polar_Veh_More_Than_T4_Combined=polarhistogram(deg2rad(vertcat(Units_NREM_Veh_More_Than_T4_Data.NREM_SW_Phases)), 18, 'FaceColor','g');
title(sprintf("All Veh Pyr Units Combined \n Units:%d \n Mean:%f degrees \n Resultant: %f",size(Units_NREM_Veh_More_Than_T4_Data,1),mean(mean_More_Than_T4_Veh),mean(resultant_More_Than_T4_Veh)))


%% Circular Statistics for Split Groups (Analysis in radians: Adrian Groups)

% RGS Last 20
Data_RGS=Units_NREM_RGS_More_Than_T4_Data;


mean_RGS_rad=[];median_RGS=[]; Res_Vec_RGS=[];
for i=1:size(Data_RGS,1)
    
    phase_vec_current_unit_deg=Data_RGS(i).NREM_SW_Phases;
    
    phase_in_rad=deg2rad(phase_vec_current_unit_deg);
    
    mean_RGS_rad=[mean_RGS_rad; circ_mean(phase_in_rad)];
    
%     median_RGS=[median_RGS; circ_median(phase_in_rad)];
        
    Res_Vec_RGS=[Res_Vec_RGS; circ_r(phase_in_rad)];
    
    
end

% Veh >20
Data_Veh=[Units_NREM_Veh_More_Than_T1_Data;Units_NREM_Veh_More_Than_T2_Data;Units_NREM_Veh_More_Than_T3_Data;Units_NREM_Veh_More_Than_T4_Data];


mean_Veh_rad=[];median_Veh=[]; Res_Vec_Veh=[];
for i=1:size(Data_Veh,1)
    
    phase_vec_current_unit_deg=Data_Veh(i).NREM_SW;
    
    phase_in_rad=deg2rad(phase_vec_current_unit_deg);
    
    mean_Veh_rad=[mean_Veh_rad; circ_mean(phase_in_rad)];
    
%     median_Veh=[median_Veh; circ_median(phase_in_rad)];
        
    Res_Vec_Veh=[Res_Vec_Veh; circ_r(phase_in_rad)];
    
    
end














 
   
