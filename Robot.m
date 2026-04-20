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
        end
        
        function updateLogic(obj)
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
                
                if obj.t_tilde >= max_neighbor_t
                    obj.a = obj.a_ideal;
                else
                    obj.a = 0;
                end
            end
        end
        
        % Final State Update (Physics and Geometry)
        function updateStates(obj, dt)
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
            obj.theta = lambda - obj.gamma;
        end
    end
end