
%% Interneuron
function [Interneuron_Data, Pyr_Data]= Avg_Firing_Rate_Classification(ELike,Stored_WFMs_All)
Interneuron_Index=ELike==0;
Interneuron_Data=Stored_WFMs_All(Interneuron_Index);
Interneuron_Data=nestedSortStruct(Interneuron_Data,'Avg_Firing_Rate');

%% Pyramidal 
Pyramidal_Index=ELike==1;
Pyr_Data=Stored_WFMs_All(Pyramidal_Index);
Pyr_Data=nestedSortStruct(Pyr_Data,'Avg_Firing_Rate');

end
