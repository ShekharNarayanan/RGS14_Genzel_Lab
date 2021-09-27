% clc;clear
cd /
cd /home/irene/Downloads/RGS14_all_Shekhar/Code
A=load('RAT_1_TEMP_SD_BEST_WFM.mat');
B=load('RAT_2_TEMP_SD_BEST_WFM.mat');
C=load('RAT_3_TEMP_SD_BEST_WFM.mat');
D=load('RAT_4_TEMP_SD_BEST_WFM.mat');
E=load('RAT_6_TEMP_SD_BEST_WFM.mat');
F=load('RAT_7_TEMP_SD_BEST_WFM.mat');
G=load('RAT_9_TEMP_SD_BEST_WFM.mat');
H=load('RAT_8_TEMP_SD_BEST_WFM.mat');

addpath('/home/irene/Downloads/RGS14_all_Shekhar/Waveforms')
load('Rat_3_SP_Corrected_WFM.mat');load('Rat_4_SP_Corrected_WFM.mat');load('Rat_7_SP_Corrected_WFM.mat');load('Rat_8_SP_Corrected_WFM.mat');
load('Rat_1_SP_Corrected_WFM.mat');load('Rat_2_SP_Corrected_WFM.mat');load('Rat_6_SP_Corrected_WFM.mat');load('Rat_9_SP_Corrected_WFM.mat');

%% RGS14
RGS14_Matrix=[C.Wave_Matrix_Data,D.Wave_Matrix_Data,F.Wave_Matrix_Data,H.Wave_Matrix_Data];
Stored_WFM_RGS14=[Rat_3_SP_Corrected_WFM  Rat_4_SP_Corrected_WFM  Rat_7_SP_Corrected_WFM Rat_8_SP_Corrected_WFM];

%% VEHICLE
Vehicle_Matrix=[A.Wave_Matrix_Data,B.Wave_Matrix_Data,E.Wave_Matrix_Data,G.Wave_Matrix_Data]; 
Stored_WFM_Vehicle=[Rat_1_SP_Corrected_WFM Rat_2_SP_Corrected_WFM Rat_6_SP_Corrected_WFM Rat_9_SP_Corrected_WFM];

MaxWaves_1 = Vehicle_Matrix;MaxWaves_2=RGS14_Matrix;
% for a = 1:length(spikes.rawWaveform)%in case stored wrong
%     if iscolumn(spikes.rawWaveform{1})
%         MaxWaves = cat(2,spikes.rawWaveform{:});
%     elseif isrow(spikes.rawWaveform{1})
%         MaxWaves = cat(1,spikes.rawWaveform{:})';
%     else
%         error('Something is wrong with your waveforms')
%     end
% end
% %% get trough-peak delay times
% AllWaves(:,:,1) = [];
%% VEHICLE (spkW_1, tp_1,[x_1 y_1])
for a = 1:size(MaxWaves_1,2)
    thiswave = MaxWaves_1(:,a);
    [minval,minpos] = min(thiswave);
    minpos = minpos(1);
    [maxval,maxpos] = max(thiswave);
        [dummy,maxpos] = max(thiswave(minpos+1:end));
        if isempty(maxpos)
            warning('Your Waveform may be erroneous')
            maxpos = 1
        end
        maxpos=maxpos(1);
        maxpos = maxpos+minpos;
        tp_1(a) = maxpos-minpos; %In number of samples
end

%% VEHICLE:get spike width by taking inverse of max frequency in spectrum (based on Adrien's use of Eran's getWavelet)
for a = 1:size(MaxWaves_1,2)
    w_1 = MaxWaves_1(:,a);
    w_1 = [w_1(1)*ones(1000,1);w_1;w_1(end)*ones(1000,1)];
    [wave f t] = getWavelet(w_1,30000,500,3000,128);
    
    %We consider only the central portion of the wavelet because we
    %haven't filtered it before hand (e.g. with a Hanning window)
    wave = wave(:,int16(length(t)/4):3*int16(length(t)/4));
    %Where is the max frequency?
    [maxPow ix] = max(wave);
    [dumy mix] = max(maxPow);
    ix = ix(mix);
    spkW_1(a) = 1000/f(ix);
end

%% RGS14 (spkW_2, tp_2, [x_2 y_2])

for b = 1:size(MaxWaves_2,2)
    thiswave = MaxWaves_2(:,b);
    [minval,minpos] = min(thiswave);
    minpos = minpos(1);
    [maxval,maxpos] = max(thiswave);
        [dummy,maxpos] = max(thiswave(minpos+1:end));
        if isempty(maxpos)
            warning('Your Waveform may be erroneous')
            maxpos = 1
        end
        maxpos=maxpos(1);
        maxpos = maxpos+minpos;
        tp_2(b) = maxpos-minpos; %In number of samples
end

%% RGS14:get spike width by taking inverse of max frequency in spectrum (based on Adrien's use of Eran's getWavelet)
for b = 1:size(MaxWaves_2,2)
    w_2 = MaxWaves_2(:,b);
    w_2 = [w_2(1)*ones(1000,1);w_2;w_2(end)*ones(1000,1)];
    [wave f t] = getWavelet(w_2,30000,500,3000,128);
    
    %We consider only the central portion of the wavelet because we
    %haven't filtered it before hand (e.g. with a Hanning window)
    wave = wave(:,int16(length(t)/4):3*int16(length(t)/4));
    %Where is the max frequency?
    [maxPow ix] = max(wave);
    [dumy mix] = max(maxPow);
    ix = ix(mix);
    spkW_2(b) = 1000/f(ix);
end

%% Generate separatrix for cells 
OneMs = round(30000/1000);
%% VEHICLE
x_1 = tp_1'/OneMs;%trough to peak in ms
y_1 = spkW_1';%width in ms of wavelet representing largest feature of spike complex... ie the full trough including to the tip of the peak
%% RGS14
x_2 = tp_2'/OneMs;%trough to peak in ms
y_2 = spkW_2';%width in ms of wavelet representing largest feature of spike complex... ie the full trough including to the tip of the peak
xx = [0 0.8];
yy = [2.4 0.4];

m = diff( yy ) / diff( xx );
b = yy( 1 ) - m * xx( 1 );  % y = ax+b
RS = y_1>= m*x_1+b;
INT = ~RS;
%%
knownEidx=[];
knownIidx=[];

% if all(knownEidx | knownIidx | ignoreidx) && keepKnown
%     PyrBoundary = [nan nan];
%     ELike = false(size(spikes.UID));
% else

%% 


   C1=[x_1,y_1]; %vVehicle
   C2=[x_2, y_2]; %RG
   C=[C1;C2];

% Generating Classification plot   
%     h = figure('position',[674   456   560   420]);
%     fprintf('\nDiscriminate pyr and int (select Pyramidal)');
%     xlabel('Trough-To-Peak Time (ms)')
%     ylabel('Wave width (via inverse frequency) (ms)')
%     figure('position',[674   961   561   109]);
%     title({'Discriminate pyr and int (select Pyramidal)','left click to draw boundary', 'center click/ENTER to complete)'});
%     figure(h)
%     [ELike,PyrBoundary] = ClusterPointsBoundaryOutBW_mod([C],knownEidx,knownIidx,m,b,C1,C2);
%     ELike=ELike';
%     ELike_Vehicle=ELike(1:size(Stored_WFM_Vehicle,2));
%     ELike_RGS14=ELike(size(Stored_WFM_Vehicle,2)+1:size(ELike,2));
% %     
% % RGS14 WFM Names   
% index_rgs_pyr=ELike_RGS14==1; index_rgs_inter=ELike_RGS14==0;
% Interneuron_Data_RGS14=Stored_WFM_RGS14(index_rgs_inter);
% Pyr_Data_RGS14=Stored_WFM_RGS14(index_rgs_pyr);
% 
% RGS14=[]; 
% 
% RGS14.Interneurons=Interneuron_Data_RGS14; RGS14.Pyramidal_Cells=Pyr_Data_RGS14;
% 
% % Vehicle WFM Names   
% index_veh_pyr=ELike_Vehicle==1; index_veh_inter=ELike_Vehicle==0;
% 
% Interneuron_Data_Vehicle=Stored_WFM_Vehicle(index_veh_inter);
% 
% Pyr_Data_Vehicle=Stored_WFM_Vehicle(index_veh_pyr);
% 
% Vehicle=[]; 
% 
% Vehicle.Interneurons=Interneuron_Data_Vehicle; Vehicle.Pyramidal_Cells=Pyr_Data_Vehicle;
% 
% 
% save('/home/irene/Downloads/RGS14_all_Shekhar/Cell_Classification_Data','RGS14');
% save('/home/irene/Downloads/RGS14_all_Shekhar/Cell_Classification_Data','Vehicle');

