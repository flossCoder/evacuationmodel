% cleanAndSetUP.m
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

% cleanAndSetUP cleans workspace, ... and sets the directories, where the
% code can be found

%% clean up
clear; % clears the workspace
close all; % closes all open figures
clc; % clears the command window

%% set the directories and adds all code directories to the path
% directories for plotting and text output
plots_and_saves = [pwd, '/plots_and_saves/']; % contains all output plots
testOutput = [plots_and_saves, 'test-plots_and_saves/']; % just for tests

% path of matlab code
initDir = [pwd, '/init']; % contains the init function
addpath(initDir);

output = [pwd, '/output']; % contains the output functions
addpath(output);

simulation = [pwd, '/simulation']; % contains the simulation
addpath(simulation);

tests = [pwd, '/tests']; % contains all tests
addpath(tests);
