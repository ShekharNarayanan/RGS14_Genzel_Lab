%% MODULE TRAVERSING TETRODE FOLDERS
%Ask user to enter tetrode folder name thenextract .continous files to [c,t]

root = '/home/irene/Downloads/RGS14_all/Tetrodes'; %Change directory to a folder which has all tetrodes
user_input_tet = input('Enter tetrode folder ', 's');
cd (strcat(root,{'/'},string(user_input_tet)))     %Changing directory to the chosen tetrode folder
channel_list=dir('*.continuous*');                 %Storing .continuous files in a struct
channels=struct2cell(channel_list);                %converting struct to cell for accessing channel names
%[ch1,t1]=load_open_ephys_data_faster(string(channels(1,1)));

[ch2,t2]=load_open_ephys_data_faster(string(channels(1,2)));%Channel(i)=string(channels(1,(i))
%% FILTER APPLICATION
fn=30000;
Wn1=[300/(fn/2) 6000/(fn/2)]; % Cutoff=300-6000 Hz
[b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients
ch2=filtfilt(b1,a1,ch2);
ch=ch2; %Channels (modify accordingly)**
t=t2; %Timestamps (modify accordingly)**

%% Parameters
gwfparams.nCh = 1;% 4 most times. Number of channels of tetrode. It should be adaptative since not all tetrodes contain 4 channels.
gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out. For now we leave this but may also need to adapt later.

%% MODULE SELECTING phy_AGR or phy_MS4 for loading gwfparams
params_dir= dir(strcat('/home/irene/Downloads/RGS14_all/Tetrodes',{'/'},string(user_input_tet))); %Reaching the directory after user input
% remove all files (isdir property is 0)
params_dir= params_dir([params_dir(:).isdir]); 
% remove '.' and '..' 
params_dir_folder = params_dir(~ismember({params_dir(:).name},{'.','..'}));                        %Only displaying folders (contains either AGR or MS4
extension=struct2cell(params_dir_folder);
extension_final=string(extension(1,1));                                                            %Obtaining the folder name for that tetrode folder
 
gwfparams.dataDir=strcat('/home/irene/Downloads/RGS14_all/Tetrodes',{'/'},string(user_input_tet),{'/'},extension_final);  %entering extension_final

%% Old script starting here 
gwfparams.spikeClusters= readNPY(fullfile(gwfparams.dataDir, 'spike_clusters.npy')); 
gwfparams.spikeTimes= readNPY(fullfile(gwfparams.dataDir, 'spike_times.npy')); %size=1180074              % Order in which data was streamed to disk; must be 1-indexed for Matlab
chMap= readNPY(fullfile(gwfparams.dataDir, 'channel_map.npy'))+1; % Order in which data was streamed to disk; must be 1-indexed for Matlab
chMap_use=chMap(2); % only one channel for our test case**
wfNSamples = length(gwfparams.wfWin(1):gwfparams.wfWin(end));
nChInMap = numel(chMap_use);%**

% Read spike time-centered waveforms
unitIDs = unique(gwfparams.spikeClusters); %8 unique cluster IDs
numUnits = size(unitIDs,1);
spikeTimeKeeps = nan(numUnits,gwfparams.nWf);%[8 2000]
waveForms_2 = nan(gwfparams.nWf,nChInMap,wfNSamples,numUnits);%[2000 1 82 8]
waveFormsMean_2 = nan(nChInMap,wfNSamples,numUnits);%[1 82 8]


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
        
        waveForms_2(curSpikeTime,:,:,curUnitInd)=  tmpWf;%[2000 1 82 8]
    end
    
    
    %waveFormsMean_2_changed = nan(nChInMap,wfNSamples,numUnits);%[1 82 8] 
    waveFormsMean_2(:,:,curUnitInd)=  squeeze(nanmean(waveForms_2(:,:,:,curUnitInd),1));
    disp(['Completed ' int2str(curUnitInd) ' units of ' int2str(numUnits) '.']);
end 

 for Unit=1:numUnits 
        subplot(4,4,Unit)
        plot(((0:length(waveFormsMean_2(:,:,Unit))-1))/30000*1000,waveFormsMean_2(:,:,Unit))
        xlabel('millisecond');
        ylabel('Unit ID'+string(unitIDs(Unit)));
end    
 