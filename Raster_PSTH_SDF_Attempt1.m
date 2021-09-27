clc;clear
A=matfile('RAT_3_TEMP_SD_BEST_WFM.mat');
tm=({A.curSpikeTimes});
sptimes=cellfun(@(x) double(x*(1/30000)) ,tm,'UniformOutput',false);
all = [];
for iTrial = 1:length(sptimes)
    all             = [all; sptimes{iTrial}];               % Concatenate spikes of all trials             
end

ax                  = figure();
% ax=figure()
nbins               = 1000;
h                   = histogram(all,nbins);
h.FaceColor         = 'k';
mVal                = max(h.Values)+round(max(h.Values)*.1);
xlim             = [0 7*60*60];
ylim            = [0 mVal];
%xticks            = [0 7*60*60];
xlabel('Time [s]');
ylabel('Spikes/Bin');

yticklabels_new=reshape(yticklabels,[1 size(yticklabels,1)]);
slength             = 25819000;                                  % Length of signal trace [ms]
bdur                = slength/nbins;                        % Bin duration in [ms]
nobins              = 1000/bdur;                            % No of bins/sec
for iLab = 1:length(yticklabels_new)
    lab             = str2num(yticklabels_new{iLab});
    conv            = lab/length(sptimes) * nobins; 	% Convert to [Hz]: avg spike count * bins/sec
    newlabel{iLab}  = num2str(round(conv));                 % Change YLabel
end 
yticklabels=newlabel;
%ax.YLabel.String  	= 'Firing Rate [Hz]';
%ylim=[0 str2num(newlabel{7})];
ylabel('Firing rate [Hz]');




xline([300+2700],'LineWidth', 1, 'Color', 'r') % T1
xline([300+2700+2700],'LineWidth', 1, 'Color', 'r') %PT1
xline([300+2700+2700+300],'LineWidth', 1, 'Color', 'r') %T2
xline([300+2700+2700+300+2700],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300+2700],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300+2700+300],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300+2700+300+2700],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300+2700+300+2700+300],'LineWidth', 1, 'Color', 'r') 

