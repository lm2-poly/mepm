function compareBarPlotV(v_real,v_desired,dv_real,mode,i,myPlot)

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
    if nargin == 5
        figure(i+2);
    end
        
    % Plot and data labels
    nozzleNumber = 1:size(v_real,2);
    
    % Y line at desired speed
    if nargin == 5
        plot([0,nozzleNumber(end)+1],v_desired*ones(1,2),'--','LineWidth',1.0,'Color','k');
        hold on
        plot([0,nozzleNumber(end)+1],mean(v_real)*ones(1,2),'--','LineWidth',1.0,'Color','r');
    else
        plot(myPlot,[0,nozzleNumber(end)+1],v_desired*ones(1,2),'--','LineWidth',1.0,'Color','k');
        hold(myPlot,'on')
        plot(myPlot,[0,nozzleNumber(end)+1],mean(v_real)*ones(1,2),'--','LineWidth',1.0,'Color','r');
    end
    
    if nargin == 5
        bar(nozzleNumber,v_real,0.2,'b','LineWidth',1.5);
        set(findall(gca,'-property','FaceColor'),'FaceColor',red)
        set(findall(gca,'-property','FaceColor'),'EdgeColor',darkRed)
    else
        bar(myPlot,nozzleNumber,v_real,0.2,'b','LineWidth',1.2);%,'HandleVisibility','off');
    end
    
    if nargin == 5
        err = errorbar(nozzleNumber,v_real,dv_real,dv_real);
        t_model = text(nozzleNumber,v_real,string(round(v_real,2)),'VerticalAlignment','bottom','HorizontalAlignment','center','FontSize',12);
        err.Color = [0 0 0];
        err.LineStyle = 'none';
        set(t_model,'Color',red)
    else
        hold(myPlot,'on')
        err = errorbar(myPlot,nozzleNumber,v_real,dv_real,dv_real);
        t_model = text(myPlot,nozzleNumber,v_real,string(round(v_real,2)),'VerticalAlignment','bottom','HorizontalAlignment','center','FontSize',12);
        err.Color = [0 0 0];
        err.LineStyle = 'none';
        set(t_model,'Color',red)
    end
    
    % Appearance
    if nargin == 5
        set(gca,'XMinorTick','off','YMinorTick','on')
        if strcmp(mode,'latex')
            set(gca,'TickLabelInterpreter','latex')
        else
            set(gca,'TickLabelInterpreter','default')
        end
        set(gca,'FontSize',12)
    end
    
    % Axis labels, legend
    if nargin == 5
        xlabel('Nozzle number','FontSize',12);
        ylabel('Nozzle exit velocity [mm/s]','FontSize',12);
    end
    
    if strcmp(mode,'default') && nargin == 5
        set(findall(gca,'-property','FontName'),'FontName','Verdana')
    end
    
    if strcmp(mode,'latex')
        lgd = legend('$P_{model}$','$P_{literature}$');
        set(lgd, 'interpreter', 'latex');
    else
        if nargin == 5
            lgd = legend('Desired velocity','Average velocity');
        else
            lgd = legend(myPlot,'Desired velocity','Average velocity');
        end
        set(lgd, 'interpreter', 'default');    
    end
    lgd.FontSize = 10;
    lgd.Location = 'southeast';
    
    if nargin == 5
        hold off
    else
        hold(myPlot,'off')
    end
end

end