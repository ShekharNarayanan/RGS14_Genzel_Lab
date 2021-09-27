
function [ranges_quiet_wake_final, ranges_microarousal_final,ranges_NREM_final, ranges_intermediate_final, ranges_REM_final,ranges_wake_final]=bout_ranges_per_trial_threshold...
    (states,trial_number_index,threshold_vector_for_treatment)

fs=30000;

%% post _trial_matrix=[{states_presleep},{states_trial_1},{states_PT1},{states_trial_2},{states_PT2},{states_trial_3},{states_PT3},{states_trial_4},{states_PT4},{states_trial_5},{states_PT5}];


switch trial_number_index
    case {1,3,5,7,9} % Rest Periods - {PT5}

        x= 3000*(trial_number_index-1)/2 ; % trial_number_index=3 || post_trial_1 starts at 3001
        start_sample_per_second=[x*fs:fs:(fs*length(states)+fs*x)];
        
    case 11 % Post Trial 5
        
        x_1= 3000*(trial_number_index-1)/2; states_1=states(1:2700); %%% x_1 and so on are in time (seconds units)
        
        x_2=x_1+(2700); states_2=states(2701:5400);
        x_3=x_2+(2700); states_3=states(5401:8100);
        x_4=x_3+(2700); states_4=states(8101:end);
        
        start_sample_per_second_1=[x_1*fs :fs: (fs*length(states_1))+x_1*fs];
        start_sample_per_second_2=[x_2*fs :fs: (fs*length(states_2)+fs*x_2)];
        start_sample_per_second_3=[x_3*fs :fs: (fs*length(states_3)+fs*x_3)];
        start_sample_per_second_4=[x_4*fs :fs: (fs*length(states_4)+fs*x_4)];
        
        states_PT5=[{states_1},{states_2},{states_3},{states_4}];
        start_sample_per_second=[{start_sample_per_second_1},{start_sample_per_second_2},{start_sample_per_second_3},{start_sample_per_second_4}];

    case {2,4,6,8,10}  % Trials
        x=2700+3000*((trial_number_index-2)/2);
        
        start_sample_per_second=[x*fs :fs: (fs*length(states)+fs*x)];
end

if trial_number_index~=11 
    for i=1:7
        
        
%         if (i == 1) ||(i == 2) || (i == 3) || (i == 4)  ||(i==5) || (i==7) || (i==6) ||(i==8)||(i==10)
            
            %% Quiet Wake
            
            if i==1
                
                
                sum_check=sum(states==i);
                if sum_check==0
                    ranges_quiet_wake_final=[];
                    continue
                end
                
                %% Quiet Wake Thresholding
                
                
                bout_lengths=ConsecutiveOnes(states==i);
                bout_lengths(bout_lengths<threshold_vector_for_treatment(1))=0;
                
                bout_index=find(bout_lengths);
                
                if isempty(bout_index)
                    ranges_quiet_wake_final=[];
%                     continue
                end
                
                lower_bound=start_sample_per_second(bout_index);
                upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                
                upper_bound=upper_bound-1;
                ranges_sleep_wake=[lower_bound; upper_bound].';
                
                ranges_quiet_wake_first=[]; ranges_quiet_wake_last=[];
                
                for idx=1:size(ranges_sleep_wake,1)
                    
                    first_temp_1=ranges_sleep_wake(idx,1);
                    first_temp_2=ranges_sleep_wake(idx,1)+10*fs;
                    ranges_quiet_wake_first(idx).Samples_Start=first_temp_1;
                    ranges_quiet_wake_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_sleep_wake,1)
                    first_temp_2=ranges_sleep_wake(idx,2);
                    first_temp_1=ranges_sleep_wake(idx,2)-10*fs;
                    ranges_quiet_wake_last(idx).Samples_Start=first_temp_1;
                    ranges_quiet_wake_last(idx).Samples_End=first_temp_2;
                end
                
              
                
                
                
                ranges_quiet_wake_final.First_10=ranges_quiet_wake_first;
                ranges_quiet_wake_final.Last_10=ranges_quiet_wake_last;
                
                
                %% Microarousal
            elseif i==2
                
                ranges_microarousal_first=[]; ranges_microarousal_last=[];
                
                sum_check=sum(states==i);
                if sum_check==0
                    ranges_microarousal_final=[];
                    continue
                end
                
                %% Microarousal Thresholding
                
                bout_lengths=ConsecutiveOnes(states==i);
                bout_lengths(bout_lengths<threshold_vector_for_treatment(2))=0;
                
                bout_index=find(bout_lengths);
                
                            if isempty(bout_index)
                                ranges_microarousal_final=[];
                                continue
                            end
                
                lower_bound=start_sample_per_second(bout_index);
                upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                upper_bound=upper_bound-1;
                ranges_microarousal=[lower_bound; upper_bound].';
                
                ranges_microarousal_first=[]; ranges_microarousal_last=[];
                
                 for idx=1:size(ranges_microarousal,1)
                    
                    first_temp_1=ranges_microarousal(idx,1);
                    first_temp_2=ranges_microarousal(idx,1)+10*fs;
                    ranges_microarousal_first(idx).Samples_Start=first_temp_1;
                    ranges_microarousal_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_microarousal,1)
                    first_temp_2=ranges_microarousal(idx,2);
                    first_temp_1=ranges_microarousal(idx,2)-10*fs;
                    ranges_microarousal_last(idx).Samples_Start=first_temp_1;
                    ranges_microarousal_last(idx).Samples_End=first_temp_2;
                end
                
              
                
                
                
                ranges_microarousal_final.First_10=ranges_microarousal_first;
                ranges_microarousal_final.Last_10=ranges_microarousal_last;
                
            
                
                %% NREM
            elseif i == 3
                
                
                
                sum_check=sum(states==i);
                if sum_check==0
                    ranges_NREM_final=[];
                    continue
                end
                
                %% NREM Thresholding
                bout_lengths=ConsecutiveOnes(states==i);
                bout_lengths(bout_lengths<threshold_vector_for_treatment(3))=0;
                bout_index=find(bout_lengths);
                if isempty(bout_index)
                    ranges_NREM_final=[];
                    continue
                end
                lower_bound=start_sample_per_second(bout_index);
                upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                upper_bound=upper_bound-1;
                
                ranges_NREM=[lower_bound; upper_bound].';
                
                ranges_NREM_first=[]; ranges_NREM_last=[];
                
                for idx=1:size(ranges_NREM,1)
                    
                    first_temp_1=ranges_NREM(idx,1);
                    first_temp_2=ranges_NREM(idx,1)+10*fs;
                    ranges_NREM_first(idx).Samples_Start=first_temp_1;
                    ranges_NREM_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_NREM,1)
                    first_temp_2=ranges_NREM(idx,2);
                    first_temp_1=ranges_NREM(idx,2)-10*fs;
                    ranges_NREM_last(idx).Samples_Start=first_temp_1;
                    ranges_NREM_last(idx).Samples_End=first_temp_2;
                end
   
                
                ranges_NREM_final.First_10=ranges_NREM_first;
                ranges_NREM_final.Last_10=ranges_NREM_last;
                
                %% Intermediate
            elseif i == 4
                
                
                sum_check=sum(states==i);
                if sum_check==0
                    ranges_intermediate_final=[];
                    continue
                end
                %% Intermediate Thresholding
                
                bout_lengths=ConsecutiveOnes(states==i);
                bout_lengths(bout_lengths<threshold_vector_for_treatment(4))=0;
                bout_index=find(bout_lengths);
                
                if isempty(bout_index)
                    ranges_intermediate_final=[];
                    continue
                end
                lower_bound=start_sample_per_second(bout_index);
                upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                upper_bound=upper_bound-1;
                
                ranges_intermediate=[lower_bound; upper_bound].';
                
                ranges_intermediate_first=[]; ranges_intermediate_last=[];
                
                for idx=1:size(ranges_intermediate,1)
                    
                    first_temp_1=ranges_intermediate(idx,1);
                    first_temp_2=ranges_intermediate(idx,1)+10*fs;
                    ranges_intermediate_first(idx).Samples_Start=first_temp_1;
                    ranges_intermediate_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_intermediate,1)
                    first_temp_2=ranges_intermediate(idx,2);
                    first_temp_1=ranges_intermediate(idx,2)-10*fs;
                    ranges_intermediate_last(idx).Samples_Start=first_temp_1;
                    ranges_intermediate_last(idx).Samples_End=first_temp_2;
                end
   
                
                ranges_intermediate_final.First_10=ranges_intermediate_first;
                ranges_intermediate_final.Last_10=ranges_intermediate_last;

                
                %% REM
                
            elseif i == 5
                
                sum_check=sum(states==i);
                if sum_check==0
                    ranges_REM_final=[];
                    continue
                end
                
                %% REM  Thresholding
                bout_lengths=ConsecutiveOnes(states==i);
                bout_lengths(bout_lengths<threshold_vector_for_treatment(5))=0;
                bout_index=find(bout_lengths);
                if isempty(bout_index)
                    ranges_REM_final=[];
                    continue
                end
                lower_bound=start_sample_per_second(bout_index);
                upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                upper_bound=upper_bound-1;
                ranges_REM=[lower_bound; upper_bound].';
                
                ranges_REM_first=[]; ranges_REM_last=[];
                
                for idx=1:size(ranges_REM,1)
                    
                    first_temp_1=ranges_REM(idx,1);
                    first_temp_2=ranges_REM(idx,1)+10*fs;
                    ranges_REM_first(idx).Samples_Start=first_temp_1;
                    ranges_REM_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_REM,1)
                    first_temp_2=ranges_REM(idx,2);
                    first_temp_1=ranges_REM(idx,2)-10*fs;
                    ranges_REM_last(idx).Samples_Start=first_temp_1;
                    ranges_REM_last(idx).Samples_End=first_temp_2;
                end
   
                
                ranges_REM_final.First_10=ranges_REM_first;
                ranges_REM_final.Last_10=ranges_REM_last;
                
                
                %% Wake
            elseif i == 7
                bout_lengths=ConsecutiveOnes(states==i);
                bout_index=find(bout_lengths);
                lower_bound=start_sample_per_second(bout_index);
                upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                upper_bound=upper_bound-1;
                
                sum_check=sum(states==i);
                if sum_check==0
                    ranges_wake_final=[];
                    continue
                end
                
                ranges_trial_wake=[lower_bound; upper_bound].';
                Counts_Trial_Wake=size(ranges_trial_wake,1);
                
                for e=1:Counts_Trial_Wake
                    ranges_trial_wake_correct(e).Samples_Start=ranges_trial_wake(e,1);
                    ranges_trial_wake_correct(e).Samples_End=ranges_trial_wake(e,2);
                    ranges_trial_wake_correct(e).Sleep_Period='Wake: 7';
                end
                
                ranges_wake_final=ranges_trial_wake_correct; % Trial Wake
                
                 
                
                
                
                
            end
            
            
            

    end

else
    ranges_quiet_wake_final=[];ranges_microarousal_final=[];ranges_NREM_final=[];ranges_intermediate_final=[];ranges_REM_final=[];
    
    
    for states_index=1:length(states_PT5)
        ranges_sleep_wake_correct=[];ranges_microarousal_correct=[];ranges_NREM_correct=[];ranges_intermediate_correct=[];ranges_REM_correct=[];
        %disp(states_index)
        states=states_PT5{states_index};
        %disp(length(states))
        start_sample_per_second_index=start_sample_per_second{states_index};
        
        for i=1:7
            
            
%              if (i == 1) ||(i == 2) || (i == 3) || (i == 4)  ||(i==5) || (i==7) || (i==6) || (i==8) || (i==10)
                
                %% Quiet Wake
                
                if i==1
                    
                    
                    sum_check=sum(states==i);
                    if sum_check==0
                        %                         ranges_quiet_wake_final=[];
                        ranges_quiet_wake_prelim=[];
                        continue
                    end
                    
                    %% Quiet Wake Thresholding
                    
                    bout_lengths=ConsecutiveOnes(states==i);
                    
                    bout_lengths(bout_lengths<threshold_vector_for_treatment(1))=0;
                    
                    bout_index=find(bout_lengths);
                    
                    
                                if isempty(bout_index)
                                    ranges_quiet_wake_prelim=[];
                                    continue
                                end
                    
                    lower_bound=start_sample_per_second_index(bout_index);
                    upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                    upper_bound=upper_bound-1;
                    ranges_sleep_wake=[lower_bound; upper_bound].';
                    
                    ranges_quiet_wake_first=[]; ranges_quiet_wake_last=[];
                
                for idx=1:size(ranges_sleep_wake,1)
                    
                    first_temp_1=ranges_sleep_wake(idx,1);
                    first_temp_2=ranges_sleep_wake(idx,1)+10*fs;
                    ranges_quiet_wake_first(idx).Samples_Start=first_temp_1;
                    ranges_quiet_wake_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_sleep_wake,1)
                    first_temp_2=ranges_sleep_wake(idx,2);
                    first_temp_1=ranges_sleep_wake(idx,2)-10*fs;
                    ranges_quiet_wake_last(idx).Samples_Start=first_temp_1;
                    ranges_quiet_wake_last(idx).Samples_End=first_temp_2;
                end
                
              
                
                
                
                ranges_quiet_wake_prelim.First_10=ranges_quiet_wake_first;
                ranges_quiet_wake_prelim.Last_10=ranges_quiet_wake_last;
                    
                    %                     ranges_quiet_wake_final=[ranges_quiet_wake_final, {ranges_quiet_wake_prelim}];
                    
                    %% Microarousal
                elseif i==2
                    
                    sum_check=sum(states==i);
                    if sum_check==0
                        %                         ranges_microarousal_final=[];
                        ranges_microarousal_prelim=[];
                        continue
                    end
                    
                    %% Microarousal Thresholding
                    
                    bout_lengths=ConsecutiveOnes(states==i);
                    bout_lengths(bout_lengths<threshold_vector_for_treatment(2))=0;
                    
                    bout_index=find(bout_lengths);
                    
                                if isempty(bout_index)
                                    ranges_microarousal_prelim=[];
                                    continue
                                end
                    
                    lower_bound=start_sample_per_second_index(bout_index);
                    upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                    upper_bound=upper_bound-1;
                    ranges_microarousal=[lower_bound; upper_bound].';
                    
                    ranges_microarousal_first=[]; ranges_microarousal_last=[];
                
                 for idx=1:size(ranges_microarousal,1)
                    
                    first_temp_1=ranges_microarousal(idx,1);
                    first_temp_2=ranges_microarousal(idx,1)+10*fs;
                    ranges_microarousal_first(idx).Samples_Start=first_temp_1;
                    ranges_microarousal_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_microarousal,1)
                    first_temp_2=ranges_microarousal(idx,2);
                    first_temp_1=ranges_microarousal(idx,2)-10*fs;
                    ranges_microarousal_last(idx).Samples_Start=first_temp_1;
                    ranges_microarousal_last(idx).Samples_End=first_temp_2;
                end
                
              
                
                
                
                ranges_microarousal_prelim.First_10=ranges_microarousal_first;
                ranges_microarousal_prelim.Last_10=ranges_microarousal_last;
                    
                    %                     ranges_microarousal_final=[ranges_microarousal_final,{ranges_microarousal_prelim}];
                    
                    
                    
                    
                    
                    %% NREM
                elseif i == 3
                    
                    sum_check=sum(states==i);
                    if sum_check==0
                        %                         ranges_NREM_final=[];
                        ranges_NREM_prelim=[];
                        continue
                    end
                    
                    %% NREM Thresholding
                    bout_lengths=ConsecutiveOnes(states==i);
                    bout_lengths(bout_lengths<threshold_vector_for_treatment(3))=0;
                    bout_index=find(bout_lengths);
                    
                    if isempty(bout_index)
                        ranges_NREM_prelim=[];
                        continue
                    end
                    
                    lower_bound=start_sample_per_second_index(bout_index);
                    upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                    upper_bound=upper_bound-1;
                    
                    ranges_NREM=[lower_bound; upper_bound].';
                    ranges_NREM_first=[]; ranges_NREM_last=[];
                
                for idx=1:size(ranges_NREM,1)
                    
                    first_temp_1=ranges_NREM(idx,1);
                    first_temp_2=ranges_NREM(idx,1)+10*fs;
                    ranges_NREM_first(idx).Samples_Start=first_temp_1;
                    ranges_NREM_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_NREM,1)
                    first_temp_2=ranges_NREM(idx,2);
                    first_temp_1=ranges_NREM(idx,2)-10*fs;
                    ranges_NREM_last(idx).Samples_Start=first_temp_1;
                    ranges_NREM_last(idx).Samples_End=first_temp_2;
                end
   
                
                ranges_NREM_prelim.First_10=ranges_NREM_first;
                ranges_NREM_prelim.Last_10=ranges_NREM_last;
                    %                     ranges_NREM_final=[ranges_NREM_final,{ranges_NREM_prelim}];
                    
                    %% Intermediate
                elseif i == 4
                    
                    sum_check=sum(states==i);
                    if sum_check==0
                        %                         ranges_intermediate_final=[];
                        ranges_intermediate_prelim=[];
                        continue
                    end
                    %% Intermediate Thresholding
                    
                    bout_lengths=ConsecutiveOnes(states==i);
                    bout_lengths(bout_lengths<threshold_vector_for_treatment(4))=0;
                    bout_index=find(bout_lengths);
                    
                    if isempty(bout_index)
                        %ranges_intermediate_final=[];
                        ranges_intermediate_prelim=[];
                        continue
                    end
                    lower_bound=start_sample_per_second_index(bout_index);
                    upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                    upper_bound=upper_bound-1;
                    
                    ranges_intermediate=[lower_bound; upper_bound].';
                    ranges_intermediate=[lower_bound; upper_bound].';
                
                ranges_intermediate_first=[]; ranges_intermediate_last=[];
                
                for idx=1:size(ranges_intermediate,1)
                    
                    first_temp_1=ranges_intermediate(idx,1);
                    first_temp_2=ranges_intermediate(idx,1)+10*fs;
                    ranges_intermediate_first(idx).Samples_Start=first_temp_1;
                    ranges_intermediate_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_intermediate,1)
                    first_temp_2=ranges_intermediate(idx,2);
                    first_temp_1=ranges_intermediate(idx,2)-10*fs;
                    ranges_intermediate_last(idx).Samples_Start=first_temp_1;
                    ranges_intermediate_last(idx).Samples_End=first_temp_2;
                end
   
                
                ranges_intermediate_prelim.First_10=ranges_intermediate_first;
                ranges_intermediate_prelim.Last_10=ranges_intermediate_last;
                    
                    %% REM
                elseif i == 5
                    
                    sum_check=sum(states==i);
                    if sum_check==0
                        %                         ranges_REM_final=[];
                        ranges_REM_prelim=[];
                        continue
                    end
                    
                    %% REM  Thresholding
                    bout_lengths=ConsecutiveOnes(states==i);
                    bout_lengths(bout_lengths<threshold_vector_for_treatment(5))=0;
                    bout_index=find(bout_lengths);
                    
                    if isempty(bout_index)
                        %ranges_REM_final=[];
                        ranges_REM_prelim=[];
                        continue
                    end
                    lower_bound=start_sample_per_second_index(bout_index);
                    upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                    upper_bound=upper_bound-1;
                    ranges_REM=[lower_bound; upper_bound].';
                    
                    ranges_REM_first=[]; ranges_REM_last=[];
                
                for idx=1:size(ranges_REM,1)
                    
                    first_temp_1=ranges_REM(idx,1);
                    first_temp_2=ranges_REM(idx,1)+10*fs;
                    ranges_REM_first(idx).Samples_Start=first_temp_1;
                    ranges_REM_first(idx).Samples_End=first_temp_2;
                end
                
                for idx=1:size(ranges_REM,1)
                    first_temp_2=ranges_REM(idx,2);
                    first_temp_1=ranges_REM(idx,2)-10*fs;
                    ranges_REM_last(idx).Samples_Start=first_temp_1;
                    ranges_REM_last(idx).Samples_End=first_temp_2;
                end
   
                
                ranges_REM_prelim.First_10=ranges_REM_first;
                ranges_REM_prelim.Last_10=ranges_REM_last;
                    
                    
                    %% Wake
                elseif i == 7
                    
                    sum_check=sum(states==i);
                    if sum_check==0
                        ranges_wake_final=[];
                        continue
                    end
                    bout_lengths=ConsecutiveOnes(states==i);
                    bout_index=find(bout_lengths);
                    lower_bound=start_sample_per_second_index(bout_index);
                    upper_bound=lower_bound+bout_lengths(bout_index)*fs;
                    upper_bound=upper_bound-1;
                    
                    
                    
                    ranges_trial_wake=[lower_bound; upper_bound].';
                    Counts_Trial_Wake=size(ranges_trial_wake,1);
                    
                    for e=1:Counts_Trial_Wake
                        ranges_trial_wake_correct(e).Samples_Start=ranges_trial_wake(e,1);
                        ranges_trial_wake_correct(e).Samples_End=ranges_trial_wake(e,2);
                        ranges_trial_wake_correct(e).Sleep_Period='Wake: 7';
                    end
                    
                    ranges_wake_final=ranges_trial_wake_correct; % Trial Wake
                    

                    
                    
                    
                    
                end
                
                
        end
        switch states_index
            
            case 1
                
                ranges_quiet_wake_final.state_1=ranges_quiet_wake_prelim;
                ranges_microarousal_final.state_1=ranges_microarousal_prelim;
                ranges_NREM_final.state_1=ranges_NREM_prelim;
                ranges_intermediate_final.state_1=ranges_intermediate_prelim;
                ranges_REM_final.state_1=ranges_REM_prelim;

                
            case 2
                
                ranges_quiet_wake_final.state_2=ranges_quiet_wake_prelim;
                ranges_microarousal_final.state_2=ranges_microarousal_prelim;
                ranges_NREM_final.state_2=ranges_NREM_prelim;
                ranges_intermediate_final.state_2=ranges_intermediate_prelim;
                ranges_REM_final.state_2=ranges_REM_prelim;

        
            case 3
                
                ranges_quiet_wake_final.state_3=ranges_quiet_wake_prelim;
                ranges_microarousal_final.state_3=ranges_microarousal_prelim;
                ranges_NREM_final.state_3=ranges_NREM_prelim;
                ranges_intermediate_final.state_3=ranges_intermediate_prelim;
                ranges_REM_final.state_3=ranges_REM_prelim;

                
            case 4
                ranges_quiet_wake_final.state_4=ranges_quiet_wake_prelim;
                ranges_microarousal_final.state_4=ranges_microarousal_prelim;
                ranges_NREM_final.state_4=ranges_NREM_prelim;
                ranges_intermediate_final.state_4=ranges_intermediate_prelim;
                ranges_REM_final.state_4=ranges_REM_prelim;
                
      
                
        end
        
        
    end
    
   
    
end




end