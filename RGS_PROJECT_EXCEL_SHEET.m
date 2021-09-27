%%% Returns an excel sheet with all relevant info about the data
addpath('/home/irene/Downloads/RGS14_all_Shekhar/Cell_Classification Data')
Test_RGS14=load('RGS14.mat').RGS14_Units ;

Pyr_Cells_RGS=Test_RGS14.Pyramidal_Cells;

Single_Title=Pyr_Cells_RGS(1).WFM_Titles;

Column_Headings={'Project','Treatment','Part','Rat','Condition','Study_Day','Tetrode','ID','Channel','Avg_Firing_Rate'};

Split_Data=regexp([Pyr_Cells_RGS.WFM_Titles],'_','split');

Split_Data=Split_Data';


Cell_Array_Rgs_Pyr={};%cell(size(Pyr_Cells_RGS,1),10);
Temp_Cell={};
for range=1:size(Pyr_Cells_RGS,1)
    %% all columns useful in split data except 2
    temp_split=Split_Data{range};
    Temp_Cell={temp_split(1),temp_split(3),temp_split(4),temp_split(5),temp_split(6),temp_split(7),temp_split(8),temp_split(9),temp_split(10),Pyr_Cells_RGS(range).Avg_Firing_Rate};
    
    Cell_Array_Rgs_Pyr=[Cell_Array_Rgs_Pyr;Temp_Cell];
    
end    
    
%% Converting to Table
RGS_Project_Table_Test=cell2table(Cell_Array_Rgs_Pyr); 

%% Assigning Table Headings
RGS_Project_Table_Test.Properties.VariableNames=Column_Headings;