function [vmelt] = Fmelt(Temp,depth,Cwater,Dpartition)

p=(3.5/110)*(depth-40)+1;
Ts=(1085.7)+(132.9)*p+(-5.1).*(p^2);
Tli=(1475)+(80)*p+(-3.2)*(p^2);

Y=@(v)(((Temp-Ts+((43)*((Cwater/(Dpartition+(1-Dpartition)*v))^0.75)))/(Tli-Ts))^1.5)-v;
vmelt=fsolve(Y,0);
end

