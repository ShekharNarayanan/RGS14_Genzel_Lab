%% Automation Attempt
%% Brief explanation of what the script does:
%%

tic
cd /

%% Accessing different study days

root_rat= '/media/irene/Rat9/Spike_sorting';
study_day_dir= dir(root_rat); %Reaching the directory after user input
% remove all files (isdir property is 0)
study_day_dir= study_day_dir([study_day_dir(:).isdir]); 
% remove '.' and '..' 
study_day_folders = study_day_dir(~ismember({study_day_dir(:).name},{'.','..'}));                        
study_day_folders=struct2cell(study_day_folders(:,1));
study_days=natsortfiles(study_day_folders(1,:));

%% Adrian's note: Take only spike-sorted folders indicated in the google spreadsheet. Also some spike-sorted study days are not in SPIKE for some reason...
%Temp_Study_Days=study_days([1 3 6]); % TEMPORARY

%% Initializing Main Variabes

Stored_WFMs=[];
Wave_Matrix_Data=[];
Wave_Matrix_Titles=[];

%% Reaching merged and cortex folders

for study_days_index=1:length(study_days) 
        
    root_prelim=strcat(root_rat,{'/'},string(study_days(study_days_index)));
    root_merged_dir=dir(root_prelim);
    root_merged_dir=root_merged_dir([root_merged_dir(:).isdir]);
    root_merged_folders=root_merged_dir(~ismember({root_merged_dir(:).name},{'.','..'}));
    
    root_folder_names=extractfield(root_merged_folders,'name');
    for i=1:length(root_folder_names)
  
      X=string(root_folder_names(i));
      X=convertStringsToChars(X);
      if ismember('Post',X)
          Post_Trial=X;
      else
          Merged_Folder=X;
      end
    end 
    
    root_merged=strcat(root_prelim,{'/'},string(Merged_Folder));
    addpath(root_merged)
    load('trials_durations_samples.mat');
    
    root_cortex=strcat(root_merged,{'/'},'cortex'); % can be changed for hpc
    
    root=root_cortex;%convertStringsToChars(root_cortex);
    %'/media/irene/MD04_RAT_SPIKE/rat/Rat_OS_Ephys_RGS14/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019_merged/cortex';
    %(example)
    
    %% Getting folders for tetrodes (accomodates for hpc)
      tetrodes_dir=dir(root);
      tetrodes_dir=tetrodes_dir([tetrodes_dir(:).isdir]);
      tetrodes_folders=tetrodes_dir(~ismember({tetrodes_dir(:).name},{'.','..'}));
      tetrodes=natsortfiles(extractfield(tetrodes_folders(:,1),'name')); 
      R=convertStringsToChars(root);
      k1=strfind(root_rat,'Rat');%rat number
      k2=strfind(R,'_SD');
      study_day=R(k2(1)+3:k2(1)+4);%study day
      study_day=regexp(study_day,'_','split');
      study_day=study_day{1};
      
      
      name_exp_cond_prelim=string(string(R(k2(1)+5:k2(1)+7)));%gives a string containing the experimental conditons (For two character conditions, extra '_')
      name_exp_cond_final=regexp(name_exp_cond_prelim,'_','split');
      name_exp_cond_final=name_exp_cond_final{1};
    
disp(strcat('starting extraction for:','SD',string(study_day))) 

for folder=1:length(tetrodes)
    Max_vals=[];
    W_temp=[];
   
  
        cd (strcat(root,{'/'},string(tetrodes(folder))))
        channel_list=dir('*.continuous*');                 %Storing .continuous files in a struct
        channel_names=struct2cell(channel_list);           %converting struct to cell for accessing channel names
        channels_in_use=numel(channel_names(1,:));
        Channels_array=[];
        for i=1:channels_in_use
            Channels_array=[Channels_array;string(channel_names(1,i))]; %only contains channel names; without other data from the struct
        end    
       
        
        for channel_index=1:length(Channels_array)
            cd (strcat(root,{'/'},string(tetrodes(folder))))
            CHANNEL=convertStringsToChars(Channels_array(channel_index));
            [c,t]=load_open_ephys_data(CHANNEL);
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
                curSpikeTimes = gwfparams.spikeTimes(gwfparams.spikeClusters==curUnitID);% size=1972, << gwfparams.spikeTimes// save for each ID
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
                
                %% Saving Waveforms according to their Unit IDs (Tetrode Wise)
                
                W_temp(curUnitInd,channel_index).WFM_Titles=strcat('WFM','_','Rn',root_rat(k1+3),'_',string(name_exp_cond_final),'_','SD',string(study_day),'_','T',string(T{1}{2}),'_','UID',string(curUnitID),'_','C',string(channel_index));%%k2(1),k1, T(2) may give array indexing errors; best to check their contents 
               
                W_temp(curUnitInd,channel_index).WFM_Data=waveFormsMean;
                
                W_temp(curUnitInd,channel_index).curSpikeTimes=curSpikeTimes;
                
                W_temp(curUnitInd,channel_index).Avg_Firing_Rate=size(curSpikeTimes,1)/(sum(trial_durations)/30000);
               
               
               
                
                
            end
            
      
        end
        W_Final=W_temp;
        clear ch; clear t; clear waveForms; clear waveFormMean; clear Channels_array;
        
        %% Storing Best Waveforms per Tetrode folder
        for rows=1:size(W_Final,1)
             for columns=1:size(W_Final,2)
                 Max_vals(rows,columns).title=W_Final(rows,columns).WFM_Titles;
                 Max_vals(rows,columns).data=max(abs(W_Final(rows,columns).WFM_Data));
                 
             end 
             A=extractfield(Max_vals(rows,:),'data');
             [M,I]=max(A,[],'linear');
             Stored_WFMs=[Stored_WFMs;W_Final(rows,I)];
             clear A;
        end    
    
       
        
 
    
         
            
        

end







    %end
end

%% Extracting variables for Buzaki script
for c=1:size(Stored_WFMs,1)
    
        
        Wave_Matrix_Data=[Wave_Matrix_Data,Stored_WFMs(c,1).WFM_Data];
        Wave_Matrix_Titles=[Wave_Matrix_Titles,Stored_WFMs(c,1).WFM_Titles];
        
end
%% Saving all relevant variables
for k=1:size(Stored_WFMs,1)
Stored_WFMs(k).WFM_Titles=strrep(Stored_WFMs(k).WFM_Titles,'WFM','RGS_PROJECT_VEHICLE_PFC');
end
RAT_9_TEMP_SD_BEST_WFM= Stored_WFMs;
save('/home/irene/Downloads/RGS14_all_Shekhar/Code/RAT_9_TEMP_SD_BEST_WFM');         
et=toc/60;
disp(strcat('Run time in minutes:',string(et)))
%sendmail('relativelygenius1111@gmail.com',strcat('Rn',root_rat(k1+3)))
