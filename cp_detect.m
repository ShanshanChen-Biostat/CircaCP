

function CP = cp_detect(M,dist)
%%

para = mle(M,'Distribution','Gamma');
xi = para(1);
% theta = para(2);
n = length(M);

%%
n = length(M);
for i = 1:n-1
    seg1 = M(1:i);
    seg2 = M(i+1:end);
    n1 = length(seg1);
    n2 = length(seg2);
        switch dist
            case 'Gamma'
                item1(i) = 2*n1*xi*log(sum(seg1));
                item2(i) = 2*n2*xi*log(sum(seg2));
                item32(i) = 2*n1*xi*log(n1*xi)+2*n2*xi*log(n2*xi);
                item5(i) = 50*(2*n1/n-1)^2*log(n);
                
                 L(i) = item1(i)+item2(i)-item32(i)+item5(i); %%% MIC
                   
                           
%               case 'Gamma2'
%                  item1(i) = 2*n1*log(sum(seg1));
%                  item2(i) = 2*n2*log(sum(seg2)); 
%                  L(i) = item1(i)+item2(i);
         

         end
                

end

 
Min = find(L==min(L));
Min = Min(1);
CP = Min;
 


