tic
cd /
root= '/media/irene/MD04_RAT_SPIKE/rat/Rat_OS_Ephys_RGS14/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019_merged/cortex';
k1=strfind(root,'_rat');
k2=strfind(root,'_SD');
WFM_ALL_TETRODE_WISE=[];
tetrodes=[];

for i=6:15
  tetrodes=[tetrodes; 'Tetrode_'+string(i)];
    
end  


for folder=1:length(tetrodes)
    if folder==3
  
        cd (strcat(root,{'/'},tetrodes(folder)))
        channel_list=dir('*.continuous*');                 %Storing .continuous files in a struct
        channel_names=struct2cell(channel_list);           %converting struct to cell for accessing channel names
        channels_in_use=numel(channel_names(1,:));
        Channels_array=[];
        for i=1:channels_in_use
            Channels_array=[Channels_array;string(channel_names(1,i))]; %only contains channel names; without other data from the struct
        end    
       
        
        for channel_index=1:length(Channels_array)
            cd (strcat(root,{'/'},tetrodes(folder)))
            [c,t]=load_open_ephys_data_faster(Channels_array(channel_index));
            fn=30000;
            Wn1=[300/(fn/2) 6000/(fn/2)]; % Cutoff=300-6000 Hz
            [b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients
            c=filtfilt(b1,a1,c);
            ch=c; %Channels (modify accordingly)**
            t=t; %Timestamps (modify accordingly)**
            disp('done loading channel'+string(channel_index)+' '+'for'+' '+string(tetrodes(folder)))
            %% MODULE SELECTING phy_AGR or phy_MS4 for loading gwfparams
            
            params_dir= dir(strcat(root,{'/'},string(tetrodes(folder)))); %Reaching the directory after user input
            % remove all files (isdir property is 0)
            params_dir= params_dir([params_dir(:).isdir]); 
            % remove '.' and '..' 
            params_dir_folder = params_dir(~ismember({params_dir(:).name},{'.','..'}));                        %Only displaying folders (contains either AGR or MS4)
            extension=struct2cell(params_dir_folder);
            extension_final=string(extension(1,1));                                                            %Obtaining the folder name for that tetrode folder
 
            gwfparams.dataDir=strcat(root,{'/'},string(tetrodes(folder)),{'/'},extension_final);  %entering extension_final
            
            %Load phy data
            %% Parameters
            gwfparams.nCh = 1;% 4 most times. Number of channels of tetrode. It should be adaptative since not all tetrodes contain 4 channels.
            gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
            gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out. For now we leave this but may also need to adapt later.

            gwfparams.spikeClusters= readNPY(fullfile(gwfparams.dataDir, 'spike_clusters.npy'));               % Order in which data was streamed to disk; must be 1-indexed for Matlab
            gwfparams.spikeTimes= readNPY(fullfile(gwfparams.dataDir, 'spike_times.npy')); %size=1180074              % Order in which data was streamed to disk; must be 1-indexed for Matlab
            chMap= readNPY(fullfile(gwfparams.dataDir, 'channel_map.npy'))+1; % Order in which data was streamed to disk; must be 1-indexed for Matlab
            
            chMap_use=chMap(channel_index); % only one channel for our test case**
            
            wfNSamples = length(gwfparams.wfWin(1):gwfparams.wfWin(end));
            nChInMap = numel(chMap_use);%**
            
            %disp('done loading parameters'+'for'+'channel'+string(channel_index))
            %% Read spike time-centered waveforms
            cd(gwfparams.dataDir) %important
            a=tdfread('cluster_group.tsv'); %Read TSV file
            cluster_id=extractfield(a,'cluster_id')'; %Extract IDs
            group=extractfield(a,'group'); %Extract labels
            unitIDs=cluster_id(contains(string(group{1}),'good')|contains(string(group{1}),'unsorted'));%Use only good or unsorted
            numUnits = size(unitIDs,1);
            spikeTimeKeeps = nan(numUnits,gwfparams.nWf);%[8 2000]
            %WF_ALL=[];
            
            waveForms = nan(gwfparams.nWf,nChInMap,wfNSamples,numUnits);%[2000 1 82 8]
%             waveFormsMean = nan(nChInMap,wfNSamples,numUnits);%[1 82 8]
            
            for curUnitInd=1:numUnits %from 1 to 8
               
                curUnitID = unitIDs(curUnitInd); % curated cluster IDs from unique clusters(unitIDs)
                curSpikeTimes = gwfparams.spikeTimes(gwfparams.spikeClusters==curUnitID);% size=1972, << gwfparams.spikeTimes
                curUnitnSpikes = size(curSpikeTimes,1);%value=1972
                rng('default');
                s = rng; %setting a fixed seed for permutation
                spikeTimesRP = curSpikeTimes(randperm(curUnitnSpikes));%random permutation of different spiketimes (why?)
                spikeTimeKeeps(curUnitInd,1:min([gwfparams.nWf curUnitnSpikes])) = sort(spikeTimesRP(1:min([gwfparams.nWf curUnitnSpikes])));
                %^size=[8 min value(2000, nspikes)], max=[8 2000]              %^%sorting maximum of 2000 permuted spiketimes value
                
                for curSpikeTime = 1:min([gwfparams.nWf curUnitnSpikes])
                    %.continuous files in 'ch'. It should something like:
                    tmpWf= ch(spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(1):spikeTimeKeeps(curUnitInd,curSpikeTime)+gwfparams.wfWin(end));%seems to work as is
                    %^[82]
                    waveForms(curSpikeTime,:,:,curUnitInd)=  tmpWf;%[2000 1 82 8]
    
                end
                waveFormsMean=  squeeze(nanmean(waveForms(:,:,:,curUnitInd),1));
                disp(['Completed ' int2str(curUnitInd) ' units of ' int2str(numUnits) '.']);
               
                t_name=tetrodes(folder);
                T=regexp(t_name,'_','split');
                   
                WFM.title=strcat('WFM','_','Rn',root(k1+4),'_','SD',root(k2(1)+3),'_','T',string(T(2)),'_','UID',string(curUnitID),'_','C',string(channel_index));% WFM+rat_no.+study_day+tetrode_name+Cluster IDs+channel 
                WFM.title=WFM.title(1);
                WFM.data=waveFormsMean.';
                
                WFM_ALL_TETRODE_WISE=[WFM_ALL_TETRODE_WISE;WFM];
                %WFM.title=strcat('WFM',string(i),'_','Rn',root(k1+4),'_','SD',root(k2(1)+3),'_','T',string(T(2)),'_','UID',string(unitIDs),'_','C',string(channel_index));% WFM+rat_no.+study_day+tetrode_name+Cluster IDs+channel 
              
                    
                     
                
                
            end
            
            
            
            
           

 
            
        
        end
        
    
        
        clear ch; clear t; clear waveForms; clear waveFormMean; clear Channels_array
 
    end       

end
RAT_3_Test= WFM_ALL_TETRODE_WISE;
save('/home/irene/Downloads/RGS14_all/Code/Rat_3_Test');         
toc       
