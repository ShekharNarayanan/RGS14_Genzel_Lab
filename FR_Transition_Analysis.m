%% Loading Data

load('RGS_Session_1.mat')
% load('RGS_Pyr_S1_No_Rn3.mat')
load('Vehicle_Session_1.mat') 


Pyr_RGS=RGS14_Session_1.Pyramidal_Cells;
Pyr_Veh=Vehicle_Session_1.Pyramidal_Cells;

%% Removing Outliers
Pyr_RGS(61)=[];
Pyr_RGS(41)=[];


% % Acquiring data for the plots
% Pyr_RGS_Unit_Wise_Data_norm=FR_Analysis_Threshold(Pyr_RGS,[20 10 20 15 20 100],'norm');
% Pyr_Veh_Unit_Wise_Data_norm=FR_Analysis_Threshold(Pyr_Veh,[20 10 20 15 20 100],'norm');

Pyr_RGS_Unit_Wise_Data_norm=FR_Analysis_Threshold(Pyr_RGS,[20 10 20 15 20 100]);
Pyr_Veh_Unit_Wise_Data_norm=FR_Analysis_Threshold(Pyr_Veh,[20 10 20 15 20 100]);

RGS_First=Pyr_RGS_Unit_Wise_Data_norm.First_10;
Veh_First=Pyr_Veh_Unit_Wise_Data_norm.First_10;

RGS_Last=Pyr_RGS_Unit_Wise_Data_norm.Last_10;
Veh_Last=Pyr_Veh_Unit_Wise_Data_norm.Last_10;


%% KS Test Values First

[~, p_KS_QW_RGS]=kstest2(RGS_First(:,1),[RGS_Last(:,1)]);
[~, p_KS_MA_RGS]=kstest2(RGS_First(:,2),[RGS_Last(:,2)]);
[~, p_KS_NREM_RGS]=kstest2(RGS_First(:,3),[RGS_Last(:,3)]);
[~, p_KS_Intermediate_RGS]=kstest2(RGS_First(:,4),[RGS_Last(:,4)]);
[~, p_KS_REM_RGS]=kstest2(RGS_First(:,5),[RGS_Last(:,5)]);


%% KS Test Values Last

[~, p_KS_QW_Veh]=kstest2(Veh_First(:,1),[Veh_Last(:,1)]);
[~, p_KS_MA_Veh]=kstest2(Veh_First(:,2),[Veh_Last(:,2)]);
[~, p_KS_NREM_Veh]=kstest2(Veh_First(:,3),[Veh_Last(:,3)]);
[~, p_KS_Intermediate_Veh]=kstest2(Veh_First(:,4),[Veh_Last(:,4)]);
[~, p_KS_REM_Veh]=kstest2(Veh_First(:,5),[Veh_Last(:,5)]);





%% First 10 seconds
Periods={'Quiet Wake', 'Microarousal', 'NREM', 'Intermediate', 'REM'};
% format long;
p_value_vector_RGS=[p_KS_QW_RGS p_KS_MA_RGS p_KS_NREM_RGS p_KS_Intermediate_RGS p_KS_REM_RGS];
p_value_vector_Veh=[p_KS_QW_Veh p_KS_MA_Veh p_KS_NREM_Veh p_KS_Intermediate_Veh p_KS_REM_Veh];

segment_length_vector=[10 5 10 7 10];
bin_width=.6;

for a=1:5
    
    figure('Name',Periods{a})
    
    subplot(1,2,1)
    hold on;
    h_1=histogram(RGS_First(:,a),'FaceColor','b');h_1.BinWidth=bin_width;
    x1_temp=h_1.BinCounts; x1=sum(x1_temp(15:end)); x1_vec=15*ones(x1,1);
    
    histogram(x1_vec,'FaceColor','b','BinWidth',bin_width);
    
    h_2=histogram(RGS_Last(:,a),'FaceColor','c');h_2.BinWidth=bin_width;
    x2_temp=h_1.BinCounts; x2=sum(x2_temp(15:end)); x2_vec=15*ones(x2,1);
    
    histogram(x2_vec,'FaceColor','c','BinWidth',bin_width);

    xlim([0 16])
    legend([h_1 h_2],'First Period','Last Period')
    xlabel('Firing Rate Across Rest Periods');ylabel('Number of Neurons');
    title(sprintf("%s RGS: pvalue from KS Test= %d \n segment length=%d",Periods{a},p_value_vector_RGS(a),segment_length_vector(a)))
    hold off;
    
    subplot(1,2,2)
    hold on;
    h_3=histogram(Veh_First(:,a),'FaceColor','b');h_3.BinWidth=bin_width;
%     x3_temp=h_1.BinCounts; x3=sum(x3_temp(15:end)); x3_vec=15*ones(x1,1);
%     
%     histogram(x3_vec,'FaceColor','b','BinWidth',bin_width);
    
    h_4=histogram(Veh_Last(:,a),'FaceColor','c');h_4.BinWidth=bin_width;
%     x4_temp=h_1.BinCounts; x4=sum(x4_temp(15:end)); x4_vec=15*ones(x2,1);
%     
%     histogram(x4_vec,'FaceColor','c','BinWidth',bin_width);

    xlim([0 16])
    legend([h_3 h_4],'First Period','Last Period')
    xlabel('Firing Rate Across Rest Periods');ylabel('Number of Neurons');
    title(sprintf("%s Vehicle : pvalue from KS Test= %d \n segment length=%d",Periods{a},p_value_vector_Veh(a),segment_length_vector(a)))
    hold off;
    
end  
