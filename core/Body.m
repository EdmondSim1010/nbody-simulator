classdef Body < handle

    properties
        Mass        (1,1) double {mustBeReal, mustBeFinite}
        Position    (1,2) double {mustBeReal, mustBeFinite} % [x, y]
        Velocity    (1,2) double {mustBeReal, mustBeFinite} % [vx, vy]
        Acceleration(1,2) double {mustBeReal, mustBeFinite} = [0, 0]
        Color       (1,1) char   = 'w' % Plotting color
        Size        (1,1) double = 10  % Plotting size
    end

    methods
        function obj = Body(varargin)

            p = inputParser;
            addParameter(p, 'Mass', 0, @(x) isnumeric(x) && isscalar(x));
            addParameter(p, 'Position', [0, 0], @(x) isnumeric(x) && isvector(x) && numel(x) == 2);
            addParameter(p, 'Velocity', [0, 0], @(x) isnumeric(x) && isvector(x) && numel(x) == 2);
            addParameter(p, 'Color', 'w', @(x) ischar(x) || isstring(x));
            addParameter(p, 'Size', 10, @(x) isnumeric(x) && isscalar(x));
            parse(p, varargin{:});

            % Assign parsed properties to the object
            obj.Mass = p.Results.Mass;
            obj.Position = p.Results.Position;
            obj.Velocity = p.Results.Velocity;
            obj.Color = p.Results.Color;
            obj.Size = p.Results.Size;
        end
    end
end