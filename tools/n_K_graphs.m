clc; clear all;

figure(1)
d = [150, 200, 250, 330]; %µm

n_25 = [0.3670, 0.4864, 0.6469, 0.6814];
K_25 = [2983, 1774, 1239, 1670];

n_b = [NaN, 0.4012, 0.5867, 0.5551];
K_b = [NaN, 3189, 1693, 2716];

yyaxis left
plot(d, n_25, 'ko-')
hold on
yyaxis right 
plot(d, K_25,'ks--')
yyaxis left
plot(d, n_b, 'ro-')
yyaxis right 
plot(d, K_b,'rs--')
hold off

lgd0 = legend('n - 25 wt.%','K - 25 wt.%','n - Benchmark','K - Benchmark');
lgd0.Location = 'Southoutside';
lgd0.Orientation = 'horizontal';

xlim([150,350])
xlabel('Nozzle diameter, D [$\mu$m]', 'Interpreter','latex')

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'r';
set(gca,'XMinorTick','on','YMinorTick','on')

ylabel('Flow consistency index, K [Pa.s$^n$]', 'Interpreter','latex')

yyaxis left
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'FontName','Times New Roman')
set(gca,'FontSize',12)
ylabel('Flow behaviour index, n [-]', 'Interpreter','latex')

figure(2)
n_25_a = [0.3634, 0.5224, 0.5424];
k_25_a = [13600, 3013, 3080];
n_30_a = [0.3698, 0.4629,0.4495];
k_30_a = [15150, 3885, 3643];
n_b_a = [0.274, 0.0851, 0.0742];
k_b_a = [6352, 3790,3600];

subplot(1,2,1)
X = categorical({'25%','30%','Bench.'});
X = reordercats(X,{'25%','30%','Bench.'});
Y = [n_25_a;n_30_a;n_b_a];

graph1 = bar(X,Y);
graph1(1).FaceColor = 'r';
graph1(2).FaceColor = 'b';
graph1(3).FaceColor = 'g';
ylabel('Flow behaviour index, n [-]', 'Interpreter','latex');
legend('Capillary data', 'Rheometer data', 'Combined model');

% xtips1 = graph1(1).XData;
% ytips1 = graph1(1).YData;
% labels1 = string(graph1(1).YData);
% text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom')
% xtips2 = graph1(2).XData;
% ytips2 = graph1(2).YData;
% labels2 = string(graph1(2).YData);
% text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom')
% xtips3 = graph1(3).XData;
% ytips3 = graph1(3).YData;
% labels3 = string(graph1(3).YData);
% text(xtips3,ytips3,labels3,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom')

set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'FontName','Times New Roman')
set(gca,'FontSize',12)

lgd1 = legend('Capillary data', 'Rheometer data', 'Combined model');
lgd1.FontSize = 10;

subplot(1,2,2)
XX = categorical({'25%','30%','Bench.'});
XX = reordercats(X,{'25%','30%','Bench.'});
YY = [k_25_a;k_30_a;k_b_a];

graph2 = bar(XX,YY/1000);
graph2(1).FaceColor = 'r';
graph2(2).FaceColor = 'b';
graph2(3).FaceColor = 'g';
ylabel('Flow consistency index, K [Pa.s$^n$] $\times$10$^3$', 'Interpreter','latex')

% xxtips1 = graph2(1).XData;
% yytips1 = graph2(1).YData;
% labels1 = string(graph2(1).YData);
% text(xxtips1,yytips1,labels1,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom')
% xxtips2 = graph2(2).XData;
% yytips2 = graph2(2).YData;
% labels2 = string(graph2(2).YData);
% text(xxtips2,yytips2,labels2,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom')
% xxtips3 = graph2(3).XData;
% yytips3 = graph2(3).YData;
% labels3 = string(graph2(3).YData);
% text(xxtips3,yytips3,labels3,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom')

set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'FontName','Times New Roman')
set(gca,'FontSize',12)

lgd2 = legend('Capillary data', 'Rheometer data', 'Combined model');
lgd2.FontSize = 10;