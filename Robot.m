classdef Robot < handle
    properties
        ID
        pos              % [px, py]
        v                % Constant speed
        vel              % [vx, vy]
        gamma            % Heading angle
        theta            % Lead angle
        a = 0            % Actual lateral acceleration
        a_ideal = 0      % Ideal lateral acceleration (a')
        t_tilde = 0      % Estimated time of interception
        distToTarget = 0 % Distance to target
        isCaptured = false;

        % --- History Storage ---
        timeHistory = []
        posHistory = []   % Will store [x, y]
        tTildeHistory = [] % Add this
        %velHistory = []   % Will store [vx, vy]
        %accelHistory = [] % Will store lateral acceleration 'a'

    end
    
    methods
        function obj = Robot(id, p0, v0, theta0)
            global targetPos
            obj.ID = id;
            obj.pos = p0;
            obj.v = v0;
            obj.theta = theta0;
            
            % Initial distance and LOS angle
            los_vec = targetPos - obj.pos;
            obj.distToTarget = norm(los_vec);
            lambda = atan2(los_vec(2), los_vec(1));
            
            % Heading: gamma = lambda - theta
            obj.gamma = lambda - theta0;
            obj.vel = [cos(obj.gamma), sin(obj.gamma)] * obj.v;

            %isCaptured
            isCaptured = false;

            % Initialize history with the starting position
            obj.posHistory = p0;
        end
        
        function updateLogic(obj)

            if obj.isCaptured
                return; % Do nothing if the robot has arrived
            end

            % Sequence: Ideal Accel -> Time of Interception -> Lateral Accel
            obj.updateIdealAccel();
            obj.updateTimeOfInterception();
            obj.updateLateralAccel();
        end
        
        % 1. Calculate Ideal Lateral Acceleration (a')
        function updateIdealAccel(obj)
            % Formula: (2 * v^2 * sin(theta)) / distance
            % Avoid division by zero if robot reaches target
            if obj.distToTarget > 0.1
                obj.a_ideal = (2 * obj.v^2 * sin(obj.theta)) / obj.distToTarget;
            else
                obj.a_ideal = 0;
            end

            obj.a_ideal = max(min(obj.a_ideal, 1000), -1000);
        end
        
        % 2. Calculate Estimated Time of Interception (t_tilde)
        function updateTimeOfInterception(obj)
            % Formula: (dist * theta) / (v * sin(theta))
            denom = obj.v * sin(obj.theta);
            if abs(denom) > 1e-4
                obj.t_tilde = (obj.distToTarget * obj.theta) / denom;
            else
                % Limit case where theta is very small (L'Hopital's rule)
                obj.t_tilde = obj.distToTarget / obj.v;
            end
        end
        
        % 3. Calculate Actual Lateral Acceleration (a)
        function updateLateralAccel(obj)
            global currentGraph
            % Get objects of out-neighbors
            neighborIDs = successors(currentGraph, obj.ID);
            
            if isempty(neighborIDs)
                % If no neighbors, default to its own ideal acceleration
                obj.a = obj.a_ideal;
            else
                % Extract t_tilde from all out-neighbors
                neighborObjects = currentGraph.Nodes.Obj(neighborIDs);
                neighbor_t_tildes = [neighborObjects.t_tilde];
                
                % Logic: a = a' IF my t_tilde is the maximum in my neighborhood
                max_neighbor_t = max(neighbor_t_tildes);
                

                % to prevent the zig zag behaviour of t_tilde among robots 

                % If my time is within 0.1s of the leader, I have reached consensus.
                % I should now just follow my curve (a_ideal) to the target.
                if obj.t_tilde >= (max_neighbor_t - 0.1)
                    obj.a = obj.a_ideal;
                else
                    obj.a = 0; % Still waiting
                end

            end
        end
        
        % Final State Update (Physics and Geometry)
        function updateStates(obj, dt, currentTime)

            global targetPos

            % 1. If already captured, don't move or calculate anything
            if obj.isCaptured
                return; 
            end

            % 2. CHECK CAPTURE CONDITION
            % Since robots are fast (92m/s), we use a threshold of 2.0 meters
            if obj.distToTarget < 3
                obj.isCaptured = true;
                obj.v = 0;           % Set speed to 0
                obj.vel = [0, 0];    % Set velocity vector to 0
                obj.a = 0;           % Set acceleration to 0
                obj.a_ideal = 0;
                obj.t_tilde = 0;     % Time remaining is now 0

                obj.pos = targetPos; % Snap to target [0,0]
                obj.posHistory(end+1, :) = targetPos; % Record final point

                obj.timeHistory(end+1) = currentTime;
                obj.tTildeHistory(end+1) = obj.t_tilde;


            end


            global targetPos
            
            % 1. Update Heading (gamma_dot = a/v)
            obj.gamma = obj.gamma + (obj.a / obj.v) * dt;
            
            % 2. Update Position (x_dot = v*cos(gamma))
            obj.vel = [cos(obj.gamma), sin(obj.gamma)] * obj.v;
            obj.pos = obj.pos + obj.vel * dt;
            
            % 3. Update Distance to Target
            los_vec = targetPos - obj.pos;
            obj.distToTarget = norm(los_vec);
            
            % 4. Update Theta (theta = lambda - gamma)
            lambda = atan2(los_vec(2), los_vec(1));
            %obj.theta = lambda - obj.gamma;

            % 3. Calculate Theta (Lead angle)
            % We subtract gamma from lambda, THEN wrap to ensure result is in (-pi, pi)
            obj.theta = atan2(sin(lambda - obj.gamma), cos(lambda - obj.gamma));

            % 4. Enforce the non-zero constraint \ {0}
            if abs(obj.theta) < 1e-6
                obj.theta = 1e-6 * sign(obj.theta + eps); 
            end

            % --- ADD THIS LINE TO RECORD HISTORY ---
            obj.posHistory(end+1, :) = obj.pos;
            obj.timeHistory(end+1) = currentTime;
            obj.tTildeHistory(end+1) = obj.t_tilde;

            

            % --- Record History ---
            %
            %obj.posHistory(end+1, :) = obj.pos;
            %obj.velHistory(end+1, :) = obj.vel;
            %obj.accelHistory(end+1) = obj.a;
            
        end
    end
end