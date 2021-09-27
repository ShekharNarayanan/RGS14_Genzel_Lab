%% Introduction
% This script is the source code that will be later used in the automation_attempt scripts.
% The general idea is to extract the waveform shapes from raw channel recordings.
% Written for channels in Rat 3 Tetrode 8; change path to the appropriate directory before loading the channel
% Note: For cluster IDs, this script does not contain the code segment which loads only the 'good' or 'unsorted units'...(you will see noisy units too) contd.->
% ->... i.e. pay attention to the part that loads phy parameters in automation_attempt scripts.

%Source Code: Adrian Aleman
%Author(s): Adrian Aleman, Shekhar Narayanan (shekharnarayanan833@gmail.com)



%% Read Open Ephys files
% Change path for correct channel here: ex- cd('/media/irene/RAT_SPIKE/.....')

[ch2 ,t2]=load_open_ephys_data_faster('100_CH47.continuous');
%Bandpass filter (300Hz-6kHz)
fn=30000;
Wn1=[300/(fn/2) 6000/(fn/2)]; % Cutoff=300-6000 Hz
[b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients
ch2=filtfilt(b1,a1,ch2);
%[ch2 ,t2]=load_open_ephys_data_faster('100_CH47.continuous');
%[ch3, t3]=load_open_ephys_data_faster('100_CH48.continuous');
%[ch4, t4]=load_open_ephys_data_faster('100_CH61.continuous');

%All changes to the initial script are marked with **
ch=ch2; %Channels (modify according to the channel loaded at top)**
t=t2; %Timestamps (modify according to the channel loaded at top)**

%% Parameters
gwfparams.nCh = size(t,2);% 4 most times. Number of channels of tetrode. It should be adaptative since not all tetrodes contain 4 channels.
gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out. For now we leave this but may also need to adapt later.

%% Folder with phy data (Change to your path with the AGR folder: Rat 3 Tetrode 8)
gwfparams.dataDir='/home/irene/Downloads/Tetrode_8/phy_AGR';
%gwfparams.dataDir='/media/adrian/MD04_RAT_SPIKE/rat/Rat_OS_Ephys_RGS14/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019_merged/cortex/Tetrode_8/phy_AGR';

%% Load phy data
gwfparams.spikeClusters= readNPY(fullfile(gwfparams.dataDir, 'spike_clusters.npy'));               % Order in which data was streamed to disk; must be 1-indexed for Matlab
gwfparams.spikeTimes= readNPY(fullfile(gwfparams.dataDir, 'spike_times.npy')); %size=1180074              % Order in which data was streamed to disk; must be 1-indexed for Matlab
chMap_4 = readNPY(fullfile(gwfparams.dataDir, 'channel_map.npy'))+1; % Order in which data was streamed to disk; must be 1-indexed for Matlab

chMap_2=chMap_4(2); % only one channel for our test case, use as: Ch_Map_i=Ch_Map4(i), where i is the channel loaded at top**
wfNSamples = length(gwfparams.wfWin(1):gwfparams.wfWin(end));
nChInMap = numel(chMap_2);%**

%% Read spike time-centered waveforms: Initializing empty variables which will later contain our data
unitIDs = unique(gwfparams.spikeClusters); %8 unique cluster IDs in this case, could change 
numUnits = size(unitIDs,1);
spikeTimeKeeps = nan(numUnits,gwfparams.nWf);%[8 2000]
waveForms = nan(numUnits,gwfparams.nWf,nChInMap,wfNSamples);%**[8 2000 1 82](single channel)
waveFormsMean = nan(numUnits,nChInMap,wfNSamples); %8x1x82


%%
for curUnitInd=1:numUnits %from 1 to 8
    curUnitID = unitIDs(curUnitInd); % curated cluster IDs from unique clusters(unitIDs)
    curSpikeTimes = gwfparams.spikeTimes(gwfparams.spikeClusters==curUnitID);% size=426268, << gwfparams.spikeTimes
    curUnitnSpikes = size(curSpikeTimes,1);%value=426268
    spikeTimesRP = curSpikeTimes(randperm(curUnitnSpikes));%random permutation of different spiketimes (why?---> randomizing = removing bias, someone may only pick 'better' waveforms for their analysis, which is wrong)
    spikeTimeKeeps(curUnitInd,1:min([gwfparams.nWf curUnitnSpikes])) = sort(spikeTimesRP(1:min([gwfparams.nWf curUnitnSpikes])));
    %^size=[8 2000], 2000 is tha maximum val                           ^%sorting a maximum of 2000 permuted spiketimes values 
    
    for curSpikeTime = 1:min([gwfparams.nWf curUnitnSpikes])% 1 to max 2000
        %Change the following line to extract the samples from the 4
        %.continuous files in 'ch'. It should something like:
        tmpWf= ch(spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(1):spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(end)); % not as complicated as it looks!! Read below
        
%       ^ This part just collects 82 samples for each spike time within a cluster. i.e.: (1) curUnitInd will change according to the cluster, (2) within a cluster, it will loop for all spike times....contd->

%       (3) Since we know that we will 82 collect samples (40 before, 41 after) around one spike time, the loop does exactly this for all clusters, one waveform at a time
  
        waveForms(curUnitInd,curSpikeTime,:,:) = tmpWf; %sdimensions: [1 1 1 82]=[82] **
    end
    waveFormsMean(curUnitInd,:,:) = squeeze(nanmean(waveForms(curUnitInd,:,:,:),2));% compute without mean
    disp(['Completed ' int2str(curUnitInd) ' units of ' int2str(numUnits) '.']);
end

%% Plotting the Data
for Unit=1:numUnits
    subplot(4,4,Unit)
    plot(((0:length(waveFormsMean(Unit,:))-1))/30000*1000,waveFormsMean(Unit,:))
    xlabel('milliseconds');
    ylabel(string(Unit));
end  