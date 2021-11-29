
function labels = CP2label(AWT,SLT,len)

CP= sort([AWT(:);SLT(:)]);
labels = zeros(len,1);


if ismember(CP(1),SLT)
    labels(1:SLT(1))= 1; %% first change is sleep time, first phase is awake
    
    for i = 1:length(SLT)-1
    s1 = SLT(i):AWT(i);  %% Sleep phase, state 1, 
    s2 = AWT(i):SLT(i+1); %% awake phase, state 2, 
    labels(s1)= zeros(length(s1),1);    
    labels(s2)= ones(length(s2),1);
    
    end
    
else 
    labels(1:AWT(1))= 0; %% first change is awake time, first phase is sleep
    
    for i = 1:length(AWT)-1
    s1 = AWT(i):SLT(i);  %% awake phase, state 1, state 1 doens't contain very high value
    s2 = SLT(i)+1:AWT(i+1)-1; %% sleep phase, state 2, state 2 contains low value
    labels(s1)= ones(length(s1),1);    
    labels(s2)= zeros(length(s2),1);
    end
    
end 

if  ismember(CP(end),SLT)
      labels(SLT(end):end)=0;
      labels(CP(end-1):SLT(end))=1;
else
      labels(AWT(end):end)=1;
      labels(CP(end-1):AWT(end))=0;

end




