% evacuationmodel.m
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

%
% The program simulates the evacuation of a field with walls, exits and
% agents. Different movement algorithm (random, direct and panic) can be
% choosen. The time series of each simulation will be saved as csv. All
% plots (field and the number of agents per time) are saved as png. All
% files are saved in the folder plots_and_saves.

%% clean workspace, ... and set directories
cleanAndSetUP;

%% set default parameters
showSingleStep = true; % for showing single steps during simulation,...
                       % true: show, false: show not
numRows = 20;
numCols = 30;
numInnerWalls = 25;
numExits = 1;
numAgents = 25;
field = initTested(numRows, numCols, numInnerWalls, numExits, numAgents);
plotField(field, 'initial field', plots_and_saves, 'initial');


%% default program
figure();
random = simulate(field, showSingleStep, 'random simulation',...
                  plots_and_saves, 'random', 0);

%% direct program
direct = simulate(field, showSingleStep, 'direct simulation',...
                  plots_and_saves, 'direct', 1);

%% panic program
panic = simulate(field, showSingleStep, 'panic simulation',...
                 plots_and_saves, 'panic', 2);

%% compare plots
plotTimeSeries('compare random-, direct- and panic simulation',...
               random(:, 2), direct(:, 2), panic(:, 2));
legend('random', 'direct', 'panic');
print([plots_and_saves, '/', 'compare', '_time-series'],'-dpng');
