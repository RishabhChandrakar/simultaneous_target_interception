function edges = getTopology(t_curr, n)
global simulation_case currentPhase 
global phase_durations_case1 phase_durations_case2 phase_durations_case3 phase_durations_case4

% 1. Determine time limits based on the active simulation case
switch simulation_case
    case 1, limits = cumsum(phase_durations_case1);
    case 2, limits = cumsum(phase_durations_case2);
    case 3, limits = cumsum(phase_durations_case3);
    case 4, limits = cumsum(phase_durations_case4);
end

% 2. Calculate currentPhase index
currentPhase = find(t_curr < limits, 1) - 1;
if isempty(currentPhase) 
    currentPhase = length(limits) - 1; 
end

% 3. Define Topologies for all cases
topologies_case1 = {
    [1, 2, 3, 3, 5; 5, 5, 1, 2, 4]  
    };

topologies_case2 = {    
    [1, 2, 3, 4, 5, 5; 4, 4, 5, 5, 1, 4],
    [1, 2; 4, 4],
    [1, 1, 2, 2, 3, 3, 4, 4, 5; 4, 3, 4, 1, 2, 4, 1, 5, 2], 
    [5, 5; 1, 4],
    [1, 2, 3, 3, 4, 5, 5; 4, 5, 5, 4, 5, 3, 4],
    [1, 3, 5; 3, 2, 1],
    [1, 2, 3, 3, 4, 4, 5; 3, 4, 2, 4, 3, 5, 4]
    };

topologies_case3 = {   
    [1, 2, 3, 3, 4, 5; 4, 4, 5, 4, 5, 4],
    [2, 3; 5, 5],
    [2, 3; 3, 4], 
    [1, 4; 2, 5],
    [1, 1, 2, 2, 3, 3, 3, 3, 4, 5; 4, 5, 3, 4, 1, 2, 4, 5, 3, 4],
    [2, 5; 3, 3],
    [1, 1, 2, 3, 4, 4, 5, 5; 3, 4, 3, 4, 2, 3, 2, 3]
    };

% CASE 4: Phase 1 (index 0) is before robot 6 joins, Phase 2 (index 1) is after
topologies_case4 = {
    [1, 2, 3, 3, 5; 5, 5, 1, 2, 4],         % n=5 topology
    [1, 2, 3, 3, 4, 5; 5, 5, 1, 2, 6, 4]    % n=6 topology
    };

% 4. CENTRAL SELECTION LOGIC
if simulation_case == 1
    selected = topologies_case1{currentPhase + 1};
elseif simulation_case == 2
    selected = topologies_case2{currentPhase + 1};
elseif simulation_case == 3
    selected = topologies_case3{currentPhase + 1};
elseif simulation_case == 4
    selected = topologies_case4{currentPhase + 1};
end

% 5. Extract Sources and Targets
s = selected(1,:);
t = selected(2,:);

edges = [s', t'];
end