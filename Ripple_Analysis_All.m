function Final_Var=Ripple_Analysis_All(Treatment)

if strcmp(Treatment,'rgs')
    Rat_Dir='/home/irene/Downloads/RGS14_all_Shekhar/Ripple_Time_Vars_All_Rat_SD/RGS14';
    Input_WFM=load('Phase_Vector_Slow_Wave_Pyr_RGS_Session_1.mat');
    Phase_Vec=Input_WFM.Phase_Vector_Slow_Wave_Pyr_RGS_Session_1;
else
    Rat_Dir='/home/irene/Downloads/RGS14_all_Shekhar/Ripple_Time_Vars_All_Rat_SD/Vehicle';
    Input_WFM=load('Phase_Vector_Slow_Wave_Pyr_Veh_Session_1.mat');
    Phase_Vec=Input_WFM.Phase_Vector_Slow_Wave_Pyr_Veh_Session_1;
end

%% Parameters
fs=30000;


Offset_Vector=[0 50 100 150 200 250 295 340 385]*60*fs; % Offset Vector for Post Trials=[0 50 100 150 200 250 295 340 385]*sec*fs (mins->sec->samples)

for unit_index=1:size(Phase_Vec,2)
    
    
    Unit_ID_Title=convertStringsToChars(Phase_Vec(unit_index).WFM_Titles);
    Unit_ID_Split=regexp(Unit_ID_Title,'_','split');
    Unit_Rat=Unit_ID_Split{5}; % Answer='RnX' where X is the rat number
    Unit_Rat_Index=Unit_Rat(3);% Answer=X
    Unit_Rat_Index_Final=convertStringsToChars(strcat('Rat',string(Unit_Rat_Index)));
    WFM_Data=Phase_Vec(unit_index); %% Collecting data of the unit
    Unit_SD=Unit_ID_Split{7};
    
    cd(Rat_Dir)
    
    rat_file_dir= dir(string(Rat_Dir)); %Reaching the directory after user input
    % remove all files (isdir property is 0)
    % remove '.' and '..'
    rat_files = rat_file_dir(~ismember({rat_file_dir(:).name},{'.','..'}));
    rat_files=struct2cell(rat_files(:,1));
    rat_file_names=natsortfiles(rat_files(1,:));
    
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
        load(correct_file_name)
        spikes_raw=[]; spikes_normalized=[];
        NREM_Spikes=WFM_Data.NREM_SW_Spikes;
        disp('Spikes Collected')
        
        for post_trial_index=1:length(ripple_timestamps)
            Current_PT=ripple_timestamps{post_trial_index};
            
            if size(Current_PT,2)==1
                disp('No Ripples in Presleep, going to the next sleep period')
                continue
            end
            
            Current_Offset=Offset_Vector(post_trial_index);
            
            Bouts_in_PT=Current_PT(:,3);
            
            for inside_bout_index=1:length(Bouts_in_PT)
                Current_Bout=Bouts_in_PT{inside_bout_index};
                
                for peaks_in_bout=1:length(Current_Bout)
                    peak=Current_Bout(peaks_in_bout)*fs;
                    peak=(Current_Offset)+(peak);
                    
                    lower_lim=peak-fs;
                    upper_lim=peak+fs;
                    spliced_spikes=NREM_Spikes( (NREM_Spikes(:)>lower_lim) & (NREM_Spikes<upper_lim) );
                    x=spliced_spikes-lower_lim;
                    x=double(x);
                    x=(x-30000)/fs;
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