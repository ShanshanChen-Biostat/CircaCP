function X_new = norm_scale(X,method)

%%% X can come in as a matrix

X_new = zeros(size(X));

for i =1: size(X,2)

    switch method    

        case 'stats'        

            X_new(:,i) = (X(:,i)-mean(X(:,i)))./(max(X(:,i))-mean(X(:,i)));
   

        case 'range'

            X_new(:,i) = (X(:,i)-min(X(:,i)))./range(X(:,i));               

        case 'range2'

            x = X(:,i);

            mx = max(x);

            mn = min(x);

            X_new(:,i) = 2*x/range(x) -(mx+mn)/range(x);

        case 'range3'

            X_new(X>=0) = (X(X>=0,i)-min(X(X>=0,i)))./range(X(X>=0,i)); %% positive normalized to [0,1];                     

            X_new(X<0)  = (X(X<0,i) -max(X(X<0,i)))./range(X(X<0,i)); %% negative normalized to [-1,0]
    
            
        case 'range4'
            m = mean(X);
            X_new(X>=m) = (X(X>=m,i)-min(X(X>=m,i)))./range(X(X>=m,i)); %% positive normalized to [0,1];                     

            X_new(X<m)  = (X(X<m,i) -max(X(X<m,i)))./range(X(X<m,i)); %% negative normalized to [-1,0]


        case 'std'

            X_new(:,i) = (X(:,i)-mean(X(:,i)))./std(X(:,i)); %% zscore normalization

    end

end