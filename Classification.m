cd /
root='/media/irene/MD04_RAT_SPIKE/rat/Rat_OS_Ephys_RGS14/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019_merged/cortex/Tetrode_8/phy_AGR';
cd (root)
cd ..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ch4, t4]=load_open_ephys_data_faster('100_CH61.continuous');
fn=30000;
Wn1=[300/(fn/2) 6000/(fn/2)]; % Cutoff=300-6000 Hz
[b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients
ch4=filtfilt(b1,a1,ch4);
ch=ch4; %Channels (modify accordingly)**
t=t4; %Timestamps (modify accordingly)**
%% Parameters
gwfparams.dataDir=root;
gwfparams.nCh = 1;% 4 most times. Number of channels of tetrode. It should be adaptative since not all tetrodes contain 4 channels.
gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out. For now we leave this but may also need to adapt later.

%Folder with phy data (Change to your path)

%gwfparams.dataDir='/media/irene/MD04_RAT_SPIKE/rat/Rat_OS_Ephys_RGS14/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019_merged/cortex/Tetrode_8/phy_AGR';
%gwfparams.dataDir='/media/adrian/MD04_RAT_SPIKE/rat/Rat_OS_Ephys_RGS14/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019_merged/cortex/Tetrode_8/phy_AGR';

%Load phy data
gwfparams.spikeClusters= readNPY(fullfile(gwfparams.dataDir, 'spike_clusters.npy'));               % Order in which data was streamed to disk; must be 1-indexed for Matlab
gwfparams.spikeTimes= readNPY(fullfile(gwfparams.dataDir, 'spike_times.npy')); %size=1180074              % Order in which data was streamed to disk; must be 1-indexed for Matlab
chMap= readNPY(fullfile(gwfparams.dataDir, 'channel_map.npy'))+1; % Order in which data was streamed to disk; must be 1-indexed for Matlab

chMap_use=chMap(4); % only one channel for our test case**
wfNSamples = length(gwfparams.wfWin(1):gwfparams.wfWin(end));
nChInMap = numel(chMap_use);%**

% Read spike time-centered waveforms
cd(root)
a=tdfread('cluster_group.tsv'); %Read TSV file
cluster_id=extractfield(a,'cluster_id')'; %Extract IDs
group=extractfield(a,'group'); %Extract labels
unitIDs=cluster_id(contains(string(group{1}),'good')|contains(string(group{1}),'unsorted'));%Use only good or unsorted
%unitIDs = unique(gwfparams.spikeClusters); %8 unique cluster IDs
numUnits = size(unitIDs,1);
spikeTimeKeeps = nan(numUnits,gwfparams.nWf);%[8 2000]
waveForms_4 = nan(gwfparams.nWf,nChInMap,wfNSamples,numUnits);%[2000 1 82 8]
waveFormsMean_4 = nan(nChInMap,wfNSamples,numUnits);%[1 82 8]


for curUnitInd=1:numUnits %from 1 to 8
    curUnitID = unitIDs(curUnitInd); % curated cluster IDs from unique clusters(unitIDs)
    curSpikeTimes = gwfparams.spikeTimes(gwfparams.spikeClusters==curUnitID);% size=1972, << gwfparams.spikeTimes
    curUnitnSpikes = size(curSpikeTimes,1);%value=1972
    spikeTimesRP = curSpikeTimes(randperm(curUnitnSpikes));%random permutation of different spiketimes (why?)
    spikeTimeKeeps(curUnitInd,1:min([gwfparams.nWf curUnitnSpikes])) = sort(spikeTimesRP(1:min([gwfparams.nWf curUnitnSpikes])));
    %^size=[8 min value(2000, nspikes)], max=[8 2000]                                                                   ^%sorting maximum of 2000 permuted spiketimes values 
    for curSpikeTime = 1:min([gwfparams.nWf curUnitnSpikes])
        %Change the following line to extract the samples from the 4
        %.continuous files in 'ch'. It should something like:
        tmpWf= ch(spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(1):spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(end));%seems to work as is
        %^[82]
        
        %tmpWf = mmf.Data.x(1:gwfparams.nCh,spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(1):spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(end));
        
        %waveForms(curUnitInd,curSpikeTime,:,:) = tmpWf(chMap,:);  %assignment error here, dimensions don't match**
       
        %waveForms_2_changed = nan(gwfparams.nWf,nChInMap,wfNSamples,numUnits);[]
        
        waveForms_4(curSpikeTime,:,:,curUnitInd)=  tmpWf;%[2000 1 82 8]
    end
    
    
    %waveFormsMean_2_changed = nan(nChInMap,wfNSamples,numUnits);%[1 82 8] 
    waveFormsMean_4(:,:,curUnitInd)=  squeeze(nanmean(waveForms_4(:,:,:,curUnitInd),1));
    disp(['Completed ' int2str(curUnitInd) ' units of ' int2str(numUnits) '.']);
end 
