global targetPos currentGraph phase_durations_case2 phase_durations_case3

n_robots = 5;
targetPos = [0, 0]; % Interception at origin


% Define the sequence of durations (in seconds)
% Phase 0 lasts 2.5s, Phase 1 lasts 1.0s, Phase 2 lasts 4.0s

phase_durations_case2 = [0.5, 1.2, 0.2, 0.7, 0.7, 0.5, 10];

phase_durations_case3 = [0.3, 0.8, 0.2, 0.6, 0.3, 0.3, 10];



% Coordinates based on your specific input
initial_positions = [ 81, -101; -159, 61; -79, 301; -104, 31; 109, 31];
initial_speeds = [92, 73.6, 80.5, 46, 69];
initial_thetas = deg2rad([60, 72, -12, 120, 72]);

%dt_fixed = 0.01; % Use this for logic if real-time dt is too small
sim_steps = 3000;

% Correct axis to see everything: [minX-50 maxX+50 minY-50 maxY+50]
% Based on your numbers: [-210 160 -150 350]
bounds = [-500 500 -500 500];