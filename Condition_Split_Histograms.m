function Condition_Wise_Data=Condition_Split_Histograms(Rat_x_Data, Data_Combined)
% % Segregate data from WFM Input into different conditions first
% % Collect Wake Data from each category and save as field in o/p variable

% [RP_Data,~,~]=FR_Analysis(Rat_x_Data);

Cond_String={'OR','OD','HC','CON'};
Exp_OR_Temp=[];Exp_OD_Temp=[];Exp_HC_Temp=[];Exp_CON_Temp=[];

% Wake_Data_Combined=RP_Data.Wake_Temp_Data;

for index1=1:size(Rat_x_Data,1)
    WFM_Title=Rat_x_Data(index1).WFM_Titles;
    WFM_Title=convertStringsToChars(WFM_Title);
    WFM_Title_All=regexp(WFM_Title,'_','split');
    Exp_Cond=WFM_Title_All{6};
    
    if strcmp(Exp_Cond,Cond_String{1})
        Exp_OR_Temp=[Exp_OR_Temp; Data_Combined(index1,:)];
        
    elseif strcmp(Exp_Cond,Cond_String{2})
        
        Exp_OD_Temp=[Exp_OD_Temp; Data_Combined(index1,:)];
   
    elseif strcmp(Exp_Cond,Cond_String{3})
        
        Exp_HC_Temp=[Exp_HC_Temp; Data_Combined(index1,:)];
        
   elseif strcmp(Exp_Cond,Cond_String{4})
        
        Exp_CON_Temp=[Exp_CON_Temp; Data_Combined(index1,:)];     
        
    end    
    
    
end


Condition_Wise_Data.FR_Data=[{Exp_OR_Temp}, {Exp_OD_Temp}, {Exp_HC_Temp} {Exp_CON_Temp}];










end