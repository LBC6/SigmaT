function [Viscos, alpha_used] = Viscosity_Xia13(T, Cw, depth, Xmelt)
%%
p = (3.5/110)*(depth-40) + 1; 
P = p * 1e6; 
Tk = T + 273.15;  
Coh = Cw * 1e4;
R = 8.314 / 1000;  
%% 
Acre = 90; 
tao = 0.3; 
n = 3.5;  
r = 1.2;  
Q = 480;  
Vcre = 1.06e-5;
%% 
c0 = -7.9859;
c1 = 4.3559;
c2 = -0.5742;
c3 = 0.0337;
logCoh = log(Coh);
Fwater = exp(c0 + c1*logCoh + c2*logCoh^2 + c3*logCoh^3);
%% 
if Xmelt <= 0
    alpha_used = 12;
elseif Xmelt <= 0.01
    alpha_used = 25;
else
    alpha_used = 35;
end
melt_factor = exp(alpha_used * (Xmelt - 0.01));
%%
epsilon = Acre * (tao^n) * (Fwater^r) ...
    * exp(-(Q + P*Vcre)./(R*Tk)) ...
    * melt_factor;
Viscos = (tao / epsilon) * 1e6;
end