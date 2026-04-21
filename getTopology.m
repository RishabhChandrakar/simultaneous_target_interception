function edges = getTopology(t_curr, n)
    global phase_durations_case2   currentPhase phase_durations_case3 
    l = 4;
    
    % Find current phase index
    limits = cumsum(phase_durations_case3);
    currentPhase = find(t_curr < limits, 1) - 1; % find(x, 1) it will give me only the first index where x is True.
    
    % If time exceeds all limits, default to the last phase
    if isempty(currentPhase) 
        currentPhase = length(phase_durations_case3) - 1; 
    end
    
    % Define topologies in a cell array for ultra-clean code
    % Row 1: Source nodes, Row 2: Target nodes

    topologies_case2 = {    % in case 2 within the globally not reachable zone graph is static 
        [1, 2, 3, 4, 5, 5; 4, 4, 5, 5, 1, 4],
        [1, 2; 4, 4],
        [1, 1, 2, 2, 3, 3, 4, 4, 5; 4, 3, 4, 1, 2, 4, 1, 5, 2], 
        [5, 5; 1, 4],
        [1, 2, 3, 3, 4, 5, 5; 4, 5, 5, 4, 5, 3, 4],
        [1, 3, 5; 3, 2, 1],
        [1, 2, 3, 3, 4, 4, 5; 3, 4, 2, 4, 3, 5, 4]
        };

    topologies_case3 = {   % case3 is about multiple switches within globally not reachable zone 
        [1, 2, 3, 3, 4, 5; 4, 4, 5, 4, 5, 4],
        [2, 3; 5, 5],
        [2, 3; 3, 4], 
        [1, 4; 2, 5],
        [1, 1, 2, 2, 3, 3, 3, 3, 4, 5; 4, 5, 3, 4, 1, 2, 4, 5, 3, 4],
        [2, 5; 3, 3],
        [1, 1, 2, 3, 4, 4, 5, 5; 3, 4, 3, 4, 2, 3, 2, 3]
        };

    
    selected = topologies_case3{currentPhase + 1};
    s = selected(1,:);
    t = selected(2,:);
    
    edges = [s', t'];
end