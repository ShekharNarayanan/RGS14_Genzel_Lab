 MaxWaves = [];
 for a = 1:length(spikes.rawWaveform)%in case stored wrong
     if iscolumn(spikes.rawWaveform{1})
         MaxWaves = cat(2,spikes.rawWaveform{:});
     elseif isrow(spikes.rawWaveform{1})
         MaxWaves = cat(1,spikes.rawWaveform{:})';
     else
        error('Something is wrong with your waveforms')
     end
 end
% %% get trough-peak delay times
 AllWaves(:,:,1) = [];
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
    [wave f t] = getWavelet(w,20000,500,3000,128);
    %We consider only the central portion of the wavelet because we
    %haven't filtered it before hand (e.g. with a Hanning window)
    wave = wave(:,int16(length(t)/4):3*int16(length(t)/4));
    %Where is the max frequency?
    [maxPow ix] = max(wave);
    [dumy mix] = max(maxPow);
    ix = ix(mix);
    spkW(a) = 1000/f(ix);
end