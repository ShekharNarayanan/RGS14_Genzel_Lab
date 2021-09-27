addingpath()
% rng(1)
% units=randi(774565888,[74565888,1]);
% units=sort(units);
%%
%GET SPIKES 
% In my case I get them directly from the file and I skip the step of using only 
%"unsorted" or "good" but just for testing the script). 
%You can get the actual ones from your .mat file 
gwfparams.dataDir='/media/adrian/6aa1794c-0320-4096-a7df-00ab0ba946dc/Cell_assembly/cortex/Tetrode_6/phy_MS4';
units = readNPY(fullfile(gwfparams.dataDir, 'spike_times.npy'));
%units=units+1; %Because Matlab.
a=units;

%Get channel with nice slow waves
cd(gwfparams.dataDir)
cd ..
[lfp,~]=load_open_ephys_data_faster('100_CH52.continuous');

%In case there are any NaNs (not likely), convert to zero
if  sum(isnan(lfp))>0
    lfp(isnan(lfp))=0;
end
    

%t_lfp=[1:length(lfp)];
fn=30000;
%Wn1=[300/(fn/2) 6000/(fn/2)]; % Cutoff=300-6000 Hz
Wn1=[4/(fn/2) ]; % Cutoff=300-6000 Hz
[b1,a1] = butter(3,Wn1,'low'); %Filter coefficients
lfp=filtfilt(b1,a1,lfp);


phase_degrees=mod(rad2deg(angle(hilbert(lfp))),360);
% spike_phase=phase_degrees(a);

%READ SPREADSHEET WITH ACTUAL TIMESTAMPS (Matlab format)
cd('/media/adrian/6aa1794c-0320-4096-a7df-00ab0ba946dc/Cell_assembly/')
%'trial_durations' gives you the actual duration in samples per trial/posttrial
load('trials_durations_samples.mat') 
%cumsamp is the cumulative amount of samples throughout the recording.
cumsamp=cumsum(trial_durations);
%fixed_amount: Vector with the amount of samples that each trial/posttrial should have
fixed_amount=[81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	81000000	9000000	324000000
];

%%
new_lfp=lfp;
new=[];
new(1)=fixed_amount(1);
trial_ranges(1,:)=[0 new(1)]; % Range for presleep

%CASE 1: Periods longer than 5 or 45 min. Remove extra spikes periods.
if  cumsamp(1)>new(1) %Extra spikes period
    a=a(a(:) >= cumsamp(1) | a(:) < new(1)); %Removes extra spikes.
    %new_lfp(new(1)+1:cumsamp(1))=NaN;
    phase_degrees(new(1)+1:cumsamp(1))=NaN; %Makes extra samples NaNs to remove later.
%CASE 2: Periods shorter than the 5/45 min we expected. Requires filling.
else
    'Post trial shorter than it should be. Filling up'
    filler=new(1)-cumsamp(1); %Find size of filler
    a(a>cumsamp(1))=a(a>cumsamp(1))+filler;
    %Need to also include a filler for the lfp. We fill with zeros
    phase_degrees=[ phase_degrees(1:cumsamp(1)) ;  (zeros(filler,1)); phase_degrees(cumsamp(1)+1:end)];
    cumsamp(1:end)=cumsamp(1:end)+filler; % This will make cumsamp(1) have the same value as new(1). There won't a be a shift added at the end.

end


fprintf('Removed spikes between sample %i and sample %i.\n',new(1),cumsamp(1));

%% Remove spikes above 5 or 45 min trials/posttrials
for i=2:length(fixed_amount)
    %Find sample giving exactly 5/45 min. Must start counting at the actual end of
    %the previous trial/postrial
    new=[new cumsamp(i-1)+fixed_amount(i)];
    
    %Range of current trial/postrial
    trial_ranges(i,:)=[cumsamp(i-1) new(i)] ;
    
%CASE 1: Periods longer than 5 or 45 min. Remove extra spikes periods.
    %Remove extra spikes by only saving spikes that are below lower bound OR above
    %upper bound of the extra period.
%     spike_phase=spike_phase(a(:) > cumsamp(1) | a(:) <= new(1));
    if  cumsamp(i)>new(i)
        a=a(a(:) >= cumsamp(i) | a(:) < new(i));
        %new_lfp(new(i)+1:cumsamp(i))=NaN;
        phase_degrees(new(i)+1:cumsamp(i))=NaN;
%CASE 2: Periods shorter than the 5/45 min we expected. Requires filling.        
    else
        'Post trial shorter than it should be. Filling up'
        %xo
        filler=new(i)-cumsamp(i);
        a(a>cumsamp(i))=a(a>cumsamp(i))+filler;
        %Need to also include a filler for the lfp. We fill with zeros
        phase_degrees=[ phase_degrees(1:cumsamp(i)) ;  (zeros(filler,1)); phase_degrees(cumsamp(i)+1:end)];
        cumsamp(i:end)=cumsamp(i:end)+filler;% This will make cumsamp(i) have the same value as new(i)
        
    end
        
fprintf('Removed spikes between sample %i and sample %i.\n',new(i),cumsamp(i));

end
aa=a;
fprintf('Total of %i extra spikes removed\n',length(units)-length(a))
%xo
%% Visualize sample ranges per sleep stage
trials={'Presleep';'Trial1'; 'PT1';'Trial2';'PT2';'Trial3';'PT3';'Trial4';'PT4';'Trial5';'PT5'};


T=table(trials,num2str(trial_ranges(:,1)),num2str(trial_ranges(:,2)));
T.Properties.VariableNames{2}='Start';
T.Properties.VariableNames{3}='End';
T
%%
%spike_phase=phase_degrees(a);
%% Correct delay by shifting trial timestamps 
%according to the number of extra samples from the trial(s) before
%When period is shorter than 5/45 min the shift will be zero and there
%won't be a delay correction.

v=[];
Shift=[];
for i=2:length(fixed_amount) %Iterate across trials
    a_ind=(cumsamp(i-1)<a & a<new(i)); %Binary vector with samples within trial/posttrial period.
    shift=cumsamp(i-1)-new(i-1); %Duration of preceding 'Extra spikes' period (in samples).
    Shift=[Shift shift]; %Accumulate shifts.
    a(a_ind)=a(a_ind)-sum(Shift); %Substract the cumulative shift value to remove empty 'Extra spikes' period.
  v=[v cumsamp(i-1)-sum(Shift)];
end

%newest_lfp=new_lfp;
%newest_lfp(isnan(newest_lfp)) = [];
phase_degrees(isnan(phase_degrees)) = [];
sp=phase_degrees(a+1);
xo


%%

% newest_lfp=filtfilt(b1,a1,newest_lfp);
% p_degrees=mod(rad2deg(angle(hilbert(newest_lfp))),360);
%% Plotting
histogram(units); hold on; histogram(a);
for j=1:length(cumsamp)
    xline(cumsamp(j))
    hold on
    xline(new(j))
end