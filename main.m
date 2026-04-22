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
lastPhase = -1; 
lastLeaderID = []; % Initialize hysteresis variable
robotAdded = false; 
dt=0.02
tic; 

try
    for s = 1:sim_steps
        % A. Window Check: Exit if user closes the figure
        if ~ishandle(fig)
            disp('Animation window closed by user. Finalizing...');
            break; 
        end

        % B. Update Simulation Time
        currentTime = s * dt;

        % C. CASE 4: DYNAMIC NODE ADDITION (Check before logic/topology)
        global simulation_case addedRobotData
        if simulation_case == 4 && currentTime >= 1.0 && ~robotAdded
            newBot = Robot(addedRobotData.id, addedRobotData.pos, ...
                           addedRobotData.speed, addedRobotData.theta);
            
            newNodeTable = table(newBot, 'VariableNames', {'Obj'});
            currentGraph = addnode(currentGraph, newNodeTable);
            
            n_robots = numnodes(currentGraph); % Update count
            robotAdded = true;
            
            % Force a plot reset to include the new node visually
            if ishandle(hPlot), delete(hPlot); end
            hPlot = plot(currentGraph, 'XData', zeros(n_robots,1), 'YData', zeros(n_robots,1));
            axis(bounds); hold on;
            fprintf('Time %.2fs: Robot 6 joined the network.n', currentTime);
        end

        % D. TOPOLOGY UPDATE
        % We update the graph structure BEFORE logic so robots see new neighbors
        newEdges = getTopology(currentTime, n_robots);
        currentGraph = digraph(newEdges(:,1), newEdges(:,2), [], currentGraph.Nodes);

        % E. LOGIC & PHYSICS UPDATE
        for i = 1:numnodes(currentGraph)
            currentGraph.Nodes.Obj(i).updateLogic();
        end
        for i = 1:numnodes(currentGraph)
            currentGraph.Nodes.Obj(i).updateStates(dt, currentTime);
        end

        % F. STABLE LEADER IDENTIFICATION (Hysteresis Logic)
        all_t = [currentGraph.Nodes.Obj.t_tilde];
        [absoluteMaxT, potentialLeaderID] = max(all_t);
        epsilon = 0.05; 

        if isempty(lastLeaderID)
            leaderID = potentialLeaderID;
        else
            if (absoluteMaxT - all_t(lastLeaderID)) > epsilon
                leaderID = potentialLeaderID;
            else
                leaderID = lastLeaderID;
            end
        end
        lastLeaderID = leaderID;

        % G. REACHABILITY CHECK
        D = distances(currentGraph);
        isGloballyReachable = all(D(:, leaderID) < Inf);
        
        if isGloballyReachable
            reachStr = 'YES'; reachCol = [0 0.6 0]; 
        else
            reachStr = 'NO'; reachCol = [0.8 0 0];
        end

        % H. ANIMATION & FIREWALL
        allPos = vertcat(currentGraph.Nodes.Obj.pos);
        if ~all(isfinite(allPos(:)))
            allPos(~isfinite(allPos)) = 0; 
        end

        % Redraw arrows if Phase changed, otherwise just move nodes
        global currentPhase
        if currentPhase ~= lastPhase
            if ishandle(hPlot), delete(hPlot); end 
            hPlot = plot(currentGraph, 'XData', allPos(:,1), 'YData', allPos(:,2), ...
                'MarkerSize', 10, 'LineWidth', 1.5, 'EdgeColor', [0.4 0.4 0.4]);
            lastPhase = currentPhase;
        else
            hPlot.XData = allPos(:,1);
            hPlot.YData = allPos(:,2);
        end

        % Highlight Leader and Update Dynamic Title
        highlight(hPlot, leaderID, 'NodeColor', reachCol, 'MarkerSize', 12);
        title(sprintf('Time: %.2fs | Leader: P%d (%.2fs) | Reachable: %s | Phase: %d', ...
              currentTime, leaderID, all_t(leaderID), reachStr, currentPhase), 'Color', reachCol);

        % Leave path trail
        plot(allPos(:,1), allPos(:,2), 'k.', 'MarkerSize', 1);

        % I. EXIT CONDITION
        if all([currentGraph.Nodes.Obj.isCaptured])
            fprintf('\n[SUCCESS] Interception complete at %.2fs\n', currentTime);
            break; 
        end

        drawnow; % Use 'drawnow limitrate' for faster performance if needed
    end

catch ME
    fprintf('\nSimulation stopped. Message: %s\n', ME.message);
end

% FINAL ACTION
disp('Generating final analysis plots...');
showResults(currentGraph);