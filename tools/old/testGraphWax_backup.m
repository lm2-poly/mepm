function testGraphWax(P_required_40,P_required_30)

%**************************************************************************
%testGraphWax.m is the function used to obtain comparison graphs for Pressure
%vs speed of selected abradable materials
%**************************************************************************
%The output is a multi-line graph.
%The inputs are the estimated driving pressures on the robot, as computed
%by the main model.
%Author: David Brzeski
%Date: May 25th, 2020
%**************************************************************************
%Reference values taken from Bruneaux, Figure 10.
P_printability_40 = [600,950,1150,1300,1500,2600]; %510µm, P in kPa
P_printability_30 = [400,650,850,975,1100,2000]; %510µm, P in kPa
v = [1,3,5,7,10,40]; 
%Evaluate main.m succesively with each speed, for each material, with
%510nozzle, and build two pressure required vectors (one per material)

if nargin==2
    if isnumeric(v) &&  isnumeric(P_required_40) && isnumeric(P_required_30)
        plot(v,P_printability_40,'rv-');
        hold on
        plot(v,P_printability_30,'bv-');
        plot(v,P_required_40,'ro-');
        plot(v,P_required_30,'bo-');
        xlim([1,6]);
        ylim([750,4500]);
        xlabel('Deposition speed [mm.s^{-1}]','fontweight','bold','FontSize',12)
        ylabel('Pressures [kPa]','fontweight','bold','FontSize',12)
        lgd = legend('P_{experimental} - 40%','P_{model} - 40%',...
            'P_{experimental} - 30%','P_{model} - 30%');
        lgd.Location = 'southeast';
        set(gca,'XMinorTick','on','YMinorTick','on')
        set(gca,'FontName','Times New Roman')
        hold off
    end
end
end