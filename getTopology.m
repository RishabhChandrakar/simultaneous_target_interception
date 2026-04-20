function edges = getTopology(t_curr, n)
    global phase_durations
    l = 4;
    
    % Find current phase index
    limits = cumsum(phase_durations);
    phase = find(t_curr < limits, 1) - 1; % find(x, 1) it will give me only the first index where x is True.
    
    % If time exceeds all limits, default to the last phase
    if isempty(phase), phase = length(phase_durations) - 1; end
    
    % Define topologies in a cell array for ultra-clean code
    % Row 1: Source nodes, Row 2: Target nodes
    topologies = {
        [1, 2, 3, 5; 4, 4, 4, 4], ... % Phase 0: Star
        [1, 2, 3, 5; 2, 3, 5, 4], ... % Phase 1: Chain
        [1, 2, 3, 5; 2, 4, 5, 4]      % Phase 2: Branches
        };
    
    selected = topologies{phase + 1};
    s = selected(1,:);
    t = selected(2,:);
    
    edges = [s', t'];
end