
%% MODULE TRAVERSING TETRODE FOLDERS
%Ask user to enter tetrode folder name then extract .continous files to [c,t]
root = '/home/irene/Downloads/RGS14_all/Tetrodes'; %Change directory to a folder which has all tetrodes
user_input_tet = input('PLEASE enter the tetrode folder ', 's');
cd (strcat(root,{'/'},string(user_input_tet)))     %Changing directory to the chosen tetrode folder
channel_list=dir('*.continuous*');                 %Storing .continuous files in a struct
channels=struct2cell(channel_list);                %converting struct to cell for accessing channel names
[ch1,t1]=load_open_ephys_data_faster(string(channels(1,1)));
disp('done loading channel 1 data')

%% MODULE SELECTING phy_AGR or phy_MS4 for loading gwfparams
params_dir= dir(strcat('/home/irene/Downloads/RGS14_all/Tetrodes',{'/'},string(user_input_tet))); %Reaching the directory after user input
% remove all files (isdir property is 0)
params_dir= params_dir([params_dir(:).isdir]); 
% remove '.' and '..' 
params_dir_folder = params_dir(~ismember({params_dir(:).name},{'.','..'}));                        %Only displaying folders (contains either AGR or MS4
extension=struct2cell(params_dir_folder);
extension_final=string(extension(1,1));                                                            %Obtaining the folder name for that tetrode folder
  
%% Old script starting here  
gwfparams.dataDir=strcat('/home/irene/Downloads/RGS14_all/Tetrodes',{'/'},string(user_input_tet),{'/'},extension_final);    
gwfparams.spikeClusters= readNPY(fullfile(gwfparams.dataDir, 'spike_clusters.npy')); 
disp('done loading channel data and parameters')

