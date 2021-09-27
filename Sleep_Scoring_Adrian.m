clc;clear
%GET SPIKES 
% In my case I get them directly from the file and I skip the step of using only 
%"unsorted" or "good" but just for testing the script). 
%You can get the actual ones from your .mat file 
cd /
cd /media/irene/Rat9/Spike_sorting/OS_Ephys_RGS14_Rat9_378134_SD1_HC_29_04_2020/OS_Ephys_RGS14_Rat9_378134_SD1_HC_29_04_2020_merged/cortex
gwfparams.dataDir='/media/irene/Rat9/Spike_sorting/OS_Ephys_RGS14_Rat9_378134_SD1_HC_29_04_2020/OS_Ephys_RGS14_Rat9_378134_SD1_HC_29_04_2020_merged/cortex/Tetrode_6/phy_AGR';
units = readNPY(fullfile(gwfparams.dataDir, 'spike_times.npy'));
a=units;

%READ SPREADSHEET WITH ACTUAL TIMESTAMPS

addpath /media/irene/Rat9/Spike_sorting/OS_Ephys_RGS14_Rat9_378134_SD1_HC_29_04_2020/OS_Ephys_RGS14_Rat9_378134_SD1_HC_29_04_2020_merged
load('trials_durations_samples.mat') 

%cumsamp is the cumulative amount of samples throughout the recording.
cumulative_samples=cumsum(trial_durations);
%fixed_amount: Vector with the amount of samples that each trial/posttrial should have
fixed_amount=[81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	324000000];

%%
new=[];
new(1)=fixed_amount(1);
trial_ranges(1,:)=[0 new(1)]; % Range for presleep

%Remove spikes above the first 45min of presleep
a=a(a(:) >= cumulative_samples(1)  | a(:) < new(1));

fprintf('Removed spikes between sample %i and sample %i.\n',new(1),cumulative_samples(1));
%% Remove spikes above 5 or 45 min trials/posttrials
for i=2:length(fixed_amount)
    %Find sample giving exactly 5/45 min. Must start counting at the actual end of
    %the previous trial/postrial
    new=[new cumulative_samples(i-1)+fixed_amount(i)];
    
    %Range of current trial/postrial
    %trial_ranges(i,:)=[cumulative_samples(i-1) new(i)] ;
    
    %Remove extra spikes by only saving spikes that are below lower bound OR above
    %upper bound of the extra period.
    a=a(a(:) >= cumulative_samples(i) | a(:) < new(i));
    %a=a(a(:)<=new(1));
%fprintf('Removed spikes between sample %i and sample %i.\n',new(i),cumulative_samples(i));

end
%% Correct delay by shifting trial timestamps 
%according to the number of extra samples from the trial(s) before
Shift=[];
for i=2:length(fixed_amount) %Iterate across trials
    a_ind=(cumulative_samples(i-1)<a & a<new(i)); %Binary vector with samples within trial/posttrial period.
    shift=cumulative_samples(i-1)-new(i-1); %Duration of preceding 'Extra spikes' period (in samples).
    Shift=[Shift shift]; %Accumulate shifts.
    a(a_ind)=a(a_ind)-sum(Shift); %Substract the cumulative shift value to remove empty 'Extra spikes' period.
    trial_ranges(i,:)=[new(i-1) new(i)] ;
end

%fprintf('Total of %i extra spikes removed\n',length(units)-length(a))
%% Visualize sample ranges per sleep stage
trials={'Presleep';'Trial1'; 'PT1';'Trial2';'PT2';'Trial3';'PT3';'Trial4';'PT4';'Trial5';'PT5'};


T=table(trials,num2str(trial_ranges(:,1)),num2str(trial_ranges(:,2)));
T.Properties.VariableNames{2}='Start';
T.Properties.VariableNames{3}='End';
T
