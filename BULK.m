function [sbulk]=BULK(Temp,depth,Cwbulk,Dpartition,Cc,Threshold,...
    Xol,Xopx,Xcpx,Xgrt,...
    Dsolidol,Dsolidopx,Dsolidcpx,Dsolidgrt,...
    Dmixol,Dmixopx,Dmixcpx,Dmixgrt,Dmixmelt)

Dmixmelt_c=1; 

global Cwmeltmix
global Ccmeltmix
%===========================================starting to calculate================================================%
Tmelt=Tempmelt(depth,Cwbulk,Dpartition);

if Temp<=Tmelt                         
    
    xsolid=fsolve(@(x)Xol*Dsolidol*x+Xopx*Dsolidopx*x+Xcpx*Dsolidcpx*x+Xgrt*Dsolidgrt*x-Cwbulk,0);
    Cwolsolid=Dsolidol*xsolid*100;      
    Cwcpxsolid=Dsolidopx*xsolid*100;    
    Cwopxsolid=Dsolidcpx*xsolid*100;    
    Cwgrtsolid=Dsolidgrt*xsolid*100;    
    
    sigmaol=Solid_OL(Temp,Cwolsolid);         
    sigmaopx=Solid_OPX(Temp,Cwopxsolid);      
    sigmacpx=Solid_CPX(Temp,Cwcpxsolid);      
    sigmagrt=Solid_GRT(Temp,Cwgrtsolid,depth);
    Cwmeltmix=0;
    Ccmeltmix=0;
    
    sigmasolid=(((Xol/100)/(sigmaol+2*sigmaol))+((Xopx/100)/(sigmaopx+2*sigmaol))+((Xcpx/100)/(sigmacpx+2*sigmaol))+((Xgrt/100)/(sigmagrt+2*sigmaol)))^(-1)-(2*sigmaol);
    sbulk=sigmasolid;
    
else Temp>Tmelt                         
    
    Xmelt=Fmelt(Temp,depth,Cwbulk,Dpartition);
    
    if Xmelt<Threshold                      
        xmix=fsolve(@(x)Xol*(1-Xmelt)*Dmixol*x+Xopx*(1-Xmelt)*Dmixopx*x+Xcpx*(1-Xmelt)*Dmixcpx*x+Xgrt*(1-Xmelt)*Dmixgrt*x+Xmelt*Dmixmelt*x-Cwbulk,0);
        Cwolmix=Dmixol*xmix*100;        
        Cwopxmix=Dmixopx*xmix*100;      
        Cwcpxmix=Dmixcpx*xmix*100;      
        Cwgrtmix=Dmixgrt*xmix*100;      
        Cwmeltmix=Dmixmelt*xmix*100;    
        Cwmelt=Cwmeltmix*Xmelt;        
        
        xmix_c=fsolve(@(x_c)Xmelt*Dmixmelt_c*x_c-Cc,0);
        Ccmeltmix=Dmixmelt_c*xmix_c*100;    
        if Ccmeltmix>=45
            Ccmeltmix=45;               
        end
        
        sigmaol=Solid_OL(Temp,Cwolmix);       
        sigmaopx=Solid_OPX(Temp,Cwopxmix);    
        sigmacpx=Solid_CPX(Temp,Cwcpxmix);    
        sigmagrt=Solid_GRT(Temp,Cwgrtmix,depth);
        sigmamelt=MELT_CarSi14(Temp,Cwmeltmix,Ccmeltmix); 
        
        sigmasolid=(((Xol/100)/(sigmaol+2*sigmaol))+((Xopx/100)/(sigmaopx+2*sigmaol))+((Xcpx/100)/(sigmacpx+2*sigmaol))+((Xgrt/100)/(sigmagrt+2*sigmaol))+((Xmelt/100)/(sigmamelt+2*sigmaol)))^(-1)-(2*sigmaol);
       
        sbulk=sigmasolid;
    else                                
        xmix=fsolve(@(x)Xol*(1-Xmelt)*Dmixol*x+Xopx*(1-Xmelt)*Dmixopx*x+Xcpx*(1-Xmelt)*Dmixcpx*x+Xgrt*(1-Xmelt)*Dmixgrt*x+Xmelt*Dmixmelt*x-Cwbulk,0);
        Cwolmix=Dmixol*xmix*100;       
        Cwopxmix=Dmixopx*xmix*100;     
        Cwcpxmix=Dmixcpx*xmix*100;     
        Cwgrtmix=Dmixgrt*xmix*100;     
        Cwmeltmix=Dmixmelt*xmix*100; 
        Cwmelt=Cwmeltmix*Xmelt;        
        
        xmix_c=fsolve(@(x_c)Xmelt*Dmixmelt_c*x_c-Cc,0);
        Ccmeltmix=Dmixmelt_c*xmix_c*100;    
        if Ccmeltmix>=45
            Ccmeltmix=45;               
        end
        
        sigmaol=Solid_OL(Temp,Cwolmix);      
        sigmaopx=Solid_OPX(Temp,Cwopxmix);   
        sigmacpx=Solid_CPX(Temp,Cwcpxmix);   
        sigmagrt=Solid_GRT(Temp,Cwgrtmix,depth);
        sigmamelt=MELT_CarSi14(Temp,Cwmeltmix,Ccmeltmix);
        
        sigmasolid=(((Xol/100)/(sigmaol+2*sigmaol))+((Xopx/100)/(sigmaopx+2*sigmaol))+((Xcpx/100)/(sigmacpx+2*sigmaol))+((Xgrt/100)/(sigmagrt+2*sigmaol)))^(-1)-(2*sigmaol);
        sigmamix=sigmamelt*((3*sigmasolid+2*Xmelt*(sigmamelt-sigmasolid))/(3*sigmamelt-Xmelt*(sigmamelt-sigmasolid)));
        sbulk=sigmamix;
    end
end
end
