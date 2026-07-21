function [tmelt] = Tempmelt(depth,Cwater,Dpartition)
p=(3.5/110)*(depth-40)+1;
Ts=(1085.7)+(132.9).*p+(-5.1).*(p.^2);
Xwater=Cwater/Dpartition;
deltaT=43*((Xwater)^0.75);
tmelt=Ts-deltaT;