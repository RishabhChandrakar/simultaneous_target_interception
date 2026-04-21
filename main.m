clear; clc; close all;
params; 

% 1. Create RobotscurrentPhase
robots = Robot.empty(n_robots, 0);
for i = 1:n_robots
    robots(i) = Robot(i, initial_positions(i,:), initial_speeds(i), initial_thetas(i));
end

% 2. Initialize Graph Table
currentGraph = digraph();
nodeTable = table(robots', 'VariableNames', {'Obj'});
currentGraph = addnode(currentGraph, nodeTable);

% 3. Setup Static Topology
staticEdges = getTopology(0, n_robots);          % (currentTime, no. of robots)  
currentGraph = digraph(staticEdges(:,1), staticEdges(:,2), [], currentGraph.Nodes);

% --- Step 4: Visualization Setup ---
% YOU MUST ASSIGN THE FIGURE TO THE VARIABLE 'fig'
fig = figure('Color', 'w', 'Name', 'Robot Simulation'); 
hold on; grid on;

% Plot the target star
plot(targetPos(1), targetPos(2), 'rp', 'MarkerSize', 15, 'MarkerFaceColor', 'r');

% Initialize the plot handle (hPlot)
hPlot = plot(currentGraph, 'XData', initial_positions(:,1), 'YData', initial_positions(:,2), ...
    'NodeColor', 'b', 'MarkerSize', 8);

axis(bounds); % Ensure you are using the axis limits from params.m
xlabel('x'); ylabel('y');
title('Initialization...');

% --- 5. Initialization before Loop ---
currentTime = 0;
lastPhase = -1; % Important for the first topology check
dt = 0.02;      % Consistent time step
tic;            % Start timer

try
    for s = 1:sim_steps
        % A. Check if the user closed the figure window
        if ~ishandle(fig)
            disp('Animation window closed by user. Finalizing...');
            break; 
        end

        currentTime = s * dt;

        % 1. Determine Topology & Update Graph
        % (Assuming getTopology updates the global currentPhase internally)
        newEdges = getTopology(currentTime, n_robots);
        currentGraph = digraph(newEdges(:,1), newEdges(:,2), [], currentGraph.Nodes);

        % --- Step A: Logic Update ---
        for i = 1:n_robots
            currentGraph.Nodes.Obj(i).updateLogic();
        end

        % --- Step B: State Update ---
        for i = 1:n_robots
            currentGraph.Nodes.Obj(i).updateStates(dt, currentTime);
        end

        % --- Step C: Animation Update ---
        allPos = vertcat(currentGraph.Nodes.Obj.pos);

        % THE FIREWALL: Handle non-finite math errors
        if ~all(isfinite(allPos(:)))
            allPos(~isfinite(allPos)) = 0; 
        end

        % 2. Update Graph Plot ONLY if the topology switched
        % We check the global currentPhase set inside getTopology
        global currentPhase
        if currentPhase ~= lastPhase
            % Remove old plot and redraw to show new arrows
            if ishandle(hPlot), delete(hPlot); end 

            hPlot = plot(currentGraph, 'XData', allPos(:,1), 'YData', allPos(:,2), ...
                'MarkerSize', 10, 'LineWidth', 1.5, 'NodeColor', 'b', 'EdgeColor', [0.4 0.4 0.4]);

            title(['Time: ' num2str(currentTime, '%.2f') 's | Phase: ' num2str(currentPhase)]);
            lastPhase = currentPhase;

            % Debugging output as you requested
            fprintf('Switching to Phase %d at Time %.2fs\n', currentPhase, currentTime);
        else
            % Just update positions for smooth movement
            hPlot.XData = allPos(:,1);
            hPlot.YData = allPos(:,2);
        end

        % 3. Leave a breadcrumb trail
        plot(allPos(:,1), allPos(:,2), 'k.', 'MarkerSize', 1);

        % --- Step D: Exit Condition ---
        if all([currentGraph.Nodes.Obj.isCaptured])
            fprintf('\n[SUCCESS] All robots intercepted target at %.2fs\n', currentTime);
            break; 
        end

        % Force refresh
        %drawnow limitrate;
        drawnow;
    end

catch ME
    % If Ctrl+C is pressed or a code error occurs
    fprintf('\nSimulation stopped. Message: %s\n', ME.message);
end

% =====================================================
% FINAL ACTION: ALWAYS SHOW RESULTS
% =====================================================
disp('Generating final analysis plots...');
showResults(currentGraph);