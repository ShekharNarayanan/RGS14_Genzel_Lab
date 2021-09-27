function [new_states]=corrected_states(states)

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
 
wake_states=states ;
% c0=states(1); %first state.   
%Find wake bouts < 4sec
wake=(states==1);
Wake=ConsecutiveOnes(wake);
StartBout=find(Wake~=0);
EndBout=StartBout+Wake(find(Wake~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<4); %Bout ID shorter than 4 seconds.
if isempty(ShortBoutID) == 1
    wake_states=states;
else    
    %Merging loop
  for k=1:length(ShortBoutID)
        %If it is not in the beginning or end of vector
        if StartBout(ShortBoutID(k))-1 ~=0 && EndBout(ShortBoutID(k))<length(states);
           state_pre=states(StartBout(ShortBoutID(k))-1);
           state_post=states(EndBout(ShortBoutID(k))+1); 
       
            %If pre and post bouts are the same sleep stage
                if state_pre==state_post
                     wake_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
                end
       
        %When it is in the beginning or end of vector   
         else
            %When it is in the beginning
                 if  StartBout(ShortBoutID(k))-1 ==0
                     state_post=states(EndBout(ShortBoutID(k))+1);
                     wake_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_post;
             
                 else %When it is in the end
                     state_pre=states(StartBout(ShortBoutID(k))-1);
                     wake_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
            
                 end
        end
    
    
   end
end

NREM_states=wake_states;
% c0=states(1); %first state.   
%Find wake bouts < 4sec
nrem=(states==3);
NREM=ConsecutiveOnes(nrem);
StartBout=find(NREM~=0);
EndBout=StartBout+Wake(find(NREM~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<4); %Bout ID shorter than 4 seconds.
if isempty(ShortBoutID) == 1
    NREM_states=wake_states;
else    
    %Merging loop
  for k=1:length(ShortBoutID)
        %If it is not in the beginning or end of vector
        if StartBout(ShortBoutID(k))-1 ~=0 && EndBout(ShortBoutID(k))<length(wake_states)
           state_pre=wake_states(StartBout(ShortBoutID(k))-1);
           state_post=wake_states(EndBout(ShortBoutID(k))+1); 
       
            %If pre and post bouts are the same sleep stage
                if state_pre==state_post
                     NREM_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
                end
       
        %When it is in the beginning or end of vector   
         else
            %When it is in the beginning
                 if  StartBout(ShortBoutID(k))-1 ==0
                     state_post=wake_states(EndBout(ShortBoutID(k))+1);
                     NREM_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_post;
             
                 else %When it is in the end
                     state_pre=wake_states(StartBout(ShortBoutID(k))-1);
                     NREM_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
            
                 end
        end
    
    
   end
end

REM_states=NREM_states ;
% c0=states(1); %first state.   
%Find REM bouts < 4sec
rem=(states==5);
REM=ConsecutiveOnes(rem);
StartBout=find(REM~=0);
EndBout=StartBout+Wake(find(REM~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<4); %Bout ID shorter than 4 seconds.
if isempty(ShortBoutID) == 1
    REM_states=NREM_states;
else    
    %Merging loop
  for k=1:length(ShortBoutID)
        %If it is not in the beginning or end of vector
        if StartBout(ShortBoutID(k))-1 ~=0 && EndBout(ShortBoutID(k))<length(NREM_states)
           state_pre=NREM_states(StartBout(ShortBoutID(k))-1);
           state_post=NREM_states(EndBout(ShortBoutID(k))+1); 
       
            %If pre and post bouts are the same sleep stage
                if state_pre==state_post
                     REM_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
                end
       
        %When it is in the beginning or end of vector   
         else
            %When it is in the beginning
                 if  StartBout(ShortBoutID(k))-1 ==0
                     state_post=NREM_states(EndBout(ShortBoutID(k))+1);
                     REM_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_post;
             
                 else %When it is in the end
                     state_pre=NREM_states(StartBout(ShortBoutID(k))-1);
                     REM_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
            
                 end
        end
    
   
  end
end
new_states=REM_states ;
% c0=states(1); %first state.   
%Find Inter bouts < 4sec
inter=(states==4);
Inter=ConsecutiveOnes(inter);
StartBout=find(Inter~=0);
EndBout=StartBout+Wake(find(Inter~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<4); %Bout ID shorter than 4 seconds.
if isempty(ShortBoutID) == 1
    new_states=REM_states;
else 
    %Merging loop
  for k=1:length(ShortBoutID)
        %If it is not in the beginning or end of vector
        if StartBout(ShortBoutID(k))-1 ~=0 && EndBout(ShortBoutID(k))<length(REM_states)
           state_pre=REM_states(StartBout(ShortBoutID(k))-1);
           state_post=REM_states(EndBout(ShortBoutID(k))+1); 
       
            %If pre and post bouts are the same sleep stage
                if state_pre==state_post
                     new_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
                end
       
        %When it is in the beginning or end of vector   
         else
            %When it is in the beginning
                 if  StartBout(ShortBoutID(k))-1 ==0
                     state_post=REM_states(EndBout(ShortBoutID(k))+1);
                     new_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_post;
             
                 else %When it is in the end
                     state_pre=REM_states(StartBout(ShortBoutID(k))-1);
                     new_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
            
                 end
        end
    
    
   end

end