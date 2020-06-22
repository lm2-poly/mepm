function comparePlotVisco(SR_model,eta_model,SR_literature,eta_literature,x_lim,y_lim,deta,dSR,mode,i,myPlot)

%**************************************************************************
%comparePlotVisco.m
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

if isnumeric(eta_model) && isnumeric(SR_model) && isnumeric(eta_literature) && isnumeric(SR_literature)
    % Colors (https://www.mathworks.com/help/matlab/ref/matlab.graphics.primitive.text-properties.html)
    blue = [0 0.4470 0.7410];
    red = [0.8500 0.3250 0.0980];
    if nargin == 10
        figure(i+1);
    end
    
    % Plot and data labels
    if any(eta_model)
        if nargin == 10
            loglog(SR_model,eta_model,'-s','LineWidth',1.5,'Color',red);
            hold on
            t_model = text(SR_model,eta_model,string(round(eta_model,2)),'VerticalAlignment','bottom','HorizontalAlignment','left','FontSize',12);
        else
            loglog(myPlot,SR_model,eta_model,'-s','LineWidth',1.5,'Color',red);
            hold(myPlot,'on')
            t_model = text(myPlot,SR_model,eta_model,string(round(eta_model,2)),'VerticalAlignment','bottom','HorizontalAlignment','left','FontSize',12);
        end
    end
    
    if any(eta_literature)
        if nargin == 10
            loglog(SR_literature,eta_literature,'-s','LineWidth',1.5,'Color',blue);
            t_lit = text(SR_literature,eta_literature,string(round(eta_literature,2)),'VerticalAlignment','top','HorizontalAlignment','right','FontSize',12);
        else
            loglog(myPlot,SR_literature,eta_literature,'-s','LineWidth',1.5,'Color',blue);
            t_lit = text(myPlot,SR_literature,eta_literature,string(round(eta_literature,2)),'VerticalAlignment','top','HorizontalAlignment','right','FontSize',12);
        end
    end
    
    % Error bars for model
    if nargin == 10
        errorbar(SR_model,eta_model,deta,deta,dSR,dSR,'-o','LineWidth',1.0,'Color',red);
    end
     
    % Axit limit (if any)
    if nargin == 10
        if any(x_lim)
            xlim(x_lim);
        end
        if any(y_lim)
            ylim(y_lim);
        end
    end
    
    % Appearance
    if nargin == 10
        set(gca,'XMinorTick','on','YMinorTick','on')
        if strcmp(mode,'latex')
            set(gca,'TickLabelInterpreter','latex')
        else
            set(gca,'TickLabelInterpreter','default')
        end
        set(gca,'FontSize',12)
    end
    if any(eta_model)
        set(t_model,'Color',red)
    end
    if any(eta_literature)
        set(t_lit,'Color',blue)
    end
    
    % Axis labels, legend
    if nargin == 10
        xlabel('Process-related apparent shear rate [1/s]','FontSize',12);
        ylabel('Process-related apparent viscosity [Pa.s]','FontSize',12);
    end
    if any(eta_literature)
        if strcmp(mode,'latex')
            lgd = legend('$\eta_{app,model}$','$\eta_{app,literature}$');
            set(lgd, 'interpreter', 'latex');
        else
            if nargin == 10
                lgd = legend('\eta_{app,model}','\eta_{app,literature}');
            else
                lgd = legend(myPlot,'\eta_{app,model}','\eta_{app,literature}');
            end
            set(lgd, 'interpreter', 'default');
        end
        lgd.FontSize = 12;
        lgd.Location = 'southwest';
    end
        
    if strcmp(mode,'default') && nargin == 10
        set(findall(gca,'-property','FontName'),'FontName','Verdana')
    end
    
    if nargin == 10
        hold off
    else
        hold(myPlot,'off')
    end
end

end