clc;clear;clear variables
cd /
X= '/home/irene/Downloads/RGS14_all_Shekhar/Rat_OS_Ephys_RGS14_Sleep_Scoring/Rat2_57987/Rat2_57987_SD1_OD_1';
cd(X)
% fs=30000;
%states=[3 3 3 1 5 5 3 3]; % test state vector.
File=load('2018-07-24_10-36-09_Post_Trial1-states.mat');
states_input=File.states(1:2700);
states=Sleep_Scoring_Changes(states_input);
fs=30000;
start_sample_per_second=[0:fs:fs*length(states)]; %Vector with start_sample of each second


%Find NREM epochs lengths and indices
bout_lengths=ConsecutiveOnes(states==3); %For other sleep stage change 3 to other value.
bout_index=find(bout_lengths);

%Find bounds
lower_bound=start_sample_per_second(bout_index);
upper_bound=lower_bound+bout_lengths(bout_index)*fs;
% Don't include upper_bound value
upper_bound=upper_bound-1;

%Bouts ranges:

ranges=[lower_bound; upper_bound].';
%changedIndexes = diff()~=0

% Waveform_test_NREM=Spike_Times_Correction('/media/irene/GL04_RAT_HOMER_2/Spike_sorting/Rat_OS_Ephys_RGS14_Rat2_57987','RAT_2_TEMP_SD_BEST_WFM.mat');
% idxA_1=ranges(1,1);
% idxA_2=ranges(1,2);
% idxB_1=ranges(2,1);
% idxB_2=ranges(2,2);
% units=Waveform_test_NREM.curSpikeTimes;
% units_spliced=units( (units(:)>=idxA_1 & units(:)<= idxA_2) | (units(:)>=idxB_1 & units(:)<= idxB_2)  );
% 
% ax                  = figure();
% % ax=figure()
% nbins               = 10000;
% h                   = histogram(units_spliced/30000,nbins);
% h.FaceColor         = 'k';
% mVal                = max(h.Values)+round(max(h.Values)*.1);
% xlim=[idxA_1 idxB_2]; %7 hours
% ylim=[0 mVal]/25819000;
% 
% xlabel('Time[s]');
% ylabel('Firing Rate');
% title('NREM bouts for RAT6 SD1 PostTrial 1')
% 
% xline(idxA_1/30000,'Linewidth',2,'color','b'); % T1
% xline(idxA_2/30000,'Linewidth',2,'color','b') ;%PT1

