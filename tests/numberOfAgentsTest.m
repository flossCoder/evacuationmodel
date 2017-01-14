% numberOfAgentsTest.m
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

% numberOfAgentsTest checks the numberOfAgents function
%
% usage: bool = numberOfAgentsTest()
%
% return bool: true, when everything is correct
%              false, when there is something wrong
function bool = numberOfAgentsTest()
    bool = true;
    field1 = init(5, 5, 0, 0, 3);
    field2 = init(5, 5, 0, 0, 0);
    
    if numberOfAgents(field1) ~= 3
        dispMessage(false, 'wrong agent number');
        bool = false;
    end
    if numberOfAgents(field2) ~= 0
        dispMessage(false, 'there is no agent');
        bool = false;
    end
end
