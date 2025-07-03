classdef NBodySystem < handle
    properties
        Bodies          % Cell array of Body objects
        G               (1,1) double {mustBeReal} = 6.674e-11 % Gravitational constant
        IntegratorType  (1,:) char {mustBeMember(IntegratorType,{'euler','verlet','rk4'})} = 'verlet'
        SofteningFactor (1,1) double {mustBeNonnegative} = 1e9 % Prevents singularities
    end

    properties (Access = private)
        NumBodies       (1,1) double
        History         % Stores position history for plotting trails
        PlotHandle      % Handle for the main plot axis
    end

    methods
        function obj = NBodySystem(bodies, varargin)
            % NBodySystem Construct an instance of the system.
            p = inputParser;
            addRequired(p, 'bodies', @(x) iscell(x) && all(cellfun(@(b) isa(b, 'Body'), x)));
            addParameter(p, 'G', 6.674e-11, @isnumeric);
            addParameter(p, 'integrator', 'verlet', @(x) ismember(x, {'euler', 'verlet', 'rk4'}));
            parse(p, bodies, varargin{:});

            obj.Bodies = p.Results.bodies;
            obj.G = p.Results.G;
            obj.IntegratorType = p.Results.integrator;
            obj.NumBodies = numel(obj.Bodies);
        end

        function run_simulation(obj, time_step, num_steps, plot_interval)
            % run_simulation Executes the main simulation loop.
            %   time_step: Duration of each step in seconds.
            %   num_steps: Total number of steps to simulate.
            %   plot_interval: Update the plot every N steps.

            obj.History = nan(num_steps, obj.NumBodies, 2);
            obj.setup_plot();

            % Initial force calculation is required for Verlet and others
            obj.compute_accelerations_vectorized();

            for t = 1:num_steps
                obj.step_simulation(time_step);
                
                % Store current positions for plotting orbital trails
                for i = 1:obj.NumBodies
                    obj.History(t, i, :) = obj.Bodies{i}.Position;
                end

                if mod(t, plot_interval) == 0 || t == 1
                    obj.update_plot(t, time_step);
                end
            end
        end
    end

    methods (Access = private)
        function step_simulation(obj, dt)
            % Selects and executes one step of the chosen integrator.
            switch obj.IntegratorType
                case 'euler'
                    obj.step_euler(dt);
                case 'verlet'
                    obj.step_verlet(dt);
                case 'rk4'
                    obj.step_rk4(dt);
            end
        end

        function acc = calculate_accel_at_pos(obj, pos_matrix)
            % Core vectorized calculation. Calculates acceleration for any given position matrix.
            n = obj.NumBodies;
            masses = cellfun(@(b) b.Mass, obj.Bodies)'; % Column vector

            % Calculate pairwise separation vectors using broadcasting
            dx = pos_matrix(:,1).' - pos_matrix(:,1);
            dy = pos_matrix(:,2).' - pos_matrix(:,2);
            
            dist_sq = dx.^2 + dy.^2 + obj.SofteningFactor^2;
            inv_dist_cubed = dist_sq.^(-1.5);
            inv_dist_cubed(1:n+1:end) = 0; % No self-gravity
            
            % Sum forces via matrix multiplication: G * sum(m_j * r_ij / |r_ij|^3)
            ax = obj.G * (dx .* inv_dist_cubed) * masses;
            ay = obj.G * (dy .* inv_dist_cubed) * masses;
            
            acc = [ax, ay];
        end

        function compute_accelerations_vectorized(obj)
            % Updates the acceleration property of each body based on the current state.
            current_pos = vertcat(obj.Bodies{:}.Position);
            acc = obj.calculate_accel_at_pos(current_pos);
            
            for i = 1:obj.NumBodies
                obj.Bodies{i}.Acceleration = acc(i,:);
            end
        end

        function step_euler(obj, dt)
            % Implements the first-order Euler-Cromer method.
            % Note: Prone to energy drift, not recommended for accuracy.
            for i = 1:obj.NumBodies
                b = obj.Bodies{i};
                b.Velocity = b.Velocity + b.Acceleration * dt;
                b.Position = b.Position + b.Velocity * dt;
            end
            obj.compute_accelerations_vectorized();
        end

        function step_verlet(obj, dt)
            % Implements the second-order Velocity Verlet integrator.
            pos_old = vertcat(obj.Bodies{:}.Position);
            vel_old = vertcat(obj.Bodies{:}.Velocity);
            acc_old = vertcat(obj.Bodies{:}.Acceleration);
            
            pos_new = pos_old + vel_old.*dt + 0.5.*acc_old.*dt^2;
            acc_new = obj.calculate_accel_at_pos(pos_new);
            vel_new = vel_old + 0.5.*(acc_old + acc_new).*dt;
            
            % Assign new state back to the body objects
            for i = 1:obj.NumBodies
                obj.Bodies{i}.Position = pos_new(i,:);
                obj.Bodies{i}.Velocity = vel_new(i,:);
                obj.Bodies{i}.Acceleration = acc_new(i,:);
            end
        end

        function step_rk4(obj, dt)
            % Implements the fourth-order Runge-Kutta method.
            pos_old = vertcat(obj.Bodies{:}.Position);
            vel_old = vertcat(obj.Bodies{:}.Velocity);
            
            k1_v = obj.calculate_accel_at_pos(pos_old);
            k1_p = vel_old;
            
            k2_v = obj.calculate_accel_at_pos(pos_old + 0.5*k1_p*dt);
            k2_p = vel_old + 0.5*k1_v*dt;
            
            k3_v = obj.calculate_accel_at_pos(pos_old + 0.5*k2_p*dt);
            k3_p = vel_old + 0.5*k2_v*dt;
            
            k4_v = obj.calculate_accel_at_pos(pos_old + k3_p*dt);
            k4_p = vel_old + k3_v*dt;
            
            pos_new = pos_old + (dt/6) * (k1_p + 2*k2_p + 2*k3_p + k4_p);
            vel_new = vel_old + (dt/6) * (k1_v + 2*k2_v + 2*k3_v + k4_v);

            for i = 1:obj.NumBodies
                obj.Bodies{i}.Position = pos_new(i,:);
                obj.Bodies{i}.Velocity = vel_new(i,:);
            end
            
            obj.compute_accelerations_vectorized();
        end
        
        function setup_plot(obj)
            % Initializes the figure and axis for plotting.
            figure('Name', 'N-Body Simulation', 'NumberTitle', 'off');
            hold on;
            obj.PlotHandle = gca;
            set(obj.PlotHandle, 'Color', 'k');
            axis equal;
            grid on;
            
            % Determine a reasonable axis limit based on initial positions
            max_initial_dist = max(vecnorm(vertcat(obj.Bodies{:}).Position, 2, 2));
            axis_limit = max_initial_dist * 1.5;
            axis(obj.PlotHandle, [-axis_limit, axis_limit, -axis_limit, axis_limit]);
            
            xlabel(obj.PlotHandle, 'x (meters)');
            ylabel(obj.PlotHandle, 'y (meters)');
        end
        
        function update_plot(obj, time_idx, dt)
            % Redraws the plot with the current system state.
            cla(obj.PlotHandle);
            
            % Plot orbital trails
            for i = 1:obj.NumBodies
                plot(obj.PlotHandle, ...
                     squeeze(obj.History(1:time_idx, i, 1)), ...
                     squeeze(obj.History(1:time_idx, i, 2)), ...
                     'Color', obj.Bodies{i}.Color, 'LineWidth', 1);
            end
            
            % Plot current body positions
            for i = 1:obj.NumBodies
                b = obj.Bodies{i};
                plot(obj.PlotHandle, b.Position(1), b.Position(2), 'o', ...
                    'MarkerFaceColor', b.Color, ...
                    'MarkerEdgeColor', 'w', ...
                    'MarkerSize', b.Size);
            end
            
            title(obj.PlotHandle, sprintf('N-Body Sim | Day: %.1f | Integrator: %s', ...
                  time_idx * dt / (3600*24), obj.IntegratorType));
            drawnow;
        end
    end
end