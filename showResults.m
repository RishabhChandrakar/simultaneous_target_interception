function showResults(G)
robots = G.Nodes.Obj;
n = numel(robots);
colors = [1 0 0; 0 1 0; 0 0 1; 1 0 1; 0 1 1]; % Red, Green, Blue, Magenta, Cyan

% =======================================================
% FIGURE 1: TRAJECTORIES (XY)
% =======================================================
figure('Name', 'Figure 1: Trajectories', 'Color', 'w', 'Position', [100, 100, 700, 600]);
hold on; grid on;

for i = 1:n
    rb = robots(i);
    plot(rb.posHistory(:,1), rb.posHistory(:,2), 'Color', colors(i,:), 'LineWidth', 2.5);
    plot(rb.posHistory(1,1), rb.posHistory(1,2), '.', 'Color', colors(i,:), 'MarkerSize', 25);
    text(rb.posHistory(1,1), rb.posHistory(1,2), ['  P', num2str(rb.ID)], 'FontSize', 12, 'FontWeight', 'bold', 'Color', colors(i,:));
end

plot(0, 0, 'k*', 'MarkerSize', 15, 'LineWidth', 2); % Target
xlabel('x (m)', 'FontWeight', 'bold'); ylabel('y (m)', 'FontWeight', 'bold');
title('Pursuer Trajectories', 'FontSize', 14);

% Style the Axis
ax1 = gca; ax1.XColor = 'k'; ax1.YColor = 'k'; ax1.LineWidth = 1.5; ax1.FontSize = 11;
axis([-250 250 -150 350]); daspect([1 1 1]);
hold off;

% =======================================================
% FIGURE 2: TIME OF INTERCEPTION (t_tilde) VS TIME
% =======================================================
figure('Name', 'Figure 2: Time Consensus', 'Color', 'w', 'Position', [850, 100, 700, 600]);
hold on; grid on;

for i = 1:n
    rb = robots(i);
    % Plot t_tilde vs sim_time
    plot(rb.timeHistory, rb.tTildeHistory, 'Color', colors(i,:), 'LineWidth', 2);
end

xlabel('Time t (s)', 'FontWeight', 'bold');
ylabel('Estimated Interception Time \color{black}\tilde{t}_i (s)', 'FontWeight', 'bold');
title('Consensus of Time-to-Interception', 'FontSize', 14);

% Add a Legend to identify robots
legend('Robot 1', 'Robot 2', 'Robot 3', 'Robot 4', 'Robot 5', 'Location', 'northeast');

% Style the Axis
ax2 = gca; ax2.XColor = 'k'; ax2.YColor = 'k'; ax2.LineWidth = 1.5; ax2.FontSize = 11;
ax2.GridAlpha = 0.3;

hold off;
end