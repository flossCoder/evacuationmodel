% simulate.m
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

% simulate is responsible for the simulation
%
% usage: simulate(field, showSingleStep, theTitle, outputDir, plotName,...
%                 mode)
%
% param field: the field to simulate
% param showSingleStep: if true every step is shown as a plot
% param theTitle: title of the simulation (shown as the title of the plot)
% param outputDir: the directory, where time series and plots are saved
% param plotName: the name of the plot (used to name the files)
% param mode: the simulation mode
%             0: default
%             1: direct
%             2: panic
function numberOfAgentsPerTime = simulate(field, showSingleStep,...
                                          theTitle, outputDir, plotName,...
                                          mode)
    assert(fieldValidator(field) == true, 'no valid field error');
    switch mode
        case 0
            % handle the default case
            numberOfAgentsPerTime = doTheSimulation(field,...
                showSingleStep, theTitle, outputDir, plotName, 0);
            % plot and save the semilog plot
            plotTimeSeries(theTitle, numberOfAgentsPerTime(:, 2));
            legend('random');
            print([outputDir, '/', plotName, '_time-series'],'-dpng');
        case 1
            % handle the direct case
            numberOfAgentsPerTime = doTheSimulation(field,...
                showSingleStep, theTitle, outputDir, plotName, 1);
            % plot and save the semilog plot
            plotTimeSeries(theTitle, numberOfAgentsPerTime(:, 2));
            legend('direct');
            print([outputDir, '/', plotName, '_time-series'],'-dpng');
        case 2
            % handle the panic case
            numberOfAgentsPerTime = doTheSimulation(field,...
                showSingleStep, theTitle, outputDir, plotName, 2);
            % plot and save the semilog plot
            plotTimeSeries(theTitle, numberOfAgentsPerTime(:, 2));
            legend('panic');
            print([outputDir, '/', plotName, '_time-series'],'-dpng');
        otherwise
            error('no valid simulation mode');
    end
    
end

% doTheSimulation does a single simulation
%
% usage: numberOfAgentsPerTime = doTheSimulation(field, showSingleStep,...
%                                                theTitle, outputDir)
%
% param field: the field to simulate
% param showSingleStep: if true every step is shown as a plot
% param theTitle: title of the simulation (shown as the title of the plot)
% param outputDir: the directory, where time series and plots are saved
% param plotName: title of the simulation (used for naming data- and
%                 plotfiles)
% param mode: the simulations mode
%
% return numberOfAgentsPerTime: the number of agents in each step,...
%                               the data are automatically saved to csv
function numberOfAgentsPerTime = doTheSimulation(field, showSingleStep,...
                theTitle, outputDir, plotName, mode)
    numberOfAgentsPerTime(1, 1) = 0; % saves the actual step
    numberOfAgentsPerTime(1, 2) = numberOfAgents(field); % saves the number
                                                      % of agents in step i
	while numberOfAgentsPerTime(end, 2) ~= 0
        field = simulationStep(field, mode); % do the step
        % save number of agents in this step
        numberOfAgentsPerTime(end + 1, 1) = numberOfAgentsPerTime(end, 1) + 1;
        numberOfAgentsPerTime(end, 2) = numberOfAgents(field);
        % show the live-plot, if showSingleStep is true
        if showSingleStep
            plotField(field, theTitle)
            drawnow()
            pause(0.1)
        end
    end
    
    % save the data of the agents
    csvwrite([outputDir, '/', plotName, '_data'], numberOfAgentsPerTime);
end
