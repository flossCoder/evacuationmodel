% test_suite.m
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

% This file is just for testing purpose, all tests should
% work with every new version of code. For this purpose, all outputs (e. g.
% plots and csv data) are written to /plots_and_saves/test-plots_and_saves.
% For the output directory parameter of plotField and simulate, the
% variable testOutput should be used.

%% clean workspace, ... and set directories
cleanAndSetUP

%% run the unit tests
initializing = initTest();
fieldValidator = fieldValidatorTest();
numAgents = numberOfAgentsTest();
step = simulationStepTest();

assert(initializing && fieldValidator && numAgents && step, 'the unit test failed');
disp('all unit tests passed');

%% run the integration test
% set default params
numRows = 20;
numCols = 30;
numInnerWalls = 25;
numExits = 1;
numAgents = 25;

%% initialise field
% default parameter
field_default = initTested(numRows, numCols, numInnerWalls, numExits,...
                numAgents);
plotField(field_default, 'initial field with default parameter',...
          testOutput, 'initial-field');

% 2 * default parameter
figure();
field_double_default = init(2 * numRows, 2 * numCols, 2 * numInnerWalls,...
    2 * numExits, 2 * numAgents);
plotField(field_double_default, 'initial field with double default parameter',...
          testOutput, 'initial-field-double-default-parameter');
      
%% run compulsory program (mode = 0, the random step)
% run default program with default params (do NOT show single steps)
random1 = simulate(field_default, 0, 'compulsory program default parameter',...
          testOutput, 'compulsory-program-default-parameter', 0);

% run default program with 2 * default params (do NOT show single steps)
random2 = simulate(field_double_default, 0, 'compulsory program double default parameter',...
          testOutput, 'compulsory-program-double-default-parameter', 0);

%% run first addition (mode = 1, the direct step)
% run direct program with default params (do NOT show single steps)
direct1 = simulate(field_default, 0, 'first addition default parameter',...
          testOutput, 'first-addition-default-parameter', 1);

% run direct program with 2 * default params (do NOT show single steps)
direct2 = simulate(field_double_default, 0, 'first addition double default parameter',...
          testOutput, 'first-addition-double-default-parameter', 1);

%% run first addition (mode = 2, the panic step)
% run direct program with default params (do NOT show single steps)
panic1 = simulate(field_default, 0, 'second addition default parameter',...
         testOutput, 'first-addition-default-parameter', 2);

% run direct program with 2 * default params (do NOT show single steps)
panic2 = simulate(field_double_default, 0, 'second addition double default parameter',...
         testOutput, 'first-addition-double-default-parameter', 2);

%% compare the three simulations
% default parameter
plotTimeSeries('compare random-, direct- and panic simulation default parameter',...
               random1(:, 2), direct1(:, 2), panic1(:, 2));
legend('random', 'direct', 'panic');
print([testOutput, '/', 'test-compare1', '_time-series'],'-dpng');

% 2 * default parameter
plotTimeSeries('compare random-, direct- and panic simulation double default parameter',...
               random2(:, 2), direct2(:, 2), panic2(:, 2));
legend('random', 'direct', 'panic');
print([testOutput, '/', 'test-compare2', '_time-series'],'-dpng');
