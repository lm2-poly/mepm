function testGraph(P_required_25,P_required_30)

%**************************************************************************
%testGraph.m is the function used to obtain comparison graphs for Pressure
%vs speed of selected abradable materials
%**************************************************************************
%The output is a multi-line graph.
%The inputs are the estimated driving pressures on the robot, as computed
%by the main model.
%Author: David Brzeski
%Date: May 23rd, 2020
%**************************************************************************
P_printability_25 = [1400,2147,2772,3276,3780,4078]; %250µm
P_printability_30 = [875,1808,2847,3418,3990,4247]; %250µm
v = [1,2,3,4,5,6];
%Evaluate main.m succesively with each speed, for each material, with
%510nozzle, and build two pressure required vectors (one per material)

if nargin==2
    if isnumeric(v) &&  isnumeric(P_required_25) && isnumeric(P_required_30)
        plot(v,P_printability_25,'rv-');
        hold on
        plot(v,P_printability_30,'bv-');
        plot(v,P_required_25,'ro-');
        plot(v,P_required_30,'bo-');
        xlim([1,6]);
        ylim([750,4500]);
        xlabel('Deposition speed [mm.s^{-1}]','fontweight','bold','FontSize',12)
        ylabel('Pressures [kPa]','fontweight','bold','FontSize',12)
        lgd = legend('P_{experimental} - 25%','P_{model} - 25%',...
            'P_{experimental} - 30%','P_{model} - 30%');
        lgd.Location = 'southeast';
        set(gca,'XMinorTick','on','YMinorTick','on')
        set(gca,'FontName','Times New Roman')
        hold off
    end
end
end