function showResults(G)
robots = G.Nodes.Obj;
n = numel(robots);

for i = 1:n
    rb = robots(i);
    figure('Name', ['Robot ' num2str(rb.ID) ' Results'], 'Color', 'w');

    % Subplot 1: XY Trajectory
    subplot(3, 1, 1);
    plot(rb.posHistory(:,1), rb.posHistory(:,2), 'LineWidth', 2);
    hold on; grid on;
    plot(rb.posHistory(1,1), rb.posHistory(1,2), 'go', 'MarkerFaceColor', 'g'); % Start
    plot(0, 0, 'rp', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % Target
    title(['Trajectory (X-Y) - Robot ' num2str(rb.ID)]);
    xlabel('X (m)'); ylabel('Y (m)');

    % Subplot 2: Velocities (Vx and Vy) vs Time
    subplot(3, 1, 2);
    plot(rb.timeHistory, rb.velHistory(:,1), 'r', 'LineWidth', 1.5);
    hold on; grid on;
    plot(rb.timeHistory, rb.velHistory(:,2), 'b', 'LineWidth', 1.5);
    title('Velocity Components vs Time');
    xlabel('Time (s)'); ylabel('Velocity (m/s)');
    legend('V_x', 'V_y');

    % Subplot 3: Lateral Acceleration vs Time
    subplot(3, 1, 3);
    plot(rb.timeHistory, rb.accelHistory, 'k', 'LineWidth', 1.5);
    grid on;
    title('Lateral Acceleration (a) vs Time');
    xlabel('Time (s)'); ylabel('Acceleration (m/s^2)');
end
end