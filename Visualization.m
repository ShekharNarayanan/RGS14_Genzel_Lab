%% Firing rate vals VS Frequency
A=matfile('RAT_3_TEMP_SD_BEST_WFM.mat').Stored_WFMs;

Firing_Rate=extractfield(A,'Avg_Firing_Rate');
nbins               = 203;
h                   = histogram(Firing_Rate,nbins);
xlim([0 50]);
xlabel('Neurons')
ylabel('Firing Rate')
title('Firing Rate per Neuron')

%% Firing rate VS Time
%for iLab = 1:length(ax.YTickLabel)
    %lab             = str2num(ax.YTickLabel{iLab});
    %conv            = (lab / length(sptimes)) * nobins; 	% Convert to [Hz]: avg spike count * bins/sec
    %newlabel{iLab}  = num2str(round(conv));                 % Change YLabel
%end
%ax.YTickLabel       = newlabel;
%ax.YLabel.String  	= 'Firing Rate [Hz]';

tic
cd /


%% Initializing Main Variabes

Stored_WFMs=[];
Wave_Matrix_Data=[]; 
Wave_Matrix_Titles=[];
Curated_Spike_Times=[];

%% Reaching merged and cortex folders
A=load('RAT_9_TEMP_SD_BEST_WFM.mat');
root_rat= '/media/irene/Rat9/Spike_sorting';
study_day_dir= dir(root_rat); %Reaching the directory after user input
% remove all files (isdir property is 0)
study_day_dir= study_day_dir([study_day_dir(:).isdir]); 
% remove '.' and '..' 
study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));                        
study_day_folders=struct2cell(study_day_folders(:,1));
study_days=natsortfiles(study_day_folders(1,:));

for study_days_index=1:length(study_days) 
    if study_days_index==1
    
        
    root_prelim=strcat(root_rat,{'/'},string(study_days(study_days_index)));
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
   load('trials_durations_samples.mat'); 
    end
end    
X=[];X_Temp=[];
Count_Spike=0;

for i=1:size(A.curSpikeTimes,1)

end    
