% clc;clear
% A=load('RAT_9_TEMP_SD_BEST_WFM.mat');
% WFMs=A.Stored_WFMs;
% Titles=extractfield(WFMs,'WFM_Titles');
% tm=({A.curSpikeTimes});
% sptimes=cellfun(@(x) double(x*(1/30000)) ,tm,'UniformOutput',false);
% all = [];
% for iTrial = 1:length(sptimes)
%     all             = [all; sptimes{iTrial}];               % Concatenate spikes of all trials             
% end

ax                  = figure();
% ax=figure()
nbins               = 10000;
h                   = histogram(units,nbins);
h.FaceColor         = 'k';
mVal                = max(h.Values)+round(max(h.Values)*.1);
xlim=[0 45*60]; %7 hours
ylim=[0 mVal]/25819000;
xlabel('Time[s]');
ylabel('Firing Rate');
%title(Titles(1), 'Interpreter', 'none');

 


xline(790,'LineWidth', 2, 'Color', 'b') % T1
xline(849,'LineWidth', 2, 'Color', 'b') %PT1
% xline([300+2700+2700+300],'LineWidth', 2, 'Color', 'b') %T2
% xline([300+2700+2700+300+2700],'LineWidth', 2, 'Color', 'b')
% xline([300+2700+2700+300+2700+300],'LineWidth', 2, 'Color', 'b')
% xline([300+2700+2700+300+2700+300+2700],'LineWidth', 2, 'Color', 'b')
% xline([300+2700+2700+300+2700+300+2700+300],'LineWidth', 2, 'Color', 'b')
% xline([300+2700+2700+300+2700+300+2700+300+2700],'LineWidth', 2, 'Color', 'b')
% xline([300+2700+2700+300+2700+300+2700+300+2700+300],'LineWidth', 2, 'Color', 'b') 
