function comparePlotPV(v_model,P_model,v_literature,P_literature,x_lim,y_lim,dP,mode,myPlot)

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

if isnumeric(P_model) && isnumeric(v_model) && isnumeric(P_literature) && isnumeric(v_literature)
    % Colors (https://www.mathworks.com/help/matlab/ref/matlab.graphics.primitive.text-properties.html)
    blue = [0 0.4470 0.7410];
    red = [0.8500 0.3250 0.0980];
    if nargin == 8
        figure(1);
    end
    
    % Plot and data labels
    if any(P_model)
        if nargin == 8
            semilogy(v_model,P_model,'-s','LineWidth',1.5,'Color',red);
            hold on
            t_model = text(v_model,P_model,string(round(P_model,0)),'FontSize',12);
        else
            semilogy(myPlot,v_model,P_model,'-s','LineWidth',1.5,'Color',red);
            hold(myPlot,'on')
            t_model = text(myPlot,v_model,P_model,string(round(P_model,0)),'FontSize',12);
        end
        
        % Loop to align data label
        for i=1:size(P_model,1)
            if any(P_literature) && P_model(i) <= P_literature(i)
                t_model(i).HorizontalAlignment = 'left';
                t_model(i).VerticalAlignment = 'top';
            else
                t_model(i).HorizontalAlignment = 'right';
                t_model(i).VerticalAlignment = 'bottom';
            end
        end
    end
    
    if any(P_literature)
        if nargin == 8
            semilogy(v_literature,P_literature,'-s','LineWidth',1.5,'Color',blue);
            t_lit = text(v_literature,P_literature,string(round(P_literature,0)),'FontSize',12);
        else
            semilogy(myPlot,v_literature,P_literature,'-s','LineWidth',1.5,'Color',blue);
            t_lit = text(myPlot,v_literature,P_literature,string(round(P_literature,0)),'FontSize',12);
        end
            
        % Loop to align data label
        for i=1:size(t_lit,1)
            if any(P_literature)
                if P_model(i) <= P_literature(i)
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
    if nargin == 8
        errorbar(v_model,P_model,dP,'-','LineWidth',1.0,'Color',red);
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
    if any(P_model)
        set(t_model,'Color',red)
    end
    if any(P_literature)
        set(t_lit,'Color',blue)
    end
    
    % Axis labels, legend
    if nargin == 8
        xlabel('Nozzle exit velocity [mm/s]','FontSize',12);
        ylabel('Required pressure [kPa]','FontSize',12);
    end
    if any(P_literature)
        if strcmp(mode,'latex')
            lgd = legend('$P_{model}$','$P_{literature}$');
            set(lgd, 'interpreter', 'latex');
        else
            if nargin == 8
                lgd = legend('P_{model}','P_{literature}');
            else
                lgd = legend(myPlot,'P_{model}','P_{literature}');
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