function [ranges_quiet_wake_final, ranges_NREM_final, ranges_intermediate_final, ranges_REM_final,ranges_wake_final]=bout_ranges(states)
fs=30000;
%ranges_sleep_wake=[]; ranges_REM=[]; ranges_NREM=[];ranges_trial_wake=[];
start_sample_per_second=[0:fs:fs*length(states)]; %Vector with start_sample of each second


for i=1:7
    if (i == 1) ||(i == 3) || (i == 4)  ||(i==5) || (i==7)
            bout_lengths=ConsecutiveOnes(states==i); 
            bout_index=find(bout_lengths);
            lower_bound=start_sample_per_second(bout_index);
            upper_bound=lower_bound+bout_lengths(bout_index)*fs;
            upper_bound=upper_bound-1;

        
        if i==1

            sum_check=sum(states==i);
            if sum_check==0
                ranges_quiet_wake_final=[];
                continue
            end
            

            ranges_sleep_wake=[lower_bound; upper_bound].';
            Counts_Sleep_Wake=size(ranges_sleep_wake,1);
            
            for a=1:Counts_Sleep_Wake
                ranges_sleep_wake_correct(a).Samples_Start=ranges_sleep_wake(a,1);
                ranges_sleep_wake_correct(a).Samples_End=ranges_sleep_wake(a,2);
                ranges_sleep_wake_correct(a).Sleep_Period='Quiet_Wake: 1';
            end
             ranges_quiet_wake_final=ranges_sleep_wake_correct; 
            
            
        elseif i == 3
            
            sum_check=sum(states==i);
            if sum_check==0
                ranges_NREM_final=[];
                continue
            end

            
            ranges_NREM=[lower_bound; upper_bound].';
            Counts_NREM=size(ranges_NREM,1);
            
            for b=1:Counts_NREM
                ranges_NREM_correct(b).Samples_Start=ranges_NREM(b,1);
                ranges_NREM_correct(b).Samples_End=ranges_NREM(b,2);
                ranges_NREM_correct(b).Sleep_Period='NREM : 3';    
            end
            ranges_NREM_final=ranges_NREM_correct;

            
        elseif i == 4
            
            sum_check=sum(states==i);
            if sum_check==0
                 ranges_intermediate_final=[];
                continue
            end
            
            ranges_intermediate=[lower_bound; upper_bound].';
            Counts_Intermediate=size(ranges_intermediate,1);
            
            for c=1:Counts_Intermediate
                ranges_intermediate_correct(c).Samples_Start=ranges_intermediate(c,1);
                ranges_intermediate_correct(c).Samples_End=ranges_intermediate(c,2);
                ranges_intermediate_correct(c).Sleep_Period='Intermediate : 4';      
            end
            
            ranges_intermediate_final=ranges_intermediate_correct; % Intermediate

            
        elseif i == 5
            
            sum_check=sum(states==i);
            if sum_check==0
                 ranges_REM_final=[];
                 continue
            end
            
            ranges_REM=[lower_bound; upper_bound].';
            Counts_REM=size(ranges_REM);
            
            for d=1:Counts_REM
                ranges_REM_correct(d).Samples_Start=ranges_REM(d,1);
                ranges_REM_correct(d).Samples_End=ranges_REM(d,2);
                ranges_REM_correct(d).Sleep_Period='REM : 5';
                
            end
            ranges_REM_final=ranges_REM_correct; 

            
            
        elseif i == 7
            
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
end





end