%% main script 

clear; 
clc;


%% Import an Actigraph File, file format here is based on ActiWatch

[S,Exclude] = importActigraph(filename);

 if Exclude ==1 %% file/subject is excluded, choose another actigraph file
   S=[];
 else
     R = sleep_detection_final(S,'on'); %% sleep detection, all metrics...
                                        %%% capured in the struct R, for
                                        %%% batch processing, use 'off' to 
                                        %%% avoid plotting 
 end








