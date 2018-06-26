%function to open the task window on a specified screen and also grab all
%the information we might need about it
%will also set the background of the screen as grey
%experimental screen should specify which screen will host the experiment
%for the monkey
function hardware = get_screen_information(hardware)
%find how many monitors are connected
%should be two
hardware.screen.screens = Screen('Screens');

%throw an error if this isn't the case
if hardware.screen.screens < 2
    warning('!only one screen connected!');
end

%get the screen refresh rate
hardware.screen.refresh_rate = Screen('NominalFrameRate', hardware.screen.number);

%set the base background colour for the experimental screen
hardware.screen.colours.grey = WhiteIndex(hardware.screen.number) / 2;
hardware.screen.colours.white = WhiteIndex(hardware.screen.number);
hardware.screen.colours.black = BlackIndex(hardware.screen.number);

%get the screen dimensions
[hardware.screen.dimensions.width, hardware.screen.dimensions.height] = Screen('WindowSize', hardware.screen.number);
