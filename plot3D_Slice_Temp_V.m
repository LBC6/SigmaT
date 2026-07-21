function plot3D_Slice_Temp_V
clc
clear
tic 
%% ===================================================================%
if exist('parameter.mat')
    load parameter.mat; 
else
    s_prompt = {'Depth(km):','Cwater(wt%):','Ccarbon dioxide(wt%):',...
        'Distribution coefficient','Temperature threshold(1.0)'};
    s_titles  = 'Choose Parameters';
    s_def= {'50','0.002691','0.00111','0.0042','0.001'}; 
    def_lim = char(inputdlg(s_prompt,s_titles,1,s_def));
    Depth=str2num(def_lim(1,:));                        
    Cwater=str2num(def_lim(2,:));                       
    Carbon_dioxide=str2num(def_lim(3,:));  
    D=str2num(def_lim(4,:));   
    Threshold=str2num(def_lim(5,:)); 
end
%% ===================================================================%
Xol=68; 
Xopx=22;
Xcpx=10;
Xgrt=0;

Dsolidol=1;
Dsolidopx=2.7;
Dsolidcpx=4.7;
Dsolidgrt=0.2;

Dmixol=2;
Dmixopx=3;
Dmixcpx=20;
Dmixgrt=1;
Dmixmelt=1000;
%% =================================start reading data==================================%
[filename,path]=uigetfile({'*.txt';'*.xyz';'*.*'},'Select resistivity data to Calculate');
% Longitude(°) Latitude(°) Resistivity log10[Resistivity/(Ωm)]
if filename==0
    disp('user canceled...')
    return
end
cd(path)
fid = load([path filename],'r');
if fid == -1
    return;
end
%============================================%
a= isnan(fid(:,3));        
fid(a,:)=[];                   
%==============================================================================%
x=fid(:,1);y=fid(:,2);  
z=fid(:,3); 
%==============================================================================%
c= length(z)
%===========================%
if isempty(gcp('nocreate'))
    parpool;
else
    disp('parpool start'); 
end

parfor j=1:1:c
    [Temperature(j),Meltfraction(j)]=Cal_Temp_V_Si14(z(j),abs(Depth),Cwater,D,Carbon_dioxide,Threshold,...
        Xol,Xopx,Xcpx,Xgrt,...
        Dsolidol,Dsolidopx,Dsolidcpx,Dsolidgrt,...
        Dmixol,Dmixopx,Dmixcpx,Dmixgrt,Dmixmelt);
    if Meltfraction(j)<=0
        Meltfraction(j)=-3;
    elseif Meltfraction(j)>=100
        Meltfraction(j)=2;
    else
        Meltfraction(j)=log10(Meltfraction(j));
    end
    
    Viscosity(j) = Viscosity_Xia13(Temperature(j),Cwater,abs(Depth),(10^Meltfraction(j))/100);
    if Viscosity(j)<0
        Viscosity(j)=1e18;
    end
end
clear z;
Temperature=Temperature';Meltfraction=Meltfraction';
%============================================%
a=find(isnan(Viscosity(:,3)));        
Viscosity(a,:)=[];                    
Viscosity=Viscosity';

%% ========================================fprintf Temperature======================================%
data=[x,y,Temperature];
outname=strrep(filename,'.xyz','');
fid=fopen([outname,'_T.txt'],'wt');
[m,n]=size(data);
for i=1:m
    for j=1:n
        if j==n
            fprintf(fid,'%g\n',data(i,j));
        else
            fprintf(fid,'%g\t',data(i,j));
        end
    end
end
fclose(fid)
%% ========================================fprintf Meltfraction======================================%
data=[x,y,Meltfraction];
outname=strrep(filename,'.xyz','');
fid=fopen([outname,'_M.txt'],'wt');

[m,n]=size(data);
for i=1:m
    for j=1:n
        if j==n
            fprintf(fid,'%g\n',data(i,j));
        else
            fprintf(fid,'%g\t',data(i,j));
        end
    end
end
fclose(fid)
%% ========================================fprintf Viscosity======================================%
data=[x,y,log10(Viscosity)];
outname=strrep(filename,'.xyz','');
fid=fopen([outname,'_V.txt'],'wt');
[m,n]=size(data);
for i=1:m
    for j=1:n
        if j==n
            fprintf(fid,'%g\n',data(i,j));
        else
            fprintf(fid,'%g\t',data(i,j));
        end
    end
end
fclose(fid)
cpu_time=toc                             