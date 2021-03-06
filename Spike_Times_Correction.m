function Correct_SP_WFM=Spike_Times_Correction(Input_WFM)

%%%%% Run till merged folders vector
%%%%% loop for Stored WFM
%%%%% use strcmp SDX with elements in meregd folder
%%%%%% change directory accordingly
%%%%%% load trial duration file
%%%%%%% run spike removal script with corrected timestamps

%% Hard Drive Roots
root_rat1='/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat1_57986';
root_rat2='/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat2_57987';
root_rat3='/media/irene/MD04_RAT_SPIKE/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152';
root_rat4='/media/irene/GL13_RAT_BURSTY/Spike_sorting/Rat_OS_Ephys_RGS14_rat4_357153';
root_rat6='/media/irene/MD04_RAT_THETA/Spike_sorting/Rat_OS_Ephys_RGS14_rat6_373726';
root_rat7='/media/irene/GL14_RAT_FANO/Spikesorting/Rat_OS_Ephys_RGS14_rat7_373727';
root_rat8='/media/irene/GL13_RAT_BURSTY/Spike_sorting/Rat_OS_Ephys_RGS14_rat8_378133';
root_rat9='/media/irene/Rat9/Spike_sorting';


root_vector=[{root_rat1},{root_rat2},{root_rat3},{root_rat4},{''},{root_rat6},{root_rat7},{root_rat8},{root_rat9}]; %Arranging contents as if they were correct indices (Rat1-Rat9)

Units_Unchanged=Input_WFM;
Correct_SP_WFM=[];



% Units_FR_Analysis=Firing_Rate_Trials_SW(Units_Unchanged,[0 0 0 0 0 0]);

%% Correcting spikes


for unit_index=1:size(Units_Unchanged,1)
    
    fprintf("Starting process for Unit %d \n",unit_index)
    
    %% Extracting Information From Unit ID
    Unit_ID_Title=convertStringsToChars(Units_Unchanged(unit_index).WFM_Titles);
    Unit_ID_Split=regexp(Unit_ID_Title,'_','split');
    
    Unit_Rat=Unit_ID_Split{5}; % Answer='RnX' where X is the rat number
    
    Unit_Rat_Index=Unit_Rat(3);% Answer=X, where X is the rat number, now we will use it to load incorrect spike waveforms
    
    
    WFM_Data=Units_Unchanged(unit_index); %% Collecting data of the unit
    
    Unit_SD=Unit_ID_Split{7}; %Study Day
    
    %% Extracting Names of 'Merged' Folders where we will find Trial_Durations file
    Rat_Dir=root_vector(str2double(Unit_Rat_Index)); %% gets the rat directory from the root_vector
    
    study_day_dir= dir(string(Rat_Dir)); %Reaching the directory after user input
    % remove all files (isdir property is 0)
    study_day_dir= study_day_dir([study_day_dir(:).isdir]);
    % remove '.' and '..'
    study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));
    
    study_day_folders=struct2cell(study_day_folders(:,1));
    study_days=natsortfiles(study_day_folders(1,:));
    
    %% Reaching merged and cortex folders
    root_merged_vector=[];
    for study_days_index=1:length(study_days)
        
        root_prelim=strcat(Rat_Dir,{'/'},string(study_days(study_days_index)));
        root_prelim=convertStringsToChars(root_prelim);
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
        
        root_merged_vector=[root_merged_vector,strcat(root_prelim,{'/'},string(Merged_Folder))];
    end
    
    %% Collecting only SDX out of the whole SD Name from Hard Drive Roots
    Study_Day_Names=[];
    for i=1:length(study_days)
        K=strfind(study_days(i),'_SD');
        SD=convertStringsToChars(string(study_days(i)));
        SD=SD(K{1}+3:K{1}+4);
        SD=regexp(SD,'_','split');
        Study_Day_Names=[Study_Day_Names string(strcat('SD',SD{1}))];
    end
    
    %% Selecting the correct Merged Directory for our Unit
    for i=1:length(Study_Day_Names)
        if strcmp(Unit_SD,convertStringsToChars(Study_Day_Names(i)))
            Merged_Dir_Rat=root_merged_vector(i);
        end
    end
    
    
    %% Actual SW Analysis Starts Now:
    cd(Merged_Dir_Rat)
    % cd(root_merged_vector)
    
    %     load('trials_durations_samples.mat');
    
    %% Accomodating trial_duration excel sheet split
    Sheet=readtable('Trial_durations.xls','VariableNamingRule','preserve');

    Sheet_Array_Temp=table2array(Sheet(:,2:end));
    
    Sheet_Titles=Sheet.Properties.VariableNames;
    
    split_binary_vector=contains(Sheet_Titles(2:end), '_2'); % returns a binary vector where 1 will be assigned to titles containing '_2'
    
    split_index=find(split_binary_vector); % Finding index of the column that is split
    
    
    if sum(split_binary_vector)>1               %condition for breaking the code: Give Study Day and Rat Number
        sprintf("Rat number %s and study day %s has a labelling problem",Unit_Rat_Index,Unit_SD)
        break
    end
    
    if (sum(split_index)==0) || (size(Sheet_Array_Temp,2)==11) % if there is no split
        load('trials_durations_samples.mat');
        
        
    else
        split_index=int8(split_index);
        
        
        Sheet_Array_Temp(1,split_index-1)=Sheet_Array_Temp(1,split_index)+Sheet_Array_Temp(1,split_index-1); % Adding split and split-1 columns
        
        Sheet_Array_Temp(:,split_index)=[];% Removing Column '_2' values
        
        trial_durations=Sheet_Array_Temp(1,:); % Duration Vector ready to use
        
    end
    
    
    units=WFM_Data.curSpikeTimes; %% Collecting spikes from the unit data
    a=units;
    
    fsamp=30000;
    %cumsamp is the cumulative amount of samples throughout the recording.
    cumsamp=cumsum(trial_durations);
    %fixed_amount: Vector with the amount of samples that each trial/posttrial should have
    fixed_amount=[81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	324000000
        ];
    
    %%
    new=[];
    new(1)=fixed_amount(1);
    trial_ranges(1,:)=[0 new(1)]; % Range for presleep
    
    %Remove spikes above the first 45min of presleep
    if  cumsamp(1)>new(1)
        a=a(a(:) >= cumsamp(1) | a(:) < new(1));
    else
        %     ''Post trial shorter than it should be. Filling up''
        filler=new(1)-cumsamp(1);
        a(a>cumsamp(1))=a(a>cumsamp(1))+filler;
        cumsamp(1:end)=cumsamp(1:end)+filler;
        
    end
    
    
    %% Remove spikes above 5 or 45 min trials/posttrials
    for i=2:length(fixed_amount)
        %Find sample giving exactly 5/45 min. Must start counting at the actual end of
        %the previous trial/postrial
        new=[new cumsamp(i-1)+fixed_amount(i)];
        
        %Range of current trial/postrial
        trial_ranges(i,:)=[cumsamp(i-1) new(i)] ;
        
        %Remove extra spikes by only saving spikes that are below lower bound OR above
        %upper bound of the extra period.
        if  cumsamp(i)>new(i)
            a=a(a(:) >= cumsamp(i) | a(:) < new(i));
        else
            %         'Post trial shorter than it should be. Filling up'
            %xo
            filler=new(i)-cumsamp(i);
            a(a>cumsamp(i))=a(a>cumsamp(i))+filler;
            cumsamp(i:end)=cumsamp(i:end)+filler;% This will make cumsamp(i) have the same value as new(i)
            
        end
        
        
    end
    
    Shift=[];
    for i=2:length(fixed_amount) %Iterate across trials
        a_ind=(cumsamp(i-1)<a & a<new(i)); %Binary vector with samples within trial/posttrial period.
        shift=cumsamp(i-1)-new(i-1); %Duration of preceding 'Extra spikes' period (in samples).
        Shift=[Shift shift]; %Accumulate shifts.
        a(a_ind)=a(a_ind)-sum(Shift); %Substract the cumulative shift value to remove empty 'Extra spikes' period. (In case of shorter Post Trials, subtracts 0--> no change (Line: 158))
    end
    
    disp("Spikes are now corrected")
    %% Feeding Correct Values
    
    Correct_SP_WFM(unit_index).WFM_Titles=Unit_ID_Title;
    Correct_SP_WFM(unit_index).curSpikeTimes=a;
    Correct_SP_WFM(unit_index).Avg_Firing_Rate=size(a,1)/(sum(trial_durations)/fsamp);
    
    
    
end


end


