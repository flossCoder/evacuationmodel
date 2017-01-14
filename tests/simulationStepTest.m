% simulationStepTest.m
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

% simulationStepTest tests, if the single simulation-step works correct
% under certain (easy to handle) circumstances
%
% usage: bool = simulationStepTest()
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = simulationStepTest()
    bool1 = removeAgentTest();
    bool2 = moveRandomTest();
    bool3 = moveRandomWithWalls;
    bool4 = cannotMoveTest();
    bool5 = directTest();
    % return true when all tests passed and false otherwise:
    bool = bool1 && bool2 && bool3 && bool4 && bool5;
end

% directTest checks the direct step
%
% usage: bool = directTest()
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = directTest()
    % closest exit left
    field = init(3, 10, 0, 0, 0);
    field(2, 2) = 2; % set exit 1
    field(2, 9) = 2; % set exit 2
    correctField = field; % set the correct field
    correctField(2, 3) = 3;
    field(2, 4) = 3; % set agent
    
    field = simulationStep(field, 1); % start the simulation
    bool1 = testFields(correctField, field);
    
    % closest exit right
    field = init(3, 10, 0, 0, 0);
    field(2, 9) = 2; % set exit
    correctField = field; % set the correct field
    correctField(2, 5) = 3;
    field(2, 4) = 3; % set agent
    
    field = simulationStep(field, 1); % start the simulation
    bool2 = testFields(correctField, field);
    
    % closest exit above
    field = init(10, 3, 0, 0, 0);
    field(2, 2) = 2; % set exit
    correctField = field; % set the correct field
    correctField(4, 2) = 3;
    field(5, 2) = 3; % set agent
    
    field = simulationStep(field, 1); % start the simulation
    bool3 = testFields(correctField, field);
    
    % closest exit below
    field = init(10, 3, 0, 0, 0);
    field(9, 2) = 2; % set exit
    correctField = field; % set the correct field
    correctField(6, 2) = 3;
    field(5, 2) = 3; % set agent
    
    field = simulationStep(field, 1); % start the simulation
    bool4 = testFields(correctField, field);
    
    bool = bool1 && bool2 && bool3 && bool4;
end

% cannotMoveTest the agent can not move
%
% usage: bool = cannotMoveTest()
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = cannotMoveTest()
    field = init(3, 3, 0, 0, 1);
    bool = testFields(field, simulationStep(field, 0));
    dispMessage(bool, 'agent can not move error');
end

% moveRandomWithWalls checks the random move with walls several times
%
% usage: bool = moveRandomWithWalls()
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = moveRandomWithWalls()
    bool = true;
    field = init(4, 4, 0, 0, 0);
    
    % test matrices
    left = field;
    left(3, 2) = 3;
    upper = field;
    upper(2, 3) = 3;
    
    % test for agent in right lower corner
    for k = 1:10000
        test = field;
        test(3, 3) = 3; % place the agent
        
        test = simulationStep(test, 0);
        
        % check, if the agent is on a correct position
        if sum([testFields(upper, test), testFields(left, test)]) ~= 1
            bool = false;
        end
    end
    
    % test for agent in left upper corner
    for k = 1:10000
        test = field;
        test(2, 2) = 3; % place the agent
        
        test = simulationStep(test, 0);
        
        % check, if the agent is on a correct position
        if sum([testFields(upper, test), testFields(left, test)]) ~= 1
            bool = false;
        end
    end
    dispMessage(bool, 'the random movement test with walls failed');
end

% moveRandomTest checks the random move several times
%
% usage: bool = moveRandomTest()
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = moveRandomTest()
    bool = true;
    field = init(5, 5, 0, 0, 0);
    
    % test matrices
    upper = field;
    upper(2, 3) = 3;
    lower = field;
    lower(4, 3) = 3;
    left = field;
    left(3, 2) = 3;
    right = field;
    right(3, 4) = 3;
    
    for k = 1:10000
        test = field;
        test(3, 3) = 3; % place the agent
        
        test = simulationStep(test, 0);
        
        % check, if the agent is on a correct position
        if sum([testFields(upper, test),...
           testFields(lower, test),...
           testFields(left, test),...
           testFields(right, test)]) ~= 1
            bool = false;
        end
    end
    dispMessage(bool, 'the random movement test failed');
end

% removeAgentTest checks, if the agent is removed from the field, when
%                 stays next to an exit
%
% usage: bool = removeAgentTest()
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = removeAgentTest()
    field = init(5, 6, 0, 0, 0); % init a 5 x 6 field
    field(3, 3) = 2; % add an exit
    correctField = field;
    field(3, 4) = 3; % add an agent
    % now in the step, the agent has to disappear
    field = simulationStep(field, 0);
    [bool1, message] = testFields(correctField, field);
    dispMessage(bool1, ['remove agent test ', message]);
    
    field(3, 2) = 3; % add an agent
    % now in the step, the agent has to disappear
    field = simulationStep(field, 0);
    [bool2, message] = testFields(correctField, field);
    dispMessage(bool2, ['remove agent test ', message]);
    
    field(2, 3) = 3; % add an agent
    % now in the step, the agent has to disappear
    field = simulationStep(field, 0);
    [bool3, message] = testFields(correctField, field);
    dispMessage(bool3, ['remove agent test ', message]);
    
    field(4, 3) = 3; % add an agent
    % now in the step, the agent has to disappear
    field = simulationStep(field, 0);
    [bool4, message] = testFields(correctField, field);
    dispMessage(bool4, ['remove agent test ', message]);
    
    bool = bool1 || bool2 || bool3 || bool4;
end

% testFields compares two given fields
%
% usage: [bool, message] = testFields(correctField, testField)
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function [bool, message] = testFields(correctField, testField)
    bool = true;
    message = [];
    
    if ((size(correctField, 1) ~= size(testField, 1)) ||...
            (size(correctField, 2) ~= size(testField, 2)))
        % both fields have different dimensions
        message = 'wrong dimensions';
        % error in the testing routine
        bool = false;
    elseif (all(all(correctField == testField))) == false
        message = 'are not the same';
        bool = false;
    end
end
