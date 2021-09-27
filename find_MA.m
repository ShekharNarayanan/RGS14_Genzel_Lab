function [new_states]=find_MA(states)

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
%Find microarousals
microarousal=(states==1);
Microarousal=ConsecutiveOnes(microarousal);
StartBout=find(Microarousal~=0);
EndBout=StartBout+Microarousal(find(Microarousal~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<=15); %Bout ID shorter than 15 seconds.

    %Merging loop
  for k=1:length(ShortBoutID)
        

 new_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=2;

       
       
    
   end





end