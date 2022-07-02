% The main goal of this script is to study the phase locking behaviour of
% neurons in both treatments.
% 
% It uses input data containining NREM sleep spikes and
% corresponding phases for each neuron in the entire study day. 
% 
% Using the neuron IDs, the script loads the sleep scoring file for each
% neuron (and Study Day) and collects the total duration of NREM sleep in minutes.
% The spike count is collected for 10 degree bins (36 total). This count is
% divided by the duration of nrem for the corresponding neuron to get normalized phase
% locked activity.
%
%*Note: For the Spikes to SO phase figure, the variables
%Counts_RGS_Nrem_Norm and Counts_Veh_Nrem_Norm were first split into groups
%and then later visualized in graphpad.
%
% Functions used: find_dict_rat.m


%% Loading Input Data
RGS_Phase=load('Phase_Vector_Slow_Wave_Pyr_RGS_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_RGS_Session_1;
Veh_Phase=load('Phase_Vector_Slow_Wave_Pyr_Veh_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_Veh_Session_1;

%% Correcting for Outliers Lisa found

% Loading excel sheets and collecting Neuron IDs and Wake firing rates
% used for new threshold for groups
Corrected_Var_RGS= table2struct(readtable('Stage_Wise_Unit_Wise_FR_Data_Both_Treatments_wexclusion.xlsx','Sheet',1));
RGS_Useful_Data= [{{Corrected_Var_RGS(:).NeuronIDs}'} ,{[Corrected_Var_RGS.Wake]'}];
Corrected_Var_Veh= table2struct(readtable('Stage_Wise_Unit_Wise_FR_Data_Both_Treatments_wexclusion.xlsx','Sheet',2));
Veh_Useful_Data= [{{Corrected_Var_Veh(:).NeuronIDs}'} ,{[Corrected_Var_Veh.Wake]'}];

%% Name collection for corrected Data
% RGS
RGS_Phase_Temp=[]; Veh_Phase_Temp =[];
for i1=1:length(RGS_Useful_Data{1})
    Names=RGS_Useful_Data{1};
    Name=Names{i1};
    for i2=1:length(RGS_Phase)
        if strcmp(RGS_Phase(i2).WFM_Titles,Name)
            RGS_Phase_Temp=[RGS_Phase_Temp; RGS_Phase(i2)];
        end
    end
       
end

%Veh
for i1=1:length(Veh_Useful_Data{1})
    Names=Veh_Useful_Data{1};
    Name=Names{i1};
    for i2=1:length(Veh_Phase)
        if strcmp(Veh_Phase(i2).WFM_Titles,Name)
            Veh_Phase_Temp=[Veh_Phase_Temp; Veh_Phase(i2)];
        end
    end
    
    
end

%% Replacing Data with Temp Data
% doing this ^ helps us run the remaining part (relevant) of the script
% without changing local variables
RGS_Phase = RGS_Phase_Temp';
Veh_Phase = Veh_Phase_Temp';


% % Collecting Normalized NREM Counts
Counts_RGS_Nrem_Norm=[];
for i=1:size(RGS_Phase,2)
    
    % gathering info about Neuron ID
    Unit_ID = convertStringsToChars(RGS_Phase(i).WFM_Titles);
    Unit_ID_split = regexp(Unit_ID,'_','split');
    Rat_num = Unit_ID_split{5}; Rat_num = Rat_num(3);
    Rat_Number_Input = strcat('Rat',Rat_num);
    SD_num  = Unit_ID_split{7};
    
    % using neuron ID to retrieve relevant sleep scoring directory
    [final_directory,final_SD_Folder_name]=find_dict_rat(Rat_Number_Input,SD_num,'sleep_scoring');
    cd(final_directory)
    
    files_dir= dir(string(final_directory)); %Browsing the directory
    
    [size_check, index] = max([files_dir.bytes]); %loading concatenated sleep scoring file-- the concatenated file has the largest size
    load(files_dir(index).name)
    
    nrem_len_mins = length(find(states_corrected_final==3))/60; % duration of NREM sleep (minutes) in the corresponding study day
    
    figure('name','inloopfig','Visible', 'off')
    hist_RGS=histogram(RGS_Phase(i).NREM_SW_Phases,36,'FaceColor','k');
    
    Counts_RGS_NREM_Norm_temp = hist_RGS.BinCounts/nrem_len_mins; % spikes in NREM normalized with duration of NREM
    
    Counts_RGS_Nrem_Norm =  [Counts_RGS_Nrem_Norm Counts_RGS_NREM_Norm_temp']; % collecting nrem normalized counts for each neuron
end


% Vehicle
Counts_Avg_Veh_Temp=[];Counts_Veh_Nrem_Norm =[];
for i=1:size(Veh_Phase,2)
    
    Unit_ID = convertStringsToChars(Veh_Phase(i).WFM_Titles);
    Unit_ID_split = regexp(Unit_ID,'_','split');
    Rat_num = Unit_ID_split{5}; Rat_num = Rat_num(3);
    Rat_Number_Input = strcat('Rat',Rat_num);
    SD_num  = Unit_ID_split{7};
    
    [final_directory,final_SD_Folder_name]=find_dict_rat(Rat_Number_Input,SD_num,'sleep_scoring');
    cd(final_directory)
    
    files_dir= dir(string(final_directory)); %Reaching the directory
  
    [size_check, index] = max([files_dir.bytes]); %loading concatenated sleep scoring file
    load(files_dir(index).name)
    
    nrem_len_mins = length(find(states_corrected_final==3))/60;
    
    figure('name','inloopfig','Visible', 'off')
    hist_Veh=histogram(Veh_Phase(i).NREM_SW_Phases,36,'FaceColor','k');
    
    Counts_Veh_NREM_Norm_temp = hist_Veh.BinCounts/nrem_len_mins;

    Counts_Veh_Nrem_Norm =  [Counts_Veh_Nrem_Norm Counts_Veh_NREM_Norm_temp']; % data per neuron
end


