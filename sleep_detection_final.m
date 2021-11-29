function R = sleep_detection_final(S,PlotOn)
% close all;


M = (S.T60.activity)+1e-1;%% entire sequence
%%
T =sleep_cos(S,PlotOn); %% generate a rough/robust clock, estimate maximum number of change points 
dd = diff(T);

E = find(dd~=0); %% edges detected by cos-sigmoid

E(abs(E-length(M))<60|E<60)=[]; %% delete edges too close to the beginning or end


CP = E(:);
EWT = find(diff(T)==1); %% wake times determined by cosinor
EST = find(diff(T)==-1); %% sleep times determined by cosinor

%%
if ismember(CP(1),EWT)
    label_CP(1) = 1;
    label_CP(2) = -1;

 else
     label_CP(1) = -1;
     label_CP(2) = 1;

 end

if ismember(CP(2),EWT)
    label_ipt(1) = -1;
else
    label_ipt(1) = 1;
end


tempmag= M(1:CP(2));
if length(M(1:CP(1)))>240
    gt = cp_detect(tempmag,'Gamma');
else
    gt = CP(1);
end
ipt(1) = gt;

if abs(ipt(1)-CP(2))< abs(ipt(1)-CP(1))
    label_ipt(1)=label_CP(2);
     CP=CP(2:end);
else
    label_ipt(1)=label_CP(1);
end

%%%--------------------------------
for i = 2:length(CP)-2
    pre_pt = ipt(i-1); %% updating every round
    next_pt = CP(i+1); %% based on last round 
    tempmag = M(pre_pt:next_pt);
    if label_ipt(i-1)==1
        label_ipt(i) = -1; %% current change point
    else
        label_ipt(i) = 1;
    end
    pt = cp_detect(tempmag,'Gamma');
    ipt(i) = pt+pre_pt;
end

label_ipt_secondlast = -label_ipt(end); %% reverse of the last label
tempmag= M(ipt(end):CP(end));
if length(tempmag)>1000  %% 24 hour plus another day/night's data     
    ct = cp_detect(M(ipt(end):CP(end)),'Gamma');  
    ct = ct + ipt(end);
    if length(M(CP(end):end))>240
        ct_last = cp_detect(M(ct:end),'Gamma')+ct;
        ipt = [ipt(:);ct(:);ct_last(:)];
    else
    ipt = [ipt(:);ct(:);CP(end)];
    end
   label_ipt = [label_ipt,label_ipt_secondlast,-label_ipt_secondlast];
else
    ct = cp_detect(tempmag,'Gamma');  
    ct = ct + ipt(end);
    ipt = [ipt(:);ct(:);CP(end)];
    label_ipt = [label_ipt,label_ipt_secondlast,-label_ipt_secondlast];
end

clear ct pt;
 

AWT1 = ipt(label_ipt==1);
SLT1 = ipt(label_ipt==-1);

%%
if strcmp(PlotOn,'on')

figure;
stem(EWT,ones(length(EWT),1),'r-','linewidth',2);
hold on;
stem(EST,ones(length(EST),1),'b-','linewidth',2);
stem(AWT1,ones(length(AWT1),1),'r--','linewidth',2);
hold on;
stem(SLT1,ones(length(SLT1),1),'b--','linewidth',2);
plot(M/1e3,'color',[0.9100 0.4100 0.1700]);
% legend('Proposed Awake Time','Proposed Sleep Time','Sigmoid-Cosine Model','Normalized Activity Counts');
title('After First Round CP Detection');
xlabel('Time (Minutes)');
ylabel('Rescaled Activity Counts');
end


%% Round 2 starts here

% if ismember(ipt(2),AWT)
%     label_ipt2(1) = -1;
% else
%     label_ipt2(1) = 1;
% end

if ismember(ipt(2),AWT1)
    label_ipt2(1) = -1;
    label_ipt2(2) = 1;

 else
     label_ipt2(1) = 1;
     label_ipt2(2) = -1;
 end

% if ismember(CP(2),EWT)
%     label_ipt(1) = -1;
% else
%     label_ipt(1) = 1;
% end

tempmag= M(1:ipt(2));
if length(M(1:ipt(1)))>240
    ipt2(1) = cp_detect(tempmag,'Gamma');
else
    ipt2(1)= ipt(1);
end

%%%--------------------------------
for i = 2:length(ipt)-2  
    pre_pt = ipt2(i-1); %% updating every round
    next_pt = ipt(i+1); %% based on stc model
    tempmag = M(pre_pt:next_pt);
    if label_ipt2(i-1)==1
        label_ipt2(i) = -1; %% current change point
    else
        label_ipt2(i) = 1;
    end
    pt = cp_detect(tempmag,'Gamma');
    ipt2(i) = pt+pre_pt;
end

label_ipt2_secondlast = -label_ipt2(end); %% reverse of the last label
tempmag= M(ipt2(end):ipt(end));
if length(tempmag)>1000  %% 24 hour plus another day/night's data     
    ct = cp_detect(M(ipt2(end):ipt(end)),'Gamma');  
    ct = ct + ipt2(end);
    if length(M(ipt(end):end))>240
        ct_last = cp_detect(M(ct:end),'Gamma')+ct;
        ipt2 = [ipt2(:);ct(:);ct_last(:)];
    else
    ipt2 = [ipt2(:);ct(:);ipt(end)];
    end
   label_ipt2 = [label_ipt2,label_ipt2_secondlast,-label_ipt2_secondlast];
else
    ct = cp_detect(tempmag,'Gamma');  
    ct = ct + ipt2(end);
    ipt2 = [ipt2(:);ct(:);ipt(end)];
    label_ipt2 = [label_ipt2,label_ipt2_secondlast,-label_ipt2_secondlast];
end



%% convert change pts to labels

AWT = ipt2(label_ipt2==1);
SLT = ipt2(label_ipt2==-1);

L=CP2label(AWT,SLT,length(M));


R = sleep_para_final(S,T,L,EWT,EST,AWT,SLT);

%%
if strcmp(PlotOn,'on')

figure;
stem(AWT1,ones(length(AWT1),1),'r-','linewidth',2);
hold on;
stem(SLT1,ones(length(SLT1),1),'b-','linewidth',2);
stem(AWT,ones(length(AWT),1),'r--','linewidth',2);
hold on;
stem(SLT,ones(length(SLT),1),'b--','linewidth',2);
plot(M/1e3,'color',[0.9100 0.4100 0.1700]);
title('After second round CP detection');
xlabel('Time (Minutes)');
ylabel('Rescaled Activity Counts');
end





%% Plotting option
T = T(:);
L = L(:);
if strcmp(PlotOn,'on')
figure;
subplot(2,1,1);
plot(T.*M/1e2,'r--');
hold on;
plot((1-T).*M/1e2,'b');
legend('Activity during Wake','Activity during Asleep');
title('Sigmoid-Cosine Model');
subplot(2,1,2);
plot(L.*M/1e2,'r--');
hold on;
plot((1-L).*M/1e2,'b');
title('Proposed Method');
ylabel('Rescaled Activity');
xlabel('Time (Minutes)');
end









