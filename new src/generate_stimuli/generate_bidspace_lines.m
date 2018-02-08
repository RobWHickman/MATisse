%function to draw lines every 12.5% of the way up the bidding space
%can be any colour and can also draw minor lines in between these
function lines = generate_bidspace_lines(stimuli, hardware, line_types)

%at which percentages of the bidspace should the major lines be drawn
line_percentages = 12.5;
%how many lines will this mean
no_of_lines = (100 / line_percentages) - 1;

%what should be the thickness of the lines
major_line_thickness = 4;
major_line_colour = [hardware.screen.colours.white 0 0];
minor_line_thickness = 2;
minor_line_colour = [0 hardware.screen.colours.white 0];

%at what y should the lines be drawn
major_line_y_positions = stimuli.bidspace.position(2) + (stimuli.bidspace.dimensions.height / no_of_lines) * (1:no_of_lines-1);
%minor line positions go in between these
minor_line_y_positions = [major_line_y_positions - ((stimuli.bidspace.dimensions.height / no_of_lines) / 2),...
    major_line_y_positions(no_of_lines-1) + ((stimuli.bidspace.dimensions.height / no_of_lines) / 2)];

%define the parameters for major or minor lines
%CHECK THIS- SEE TRANSPARENCY TUTORIAL FOR HAVING MULTIPLE POLYGONS IN ONE
%STRUCT
if strcmp(line_types, 'major')
    lines.position = major_line_y_positions;
    lines.thickness = repmat(major_line_thickness, 1, no_of_lines-1);
    lines.colour = repmat(major_line_colour, no_of_lines-1, 1)';
elseif strcmp(line_types, 'minor')
    lines.position = [major_line_y_positions minor_line_y_positions];
    lines.thickness = horzcat(repmat(major_line_thickness, 1, no_of_lines-1),repmat(minor_line_thickness, 1, no_of_lines));
    lines.colour = horzcat(repmat(major_line_colour, no_of_lines-1, 1)', repmat(minor_line_colour, no_of_lines-1, 1)');
elseif strcmp(line_types, 'none')
    lines.position = NaN;
end
    