function Condition_Wise_Data_Wake=Condition_Split(Rat_x_Data, Data_Combined)
% % Segregate data from WFM Input into different conditions first
% % Collect Wake Data from each category and save as field in o/p variable

% [RP_Data,~,~]=FR_Analysis(Rat_x_Data);

Cond_String={'OR','OD','HC','CON'};
Exp_OR_Temp=[];Exp_OD_Temp=[];Exp_HC_Temp=[];Exp_CON_Temp=[];

% Wake_Data_Combined=RP_Data.Wake_Temp_Data;

for index1=1:size(Rat_x_Data,2)
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
Exp_OR=[];Exp_OD=[];Exp_HC=[];Exp_CON=[];
Exp_OR_SEM=[];Exp_OD_SEM=[];Exp_HC_SEM=[];Exp_CON_SEM=[];

for i=1:size(Exp_OR_Temp,2)
    Exp_OR=[Exp_OR; nanmean(Exp_OR_Temp(:,i))]; 
    Exp_OR_SEM=[Exp_OR_SEM; SEM_Shekhar(Exp_OR_Temp(:,i))];
end    

for i=1:size(Exp_HC_Temp,2)
    Exp_HC=[Exp_HC; nanmean(Exp_HC_Temp(:,i))]; 
    Exp_HC_SEM=[Exp_HC_SEM; SEM_Shekhar(Exp_HC_Temp(:,i))];
    
end 

for i=1:size(Exp_OD_Temp,2)
    Exp_OD=[Exp_OD; nanmean(Exp_OD_Temp(:,i))]; 
    Exp_OD_SEM=[Exp_OD_SEM; SEM_Shekhar(Exp_OD_Temp(:,i))];
end 

for i=1:size(Exp_CON_Temp,2)
    Exp_CON=[Exp_CON; nanmean(Exp_CON_Temp(:,i))]; 
    Exp_CON_SEM=[Exp_CON_SEM; SEM_Shekhar(Exp_CON_Temp(:,i))];
end 

Condition_Wise_Data_Wake.FR_Data=[Exp_OR Exp_OD Exp_HC Exp_CON];
Condition_Wise_Data_Wake.SEM_Data=[Exp_OR_SEM Exp_OD_SEM Exp_HC_SEM Exp_CON_SEM];










end