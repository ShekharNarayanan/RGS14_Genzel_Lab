 

%% Session 1 selection for entire data sets
%RGS Treatment
% load('RGS14_GMM.mat');
load('RGS_GMM_2.mat');
% RGS_Pyr_Data=RGS14_GMM.Pyramidal_Cells;
% RGS_Inter_Data=RGS14_GMM.Interneurons;

RGS_Pyr_Data=RGS_GMM_2.Pyramidal_Cells;

% RGS_Pyr_Session_1=[]; RGS_Inter_Session_1=[];
RGS_Pyr_Session_1_GMM_2=[];

for session_index=1:size(RGS_Pyr_Data,2)
    
    WFM_Title=RGS_Pyr_Data(session_index).WFM_Titles;
    WFM_Title=convertStringsToChars(WFM_Title);
    Rat_Number=strfind(WFM_Title,'_Rn');
    Rat_Number_Input=strcat('Rat',WFM_Title(Rat_Number+3));
    
    
    
    Find_SD=strfind(WFM_Title,'_SD');
    SD_Number=WFM_Title(Find_SD+3:Find_SD+5);
    SD_Temp=regexp(SD_Number,'_','split');
    SD_Number_Input=strcat('SD',SD_Temp{1});
    
    [Sleep_Dir,SD_Folder_Name]=find_dict_rat(Rat_Number_Input,SD_Number_Input,'sleep_scoring');
    
    key_word_final=SD_Folder_Name(end);
    if strcmp(key_word_final,num2str(1))
        
%         RGS_Pyr_Session_1=[RGS_Pyr_Session_1; RGS_Pyr_Data(session_index)];
    RGS_Pyr_Session_1_GMM_2=[RGS_Pyr_Session_1_GMM_2; RGS_Pyr_Data(session_index)];
        

        
    end    
    
    
end    

for session_index=1:size(RGS_Inter_Data,1)
    
    WFM_Title=RGS_Inter_Data(session_index).WFM_Titles;
    WFM_Title=convertStringsToChars(WFM_Title);
    Rat_Number=strfind(WFM_Title,'_Rn');
    Rat_Number_Input=strcat('Rat',WFM_Title(Rat_Number+3));
    
    
    
    Find_SD=strfind(WFM_Title,'_SD');
    SD_Number=WFM_Title(Find_SD+3:Find_SD+5);
    SD_Temp=regexp(SD_Number,'_','split');
    SD_Number_Input=strcat('SD',SD_Temp{1});
    
    [Sleep_Dir,SD_Folder_Name]=sleep_dict_rat(Rat_Number_Input,SD_Number_Input);
    
    key_word_final=SD_Folder_Name(end);
    if strcmp(key_word_final,num2str(1))
        
        RGS_Inter_Session_1=[RGS_Inter_Session_1; RGS_Inter_Data(session_index)];
        

        
    end    
    
    
end 

RGS14_Session_1_GMM_2.Pyramidal_Cells=RGS_Pyr_Session_1_GMM_2;
RGS14_Session_1.Interneurons=RGS_Inter_Session_1;


% Vehicle
% load('Veh_GMM.mat')
load('Veh_GMM_2.mat')
% Veh_Pyr_Data=Veh_GMM.Pyramidal_Cells;
Veh_Pyr_Data=Veh_GMM_2.Pyramidal_Cells;
% Veh_Inter_Data=Vehicle.Interneurons;
% Veh_Pyr_Session_1=[]; Veh_Inter_Session_1=[];
Veh_Pyr_Session_1_GMM_2=[];

Veh_Pyr_S1_No_Rn3=[];

for session_index=1:size(Veh_Pyr_Data,2)
    
    WFM_Title=Veh_Pyr_Data(session_index).WFM_Titles;
    WFM_Title=convertStringsToChars(WFM_Title);
    Rat_Number=strfind(WFM_Title,'_Rn');
    Rat_Number_Input=strcat('Rat',WFM_Title(Rat_Number+3));
    
    
    
    Find_SD=strfind(WFM_Title,'_SD');
    SD_Number=WFM_Title(Find_SD+3:Find_SD+5);
    SD_Temp=regexp(SD_Number,'_','split');
    SD_Number_Input=strcat('SD',SD_Temp{1});
    
    [Sleep_Dir,SD_Folder_Name]=find_dict_rat(Rat_Number_Input,SD_Number_Input,'sleep_scoring');
    
    key_word_final=SD_Folder_Name(end);
    if strcmp(key_word_final,num2str(1))
        
        Veh_Pyr_Session_1_GMM_2=[Veh_Pyr_Session_1_GMM_2; Veh_Pyr_Data(session_index)];
        

        
    end    
    
    
end    
Vehicle_Session_1_GMM_2.Pyramidal_Cells=Veh_Pyr_Session_1_GMM_2;

for session_index=1:size(Veh_Inter_Data,1)
    
    WFM_Title=Veh_Inter_Data(session_index).WFM_Titles;
    WFM_Title=convertStringsToChars(WFM_Title);
    Rat_Number=strfind(WFM_Title,'_Rn');
    Rat_Number_Input=strcat('Rat',WFM_Title(Rat_Number+3));
    
    
    
    Find_SD=strfind(WFM_Title,'_SD');
    SD_Number=WFM_Title(Find_SD+3:Find_SD+5);
    SD_Temp=regexp(SD_Number,'_','split');
    SD_Number_Input=strcat('SD',SD_Temp{1});
    
    [Sleep_Dir,SD_Folder_Name]=sleep_dict_rat(Rat_Number_Input,SD_Number_Input);
    
    key_word_final=SD_Folder_Name(end);
    if strcmp(key_word_final,num2str(1))
        
        Veh_Inter_Session_1=[Veh_Inter_Session_1; Veh_Inter_Data(session_index)];
        

        
    end    
    
    
end 

Vehicle_Session_1.Pyramidal_Cells=Veh_Pyr_Session_1_GMM_2;
Vehicle_Session_1.Interneurons=Veh_Inter_Session_1;


%% Session 1 Data without Rat3
load('RGS_Session_1.mat');
RGS_Pyr_S1=RGS14_Session_1.Pyramidal_Cells;
load('Vehicle_Session_1.mat')
Veh_Pyr_S1=Vehicle_Session_1.Pyramidal_Cells;

RGS_Pyr_S1_No_Rn3=[];
RGS_Veh_S1_No_Rn3=[];

for i=1:size(RGS_Pyr_S1,1)
    WFM_Title=RGS_Pyr_S1(i).WFM_Titles;
    WFM_Title=convertStringsToChars(WFM_Title);
    Rat_Number=strfind(WFM_Title,'_Rn');
    Rat_Number_Input=WFM_Title(Rat_Number+3);
    
    if strcmp(num2str(3),Rat_Number_Input)
        continue
        
    else
        
        RGS_Pyr_S1_No_Rn3=[RGS_Pyr_S1_No_Rn3; RGS_Pyr_S1(i)];
        
    end    


end

for i=1:size(Veh_Pyr_S1,1)
    WFM_Title=Veh_Pyr_S1(i).WFM_Titles;
    WFM_Title=convertStringsToChars(WFM_Title);
    Rat_Number=strfind(WFM_Title,'_Rn');
    Rat_Number_Input=WFM_Title(Rat_Number+3);
    
    if strcmp(num2str(3),Rat_Number_Input)
        continue
        
    else
        
        RGS_Veh_S1_No_Rn3=[RGS_Veh_S1_No_Rn3; Veh_Pyr_S1(i)];
        
    end    


end
