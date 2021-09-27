%clc;clear
cd /
cd /home/irene/Downloads/RGS14_all/Code
A=matfile('RAT_1_TEMP_SD_BEST_WFM.mat');
B=matfile('RAT_2_TEMP_SD_BEST_WFM.mat');
C=matfile('RAT_3_TEMP_SD_BEST_WFM.mat');
D=matfile('RAT_4_TEMP_SD_BEST_WFM.mat');
E=matfile('RAT_6_TEMP_SD_BEST_WFM.mat');
F=matfile('RAT_7_TEMP_SD_BEST_WFM.mat');
G=matfile('RAT_9_TEMP_SD_BEST_WFM.mat');

RGS14=[C.Wave_Matrix_Data,D.Wave_Matrix_Data,F.Wave_Matrix_Data];
Stored_WFM_RGS14=[C.Stored_WFMs;D.Stored_WFMs;F.Stored_WFMs];

%% VEHICLE
Vehicle=[A.Wave_Matrix_Data,B.Wave_Matrix_Data,E.Wave_Matrix_Data,G.Wave_Matrix_Data]; 
Stored_WFM_Vehicle=[A.Stored_WFMs;B.Stored_WFMs;E.Stored_WFMs;G.Stored_WFMs];

Result_Matrix=[Vehicle,RGS14]; 

MaxWaves = Result_Matrix;
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
for a = 1:size(MaxWaves,2)
    thiswave = MaxWaves(:,a);
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
        tp(a) = maxpos-minpos; %In number of samples
end

%% get spike width by taking inverse of max frequency in spectrum (based on Adrien's use of Eran's getWavelet)
for a = 1:size(MaxWaves,2)
    w = MaxWaves(:,a);
    w = [w(1)*ones(1000,1);w;w(end)*ones(1000,1)];
    [wave f t] = getWavelet(w,30000,500,3000,128);
    
    %We consider only the central portion of the wavelet because we
    %haven't filtered it before hand (e.g. with a Hanning window)
    wave = wave(:,int16(length(t)/4):3*int16(length(t)/4));
    %Where is the max frequency?
    [maxPow ix] = max(wave);
    [dumy mix] = max(maxPow);
    ix = ix(mix);
    spkW(a) = 1000/f(ix);
end
%%
%% Generate separatrix for cells 
OneMs = round(30000/1000);
x = tp'/OneMs;%trough to peak in ms
y = spkW';%width in ms of wavelet representing largest feature of spike complex... ie the full trough including to the tip of the peak

xx = [0 0.8];
yy = [2.4 0.4];
m = diff( yy ) / diff( xx );
b = yy( 1 ) - m * xx( 1 );  % y = ax+b
RS = y>= m*x+b;
INT = ~RS;
%%
knownEidx=[];
knownIidx=[];

% if all(knownEidx | knownIidx | ignoreidx) && keepKnown
%     PyrBoundary = [nan nan];
%     ELike = false(size(spikes.UID));
% else

%%
    
    h = figure('position',[674   456   560   420]);
    fprintf('\nDiscriminate pyr and int (select Pyramidal)');
    xlabel('Trough-To-Peak Time (ms)')
    ylabel('Wave width (via inverse frequency) (ms)')
    figure('position',[674   961   561   109]);
    title({'Discriminate pyr and int (select Pyramidal)','left click to draw boundary', 'center click/ENTER to complete)'});
    figure(h)
    [ELike,PyrBoundary] = ClusterPointsBoundaryOutBW([x y],knownEidx,knownIidx,m,b);
    ELike = ELike';
    ELike_Vehicle=ELike(1:size(Stored_WFM_Vehicle,1));
    ELike_RGS14=ELike(size(Stored_WFM_Vehicle,1)+1:size(ELike,2));
   
% end

[Interneuron_Data_RGS14, Pyr_Data_RGS14]= Avg_Firing_Rate_Classification(ELike_RGS14,Stored_WFM_RGS14);

[Interneuron_Data_Vehicle, Pyr_Data_Vehicle]= Avg_Firing_Rate_Classification(ELike_Vehicle,Stored_WFM_Vehicle);
% end

%[Interneuron_Data, Pyr_Data]= Avg_Firing_Rate_Classification(ELike,Stored_WFMs_All);




