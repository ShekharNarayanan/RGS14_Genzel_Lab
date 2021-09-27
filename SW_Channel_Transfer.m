%% Roots Hard Drive
root_rat1='/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat1_57986';
root_rat2='/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat2_57987';
root_rat3='/media/irene/MD04_RAT_SPIKE/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152';
root_rat4='/media/irene/GL13_RAT_BURSTY/Spike_sorting/Rat_OS_Ephys_RGS14_rat4_357153';
root_rat6='/media/irene/MD04_RAT_THETA/Spike_sorting/Rat_OS_Ephys_RGS14_rat6_373726';
root_rat7='/media/irene/GL14_RAT_FANO/Spikesorting/Rat_OS_Ephys_RGS14_rat7_373727';
root_rat9='/media/irene/Rat9/Spike_sorting';


root_vector=[{root_rat1},{root_rat2},{root_rat3},{root_rat4},{root_rat6},{root_rat7},{root_rat9}];

%% Channel Names Cortex(Go to line X to confirm)
rat_1_channel='100_CH47.continuous'; %Changed Later to 47
rat_2_channel='100_CH52.continuous';
rat_3_channel='100_CH20.continuous';
rat_4_channel='100_CH44.continuous';
rat_6_channel='100_CH2.continuous';
rat_7_channel='100_CH48.continuous';
%rat 8
rat_9_channel='100_CH26.continuous';

Channel_Vector_PFC=[{rat_1_channel},{rat_2_channel},{rat_3_channel},{rat_4_channel},{rat_6_channel},{rat_7_channel},{rat_9_channel}];

%% Channel Names HPC(Go to line X to confirm)
rat_1_channel_hpc='100_CH4.continuous';
rat_2_channel_hpc='100_CH17.continuous';
rat_3_channel_hpc='100_CH34.continuous';
rat_4_channel_hpc='100_CH52.continuous';
rat_6_channel_hpc='100_CH33.continuous';
rat_7_channel_hpc='100_CH16.continuous';
%rat8
rat_9_channel_hpc='100_CH9.continuous';

Channel_Vector_HPC=[{rat_1_channel_hpc},{rat_2_channel_hpc},{rat_3_channel_hpc},{rat_4_channel_hpc},{rat_6_channel_hpc},{rat_7_channel_hpc},{rat_9_channel_hpc}];



%% Select SW Root
R1_SW='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels/Rat1_57986';

R2_SW='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels/Rat2_57987';

R3_SW='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels/Rat3_357152';

R4_SW='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels/Rat4_357153';

R6_SW='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels/Rat6_373726';

R7_SW='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels/Rat7_373727';



R9_SW='/home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels/Rat9_378134';

SW_Root_Vector=[{R1_SW},{R2_SW},{R3_SW},{R4_SW},{R6_SW},{R7_SW},{R9_SW}];



for root_index=1%6%:length(root_vector)
    
    %% HDD Root

    root_rat=root_vector{root_index};
    study_day_dir= dir(root_rat); %Reaching the directory after user input
    % remove all files (isdir property is 0)
    study_day_dir= study_day_dir([study_day_dir(:).isdir]);
    % remove '.' and '..'
    study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));
    study_day_folders=struct2cell(study_day_folders(:,1));
    study_days_HDD=natsortfiles(study_day_folders(1,:));
    
    %% SW Root
    SW_Root_x=SW_Root_Vector{root_index}; %% Confirm Rat Number, Go to Line: 129
    
    study_day_dir= dir(SW_Root_x); %Reaching the directory after user input
    % remove all files (isdir property is 0)
    study_day_dir= study_day_dir([study_day_dir(:).isdir]);
    % remove '.' and '..'
    study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));
    study_day_folders=struct2cell(study_day_folders(:,1));
    study_days_SW_temp=natsortfiles(study_day_folders(1,:));
    
    study_days_SW=[];
    
     if root_index==3
        x=study_days_HDD{end};
        study_days_HDD(end)=[];
        study_days_HDD=[x study_days_HDD];
        
    end    
    
    for i=1:length(study_days_SW_temp)
        SW_Temp=study_days_SW_temp{i};
        SW_Split=regexp(SW_Temp,'_','split');
        SW_Split=SW_Split{3};
   
        for j=1:length(study_days_HDD)
            HDD_Temp=study_days_HDD{j};
            HDD_Split=regexp(HDD_Temp,'_','split');
            
%             if root_index==6
                HDD_Split=HDD_Split{7};
%             
%             else
%                 HDD_Split=HDD_Split{6};
%             
%             end
            
            if strcmp(SW_Split,HDD_Split)
                study_days_SW=[study_days_SW study_days_SW_temp(i)];
            end    
            
          
            
        end
    end    
    
    
   
    
    %% Choosing Correct Channel (EITHER HPC OR CORTEX)
    rat_channel=Channel_Vector_PFC{root_index};
    
for study_days_index=1:length(study_days_SW) 
    
    SD_SW=study_days_SW{study_days_index};
    SW_Dir=strcat(string(SW_Root_x),'/',string(SD_SW));
    
    root_prelim=strcat(root_rat,{'/'},string(study_days_HDD(study_days_index)));
    root_merged_dir=dir(root_prelim);
    root_merged_dir=root_merged_dir([root_merged_dir(:).isdir]);
    root_merged_folders=root_merged_dir(~ismember({root_merged_dir(:).name},{'.','..'}));
    
    root_folder_names=extractfield(root_merged_folders,'name');
    for i=1:length(root_folder_names)
  
      X=string(root_folder_names(i));
      X=convertStringsToChars(X);
      if ismember('Post',X)
          Post_Trial=X;
      else
          Merged_Folder=X;
      end
    end 
    
    root_merged=strcat(root_prelim,{'/'},string(Merged_Folder));
    addpath(root_merged)
   
%% Decide for HPC or Cortex Here    
    root_cortex=strcat(root_merged,{'/'},'cortex'); % can be changed for hpc
%     root_hpc=strcat(root_merged,{'/'},'hpc');
    root=root_cortex;
    
    %% Getting folders for tetrodes (accomodates for hpc)
      tetrodes_dir=dir(root);
      tetrodes_dir=tetrodes_dir([tetrodes_dir(:).isdir]);
      tetrodes_folders=tetrodes_dir(~ismember({tetrodes_dir(:).name},{'.','..'}));
      tetrodes=natsortfiles(extractfield(tetrodes_folders(:,1),'name')); 


      for folder=1:length(tetrodes)
    

          
          Tetrode_Dir=strcat(root,{'/'},string(tetrodes(folder)));
          cd (Tetrode_Dir)
          channel_list=dir('*.continuous*');                 %Storing .continuous files in a struct
          channel_names=struct2cell(channel_list);           %converting struct to cell for accessing channel names
          channels_in_use=numel(channel_names(1,:));
          Channels_array=[];
          for i=1:channels_in_use
              Channels_array=[Channels_array;string(channel_names(1,i))]; %only contains channel names; without other data from the struct
          end
          
          
          for channel_index=1:length(Channels_array)
%               cd (strcat(root,{'/'},string(tetrodes(folder))))
              
              if strcmp(rat_channel,Channels_array{channel_index})

%                   X=mkdir(SW_Dir,'HPC');
                  X_string=strcat(string(SW_Dir),'/','PFC');
                  
                  copyfile(Channels_array{channel_index},X_string)
                  
                 
                  
              end    
              

          end
          
      end       
end
end
cd /home/irene/Downloads/RGS14_all_Shekhar/Slow_Wave_Best_Channels
