clear; clc; close all;
params; 

% 1. Create Robots
robots = Robot.empty(n_robots, 0);
for i = 1:n_robots
    robots(i) = Robot(i, initial_positions(i,:), initial_speeds(i), initial_thetas(i));
end

% 2. Initialize Graph Table
currentGraph = digraph();
nodeTable = table(robots', 'VariableNames', {'Obj'});
currentGraph = addnode(currentGraph, nodeTable);

% 3. Setup Static Topology
staticEdges = getTopology(0, n_robots);
currentGraph = digraph(staticEdges(:,1), staticEdges(:,2), [], currentGraph.Nodes);

% 4. Visualization Setup
figure('Color', 'w', 'Name', 'Robot Interception Simulation');
hold on; grid on;

% Plot the target
plot(targetPos(1), targetPos(2), 'rp', 'MarkerSize', 15, 'MarkerFaceColor', 'r');

% Initialize the Graph Plot
hPlot = plot(currentGraph, 'XData', initial_positions(:,1), 'YData', initial_positions(:,2), ...
    'LineWidth', 1.5, 'NodeFontSize', 10, 'MarkerSize', 7);

axis(bounds); % Use the bounds from params
xlabel('X Position (m)'); ylabel('Y Position (m)');
title('Coordinated Interception: Real-Time Animation');

% --- 5. Simulation Loop ---
tic; 
for s = 1:sim_steps
    % Calculate dynamic dt
    dt = toc; 
    tic; 

    % Safety: Prevent math errors if dt is weird
    if dt < 0.001 || dt > 0.1, dt = 0.01; end

    % --- Step A: Logic Update ---
    for i = 1:n_robots
        currentGraph.Nodes.Obj(i).updateLogic();
    end

    % --- Step B: State Update ---
    for i = 1:n_robots
        currentGraph.Nodes.Obj(i).updateStates(dt);
    end

    % --- Step C: Animation Update ---
    % 1. Extract all positions into an Nx2 matrix
    allPos = vertcat(currentGraph.Nodes.Obj.pos);

    % 2. Update ONLY the X and Y data. 
    % The arrows will follow the nodes automatically!
    hPlot.XData = allPos(:,1);
    hPlot.YData = allPos(:,2);

    % 3. Leave a breadcrumb trail (Optional)
    plot(allPos(:,1), allPos(:,2), 'k.', 'MarkerSize', 1);

    % Check if simulation should end
    if all([currentGraph.Nodes.Obj.distToTarget] < 1.5)
        title('TARGET INTERCEPTED');
        break;
    end

    % Use drawnow to refresh the screen
    drawnow; 
end