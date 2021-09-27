% function Spikes_Vector=Ripple_Analysis(Input_WFM)
% % This function uses Milan Bogers' output variable that has three columns: Start, End and Peak Ripple Times(in seconds).
% % We are only interested in the Peak Times and a +/- 1 second window (Ripple_Window) is defined around the Peak.
% % Units of time are converted into channel time stamps by multiplying them by the sampling frequency (fs).
% % From the Slow_Wave_Analysis function, we already have the spikes of each neuron across the whole study day. The script will find the spikes inside the Ripple_Window.
% % @author: Shekhar Narayanan (shekharnarayanan833@gmail.com)
%
%
%
% %% Hard Drive Roots
% root_rat1='/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat1_57986';
% root_rat2='/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat2_57987';
% root_rat3='/media/irene/MD04_RAT_SPIKE/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152';
% root_rat4='/media/irene/GL13_RAT_BURSTY/Spike_sorting/Rat_OS_Ephys_RGS14_rat4_357153';
% root_rat6='/media/irene/MD04_RAT_THETA/Spike_sorting/Rat_OS_Ephys_RGS14_rat6_373726';
% root_rat7='/media/irene/GL14_RAT_FANO/Spikesorting/Rat_OS_Ephys_RGS14_rat7_373727';
% root_rat9='/media/irene/Rat9/Spike_sorting';
% 
%
% fs=30000;
% Units=Input_WFM;
%
%
%
%
% end

%% Test Scritpt
cd /home/irene/Downloads/RGS14_all_Shekhar/Ripple_Time_Vars_All_Rat_SD

load('ripple_timestamps_OS_Ephys_RGS14_Rat3_357152_SD3_OR_14-15_10_2019.mat')
Phase_Vec=load('Phase_Vector_Slow_Wave_Pyr_RGS_Session_1.mat').Phase_Vector_Slow_Wave_Pyr_RGS_Session_1;

%% Parameters
fs=30000;

%
% %% COllecting Rat 3 SD3 Units
Rn3_SD3=[];

for i=1:size(Phase_Vec,2)
    Title=convertStringsToChars(Phase_Vec(i).WFM_Titles);
    Title_Exp=regexp(Title,'_','split');
    
    Rat=Title_Exp{5}; SD=Title_Exp{7};
    
    if strcmp(Rat,'Rn3') && strcmp(SD,'SD3')
        Rn3_SD3=[Rn3_SD3; Phase_Vec(i)];
        
    end
    
    
end

%% Offset Vector for Post Trials=[0 50 100 150 200 250 295 340 385]*sec*fs
Offset_Vector=[0 50 100 150 200 250 295 340 385]*60*fs;


for unit_index=1:size(Rn3_SD3,1)
    
    spikes_per_unit=[]; spikes_proper_units=[];
    
    NREM_Spikes=Rn3_SD3(unit_index).NREM_SW_Spikes;
    
    for post_trial_index=1:length(ripple_timestamps)
        Current_PT=ripple_timestamps{post_trial_index};
        
        if size(Current_PT,2)==1
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
                
                spikes_proper_units=[spikes_proper_units; {x'}];
                
                spikes_per_unit=[spikes_per_unit; {spliced_spikes'}];
                
            end
            
            
        end
        
    end
    
    Final_Var(unit_index).WFM_Titles=Rn3_SD3(unit_index).WFM_Titles;
    Final_Var(unit_index).Ripple_Overlap_Spikes=spikes_per_unit;
    Final_Var(unit_index).Spikes_Proper_Units=spikes_proper_units;
    
    
end


