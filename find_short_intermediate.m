function [new_states]=find_short_intermediate(states)

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
intermediate=(states==4);
Intermediate=ConsecutiveOnes(intermediate);

StartBout=find(Intermediate~=0);
EndBout=StartBout+Intermediate(find(Intermediate~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<=25); %Bout ID shorter than 25 seconds.

    %Merging loop
  for k=1:length(ShortBoutID)
        

 new_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=8;

       
       
    
   end





end