function [smelt]=MELT_CarSi14(T,Cw,Cc)
Tk=T+273.15;
%------------------------------------------------------
if Cc==0
    ex_Cofit=0;
else
    ex_Cofit=1;
end
%------------------------------------------------------------------------
a=88774;
b=0.388;
c=73029;
d=4.5e-05;
e=5.5607;
EA1=a*exp(-b*Cw)+c;
x1=d*EA1+e;
sigma01=exp(x1);
a=798166;
b=0.1808;
c=32820;
d=5.5e-05;
e=5.7956;
R=8.314;
EA2=a*exp(-b*Cc)+c;
x2=d*EA2+e;
sigma02=exp(x2);
sigmamodelNEW=sigma01*exp(-EA1./(R*Tk))+ex_Cofit*sigma02*exp(-EA2./(R*Tk));
smelt=sigmamodelNEW;
