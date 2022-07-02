function Final_Var=Ripple_Analysis_All(Input_WFM, Treatment_String_Lower_Case)

% The goal of this function is to compute firing activity in NREM sleep that occurred around the time of a SW ripple.
% 
% It implicitly uses Milan Bogers' ripple-timestamps variable that has three columns: Start, End and Peak Ripple Times(in seconds).
% We are only interested in the Peak Times and a +/- 1 second window (Ripple_Window) is defined around the Peak.
% Units of time are converted into channel time stamps by multiplying them by the sampling frequency (fs). This is done because our spike times are in fs units.
% From the Slow_Wave_Analysis function, we already have the spike times of each neuron across the whole study day. 
% The script will find the spikes inside this Ripple_Window and store it in two formats: (1) Raw (sample times) and (2) Normalized Times**.
% ** Refer to lines 104- 110 for an explanation
% Input Example: Phase_Vector_Slow_Wave_Pyr_RGS_Session_1.mat
%
% author: Shekhar Narayanan



if strcmp(Treatment_String_Lower_Case,'rgs') % takes in key word and uses it to load the correct ripple time variable
    Rat_Dir='/home/irene/Downloads/RGS14_all_Shekhar/Ripple_Time_Vars_All_Rat_SD/RGS14'; % directory where RGS ripple time vars are stored
%     Input_WFM=load('Phase_Vector_Slow_Wave_Pyr_RGS_Session_1.mat');
    Phase_Vec=Input_WFM.Phase_Vector_Slow_Wave_Pyr_RGS_Session_1;
else
    Rat_Dir='/home/irene/Downloads/RGS14_all_Shekhar/Ripple_Time_Vars_All_Rat_SD/Vehicle'; % directory where Veh ripple time vars are stored
     Input_WFM=load('Phase_Vector_Slow_Wave_Pyr_Veh_Session_1.mat');
    Phase_Vec=Input_WFM.Phase_Vector_Slow_Wave_Pyr_Veh_Session_1;
end

%% Parameters
fs=30000;

disp(size(Phase_Vec))
Offset_Vector=[0 50 100 150 200 250 295 340 385]*60*fs; % Offset Vector for Post Trials=starting time in minutes for each PT*60*fs (mins->sec->samples)

for unit_index=1:length(Phase_Vec)
    
    
    Unit_ID_Title=convertStringsToChars(Phase_Vec(unit_index).WFM_Titles);
    Unit_ID_Split=regexp(Unit_ID_Title,'_','split');
    Unit_Rat=Unit_ID_Split{5}; % Answer='RnX' where X is the rat number
    Unit_Rat_Index=Unit_Rat(3);% Answer=X
    Unit_Rat_Index_Final=convertStringsToChars(strcat('Rat',string(Unit_Rat_Index)));
    WFM_Data=Phase_Vec(unit_index); %% Collecting data of the unit
    Unit_SD=Unit_ID_Split{7};
    
    cd(Rat_Dir) % going to the appropriate directory after the Unit ID is known
    
    rat_file_dir= dir(string(Rat_Dir)); %Reaching the directory after user input
    % remove all files (isdir property is 0)
    % remove '.' and '..'
    rat_files = rat_file_dir(~ismember({rat_file_dir(:).name},{'.','..'}));
    rat_files=struct2cell(rat_files(:,1));
    rat_file_names=natsortfiles(rat_files(1,:)); % names of all the files
    
    Count_Correct=0; %Will tell us if the ripple file is present or not; 1 if present, 0 if not
    for correct_file_index=1:length(rat_file_names)

        current_name=rat_file_names{correct_file_index};
        %finding SD from file name
        SD_file_index=strfind(current_name,'SD');
        SD_file_temp=current_name(SD_file_index:SD_file_index+3);
        SD_file_final=regexp(SD_file_temp,'_','split');
        SD_file_final=SD_file_final{1};

        
        if contains(current_name,Unit_Rat_Index_Final)&& strcmp(SD_file_final,Unit_SD)
            Count_Correct=1; %changing the count
            correct_file_name=current_name; %storing the correct ripple file name
            
        end
    end
    
    if Count_Correct==1
        load(correct_file_name) % after loading this, a variable called 'ripple_timestamps' is in the workspace. 1 x 9 dimensional 
        spikes_raw=[]; spikes_normalized=[];
        NREM_Spikes=WFM_Data.NREM_SW_Spikes;
        disp('NREM Spikes Collected')
        
        for post_trial_index=1:length(ripple_timestamps) % refer to line 73 if confused
            Current_PT=ripple_timestamps{post_trial_index}; % loading current post trial
            
            if size(Current_PT,2)==1 % Current PT is a 1 x C vector, if C = 1 then it is empty
                disp('No Ripples in Presleep, going to the next sleep period')
                continue
            end
            
            Current_Offset=Offset_Vector(post_trial_index);% for us to find the spikes in appropriate post trial
            
            Bouts_in_PT=Current_PT(:,3); % selecting the column with peak ripple time stamps
            
            for inside_bout_index=1:length(Bouts_in_PT)
                Current_Bout=Bouts_in_PT{inside_bout_index};
                
                for peaks_in_bout=1:length(Current_Bout)
                    peak=Current_Bout(peaks_in_bout)*fs; % converting to samples
                    peak=(Current_Offset)+(peak); % adding offset
                    
                    lower_lim=peak-fs; % -1 s from ripple time
                    upper_lim=peak+fs; % +1 s after ripple time
                    
                    spliced_spikes=NREM_Spikes( (NREM_Spikes(:)>lower_lim) & (NREM_Spikes<upper_lim) ); % finding the spikes, finally
                    
                    % Normalized spike collection procedure
                    % Tip if you find the procedure unintuitive:
                    % Try the same procedure with simple data- x = [ 1 2 3 4 5 10], fs = 2, lower lim = 1 (first element of x)
                    
                    x=spliced_spikes-lower_lim; % time stamps- lower limit makes the range from 0 to max timestamp-lower limit
                    x=double(x); % adjusting format of data
                    x=(x-30000)/fs; % instead of making data go from 0 to 1, now it goes from -1 to 1
                    spikes_normalized=[spikes_normalized; {x'}];
                    spikes_raw=[spikes_raw; {spliced_spikes'}];
                end
            end
            
            
        end
        disp('Overlapping Spikes Collected for all bouts')
        Final_Var(unit_index).WFM_Titles=Phase_Vec(unit_index).WFM_Titles;
        Final_Var(unit_index).Ripple_Spike_Times_Raw=spikes_raw;
        Final_Var(unit_index).Ripple_Spike_Times_Normalized=spikes_normalized;
        
        
        
    else
        disp('ripple file not present: going on to the next unit')
        continue
    end
   
    
end



end