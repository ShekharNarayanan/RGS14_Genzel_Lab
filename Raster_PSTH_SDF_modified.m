clc;clear
A=matfile('RAT_9_TEMP_SD_BEST_WFM.mat');
tm=({A.curSpikeTimes});
sptimes=cellfun(@(x) double(x*(1/30000)) ,tm,'UniformOutput',false);
all = [];
for iTrial = 1:length(sptimes)
    all             = [all; sptimes{iTrial}];               % Concatenate spikes of all trials             
end

ax                  = figure();
% ax=figure()
nbins               = 10000;
h                   = histogram(all,nbins);
h.FaceColor         = 'k';
h.BinWidth          = 1;
mVal                = max(h.Values)+round(max(h.Values)*.1);
xlim=[0 7*60*60]; %7 hours
ylim=[0 mVal];
xlabel('Time[s]');
ylabel('Spike/Bin');
 


xline([300+2700],'LineWidth', 1, 'Color', 'r') % T1
xline([300+2700+2700],'LineWidth', 1, 'Color', 'r') %PT1
xline([300+2700+2700+300],'LineWidth', 1, 'Color', 'r') %T2
xline([300+2700+2700+300+2700],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300+2700],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300+2700+300],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300+2700+300+2700],'LineWidth', 1, 'Color', 'r')
xline([300+2700+2700+300+2700+300+2700+300+2700+300],'LineWidth', 1, 'Color', 'r') 
xline([300+2700+2700+300+2700+300+2700+300+2700+300+2700],'LineWidth', 1, 'Color', 'r') 

