% fieldValidator.m
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

% fieldValidator checks, whether a field is valid
%                Valid means, it contains at least one exit and all exits...
%                and agents have at least one free neighbours. The field...
%                must have a border.
%
% param field: the field
%
% return bool: true if field valid, false otherwise
function bool = fieldValidator(field)
    bool = true;
    % walk through field
    for row = 2:(size(field, 1) - 1)
        for col = 2:(size(field, 2) - 1)
            if (field(row, col) >= 2) && ... % there is an agent or exit
                  (((field(row - 1, col) ~= 0) + ... % field above
                    (field(row + 1, col) ~= 0) + ... % field below
                    (field(row, col - 1) ~= 0) + ... % field left
                    (field(row, col + 1) ~= 0) ... % field right
                    )== 4) % the field has four neighbours
                bool = false;
                return;
            end
        end
    end
    % check for at least one exit and the existance of the border
    bool = bool && any(any(field == 2)) &&...
           all(field(:, 1)) &&... % left wall
           all(field(:, end)) &&... % right wall
           all(field(1, :)) &&... % upper wall
           all(field(end, :)); % lower wall
end
