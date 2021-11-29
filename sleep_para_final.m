function B = sleep_para_final(S,T,L,EWT,EST,AWT,SLT)

%% Gathering metrics after sleep detection

M = S.T60.activity;
M = M(:);
T=T(:);
L=L(:);

B.T = T;
B.L = L; %% final sleep label
B.AWT = AWT;
B.SLT = SLT;
B.EST = EST;
B.EWT = EWT;



%% Original evaluation metric
B.simgo = var(T.*M)./var((1-T).*M);
B.propo = var(L.*M)./var((1-L).*M);

%% Calinski-Harabasz 
B.simgo1 = myclusterEval(M,T,'CH'); %% baseline
B.propo1 = myclusterEval(M,L,'CH'); %% propose

%% Matching eventmarkers and AWT and SLT

ST = SLT;
WT = AWT;


E=S.event60;
E(abs(E-length(M))<90|E<90)=[];



if length(E)>=1

Tol=180;
[W1,t1] = ismembertol(WT,E,Tol,'DataScale',1,'OutputAllIndices', true);
[S1,t2] = ismembertol(ST,E,Tol,'DataScale',1,'OutputAllIndices', true);
y1 = cellfun(@(x){min(x)}, t1);
y2 = cellfun(@(x){max(x)}, t2);
c1= cell2mat(y1);
c2= cell2mat(y2);


B.event60_AWT_plot = E(c1(c1~=0));
B.event60_SLT_plot = E(c2(c2~=0));



AWTmatch= AWT(W1);
SLTmatch = SLT(S1);


AWTmatch1 = minutes(S.T60.linetime(AWTmatch));
SLTmatch1 = minutes(S.T60.linetime(SLTmatch));
event60_AWTmatch1 = minutes(S.T60.linetime(B.event60_AWT_plot));
event60_SLTmatch1 = minutes(S.T60.linetime(B.event60_SLT_plot));



IndW1 = (AWTmatch1-event60_AWTmatch1)>900;
event60_AWTmatch1(IndW1) = event60_AWTmatch1(IndW1)+1440;
IndW2 = (AWTmatch1-event60_AWTmatch1)<-900;
AWTmatch1(IndW2) = AWTmatch1(IndW2)+1440;


IndS1 = (SLTmatch1-event60_SLTmatch1)>900;
event60_SLTmatch1(IndS1) = event60_SLTmatch1(IndS1)+1440;

IndS2 = (SLTmatch1-event60_SLTmatch1)<-900;
SLTmatch1(IndS2) = SLTmatch1(IndS2)+1440;

B.AWTmatch = AWTmatch1;
B.SLTmatch = SLTmatch1;

B.event60_AWTmatch = event60_AWTmatch1;
B.event60_SLTmatch = event60_SLTmatch1;


else
 B.AWTmatch = [];
 B.SLTmatch = [];
 B.event60_AWTmatch = [];
 B.event60_SLTmatch = [];
 B.event60_AWT_plot =[];
 B.event60_SLT_plot =[];
end
B.IDwake = S.ID*ones(length(B.AWTmatch),1);
B.IDsleep = S.ID*ones(length(B.SLTmatch),1);
B.ID = S.ID;



