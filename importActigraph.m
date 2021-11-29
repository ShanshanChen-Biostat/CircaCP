function [S,Exclude] = importActigraph(filename)

%% file format is based on ActiWatch, please adapt this importing function based on your actigrpah file

if ~exist(filename,'file')
    Exclude =1;
end


T = readtable(filename);

ID = unique(T.mesaid);


offwrist = T.offwrist;

Ind = find(diff([0;offwrist;0])~=0);

Logiv = false(length(offwrist),1);

if any(offwrist)
    if Ind(1)==1
        Logiv(Ind(1):Ind(2)) = true;
    end
    if Ind(end)==length(offwrist)+1
        Logiv(Ind(end):length(offwrist))=true;
    end
end

T(Logiv,:)=[];

% Ind = [find(diff(offwrist)~=0);length(offwrist)];
% T(Ind(end-1):Ind(end),:)=[];
% if any(offwrist)
%     T(1:Ind(1),:)=[];
%     T(Ind(end-1):Ind(end),:)=[]; %% cut the end
% end



%% Downsample/decimate to 1-min epoch 


S = struct;
S.ID = ID;



T.activity(isnan(T.activity))=0;


if length(T.activity)<2880*4 %% 30s epoch, adapt if the actigraph is gathered in other epochs
    S=NaN;
    Exclude =1;    
else 
   sig = T.activity;
   sig(isnan(T.activity))=0;    
   [Exclude,Begin,End] = detect_nonwear(sig,240);
   if Exclude ==0
     T = T(Begin:End,:);
     S.T30 = T ; %% 30 seconds epoch
     T1 = T(1:2:end,:);
     T2 = T(2:2:end,:);
     Len = min([height(T1),height(T2)]);
     Act1 = T1.activity(1:Len,1);
     Act2 = T2.activity(1:Len,1);
     S.T60 = T1(1:Len,:); %% 1 minute epoch
     S.T60.activity= Act1+Act2;
    Mark = T.marker;
    S.event30 = find(Mark==1);
    S.event60 = round(S.event30/2);
    S.filename = filename;
   else
       S =NaN;    
   end
   
end

