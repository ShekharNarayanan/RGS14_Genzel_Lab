for i=1:size(Firing_Rate_Threshold,1)
subplot(5,3,i)
plot([Firing_Rate_Threshold(i).WFM_Data]);title(strcat('Firing Rate in Hz:',string(Firing_Rate_Threshold(i).Avg_Firing_Rate),':',string(Firing_Rate_Threshold(i).WFM_Titles)),'Interpreter','none');
end