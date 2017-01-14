% initTest.m
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

% initTest tests the init function
%
% usage: bool = initTest()
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = initTest()
    % easy test:
    numRows = 5;
    numCols = 6;
    numInnerWalls = 2;
    numExits = 1;
    numAgents = 3;
    bool1 = test(numRows, numCols, numInnerWalls, numExits, numAgents);
    
    % test with default parameters:
    numRows = 20;
    numCols = 30;
    numInnerWalls = 25;
    numExits = 1;
    numAgents = 25;
    bool2 = test(numRows, numCols, numInnerWalls, numExits, numAgents);
    
    % test with 2 * default parameters:
    numRows = numRows * 2;
    numCols = numCols * 2;
    numInnerWalls = numInnerWalls * 2;
    numExits = numExits * 2;
    numAgents = numAgents * 2;
    bool3 = test(numRows, numCols, numInnerWalls, numExits, numAgents);
    
    % return true when all tests passed and false otherwise:
    bool = bool1 && bool2 && bool3;
end

% test with different params
%
% usage: bool = test(numRows, numCols, numInnerWalls, numExits, numAgents)
%
% param numRows: the number of rows of the field
% param numCols: the number of collumns of the field
% param numInnerWalls: the number of walls of the field inner (border walls
%                      are extra walls)
% param numExits: the number of exits of the field
% param numAgents: the number of agents, that are initially on the field
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = test(numRows, numCols, numInnerWalls, numExits, numAgents)
    % init a field
    field = init(numRows, numCols, numInnerWalls, numExits, numAgents);
    
    % test a field
    [boolDim, message] = testDimension(field, numRows, numCols); % dimension test
    dispMessage(boolDim, message);
    [boolBorders, message] = testBorders(field); % border test
    dispMessage(boolBorders, message);
    [boolWalls, message] = testInnerField(field, numInnerWalls, 1, 'inner walls');
    dispMessage(boolWalls, message);
    [boolExits, message] = testInnerField(field, numExits, 2, 'exits');
    dispMessage(boolExits, message);
    [boolAgents, message] = testInnerField(field, numAgents, 3, 'agents');
    dispMessage(boolAgents, message);
    
    bool = boolDim && boolBorders && boolWalls && boolExits && boolAgents;
    
    if bool == false
        disp(field);
    end
end

% test the dimension of the field
%
% usage: [bool, message] = testDimension(field, numRows, numCols)
%
% param field: the field
% param numRows: number of rows
% param numCols: number of collumns
%
% return bool: true, when everything is correct
%              false, when there is something wrong
% message: returns an error-message (if there are more then one error, just
%          one is reported)
function [bool, message] = testDimension(field, numRows, numCols)
    bool = true;
    message = [];
    if size(field, 1) ~= numRows % is true, when the number of rows is not correct
        bool = false;
        message = fprintf('the number of rows is %i, but should be %i\n',...
            size(field, 1), numRows);
        return;
    end
    if size(field, 2) ~= numCols % is true, when the number of collumns is not correct
        bool = false;
        message = fprintf('the number of collumns is %i, but should be %i\n',...
            size(field, 2), numCols);
        return;
    end
end

% test the borders of the field
%
% usage: [bool, message] = testBorders(field)
%
% param field: the field
%
% return bool: true, when everything is correct
%              false, when there is something wrong
% return message: returns an error-message (if there are more then one...
%                 error, just one is reported)
function [bool, message] = testBorders(field)
    bool = true;
    message = [];
    if ~all(field(:, 1)) % left wall
        bool = false;
        message = 'error in the left wall';
    end
    if ~all(field(:, end)) % right wall
        bool = false;
        message = 'error in the right wall';
    end
    if ~all(field(1, :)) % upper wall
        bool = false;
        message = 'error in the upper wall';
    end
    if ~all(field(end, :)) % lower wall
        bool = false;
        message = 'error in the lower wall';
    end
end

% testInnerField tests, if the number of objects on the inner field is
% correct
%
% usage: [bool, message] = testInnerField(field, numberOfObjects, value,...
%                          objects)
%
% param field: the field
% param numberOfObjects: number of objects supposed to be on the inner
%                        field
% param value: the value, which is checked
% param objects: a string for the error-message
%
% return: see above
function [bool, message] = testInnerField(field, numberOfObjects, value,...
                           objects)
    innerField = field(2 : end - 1, 2 : end - 1);
    bool = true;
    message = [];
    % check if the number of elements with value value in the innerField is
    % correct
    if numel(find(innerField == value)) ~= numberOfObjects
        bool = false;
        message = fprintf('the number of %s is %i, but should be %i\n',...
            objects, numel(find(innerField == value)), numberOfObjects);
    end
end
