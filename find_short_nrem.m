function [new_states]=find_short_nrem(states)

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
nrem=(states==3);
NREM=ConsecutiveOnes(nrem);
StartBout=find(NREM~=0);
EndBout=StartBout+NREM(find(NREM~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<=40); %Bout ID shorter than 40 seconds.

    %Merging loop
  for k=1:length(ShortBoutID)
        

 new_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=6;

       
       
    
   end





end