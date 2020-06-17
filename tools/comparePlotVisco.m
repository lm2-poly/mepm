function comparePlotVisco(SR_model,eta_model,SR_literature,eta_literature,x_lim,y_lim,deta,mode)

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
    figure(2);
    
    % Plot and data labels
    if any(eta_model)
        loglog(SR_model,eta_model,'-s','LineWidth',1.5,'Color',red);
%         set(gca,'YScale','log')
%         set(gca,'XScale','log')
        hold on
        t_model = text(SR_model,eta_model,string(round(eta_model,2)),'VerticalAlignment','bottom','HorizontalAlignment','left','FontSize',12);
    end
    
    if any(eta_literature)
        loglog(SR_literature,eta_literature,'-s','LineWidth',1.5,'Color',blue);
        t_lit = text(SR_literature,eta_literature,string(round(eta_literature,2)),'VerticalAlignment','top','HorizontalAlignment','right','FontSize',12);
    end
    
    % Error bars for model
    errorbar(SR_model,eta_model,deta,'-o','LineWidth',1.0,'Color',red);
    
    % Axit limit (if any)
    if any(x_lim)
        xlim(x_lim);
    end
    if any(y_lim)
        ylim(y_lim);
    end
    
    % Appearance
    set(gca,'XMinorTick','on','YMinorTick','on')
    if strcmp(mode,'latex')
        set(gca,'TickLabelInterpreter','latex')
    end
    set(gca,'FontSize',12)
    if any(eta_model)
        set(t_model,'Color',red)
    end
    if any(eta_literature)
        set(t_lit,'Color',blue)
    end
    
    % Axis labels, legend
    xlabel('Process-related apparent shear rate [1/s]','FontSize',12);
    ylabel('Process-related apparent viscosity [Pa.s]','FontSize',12);
    if any(eta_literature)
        if strcmp(mode,'latex')
            lgd = legend('$\eta_{app,model}$','$\eta_{app,literature}$');
            set(lgd, 'interpreter', 'latex');
        else
            lgd = legend('\eta_{app,model}','\eta_{app,literature}');
            set(lgd, 'interpreter', 'default');
        end
        lgd.FontSize = 12;
        lgd.Location = 'southwest';
    end
        
    if strcmp(mode,'default')
        set(findall(gca,'-property','FontName'),'FontName','Verdana')
    end
    
    hold off
end

end