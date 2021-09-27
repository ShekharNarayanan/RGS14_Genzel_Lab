function Phase_Vector=Slow_Wave_Analysis(Input_WFM,Brain_Part)
% % Slightly Modified from Spike_Times_Correction. Does not need any string
% inputs, only Input Waveform

%% Hard Drive Roots
root_rat1='/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat1_57986';
root_rat2='/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat2_57987';
root_rat3='/media/irene/MD04_RAT_SPIKE/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152';
root_rat4='/media/irene/GL13_RAT_BURSTY/Spike_sorting/Rat_OS_Ephys_RGS14_rat4_357153';
root_rat6='/media/irene/MD04_RAT_THETA/Spike_sorting/Rat_OS_Ephys_RGS14_rat6_373726';
root_rat7='/media/irene/GL14_RAT_FANO/Spikesorting/Rat_OS_Ephys_RGS14_rat7_373727';
root_rat9='/media/irene/Rat9/Spike_sorting';


root_vector=[{root_rat1},{root_rat2},{root_rat3},{root_rat4},{''},{root_rat6},{root_rat7},{''},{root_rat9}]; %Arranging contents as if they were correct indices

Units_Unchanged=Input_WFM;
Correct_SP_WFM_Temp=[];  Phase_Vector=[];

if strcmp(Brain_Part,'pfc')
    Part_Case=1;
elseif strcmp(Brain_Part,'hpc')
    Part_Case=2;
end

% Units_FR_Analysis=Firing_Rate_Trials_SW(Units_Unchanged,[0 0 0 0 0 0]);



for unit_index=31%size(Units_Unchanged,1)
    
    %     try
    
    fprintf("Starting process for Unit %d \n",unit_index)
    
    %% Extracting Information From Unit ID
    Unit_ID_Title=convertStringsToChars(Units_Unchanged(unit_index).WFM_Titles);
    Unit_ID_Split=regexp(Unit_ID_Title,'_','split');
    
    Unit_Rat=Unit_ID_Split{5}; % Answer='RnX' where X is the rat number
    
    Unit_Rat_Index=Unit_Rat(3);% Answer=X, where X is the rat number, now we will use it to load incorrect spike waveforms
    
    WFM_Name=strcat('RAT_',string(Unit_Rat_Index),'_TEMP_SD_BEST_WFM.mat');
    WFM_Data_All=load(WFM_Name).Stored_WFMs;
    
    for ii=1:size(WFM_Data_All,1)
        title_index=WFM_Data_All(ii).WFM_Titles;
        
        if strcmp(Unit_ID_Title,title_index)
            WFM_Data=WFM_Data_All(ii);
        end
        
    end
    
    
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
        if strcmp(Unit_SD,Study_Day_Names(i))
            Merged_Dir_Rat=root_merged_vector(i);
        end
    end
    
    
    
    %% Cortex
    
    %% Actual SW Analysis Starts Now:
    cd(Merged_Dir_Rat)
    
    load('trials_durations_samples.mat');
    
    units=WFM_Data.curSpikeTimes;
    a=units;
    
    fsamp=30000;
    %cumsamp is the cumulative amount of samples throughout the recording.
    cumsamp=cumsum(trial_durations);
    %fixed_amount: Vector with the amount of samples that each trial/posttrial should have
    fixed_amount=[81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	324000000
        ];
    switch Part_Case
        case 1
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
            
            Correct_SP_WFM_Temp(unit_index).WFM_Titles=Unit_ID_Title;
            Correct_SP_WFM_Temp(unit_index).curSpikeTimes=a;
            Correct_SP_WFM_Temp(unit_index).Avg_Firing_Rate=size(a,1)/(sum(trial_durations)/fsamp);
            
            Current_Unit=Firing_Rate_Trials_SW(Correct_SP_WFM_Temp(unit_index),[0 0 0 0 0 0]);
            
            %% NREM Spike Times for Current Unit
            
            
            Presleep=Current_Unit.Presleep;
            Post_Trial_1=Current_Unit.Post_Trial_1;
            Post_Trial_2=Current_Unit.Post_Trial_2;
            Post_Trial_3=Current_Unit.Post_Trial_3;
            Post_Trial_4=Current_Unit.Post_Trial_4;
            Post_Trial_5=Current_Unit.Post_Trial_5_All;
            
            PT5_1=Post_Trial_5.PT5_Part_1;
            PT5_2=Post_Trial_5.PT5_Part_2;
            PT5_3=Post_Trial_5.PT5_Part_3;
            PT5_4=Post_Trial_5.PT5_Part_4;
            
            NREM_All_Current_Unit=vertcat(Presleep.NREM_Spikes,Post_Trial_1.NREM_Spikes,...
                Post_Trial_2.NREM_Spikes,Post_Trial_3.NREM_Spikes,Post_Trial_4.NREM_Spikes,...
                PT5_1.NREM_Spike_Times,PT5_2.NREM_Spike_Times,PT5_3.NREM_Spike_Times,PT5_4.NREM_Spike_Times); %% These spikes will be used with phase of the lfp channel
            
            
            %% Loading The Best Channel
            Rat_Number=strcat('Rat',Unit_Rat_Index);
            Rat_SD=Unit_SD;
            [SW_directory,~]=find_dict_rat(Rat_Number,Rat_SD,'slow_wave'); %% Also performs cd(SW_directory)
            
            %% Load PFC channel
            PFC_Dir=strcat(SW_directory,'/','cortex');
            %     HPC_Dir=strcat(SW_directory,'/','HPC');
            
            cd(PFC_Dir) %Decide here
            
            channel=dir('*.continuous*').name;
            
            
            [lfp,~]=load_open_ephys_data(channel); % loading lfp channel
            
            %In case there are any NaNs (not likely), convert to zero
            if  sum(isnan(lfp))>0
                lfp(isnan(lfp))=0;
            end
            
            fn=30000; %1 kHz Sampling for Ripples
            
            
            Wn1=[4/(fn/2) ]; % low pass is below 4 Hz
            [b1,a1] = butter(3,Wn1,'low'); %Filter coefficients
            lfp=filtfilt(b1,a1,lfp);
            
            %HPC Modification: No need for
            phase_degrees=mod(rad2deg(angle(hilbert(lfp))),360); % Raw Data, Not Spike Corrected
            
            %cumsamp is the cumulative amount of samples throughout the recording.
            cumsamp=cumsum(trial_durations);
            %fixed_amount: Vector with the amount of samples that each trial/posttrial should have
            fixed_amount=[81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	324000000
                ];
            
            
            new=[];
            new(1)=fixed_amount(1);
            trial_ranges(1,:)=[0 new(1)]; % Range for presleep
            
            
            %CASE 1: Periods longer than 5 or 45 min. Remove extra spikes periods.
            if  cumsamp(1)>new(1) %Extra spikes period
                
                phase_degrees(new(1)+1:cumsamp(1))=NaN; %Makes extra samples NaNs to remove later.
                
                %CASE 2: Periods shorter than the 5/45 min we expected. Requires filling.
            else
                filler=new(1)-cumsamp(1); %Find size of filler
                
                %Need to also include a filler for the lfp. We fill with zeros
                phase_degrees=[ phase_degrees(1:cumsamp(1)) ;  (zeros(filler,1)); phase_degrees(cumsamp(1)+1:end)];
                
                
            end
            
            %% Correct Channel Data
            for i=2:length(fixed_amount)
                %Find sample giving exactly 5/45 min. Must start counting at the actual end of
                %the previous trial/postrial
                new=[new cumsamp(i-1)+fixed_amount(i)];
                
                
                %CASE 1: Periods longer than 5 or 45 min.
                
                if  cumsamp(i)>new(i)
                    
                    phase_degrees(new(i)+1:cumsamp(i))=NaN;
                    %CASE 2: Periods shorter than the 5/45 min we expected. Requires filling.
                else
                    
                    filler=new(i)-cumsamp(i);
                    
                    %Need to also include a filler for the lfp. We fill with zeros
                    phase_degrees=[ phase_degrees(1:cumsamp(i)) ;  (zeros(filler,1)); phase_degrees(cumsamp(i)+1:end)];
                    
                    
                end
                
            end
            
            disp("LFP channel corrected for cortex")
            phase_degrees(isnan(phase_degrees)) = [];
            phase_overlap_sptimes=phase_degrees(NREM_All_Current_Unit+1);
            
            disp("Phase overlap successful")
            Phase_Vector(unit_index).WFM_Titles=Unit_ID_Title;
            Phase_Vector(unit_index).NREM_SW_Phases=phase_overlap_sptimes;
            Phase_Vector(unit_index).NREM_SW_Spikes=NREM_All_Current_Unit;
            
            
        case 2
            %% HPC
            
            %% Loading The Best Channel
            Rat_Number=strcat('Rat',Unit_Rat_Index);
            Rat_SD=Unit_SD;
            [SW_directory,~]=find_dict_rat(Rat_Number,Rat_SD,'slow_wave'); %% Also performs cd(SW_directory)
            
            %% Load  HPC Channel
            
            HPC_Dir=strcat(SW_directory,'/','HPC');
            
            cd(HPC_Dir) %Decide here
            
            channel=dir('*.continuous*').name;
            
            
            [lfp,~]=load_open_ephys_data(channel); % loading lfp channel
            
            %In case there are any NaNs (not likely), convert to zero
            if  sum(isnan(lfp))>0
                lfp(isnan(lfp))=0;
            end
            
            % Applying low pass filter 
            fs=30000; 

            Wn1=[500/(fs/2) ]; % Cutoff=300-6000 Hz
            [b1,a1] = butter(3,Wn1,'low'); %Filter coefficients
            lfp=filtfilt(b1,a1,lfp);
            
            % downsampling the signal to 1kHz
%             lfp=downsample(lfp,30); %(30000/30)
            
            % Applying the band pass filter to the downsampled channel
%             fn=1000;%1 kHz Sampling for Ripples
%             
%             Wn2=[100/(fn/2) 300/(fn/2)]; % Cutoff=100-300 Hz
%             
%             [b2,a2] = butter(3,Wn2,'bandpass'); %Filter coefficients
%             
%             lfp=filtfilt(b2,a2,lfp);
            
            
            
            
            %cumsamp is the cumulative amount of samples throughout the recording.
            cumsamp=cumsum(trial_durations);
            %fixed_amount: Vector with the amount of samples that each trial/posttrial should have
            fixed_amount=[81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	324000000
                ];
            
            
            new=[];
            new(1)=fixed_amount(1);
            trial_ranges(1,:)=[0 new(1)]; % Range for presleep
            
            
            %CASE 1: Periods longer than 5 or 45 min. Remove extra spikes periods.
            if  cumsamp(1)>new(1) %Extra spikes period
                
                lfp(new(1)+1:cumsamp(1))=NaN; %Makes extra samples NaNs to remove later.
                
                %CASE 2: Periods shorter than the 5/45 min we expected. Requires filling.
            else
                filler=new(1)-cumsamp(1); %Find size of filler
                
                %Need to also include a filler for the lfp. We fill with zeros
                lfp=[ lfp(1:cumsamp(1)) ;  (zeros(filler,1)); lfp(cumsamp(1)+1:end)];
                
                
            end
            
            %% Correct Channel Data
            for i=2:length(fixed_amount)
                %Find sample giving exactly 5/45 min. Must start counting at the actual end of
                %the previous trial/postrial
                new=[new cumsamp(i-1)+fixed_amount(i)];
                
                
                %CASE 1: Periods longer than 5 or 45 min.
                
                if  cumsamp(i)>new(i)
                    
                    lfp(new(i)+1:cumsamp(i))=NaN;
                    %CASE 2: Periods shorter than the 5/45 min we expected. Requires filling.
                else
                    
                    filler=new(i)-cumsamp(i);
                    
                    %Need to also include a filler for the lfp. We fill with zeros
                    lfp=[ lfp(1:cumsamp(i)) ;  (zeros(filler,1)); lfp(cumsamp(i)+1:end)];
                    
                    
                end
                
            end
            
            disp("LFP channel corrected for hpc")
            lfp(isnan(lfp)) = [];
            
            
            disp("Phase overlap successful")
            Phase_Vector(unit_index).WFM_Titles=Unit_ID_Title;
            Phase_Vector(unit_index).LFP_Channel=lfp;
%             Phase_Vector(unit_index).NREM_SW_Spikes=NREM_All_Current_Unit;
            
            
            
    end
    
    %     catch ME
    %         if (strcmp(ME.identifier,"Unrecognized function or variable "))
    %
    %         end
    %
    %     end
    
    
end