%% Read Open Ephys files
[ch1, t1]=load_open_ephys_data_faster('100_CH46.continuous');
[ch2 ,t2]=load_open_ephys_data_faster('100_CH47.continuous');
[ch3, t3]=load_open_ephys_data_faster('100_CH48.continuous');
[ch4, t4]=load_open_ephys_data_faster('100_CH61.continuous');
%Bandpass filter (300Hz-6kHz)
fn=30000;
Wn1=[300/(fn/2) 6000/(fn/2)]; % Cutoff=300-6000 Hz
[b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients
ch1=filtfilt(b1,a1,ch1);
ch2=filtfilt(b1,a1,ch2);
ch3=filtfilt(b1,a1,ch3);
ch4=filtfilt(b1,a1,ch4);


%All changes to the initial script are marked with **
ch=[ch1,ch2,ch3,ch4]; %Channels (modify accordingly)**
t=[t1,t2,t3,t4]; %Timestamps (modify accordingly)**
%% Parameters
gwfparams.nCh = size(t,2);% 4 most times. Number of channels of tetrode. It should be adaptative since not all tetrodes contain 4 channels.
gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out. For now we leave this but may also need to adapt later.

%Folder with phy data (Change to your path)
gwfparams.dataDir='/home/irene/Downloads/Tetrode_8/phy_AGR';
%gwfparams.dataDir='/media/adrian/MD04_RAT_SPIKE/rat/Rat_OS_Ephys_RGS14/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019_merged/cortex/Tetrode_8/phy_AGR';

%Load phy data
gwfparams.spikeClusters= readNPY(fullfile(gwfparams.dataDir, 'spike_clusters.npy'));               % Order in which data was streamed to disk; must be 1-indexed for Matlab
gwfparams.spikeTimes= readNPY(fullfile(gwfparams.dataDir, 'spike_times.npy')); %size=1180074              % Order in which data was streamed to disk; must be 1-indexed for Matlab
chMap_4 = readNPY(fullfile(gwfparams.dataDir, 'channel_map.npy'))+1; % Order in which data was streamed to disk; must be 1-indexed for Matlab

chMap_1=chMap_4(1); % only one channel for our test case**
wfNSamples = length(gwfparams.wfWin(1):gwfparams.wfWin(end));
nChInMap = numel(chMap_1);%**

% Read spike time-centered waveforms
unitIDs = unique(gwfparams.spikeClusters); %8 unique cluster IDs
numUnits = size(unitIDs,1);
spikeTimeKeeps = nan(numUnits,gwfparams.nWf);%[8 2000]
waveForms = nan(numUnits,gwfparams.nWf,nChInMap,wfNSamples);%**[8 2000 1 82](single channel)
waveFormsMean = nan(numUnits,nChInMap,wfNSamples); %8x1x82
%%multichannel loop
for channel_index=ch(1):ch(4)
    for curUnitInd=1:numUnits 
        curUnitID = unitIDs(curUnitInd); % curated cluster IDs from unique clusters(unitIDs)
        curSpikeTimes = gwfparams.spikeTimes(gwfparams.spikeClusters==curUnitID);% size=426268, << gwfparams.spikeTimes
        curUnitnSpikes = size(curSpikeTimes,1);%value=426268
        spikeTimesRP = curSpikeTimes(randperm(curUnitnSpikes));%random permutation of different spiketimes (why?)
        spikeTimeKeeps(curUnitInd,1:min([gwfparams.nWf curUnitnSpikes])) = sort(spikeTimesRP(1:min([gwfparams.nWf curUnitnSpikes])));
        %^size=[8 2000]                                                                   ^%sorting 2000 permuted spiketimes values 
                                                                     
        for curSpikeTime = 1:min([gwfparams.nWf curUnitnSpikes])% 1 to 2000
            %Change the following line to extract the samples from the 4
            %.continuous files in 'ch'. It should something like:
            tmpWf= channel_index(spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(1):spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(end));%seems to work as is
            %^[82]
            waveForms(curUnitInd,curSpikeTime,:,:) = tmpWf;
         
        end
        waveFormsMean(curUnitInd,:,:) = squeeze(nanmean(waveForms(curUnitInd,:,:,:),2));% compute without mean
        disp(['Completed ' int2str(curUnitInd) ' units of ' int2str(numUnits) '.']);
        
    
    
    
    
    end
    
    
    
    
    
end

    