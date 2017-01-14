% fieldValidatorTest.m
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

% fieldValidatorTest checks, fieldValidator
%
% return bool: true if tests passed, false otherwise
function bool = fieldValidatorTest()
    field1 = init(5, 5, 0, 0, 0); % no exit
    field2 = field1;
    field2(2, 2) = 2; % exit can not be reached
    field2(2, 3) = 1; % wall
    field2(3, 2) = 1; % wall
    field2(4, 4) = 2; % second exit
    field3 = field2;
    field3(2, 2) = 3; % agent can not move
    field4 = field1;
    field4(2, 2) = 2; % exit
    field4(4, 4) = 3; % agent
    
    bool = ~fieldValidator(field1) &&... % no exit
           ~fieldValidator(field2) &&... % exit not reachable
           ~fieldValidator(field3) &&... % agent can not move
           fieldValidator(field4); % valid field
end
