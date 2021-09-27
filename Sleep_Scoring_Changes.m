%first  replace possible bins containing 0 (by errors in the manual sleep scoring) with the previous value or if 0 is at the begining with the  next value
function [states_no_zeroes]=Sleep_Scoring_Changes(A)
states_corrected=[];
for index=1:length(A)
    %load(files{index});
    x=A;
    s=find(x==0);
    y =isempty(s);
    if y==1
        states_corrected=x;
    else
        x(x==0) = NaN;
        v = fillmissing(x,'previous');
        states_corrected = fillmissing(v,'next');
    end
   
end 
   states_no_zeroes=states_corrected;
end