% simulationStep.m
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

% simulationStep does the next step
%
% usage: field = simulationStep(field, mode)
%
% param field: the field, that should be simulated
% param mode: this flag is needed for the extension:
%                   mode = 0: default simulation
%                   mode = 1: direct simulation
%                   mode = 2: panic simulation
%                   mode = 3: mixture simulation
function field = simulationStep(field, mode)
    if nargin == 1
        mode = 0; % default mode
    end
    listOfAgents = createListOfObjects(field, 3); % list all agents
    listOfExits = createListOfObjects(field, 2); % list all exits
    for k = 1:size(listOfAgents, 1) % simulate for every agent
        [field, bool] = removeAgentAtExit(field, listOfAgents(k, 1),...
        listOfAgents(k, 2));
        if ~bool % the agent has not been removed
            switch mode
                case 0
                    field = defaultStep(field, listOfAgents(k, 1),...
                        listOfAgents(k, 2));
                case 1
                    field = directStep(field, listOfAgents(k, 1),...
                        listOfAgents(k, 2), listOfExits);
                case 2
                    field = panicStep(field, listOfAgents(k, 1),...
                        listOfAgents(k, 2), listOfExits);
                otherwise
                    error('no valid mode in simulationStep');
            end
        end
    end
end

% panicStep chooses randomly between direct- and random step
%
% usage: field = panicStep(field, row, col, listOfExits)
%
% param field: the field
% param row: the row of the agent
% param col: the column of the agent
% param listOfExits: a list with all exits
%
% return field: the field after one step
function field = panicStep(field, row, col, listOfExits)
    if randi(2) == 2 % random step
        field = defaultStep(field, row, col);
    else % direct step
        field = directStep(field, row, col, listOfExits);
    end
end

% directStep implements the direct step
%
% usage: field = directStep(field, row, col, listOfExits)
%
% param field: the field
% param row: the row of the agent
% param col: the column of the agent
% param listOfExits: a list with all exits
%
% return field: the field after one step
function field = directStep(field, row, col, listOfExits)
    [rowE, colE] = nextExit(row, col, listOfExits);
    % The following logic changes the row/column by the number of steps...
    % (the shorter one is precedented). It distincts five cases:
    %
    % 1. walk in row direction is best and there is no barrier in row
    %    direction: do a step in row direction
    %
    % 2. walk in col direction is best and there is no barrier in col
    %    direction: do a step in col direction
    %
    % 3. walk in row direction is best and there is a barrier in row
    %    direction, but no one in col direction: do a step in col direction
    %
    % 4. walk in col direction is best and there is a barrier in col
    %    direction, but no one in row direction: do a step in row direction
    %
    % 5. none of this cases is correct: do a random step
    
    if (abs(rowE - row) > abs(colE - col))... % better to walk in row direction
            && (field(row + (rowE - row) / abs(rowE - row), col) == 0) % no barrier in row direction
        % walk in row direction
        field(row + (rowE - row) / abs(rowE - row), col) = field(row, col);
        field(row, col) = 0;
    elseif (abs(colE - col) > abs(rowE - row))... % better to walk in col direction
            && (field(row, col + (colE - col) / abs(colE - col)) == 0) % no barrier in col direction
        % walk in col direction
        field(row, col + (colE - col) / abs(colE - col)) = field(row, col);
        field(row, col) = 0;
    elseif (abs(rowE - row) > 0)... % second best way
            && (field(row + (rowE - row) / abs(rowE - row), col) == 0) % no barrier in row direction
        % walk in row direction
        field(row + (rowE - row) / abs(rowE - row), col) = field(row, col);
        field(row, col) = 0;
    elseif (abs(colE - col) > 0)... % second best way
            && (field(row, col + (colE - col) / abs(colE - col)) == 0) % no barrier in col direction
        % walk in col direction
        field(row, col + (colE - col) / abs(colE - col)) = field(row, col);
        field(row, col) = 0;
    else
        % nothing works
        % because of the possibility of an deadlock, check, if the agent
        % has three neighbours
        if (((field(row - 1, col) == 1) + ... % field above
                    (field(row + 1, col) == 1) + ... % field below
                    (field(row, col - 1) == 1) + ... % field left
                    (field(row, col + 1) == 1) ... % field right
                    ) == 3)
            % probably found a deadlock => the defaultStep will go in one
            % direction => agent is in the position before the last step =>
            % in two steps the agent will be here again => agent never
            % reaches an exit => program never terminates
            % solution: terminate program with an error message
            error('Deadlock: the program might otherwise nor terminate');
        else
            field = defaultStep(field, row, col);
        end
    end
end

% nextExit calculates the closest exit for a given agent
%
% usage: [rowE, colE] = nextExit(row, col, listOfExits)
%
% param row: row coordinate of the agent
% param col: column coordinate of the agent
% param listOfExits: a list with the coordinates of all exits
%
% return rowE: row coordinate of the closest exit
% return colE: column coordinate of the closest exit
function [rowE, colE] = nextExit(row, col, listOfExits)
    % define private function calculating the distance between agent and
    % exit
    dist = @(row, col, rowE, colE) sqrt((row - rowE)^2 + (col - colE)^2);
    smallestDistance = Inf;
    for k = 1:size(listOfExits, 1)
        actDistance = dist(row, col, listOfExits(k, 1),listOfExits(k, 2));
        if actDistance < smallestDistance;
            % the actually exit is closer then all other tested
            rowE = listOfExits(k, 1);
            colE = listOfExits(k, 2);
            smallestDistance = actDistance;
        end
    end
end

% removeAgentAtExit if the agent's field is next to the one of an exit,
%                   he simply leaves the field
%
% usage: [field, bool] = removeAgentAtExit(field, row, col)
%
% param field: the field
% param row: the row coordinate of the agent
% param col: the column coordinate of the agent
%
% return field: the field with removed agent, if possible
% return list: a list with all free neighbor fields
% return bool: true, if the agent has been removed, false otherwise
function [field, bool] = removeAgentAtExit(field, row, col)
    % check neighbor fields for an exit
    if (field(row - 1, col) == 2 || ... % upper field
            field(row + 1, col) == 2 || ... % lower field
            field(row, col - 1) == 2 || ... % left field
            field(row, col + 1) == 2) % right field
        field(row, col) = 0; % the agent's field is next to an exit field
        bool = true;
    else % the agent can not leave the field
        bool = false;
    end
end

% defaultStep implements the random step
%
% usage: field = defaultStep(field, row, col)
%
% param field: the field
% param row: the row of the agent
% param col: the column of the agent
%
% return field: the field after one step
function field = defaultStep(field, row, col)
    list = listOfFreePlaces(field, row, col);
    if numel(list) ~= 0 % case, that the agent can move
        % choose the field, where the agent should move
        elem = randi(size(list, 1));
        % set the value of the agent to the new field
        field(list(elem, 1), list(elem, 2)) = field(row, col);
        % set the old field of the agent to empty
        field(row, col) = 0;
    end
end

% listOfFreePlaces calculates a list of free places
%
% usage: list = listOfFreePlaces(field, row, col)
%
% param field: the field
% param row: the row coordinate of the agent
% param col: the column coordinate of the agent
%
% return list: a list of free neightbour places or [] if no step is possible
function list = listOfFreePlaces(field, row, col)
    list = [];
    
    % test the four neighbour fields
    if field(row + 1, col) == 0 % upper field
        list(end + 1, 1) = row + 1; % insert row coordinate
        list(end, 2) = col; % insert column coordinate
    end
    if field(row - 1, col) == 0 % lower field
        list(end + 1, 1) = row - 1; % insert row coordinate
        list(end, 2) = col; % insert column coordinate
    end
    if field(row, col - 1) == 0 % left field
        list(end + 1, 1) = row; % insert row coordinate
        list(end, 2) = col - 1; % insert column coordinate
    end
    if field(row, col + 1) == 0 % right field
        list(end + 1, 1) = row; % insert row coordinate
        list(end, 2) = col + 1; % insert column coordinate
    end
    
    % check for empty list
    if numel(list) == 0
        disp('agent could not move');
    end
end

% createListOfAgents returns a list of all agents
%
% usage: list = createListOfObjects(field, object)
%
% param field: the field
% param object: the encoding-number of the object
%
% return list: a 2 dimensional matrix containig the row and column
%              coordinates of each agent
function list = createListOfObjects(field, object)
    list = zeros(sum(sum(field == object)), 2); % preallocate with number of objects
    k = 1; % row param of the list
    for row = 1:size(field, 1) % walk through the rows of the field
        for col = 1:size(field, 2) % walk through the columns of the field
            if (field(row, col) == object)
                list(k, 1) = row;
                list(k, 2) = col;
                k = k + 1;
            end
        end
    end
end
