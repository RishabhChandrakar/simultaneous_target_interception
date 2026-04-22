% GLOBAL VARIABLE DECLARATIONS

global targetPos currentGraph currentPhase 
global simulation_case addedRobotData robotAdded lastLeaderID
global phase_durations_case1 phase_durations_case2 
global phase_durations_case3 phase_durations_case4


% Set which case you want to run (1, 2, 3, or 4)
simulation_case = 4; 

% GENERAL SIMULATION CONSTANTS

n_robots = 5;               % Initial number of robots
targetPos = [0, 0];         % Interception point (Origin)
%dt = 0.01;                  % Time step (smaller is better for high speeds)
sim_steps = 5000;           % Max iterations
bounds = [-500 500 -500 500]; % Plot limits

% INITIAL CONDITIONS (PURSUERS P1 - P5)

% Positions [x, y] in meters
initial_positions = [ 81, -101; 
    -159,   61; 
    -79,  301; 
    -104,   31; 
    109,   31];

% Speeds Vi in m/s
initial_speeds = [92, 73.6, 80.5, 46, 69];

% Lead Angles theta_i (Converted to Radians)
initial_thetas = deg2rad([60, 72, -12, 120, 72]);


% TOPOLOGY SWITCHING DURATIONS (SECONDS)

% Case 1: Static/Single Phase
phase_durations_case1 = 6.0;

% Case 2: Sequence of 7 Topologies
phase_durations_case2 = [0.5, 1.2, 0.2, 0.7, 0.7, 0.5, 10.0];

% Case 3: Sequence of 7 Topologies
phase_durations_case3 = [0.3, 0.8, 0.2, 0.6, 0.3, 0.3, 10.0];

% Case 4: Node Addition (Phase 0: n=5, Phase 1: n=6)
phase_durations_case4 = [1.0, 100.0]; 


% CASE 4: DYNAMIC ROBOT DATA (ROBOT 6)

addedRobotData.id = 6;
addedRobotData.pos = [100, 150];
addedRobotData.speed = 30;
addedRobotData.theta = deg2rad(55);

% RUNTIME FLAGS & HANDLES (INITIALIZATION)

robotAdded = false;     % Flag for Case 4
lastLeaderID = [];      % Used for leader hysteresis
currentPhase = 0;       % Tracking the switching phase