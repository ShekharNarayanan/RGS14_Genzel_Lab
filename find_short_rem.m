function [new_states]=find_short_rem(states)

x=states;

%Remove zeros.
s=find(x==0);
y =isempty(s);
   if y==1
      states=x;
   else
      x(x==0) = NaN;
      v = fillmissing(x,'previous');
      states = fillmissing(v,'next');
   end
new_states=states ;
% c0=states(1); %first state.   
%Find short nrem
rem=(states==5);
REM=ConsecutiveOnes(rem);

StartBout=find(REM~=0);
EndBout=StartBout+REM(find(REM~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<=40); %Bout ID shorter than 40 seconds.

    %Merging loop
  for k=1:length(ShortBoutID)
        

 new_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=10;

       
       
    
   end





end