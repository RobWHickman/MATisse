%function to draw lines every 12.5% of the way up the bidding space
%can be any colour and can also draw minor lines in between these
function stimuli = generate_bidspace_lines(stimuli, hardware, line_types)

%at which percentages of the bidspace should the major lines be drawn
line_percentages = 12.5;
%how many lines will this mean
lines = (100 / line_percentages) - 1;

%what should be the thickness of the lines
major_line_thickness = 4;
major_line_colour = [hardware.outputs.screen.white 0 0];
minor_line_thickness = 4;
minor_line_colour = [0 hardware.outputs.screen.white 0];

%at what y should the lines be drawn
major_line_y_positions = stimuli.bidspace.bidspace_info.position(2) + (stimuli.bidspace.bidspace_info.height / lines) * (1:lines-1);
%minor line positions go in between these
minor_line_y_positions = [major_line_y_positions - ((stimuli.bidspace.bidspace_info.height / lines) / 2),...
    major_line_y_positions(lines-1) + ((stimuli.bidspace.bidspace_info.height / lines) / 2)];

if strcmp(line_types, 'major')
    stimuli.bidspace.bidspace_info.bidspace_lines = 'major';
    stimuli.bidspace.lines.major.positions = major_line_y_positions;
    stimuli.bidspace.lines.major.thickness = major_line_thickness;
    stimuli.bidspace.lines.major.colour = major_line_colour;
elseif strcmp(line_types, 'minor')
    stimuli.bidspace.bidspace_info.bidspace_lines = 'minor';
    stimuli.bidspace.lines.major.positions = major_line_y_positions;
    stimuli.bidspace.lines.major.thickness = major_line_thickness;
    stimuli.bidspace.lines.major.colour = major_line_colour;
    stimuli.bidspace.lines.minor.positions = minor_line_y_positions;
    stimuli.bidspace.lines.minor.thickness = minor_line_thickness;
    stimuli.bidspace.lines.minor.colour = minor_line_colour;
end
    