function metric = myclusterEval(X,index, type)


switch type
    case 'DB'
    case 'CH'
      clusts = unique(index);

      num = length(clusts);
      centroids = NaN(num,1);
      counts = zeros(num,1);
      sumD = zeros(num,1);
      for i = 1:num
          members = (index == clusts(i));
          if any(members)
              counts(i) = sum(members);
              centroids(i,:) = sum(X(members)) / counts(i);
              sumD(i)= sum(pdist2(X(members),centroids(i,:)).^2);          
          end
      end
      SSW = sum(sumD,1);
      SSB = (pdist2(centroids,mean(X))).^2;
      SSB = sum(counts.*SSB);
      metric =(SSB/(num-1))/(SSW/(length(index)-num));
end

%     case 'silhouette'
%     case 'gap'
% end
% 
%  function [centroids, counts, sumD] = getCandSUMD(this, index)
%       %Get centroids, number of observations and sum of Squared Euclidean
%       %distance for each cluster based on cluster index. Index doesn't need
%       %to be integers between 1:number of clusters
%       p = size(this.PrivX,2);
%       clusts = unique(index);
% 
%       num = length(clusts);
%       centroids = NaN(num,p);
%       counts = zeros(num,1);
%       sumD = zeros(num,1);
%       for i = 1:num
%           members = (index == clusts(i));
%           if any(members)
%               counts(i) = sum(members);
%               centroids(i,:) = sum(this.PrivX(members,:),1) / counts(i);
%               sumD(i)= sum(pdist2(this.PrivX(members,:),centroids(i,:)).^2);          
%           end
%       end
%   end
  
%   function CH = getCH(this,centroids, Ni, SUMD,NC)
%      %Get CalinskiHarabasz value based on cluster centroids, The number of
%      %points in each cluster, sum of Squared Euclidean and the number of
%      %clusters
%       SSW = sum(SUMD,1);
%       SSB = (pdist2(centroids,this.GlobalMean)).^2;
%       SSB = sum(Ni.*SSB);
%       CH =(SSB/(NC-1))/(SSW/(this.NumObservations-NC));
%   end
% end
% end