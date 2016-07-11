data lag_ema;
set ema_daily3;
happy_lag=lag(happy);
worried_lag=lag(worried);
calm_lag=lag(calm);
restless_lag=lag(restless);
frustrated_lag=lag(frustrated);
sad_lag=lag(sad);
excited_lag=lag(excited);
lonely_lag=lag(lonely);
bored_lag=lag(bored);
sluggish_lag=lag(sluggish);
mar_lag=lag(mar_sub);
cig_lag=lag(cig_sub);
alc_lag=lag(alc_sub);
run;


data time_ema;
set lag_ema;
by case_number;
if first.case_number then day=0;
retain day 0;
day=day+1;
day2=day*day;
run;

proc freq data=lag_ema;
table alc_sub;
run;

%macro crude(var1, var2);
proc genmod data=lag_ema descending;
class &var1 case_number/param=ref ref=FIRST;
model &var1=&var2/link=logit dist=bin;
repeated subject=case_number/  type=exch;
ods select GEEEmpPEst;
run;
%mend;

%crude(alc_sub,happy_lag);
%crude(alc_sub,worried_lag);
%crude(alc_sub, Calm_lag);
%crude(alc_sub,restless_lag);
%crude(alc_sub,frustrated_lag);
%crude(alc_sub, sad_lag);
%crude(alc_sub, excited_lag);
%crude(alc_sub,lonely_lag);
%crude(alc_sub,bored_lag);
%crude(alc_sub,sluggish_lag);

%crude(cig_sub,happy_lag);
%crude(cig_sub,worried_lag);
%crude(cig_sub, Calm_lag);
%crude(cig_sub,restless_lag);
%crude(cig_sub,frustrated_lag);
%crude(cig_sub, sad_lag);
%crude(cig_sub, excited_lag);
%crude(cig_sub,lonely_lag);
%crude(cig_sub,bored_lag);
%crude(cig_sub,sluggish_lag);


%crude(mar_sub,happy_lag);
%crude(mar_sub,worried_lag);
%crude(mar_sub, Calm_lag);
%crude(mar_sub,restless_lag);
%crude(mar_sub,frustrated_lag);
%crude(mar_sub, sad_lag);
%crude(mar_sub, excited_lag);
%crude(mar_sub,lonely_lag);
%crude(mar_sub,bored_lag);
%crude(mar_sub,sluggish_lag);

proc genmod data=lag_ema descending;
class alc_sub case_number/param=ref ref=FIRST;
model alc_sub=happy_lag worried_lag restless_lag Calm_lag frustrated_lag sad_lag excited_lag lonely_lag bored_lag sluggish_lag/link=logit dist=bin;
repeated subject=case_number/  type=AR;
run;


proc genmod data=lag_ema descending;
class cig_sub case_number/param=ref ref=FIRST;
model cig_sub=happy_lag worried_lag restless_lag Calm_lag frustrated_lag sad_lag excited_lag lonely_lag bored_lag sluggish_lag/link=logit dist=bin;
repeated subject=case_number/  type=AR;
run;


proc genmod data=lag_ema descending;
class mar_sub case_number/param=ref ref=FIRST;
model mar_sub=happy_lag worried_lag restless_lag Calm_lag frustrated_lag sad_lag excited_lag lonely_lag bored_lag sluggish_lag/link=logit dist=bin;
repeated subject=case_number/  type=AR;
run;

proc genmod data=lag_ema descending;
class mar_sub cig_lag case_number/param=ref ref=FIRST;
model cig_sub=lonely_lag cig_lag/link=logit dist=bin;
repeated subject=case_number/  type=AR;
run;

proc logistic data=time_ema;
class case_number alc_sub/param=ref ref=FIRST;
model alc_sub = day case_number day*case_number;
output out=alc pred=p;
run;



proc logistic data=time_ema;
class case_number cig_sub/param=ref ref=FIRST;
model cig_sub = day case_number day*case_number;
output out=cig pred=p;
run;



proc logistic data=time_ema;
class case_number mar_sub/param=ref ref=FIRST;
model mar_sub = day case_number day*case_number;
output out=mar pred=p;
run;

ods pdf file="C:\Users\mdl0193\Dropbox\mChat\SAS\Ind Substance Trajs.pdf";
proc sgplot data=alc;
pbspline x=day y=p /group=case_number ;
title "Individual Trajectories of Alcohol Use";
run;

proc sgplot data=cig;
pbspline x=day y=p /group=case_number ;
title "Individual Trajectories of Cigarrette Use";
run;

proc sgplot data=mar;
pbspline x=day y=p /group=case_number ;
title "Individual Trajectories of Marijuana Use";
run;
ods pdf close;
