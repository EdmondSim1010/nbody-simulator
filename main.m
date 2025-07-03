clear; clc; close all;
addpath(genpath(pwd));

fprintf('Loading scenario: Solar System\n');
scenario = scenarios.solar_system();
time_step = 3600 * 24;      % Time step in seconds (1 day)
num_steps = 365 * 2;        % Number of steps to simulate (2 years)
plot_interval = 2;          % Update plot every 2 steps for performance
integrator_choice = 'verlet'; % 'verlet' is recommended for stability

% % --- SCENARIO 2: Three Body Chaos ---
% fprintf('Loading scenario: Three Body Chaos\n');
% scenario = scenarios.three_body_chaos();
% time_step = 0.005;          % A smaller time step is needed for this unstable system
% num_steps = 5000;           % Total steps
% plot_interval = 20;         % Update plot less frequently
% integrator_choice = 'rk4';  % RK4 is good for high-accuracy on chaotic systems


% Initialize the N-body system.
fprintf('Initializing system with ''%s'' integrator...\n', integrator_choice);
system = NBodySystem(scenario.bodies, ...
                     'G', scenario.G, ...
                     'integrator', integrator_choice);

% ------------------
% --- EXECUTION
% ------------------

% Run the simulation. This will open a figure window and begin the loop.
fprintf('Running simulation for %d steps...\n', num_steps);
system.run_simulation(time_step, num_steps, plot_interval);

fprintf('Simulation complete.\n');
