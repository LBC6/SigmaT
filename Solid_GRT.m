function [sgrt]=Solid_GRT(T,Cwgrt,depth)
Tk=T+273.15;
p=(3.5/110)*(depth-40)+1;
A41=exp(7.16*(1-0.012*p));
A42=1950;
E1=128;
E2=70;
V1=2.5;
V2=-0.57;
r4=0.63;%nondimensional constant
R=8.314472/1000;
if Cwgrt==0
    sgrt=A41*exp(-(E1+p*V1)/(R*Tk))+A42*(Cwgrt^r4)*exp(-(E2+p*V2)/(R*Tk));
else
    sgrt=A42*(Cwgrt^r4)*exp(-(E2+p*V2)/(R*Tk));
end