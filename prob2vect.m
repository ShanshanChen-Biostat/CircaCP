function Label = prob2vect(prob_vect,thr)


Range = max(prob_vect) -min(prob_vect);


Thr = thr*Range+min(prob_vect);


Label(prob_vect>Thr)=1;
Label(prob_vect<=Thr)=0;