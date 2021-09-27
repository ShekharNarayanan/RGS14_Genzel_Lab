A.title='My name is shekhar';
A.data=[1,2,3,4];

R='/media/irene/MD04_RAT_SPIKE/rat/Rat_OS_Ephys_RGS14/Spike_sorting/Rat_OS_Ephys_RGS14_rat3_357152/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019/OS_Ephys_RGS14_Rat3_357152_SD6_OR_21-22_10_2019_merged/cortex';
%TF = contains(str,pat)
%Example to name each cluster: 08021501C2 would mean rat8, study day 2, tetrode 15 and ID cluster 1 extracted from channel2
x1=contains(R,'_Rat3');
x2=contains(R,'SD6');

if x1&&x2
    A.title=strcat('03','06');
end    
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k1=strfind(R,'_rat');%3
k2=strfind(R,'_SD'); %6
name_exp_cond=R(k2(1)+5:k2(1)+7);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F.title=strcat('0',R(k1+4),'0',R(k2(1)+3),'15','1','C2')

for i =1:10
    
disp(i)
end    

X=[];
for i =1: 4
    B=i+1;
    C.title=strcat('B',string(i));
    C.data=B;
    D=[X;C];
end    
a=12;
b=13;
c=15;
d=17;
%%%%%%%% looping
A=[string(a),string(b),string(c),string(d)];
for i=1:length(A)
    disp(A(i))
end    
%%%%%%plotting
for i=1:length(X(:,:))
    
    subplot(length(X(:,:))/2,length(X(:,:))/2,i)

 plot(((0:length(X(i,:).data)-1)*1000/30000),X(i,:).data)

end

wtemp=[];
for y=1:4
for x=1:10
    wtemp(x,y)=x*y;
end    
end



p=[];
S=[];

for c=1:size(W_temp,1)
    S(c).data=max(abs(W_temp(1,c).data));
    S(c).title=W_temp(1,c).title;
    
end    

Max_vals=[];
Stored_WFMs=[];
for row=1:size(W_temp,1)
    %if row==2
    for column=1:size(W_temp,2)
        Max_vals(curUnitInd,channel_index).data=max(abs(W_temp(curUnitInd,channel_index).data));
        Max_vals(curUnitInd,channel_index).title=W_temp(curUnitInd,channel_index).title;
        
    end 
    A=extractfield(Max_vals(curUnitInd,:),'data');
    [M,I]=max(A,[],'linear');
    Stored_WFMs=[Stored_WFMs;W_temp(curUnitInd,I)];
    %end
end

%%%%saving amplitudes (incorporate in loop)
A=extractfield(Max_vals(1,:),'data');
[M,I]=max(A,[],'linear');


W_temp(curUnitInd,channel_index).data=waveFormsMean;
W_temp(curUnitInd,channel_index).title=strcat('WFM','_','Rn',root(k1+4),'_','SD',root(k2(1)+3),'_','T',string(T(2)),'_','UID',string(curUnitID),'_','C',string(channel_index));

wave_matrix=[];
for c=1:size(Stored_WFMs,1)
    
  L=extractfield(Stored_WFMs(c,1),'data'); 
  wave_matrix=[wave_matrix,L'];
    
    
end   




for folder=1:length(tetrodes)
    Max_vals=[];
    %if folder==7
  
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
                
                %W_temp(curUnitInd,channel_index).title=strcat('WFM','_','Rn',root(k1+4),'_','SD',root(k2(1)+3),'_','T',string(T(2)),'_','UID',string(curUnitID),'_','C',string(channel_index));
                %%k2(1),k1, T(2) may give array indexing errors; best to check their contents 
               
                W_temp(curUnitInd,channel_index).title=strcat('WFM','_','Rn','3','_','SD','6','_','OR','_','T',string(T{1}{2}),'_','UID',string(curUnitID),'_','C',string(channel_index)); %for unused directory in downloads
                W_temp(curUnitInd,channel_index).data=waveFormsMean;
                
               
                
                
            end
            
      
        end
        W_Final=W_temp;
        clear ch; clear t; clear waveForms; clear waveFormMean; clear Channels_array; clear W_temp;
        
        for rows=1:size(W_Final,1)
             for columns=1:size(W_Final,2)
                 Max_vals(rows,columns).title=W_Final(rows,columns).title;
                 Max_vals(rows,columns).data=max(abs(W_Final(rows,columns).data));
                 
             end 
             A=extractfield(Max_vals(rows,:),'data');
             [M,I]=max(A,[],'linear');
             Stored_WFMs=[Stored_WFMs;W_Final(rows,I)];
             clear A;
        end    
    
       
        
 
    %end 
         
            
        

end

B=[];
folder_names=extractfield(root_merged_folders,'name');
for i=1:length(folder_names)
  
      X=string(folder_names(i));
      X=convertStringsToChars(X);
      if ismember('Post',X)
          Post_Trial=X;
      else
          Merged_Folder=X;
      end
end 



