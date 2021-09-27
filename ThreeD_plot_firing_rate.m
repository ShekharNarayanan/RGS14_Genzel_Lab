clc;clear
cd /
cd /home/irene/Downloads/RGS14_all_Shekhar/Code
A=load('RAT_1_TEMP_SD_BEST_WFM.mat');
B=load('RAT_2_TEMP_SD_BEST_WFM.mat');
C=load('RAT_3_TEMP_SD_BEST_WFM.mat');
D=load('RAT_4_TEMP_SD_BEST_WFM.mat');
E=load('RAT_6_TEMP_SD_BEST_WFM.mat');
F=load('RAT_7_TEMP_SD_BEST_WFM.mat');
G=load('RAT_9_TEMP_SD_BEST_WFM.mat');


%% RGS14
RGS14=[C.Wave_Matrix_Data,D.Wave_Matrix_Data,F.Wave_Matrix_Data];
Stored_WFM_RGS14=[C.Stored_WFMs;D.Stored_WFMs;F.Stored_WFMs];

%% VEHICLE
Vehicle=[A.Wave_Matrix_Data,B.Wave_Matrix_Data,E.Wave_Matrix_Data,G.Wave_Matrix_Data]; 
Stored_WFM_Vehicle=[A.Stored_WFMs;B.Stored_WFMs;E.Stored_WFMs;G.Stored_WFMs];

MaxWaves_1 = Vehicle;MaxWaves_2=RGS14;
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
        tp_1(a) = maxpos-minpos;
        Firing_Rate_Vehicle(a)=Stored_WFM_Vehicle(a).Avg_Firing_Rate;%In number of samples
        Max_Amplitudes_Vehicle(a)=max(abs(Stored_WFM_Vehicle(a).WFM_Data))*0.195;
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
        Firing_Rate_RGS14(b)=Stored_WFM_RGS14(b).Avg_Firing_Rate;
        Max_Amplitudes_RGS14(b)=max(abs(Stored_WFM_RGS14(b).WFM_Data))*0.195;
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
   
% subplot(3,1,1)
scatter3(x_1,y_1,Max_Amplitudes_Vehicle,'k','filled');
hold on;
scatter3(x_2,y_2,Max_Amplitudes_RGS14,'r','filled');
legend('Vehicle','RGS14')
xlabel('Trough to Peak Delay');ylabel('Wave Width');zlabel('Maximum Amplitudes');title('3D plot (scaled_amp vs wave_width vs trough2peak delay','Interpreter','none')
%zlim([0 10]);

% subplot(3,1,2)
% scatter3(x_1,y_1,Firing_Rate_Vehicle,'k','filled');
% hold on;
% scatter3(x_2,y_2,Firing_Rate_RGS14,'r','filled');
% legend('Vehicle','RGS14')
% xlabel('Trough to Peak Delay');ylabel('Wave Width');zlabel('Average Firing Rate');title('Firing Rate Distribution 0-5 Hz')
% zlim([0 5]);
% 
% subplot(3,1,3)
% scatter3(x_1,y_1,Firing_Rate_Vehicle,'k','filled');
% hold on;
% scatter3(x_2,y_2,Firing_Rate_RGS14,'r','filled');
% legend('Vehicle','RGS14')
% xlabel('Trough to Peak Delay');ylabel('Wave Width');zlabel('Average Firing Rate');title('Firing Rate Distribution 0-1 Hz')
% zlim([0 1]);

%% Finding waveforms with firing rate Threshold

X=Stored_WFM_Vehicle;%or RGS
i=find(Firing_Rate_Vehicle>40);
Threshold=X(i);
for i=1:size(Threshold,1)
subplot(3,1,i)% change matrix dims depending on Threshodd size
plot([Threshold(i).WFM_Data]); title(strcat(num2str(Threshold(i).Avg_Firing_Rate),'_',Threshold(i).WFM_Titles),'Interpreter','none');
end

%% Finding waveforms with amplitude Threshold

% X=Stored_WFM_Vehicle;%or RGS
% i1=Max_Amplitudes_Vehicle>300;
% i2=Max_Amplitudes_Vehicle<20;
% Threshold_Upper=X(i1);
% Threshold_Lower=X(i2);
% 
% for i=1:size(Threshold_Upper,1)
% subplot(3,3,i)% change matrix dims depending on Threshodd size
% 
% plot([Threshold_Upper(i).WFM_Data*0.195]); title(strcat('Amp=-',num2str(max(abs(Threshold_Upper(i).WFM_Data*0.195))),'__',Threshold_Upper(i).WFM_Titles),'Interpreter','none');
% end
% 
% for i=1:size(Threshold_Lower,1)
% subplot(5,3,i)% change matrix dims depending on Threshodd size
% 
% plot([Threshold_Lower(i).WFM_Data*0.195]); title(strcat('Amp=-',num2str(max(abs(Threshold_Lower(i).WFM_Data*0.195))),'__',Threshold_Lower(i).WFM_Titles),'Interpreter','none');
% end
