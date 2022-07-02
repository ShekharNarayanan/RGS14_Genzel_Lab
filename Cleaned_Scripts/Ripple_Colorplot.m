function imagesc_all_units=Ripple_Colorplot(Ripple_Variable, Treatment, bins)

if strcmp(Treatment,'RGS')
    
    a=2;
    b=3;
else
    a=4;
    b=6;
    
end
imagesc_all_units=[];
numbin=bins;

% start loop here
for index=1:length(Ripple_Variable)
    
    disp(index)
    Unit=Ripple_Variable(index).Ripple_Spike_Times_Normalized;
    Unit_All=[Unit{:}];
    bin_vals=histcounts(Unit_All,numbin);
    zscored_vals=zscore(bin_vals);
    
    
    imagesc_all_units=[imagesc_all_units; zscored_vals];
    
end

%% Sorting the matrix 
mean_column=[];
for i=1:size(imagesc_all_units,1)
    
    %    mean_column=[mean_column; mean(imagesc_all_units(i,98:103))];
    mean_column=[mean_column; mean(imagesc_all_units(i,size(imagesc_all_units,2)/2- 2 :size(imagesc_all_units,2)/2+ 3))];
    
end
[~, sort_index]=sort(mean_column);
imagesc_all_units=imagesc_all_units(sort_index,:);


%% PLotting
% figure('Name',sprintf('sorted plot- %s',Treatment))

xaxis=linspace(-0.8,0.8,size(imagesc_all_units,2)-numbin/5);
yaxis=1:length(Ripple_Variable);

imagesc(xaxis,yaxis,imagesc_all_units(:,numbin/2/5+1:numbin-numbin/2/5));
colorbar();colormap('hot');
caxis([-3 7]) %Adjusted to be the same between RGS14 and veh.

ax = gca;
xlabel('window around ripple')
ylabel('unit wise response')
title(sprintf('sorted ripple response: %s pyr: \n %d units',Treatment,size(imagesc_all_units,1)))



end