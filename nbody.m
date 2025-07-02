{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 clear; clc; close all;\
\
\
G = 6.674e-11;      % Gravitational constant\
dt = 3600 * 24;     % Time step: 1 day in seconds\
AU = 1.496e11;      % Astronomical Unit in meters\
\
num_steps = 365 * 2;\
\
% SUN\
bodies(1).mass = 1.989e30;\
bodies(1).pos = [0, 0];         % Position [x, y] in meters\
bodies(1).vel = [0, 0];         % Velocity [vx, vy] in m/s\
bodies(1).acc = [0, 0];\
bodies(1).color = 'y';          % Plotting color\
bodies(1).size = 30;            % Plotting size\
\
% EARTH\
bodies(2).mass = 5.972e24;\
bodies(2).pos = [-1 * AU, 0];\
bodies(2).vel = [0, 29780.0];\
bodies(2).acc = [0, 0];\
bodies(2).color = 'b';\
bodies(2).size = 15;\
\
% MARS\
bodies(3).mass = 6.39e23;\
bodies(3).pos = [-1.524 * AU, 0];\
bodies(3).vel = [0, 24070.0];\
bodies(3).acc = [0, 0];\
bodies(3).color = 'r';\
bodies(3).size = 12;\
\
figure; \
hold on;\
set(gca, 'Color', 'k'); \
\
path_history = nan(num_steps, numel(bodies), 2);\
\
for t = 1:num_steps\
    \
    % 1. Calculate forces for each body\
    for i = 1:numel(bodies)\
        bodies(i).acc = [0, 0]; % Reset acceleration for this time step\
        for j = 1:numel(bodies)\
            if i == j\
                continue;\
            end\
            \
            % Calculate distance vector and magnitude\
            r_vec = bodies(j).pos - bodies(i).pos;\
            r_mag = norm(r_vec);\
            if r_mag < 1e6 % Avoid division by zero\
                r_mag = 1e6;\
            end\
            \
            % Calculate force and acceleration\
            F_mag = (G * bodies(i).mass * bodies(j).mass) / (r_mag^2);\
            force_vec = F_mag * (r_vec / r_mag); % Force is a vector\
            bodies(i).acc = bodies(i).acc + force_vec / bodies(i).mass;\
        end\
    end\
    \
    % 2. Update velocity and position for each body\
    for i = 1:numel(bodies)\
        bodies(i).vel = bodies(i).vel + bodies(i).acc * dt;\
        bodies(i).pos = bodies(i).pos + bodies(i).vel * dt;\
        \
        % Store the current position for the trail\
        path_history(t, i, :) = bodies(i).pos;\
    end\
    \
    clf; % Clear the current figure to redraw\
    hold on;\
    set(gca, 'Color', 'k');\
    \
    % Plot the trails\
    for i = 1:numel(bodies)\
        plot(path_history(:, i, 1), path_history(:, i, 2), 'Color', bodies(i).color, 'LineWidth', 1);\
    end\
    \
    % Plot the current position of the bodies\
    for i = 1:numel(bodies)\
        plot(bodies(i).pos(1), bodies(i).pos(2), 'o', ...\
            'MarkerFaceColor', bodies(i).color, ...\
            'MarkerEdgeColor', 'w', ...\
            'MarkerSize', bodies(i).size);\
    end\
    \
    axis equal; % Ensures orbits are circles, not ovals\
    axis([-2*AU, 2*AU, -2*AU, 2*AU]); % Set the viewing window\
    title(sprintf('N-Body Simulation | Day: %d', t));\
    xlabel('x (meters)');\
    ylabel('y (meters)');\
    grid on;\
    \
    drawnow;\
end}