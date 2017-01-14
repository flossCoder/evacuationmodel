% plotTimeSeries.m
% Copyright (C) flossCoder 2015
%
% This file is part of evacuationmodel.
%
% evacuationmodel is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% evacuationmodel is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along
% with this program.  If not, see <http://www.gnu.org/licenses/>.

% plotTimeSeries plots the agents per time as a semilog plot
%
% usage: plotTimeSeries(theTitle, numberOfAgentsPerTime,...
%        [numberOfAgentsPerTime])
%
% param theTitle: the title of the plot
% param varargin: contains the data (number of agents, not the time)
%                 for each series
%
% error: if the number of input arguments is < 2
function plotTimeSeries(theTitle, varargin)
    assert(nargin >= 2, 'not enough input arguments');
    
    figure(); % open a new figure
    symbols = {'*b', '+r', 'og'};
    for k = 1:1:numel(varargin)
        semilogx(varargin{k}, symbols{k});
        hold on;
    end
    hold off;
    title(theTitle);
    xlabel('simulation steps');
    ylabel('number of agents');
end
