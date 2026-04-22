function showResults(G)
% Access global variables for dynamic axis and case info
global bounds simulation_case

robots = G.Nodes.Obj;
n = numel(robots);

% Define 6 distinct colors (Added Orange for P6)
% Red, Green, Blue, Magenta, Cyan, Orange
colors = [1 0 0; 
    0 1 0; 
    0 0 1; 
    1 0 1; 
    0 1 1; 
    1 0.5 0]; 

% =======================================================
% FIGURE 1: TRAJECTORIES (XY)
% =======================================================
figure('Name', 'Figure 1: Trajectories', 'Color', 'w', 'Position', [100, 100, 700, 600]);
hold on; grid on;

for i = 1:n
    rb = robots(i);
    if isempty(rb.posHistory), continue; end

    % Plot Path
    plot(rb.posHistory(:,1), rb.posHistory(:,2), 'Color', colors(i,:), 'LineWidth', 2.5);

    % Plot Start Point
    plot(rb.posHistory(1,1), rb.posHistory(1,2), '.', 'Color', colors(i,:), 'MarkerSize', 25);

    % Label start point (P1, P2... P6)
    text(rb.posHistory(1,1), rb.posHistory(1,2), ['  P', num2str(rb.ID)], ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', colors(i,:));
end

% Plot Target
plot(0, 0, 'k*', 'MarkerSize', 15, 'LineWidth', 2); 
text(10, 10, 'T', 'FontSize', 14, 'FontWeight', 'bold');

xlabel('x (m)', 'FontWeight', 'bold'); ylabel('y (m)', 'FontWeight', 'bold');
title('Pursuer Trajectories', 'FontSize', 14);

% Style the Axis
ax1 = gca; ax1.XColor = 'k'; ax1.YColor = 'k'; ax1.LineWidth = 1.5; ax1.FontSize = 11;
if ~isempty(bounds), axis(bounds); end
daspect([1 1 1]);
hold off;

% =======================================================
% FIGURE 2: TIME OF INTERCEPTION (t_tilde) VS TIME
% =======================================================
figure('Name', 'Figure 2: Time Consensus', 'Color', 'w', 'Position', [850, 100, 700, 600]);
hold on; grid on;

legendLabels = {}; % To build a dynamic legend

for i = 1:n
    rb = robots(i);
    if isempty(rb.timeHistory), continue; end

    % Plot t_tilde vs sim_time
    plot(rb.timeHistory, rb.tTildeHistory, 'Color', colors(i,:), 'LineWidth', 2);

    % Add label for legend
    legendLabels{end+1} = ['Pursuer ', num2str(rb.ID)];
end

xlabel('Time t (s)', 'FontWeight', 'bold');
ylabel('Estimated Interception Time \tilde{t}_i (s)', 'FontWeight', 'bold');
title('Consensus of Time-to-Interception', 'FontSize', 14);

% Apply dynamic legend
legend(legendLabels, 'Location', 'northeast', 'FontSize', 10);

% Style the Axis
ax2 = gca; ax2.XColor = 'k'; ax2.YColor = 'k'; ax2.LineWidth = 1.5; ax2.FontSize = 11;
ax2.GridAlpha = 0.3;

hold off;
end