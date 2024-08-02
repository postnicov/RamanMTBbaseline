clear;close all;clc;FS=20;

% This code require function 'baseline' and 'peak_stripping' from 
% https://www.mathworks.com/matlabcentral/fileexchange/69649-raman-spectrum-baseline-removal

SG=61;

file{1}='45_micro_point_3_40sec_100mwt.dpt';
file{2}='1604__2_micro_70sec_1re_50mwt_point1.dpt';


j=2;     
    S=csvread(file{j});
    invlambda{j} = S(:,1);
    Sraw{j} = despiking(S(:,2));
    Sfilt{j} = sgolayfilt(Sraw{j},3,SG);
    [Base{j}, Corrected_Spectrum{j}]=baseline(Sfilt{j});
    Corrected_Spectrum{j} = 100*Corrected_Spectrum{j}/max(Corrected_Spectrum{j});
    
    nameout=['BLC_',file{j}];
   dlmwrite(nameout,[S(:,1),Corrected_Spectrum{j}],'delimiter','\t');


figure
    plot(invlambda{j},Sraw{j},'.');
    hold on
    plot(invlambda{j},Sfilt{j},'-');
    plot(invlambda{j},Base{j},'--','LineWidth',1.5);
    title(file{j},'Interpreter','none')
    xlabel('Wavenumber, cm^{-1}')
    ylabel('Raw Raman Intensity')
    xlim([S(1,1),S(end,1)])


print(nameout(1:14),'-dpng')

figure
leg={};

    plot(invlambda{j},Corrected_Spectrum{j})

grid on
legend(file,'Location','Northwest','Interpreter','none')
xlabel('Wavenumber, cm^{-1}')
ylabel('Normed Raman Intensity')
title(['Savitsky-Golay qubic filter length:',num2str(SG)])
set(gca,'XTick',[400:100:1800])
set(gca,'FontSize',FS)
xlim([700 1200])

nameout1=['Cleared_spectrum_',file{j},'.png'];
print(nameout1,'-dpng')