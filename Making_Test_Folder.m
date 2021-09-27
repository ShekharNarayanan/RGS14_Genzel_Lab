
cd /
root_source='/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring'; 
% route_destination='/home/irene/Downloads/RGS14_all_Shekhar/Concatenated_Sleep_Scoring_Files';%Change the first part of this variable to the directory of preference
route_destination='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels';
root_dir=dir(root_source);
root_dir=root_dir([root_dir(:).isdir]);
rat_folders = root_dir(~ismember({root_dir(:).name},{'.','..'}));
rat_folder_names=extractfield(rat_folders,'name');

for i=1:length(rat_folder_names)
    A=strcat(root_source,'/',rat_folder_names{i});
    mkdir(strcat(string(route_destination),'/',rat_folder_names{i}))
    cd(A)
    study_day_dir= dir(A); 
    study_day_dir= study_day_dir([study_day_dir(:).isdir]);
    study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));
    study_day_folder_names=natsort(extractfield(study_day_folders,'name'));
    
    for j=1:length(study_day_folder_names)
        B=strcat(A,'/',study_day_folder_names{j});
        cd(B)
%         sleep_scoring_files=dir('*.mat');
%         sleep_scoring_files=natsort(extractfield(sleep_scoring_files,'name'));
        C=strcat(route_destination,'/',rat_folder_names{i},'/',study_day_folder_names{j});
        new_directory=mkdir(C);
        
        %% Section specifically for sleep scoring file transfer (hash out and simply execute till the step before this line)
%         if numel(sleep_scoring_files)<8
%             continue
%         else 
%             %movefile('source', 'Destination')
%             movefile(strcat('Concatenated_Sleep_Scores','_',study_day_folder_names{j},'.mat'),C)
%             movefile(sleep_scoring_files{end},C)
%             
%         end    

        
    end    
end