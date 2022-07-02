function [final_directory,final_SD_Folder_name]=find_dict_rat(Rat_Number_Input,SD_Number_Input,keyword)

% Throughout the project, there was a need to load specific files (sleep scoring files or slow wave data) based on the ID of the neuron.
% Because of the complex and nested organization of data, this function was used to retrieve and load files per neuron ID wherever needed.



%% Input Rat Number example: Rat1
%% Input SD_Number example: SD14

if strcmp(keyword,'sleep_scoring')
    
    dict='/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring';
    
elseif strcmp(keyword,'slow_wave')
    
    dict='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels';
    
    
end

addpath(dict)
rat_dir= dir(dict);
rat_dir= rat_dir([rat_dir(:).isdir]);
rat_folders = rat_dir(~ismember({rat_dir(:).name},{'.','..'}));

rat_folder_names=natsort(extractfield(rat_folders,'name'));%get rat name

for rat_number_index=1:length(rat_folder_names)
    rat_num_folder=regexp(rat_folder_names{rat_number_index},'_','split');
    rat_num_folder=rat_num_folder{1};
    
    if strcmp(Rat_Number_Input,rat_num_folder)
        rat_directory_final=strcat(dict,'/',rat_folder_names{rat_number_index});
        
        
        cd(rat_directory_final)
        study_day_dir= dir(rat_directory_final);
        study_day_dir= study_day_dir([study_day_dir(:).isdir]);
        study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));
        study_day_folder_names=natsort(extractfield(study_day_folders,'name'));
        
        for SD_Index=1:length(study_day_folder_names)
            SD_Folder_Name=study_day_folder_names{SD_Index};
            Find_SD=strfind(SD_Folder_Name,'_SD');
            
            SD_Number=SD_Folder_Name(Find_SD+3:Find_SD+5);
            SD_Temp=regexp(SD_Number,'_','split');
            SD_Final=strcat('SD',SD_Temp{1});
            
            if strcmp(SD_Number_Input,SD_Final)
                SD_Dir=strcat(rat_directory_final,'/',SD_Folder_Name);
                final_directory=SD_Dir;
                
                final_SD_Folder_name=SD_Folder_Name;
                
                cd(final_directory)
            end
        end
    end
    
    
    
    
end

end