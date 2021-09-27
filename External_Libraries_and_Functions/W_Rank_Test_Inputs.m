function [p_value]=W_Rank_Test_Inputs(dist_1,dist_2)

dist_1_ks=[]; dist_2_ks=[];

for i=1:size(dist_1,2)
    temp_var=dist_1(:,i);
    temp_var_correct=rmmissing(temp_var);
    dist_1_ks=[dist_1_ks; temp_var_correct];
end    

for i=1:size(dist_2,2)
    temp_var=dist_1(:,i);
    temp_var_correct=rmmissing(temp_var);
    dist_2_ks=[dist_2_ks; temp_var_correct];
end 

[p_value] = ranksum(dist_2_ks,dist_1_ks,'Alpha',0.05);



end