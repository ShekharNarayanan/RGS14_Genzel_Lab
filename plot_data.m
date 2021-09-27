
for Unit=1:numUnits 
         
         subplot(4,4,Unit)
         plot(((0:length(WFM_1(:,:,Unit))-1))/30000*1000,WFM_1(:,:,Unit))
         xlabel('millisecond');
         ylabel('Unit ID'+string(unitIDs(Unit)));
end  

%Comparing values of Unit IDs from phy; ID 4 for example
 
 C_1_ID=max(abs(WFM_1(:,:,7)));
 C_2_ID=max(abs(WFM_2(:,:,7)));
 C_3_ID=max(abs(WFM_3(:,:,7)));
 C_4_ID=max(abs(WFM_4(:,:,7)));

 C_ALL=[C_1_ID,C_2_ID,C_3_ID,C_4_ID];
 
for i=1:length(C_ALL)
    if C_ALL(i)==max(abs(C_ALL))
        disp(strcat('Best Channel for ID 14 is channel',{' '},string(i), {' '},'with absolute amplitude =',{' '}, string(max(abs(C_ALL))),'mV'))
        
    end    
   
end   

plot(((0:length(WFM_1(:,:,7))-1))/30000*1000,-WFM_1(:,:,7))
xlabel('millisecond');
ylabel('Unit ID'+string(unitIDs(7)));