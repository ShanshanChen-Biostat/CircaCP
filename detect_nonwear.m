function [Exclude,Begin,End,Sig_mode,sig_nan]=detect_nonwear(sig,durtol)

sig = sig(:);
sig = sig';
tsig = (abs(sig) >= 0.1);  
dsig = diff([1 tsig 1]);
startIndex = find(dsig < 0);
endIndex = find(dsig > 0)-1;
duration = endIndex-startIndex+1;
stringIndex = (duration >= durtol);%% durtol is the duration tolerance, set to 240
startIndex = startIndex(stringIndex);
endIndex = endIndex(stringIndex);

sig_nan = sig;
for i = 1:length(startIndex)
    sig_nan(startIndex(i):endIndex(i))=NaN;
end

Sig_mode = sig;
Sig_mode(~isnan(sig_nan)) = 100;
Sig_mode(isnan(sig_nan)) = 0 ;

seq = findseq(Sig_mode);

c = seq(:,1)==100;
t=find(seq(c,4)>=1440*2*4); %% consecutive 4 days


if ~isempty(t)
    Exclude = 0;
    M = seq(c,4)==max(seq(t,4));
    Begin = seq(M,2);
    
    End = seq(M,3);

else 
    Exclude =1;
    Begin = NaN;
    End = NaN;

end
% Sig_mode = modefilt1(Sig_mode,300,90);

% ConDays = diff(find((diff(Sig_mode)==100)));%% to find consecutive days

% if ~isempty(ConDays>1440*5)||~isempty(find(Sig_mode ~=100))
%     Exclude = 0;
% else 
%     Exclude = 1;
% end

