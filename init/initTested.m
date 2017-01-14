% initTested.m
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

% initTested sets up the main field and tests it with the fieldValidator
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
function field = initTested(numRows, numCols, numInnerWalls, numExits,...
                 numAgents)
    testPassed = false;
    while ~testPassed
        field = init(numRows, numCols, numInnerWalls, numExits, numAgents);
        testPassed = fieldValidator(field);
    end
end
