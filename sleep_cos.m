function T = sleep_cos(S,PlotOn)

y = norm_scale(S.T60.activity,'range');
y = y(:);

x = 1:length(y);
x= x(:);


fhnonlin = @(p) p(1) +p(2)*cos(2*pi*(x-p(3))/1440)-y; %% p(1)is mes, p(2) is amp, p(3) is phasor
p0 = [500,550,227]; %% initial guess

para = lsqnonlin(fhnonlin,p0);
C = fhnonlin(para)+y;

T =  prob2vect(C,0.18);


%%
if strcmp(PlotOn,'on')
figure;
plot(abs(S.T60.activity)/1e3,'r','linewidth',0.5);
hold on;
plot(real(C)*3,'g','linewidth',2);
plot(T,'k','linewidth',2);
xlabel('Time (Minutes)');
ylabel('Rescaled Activity Counts');
legend('Raw Actigraphy','Fitted Cosinor Curve','Dichotomized Cosinior Curve');
end
