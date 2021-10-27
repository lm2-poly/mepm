function comparePlotQ(v_model,Q_model,v_literature,Q_literature,x_lim,y_lim,dQ,mode,myPlot)

%**************************************************************************
%comparePlotPV.m
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

if isnumeric(Q_model) && isnumeric(v_model) && isnumeric(Q_literature) && isnumeric(v_literature)
    % Colors (https://www.mathworks.com/help/matlab/ref/matlab.graphics.primitive.text-properties.html)
    blue = [0 0.4470 0.7410];
    red = [0.8500 0.3250 0.0980];
    if nargin == 8
        figure(2);
    end
    
    % Plot and data labels
    if any(Q_model)
        if nargin == 8
            plot(v_model,Q_model,'-s','LineWidth',1.5,'Color',red);
            hold on
            t_model = text(v_model,Q_model,string(round(Q_model,3)),'FontSize',12);
        else
            plot(myPlot,v_model,Q_model,'-s','LineWidth',1.5,'Color',red);
            hold(myPlot,'on')
            t_model = text(myPlot,v_model,Q_model,string(round(Q_model,3)),'FontSize',12);
        end
        
        % Loop to align data label
        for i=1:size(Q_model,1)
            if any(Q_literature) && Q_model(i) <= Q_literature(i)
                t_model(i).HorizontalAlignment = 'left';
                t_model(i).VerticalAlignment = 'top';
            else
                t_model(i).HorizontalAlignment = 'right';
                t_model(i).VerticalAlignment = 'bottom';
            end
        end
    end
    
    if any(Q_literature)
        if nargin == 8
            plot(v_literature,Q_literature,'-s','LineWidth',1.5,'Color',blue);
            t_lit = text(v_literature,Q_literature,string(round(Q_literature,3)),'FontSize',12);
        else
            plot(myPlot,v_literature,Q_literature,'-s','LineWidth',1.5,'Color',blue);
            t_lit = text(myPlot,v_literature,Q_literature,string(round(Q_literature,3)),'FontSize',12);
        end
            
        % Loop to align data label
        for i=1:size(t_lit,1)
            if any(Q_literature)
                if Q_model(i) <= Q_literature(i)
                    t_lit(i).HorizontalAlignment = 'right';
                    t_lit(i).VerticalAlignment = 'bottom';
                else
                    t_lit(i).HorizontalAlignment = 'left';
                    t_lit(i).VerticalAlignment = 'top';
                end
            end
        end
    end
    
    % Error bars for model
    if dQ ~= 0
        if nargin == 8
            errorbar(v_model,Q_model,dQ,'-','LineWidth',1.0,'Color',red);
        else    
            hold(myPlot,'on')
            errorbar(myPlot,v_model,Q_model,dQ,'-','LineWidth',1.0,'Color',red);    
        end
    end
    
    % Axit limit (if any)
    if nargin == 8
        if any(x_lim)
            xlim(x_lim);
        end
        if any(y_lim)
            ylim(y_lim);
        end
    end
    
    % Appearance
    if nargin == 8
        set(gca,'XMinorTick','on','YMinorTick','on')
        if strcmp(mode,'latex')
            set(gca,'TickLabelInterpreter','latex')
        else
            set(gca,'TickLabelInterpreter','default')
        end
        set(gca,'FontSize',12)
    end
    if any(Q_model)
        set(t_model,'Color',red)
    end
    if any(Q_literature)
        set(t_lit,'Color',blue)
    end
    
    % Axis labels, legend
    if nargin == 8
        xlabel('Nozzle exit velocity [mm/s]','FontSize',12);
        ylabel('Total mass flow rate [g/s]','FontSize',12);
    end
    if any(Q_literature)
        if strcmp(mode,'latex')
            lgd = legend('$Q_{model}$','$Q_{literature}$');
            set(lgd, 'interpreter', 'latex');
        else
            if nargin == 8
                lgd = legend('Q_{model}','Q_{literature}');
            else
                lgd = legend(myPlot,'Q_{model}','Q_{literature}');
            end
            set(lgd, 'interpreter', 'default');    
        end
        lgd.FontSize = 12;
        lgd.Location = 'southeast';
        
    end
    
    if strcmp(mode,'default') && nargin == 8
        set(findall(gca,'-property','FontName'),'FontName','Verdana')
    end
    
    if nargin == 8
        hold off
    else
        hold(myPlot,'off')
    end
end

end