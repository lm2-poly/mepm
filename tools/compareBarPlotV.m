function compareBarPlotV(v_real,v_desired,i,dv_real,v_theo,mode)

%**************************************************************************
%compareBarPlotV.m
%**************************************************************************
%
%Author: David Brzeski, Jean-François Chauvette
%Date: June 1st, 2020
%**************************************************************************

if strcmp(mode,'default')
    set(0,'defaulttextinterpreter','default')
else
    set(0,'defaulttextinterpreter','latex')
end

if isnumeric(v_real) && isnumeric(v_desired)
    % Colors (https://www.mathworks.com/help/matlab/ref/matlab.graphics.primitive.text-properties.html)
    red = [0.8500 0.3250 0.0980];
    darkRed = [0.64 0.08 0.18];
    figure(2+i);
    
    % Plot and data labels
    nozzleNumber = 1:size(v_real,2);
    %bar(nozzleNumber,[transpose(v_real) transpose(v_theo)],0.3,'b');
    bar(nozzleNumber,v_real,0.2,'b','LineWidth',1.5);
    set(findall(gca,'-property','FaceColor'),'FaceColor',red)
    set(findall(gca,'-property','FaceColor'),'EdgeColor',darkRed)
    
    hold on
    err = errorbar(nozzleNumber,v_real,dv_real,dv_real);
    err.Color = [0 0 0];
    err.LineStyle = 'none';
    t_model = text(nozzleNumber,v_real,string(round(v_real,2)),'VerticalAlignment','bottom','HorizontalAlignment','center','FontSize',12);
    
    % Y line at desired speed
    xmax = xlim();
    plot([0,xmax(2)],v_desired*ones(1,2),'--','LineWidth',1.0,'Color','k');
    
    % Appearance
    set(gca,'XMinorTick','off','YMinorTick','on')
    if strcmp(mode,'latex')
        set(gca,'TickLabelInterpreter','latex')
    else
        set(gca,'TickLabelInterpreter','default')
    end
    set(gca,'FontSize',12)
    set(t_model,'Color',red)
    
    % Axis labels, legend
    xlabel('Nozzle number','FontSize',12);
    ylabel('Nozzle exit velocity [mm/s]','FontSize',12);
    
    if strcmp(mode,'default')
        set(findall(gca,'-property','FontName'),'FontName','Verdana')
    end
    
    hold off
end

end