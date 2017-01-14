% plotField.m
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

% plotInit plots the field
%
% usage: plotField(field, theTitle, outputDir, plotName)
%
% param field: the field
% param theTitle: title of the plot
% param outputDir: the directory to save a plot (optional)
% param plotName: the name of the plot (used to name the files)
%
% error: the field is empty (the logic calling this function must assert,
%        that a valid field is passed)
function plotField(field, theTitle, outputDir, plotName)
    % security checks
    assert(numel(field) > 0, 'not enough number of fields');
    if (nargin < 2)
        error('plotField needs minimum 2 params');
    end
    
    % plot field
    imagesc(field, [0, 3]);
    title(theTitle);
    axis tight;
    xlabel('horizontal position');
    ylabel('vertical position');
    colorbar('yTick', [0, 1, 2, 3], 'yTickLabel',...
        {'empty', 'wall', 'exit', 'agent'});
    if (nargin == 4) % the case to save the plot as png
        print([outputDir, '/', plotName, '_field'],'-dpng');
    end
end
