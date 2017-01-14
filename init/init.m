% init.m
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

% init sets up the main field
%
% usage: field = init(numRows, numCols, numWalls, numExits, numAgents)
%
% param numRows: the number of rows of the field
% param numCols: the number of collumns of the field
% param numInnerWalls: the number of walls of the field inner (border walls
%                      are extra walls)
% param numExits: the number of exits of the field
% param numAgents: the number of agents, that are initially on the field
%
% return: the field setted up with the border and randomly placed numWalls
%         walls, numExits exits and numAgents agents.
%         The state of each field is:
%           empty: 0
%           wall: 1
%           exit: 2
%           agent: 3
%
% errors: (numInnerWalls + numExits + numAgents) >= (numRows * numCols)
%          invalid number of input arguments
function field = init(numRows, numCols, numInnerWalls, numExits, numAgents)
    % handling error-cases
    assert((numInnerWalls + numExits + numAgents) <= (numRows * numCols),...
        'to many walls, exits and agents');
    assert(nargin == 5, 'invalid number of input arguments');
    
    % setup the field
    field = zeros(numRows, numCols);
    field = setBorders(field);
    field = setToInnerField(field, numInnerWalls, 1); % setup the inner walls
    field = setToInnerField(field, numExits, 2); % setup the exits
    field = setToInnerField(field, numAgents, 3); % setup the agents group 1
end

% setBorders addes the borders to the field
%
% usage: field = setBorders(field)
%
% param field: the empty field
%
% return: the field with correctly borders
function field = setBorders(field)
    field(:, 1) = ones(size(field, 1), 1); % set up left wall
    field(:, end) = ones(size(field, 1), 1); % set up right wall
    field(1, :) = ones(size(field, 2), 1); % set up upper wall
    field(end, :) = ones(size(field, 2), 1); % set up lower wall
end

% setToInnerField sets a number of objects to the inner field
%
% usage: field = setToInnerField(field, numberOfObjects, value)
%
% param field: the field
% param numberOfObjects: the number of objects to be set
% param values: the value to be set
%
% error: value < 0
function field = setToInnerField(field, numberOfObjects, value)
    assert(value > 0 && value <= 3, 'invalid object');
    while (numberOfObjects > 0)
        [row, col] = getEmptyInnerField(field);
        field(row, col) = value;
        numberOfObjects = numberOfObjects - 1;
    end
end

% getEmptyInnerField calcusates randomly an empty inner field
%
% param field: the field
%
% return row: row of the random field
% return col: column of the random field
%
% error: there is no inner field == 0
function [row, col] = getEmptyInnerField(field)
    assert(~all(all(field(2 : end - 1, 2 : end - 1))), 'there is no inner field == 0');
    row = randi(size(field, 1) - 2) + 1; % [2 : numRows - 1]
    col = randi(size(field, 2) - 2) + 1; % [2 : numCols - 1]
    if (field(row, col) ~= 0)
        [row, col] = getEmptyInnerField(field);
    end
end
