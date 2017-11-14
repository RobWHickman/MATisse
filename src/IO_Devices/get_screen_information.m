%function to open the task window on a specified screen and also grab all
%the information we might need about it
%will also set the background of the screen as grey
%experimental screen should specify which screen will host the experiment
%for the monkey
function hardware = get_screen_information(hardware)
%we're going to set all this information to a single object
hardware.outputs.screen_info.task_monitor = hardware.outputs.screen_info.screen_number;

%find how many monitors are connected
%should be two
hardware.outputs.screen_info.screens = Screen('Screens');

%throw an error if this isn't the case
if hardware.outputs.screen_info.screens < 2
    display('ensure that at least two screens are connected!!!');
end

%get the screen refresh rate
hardware.outputs.screen_info.hz = Screen('NominalFrameRate', hardware.outputs.screen_info.screen_number);

%set the base background colour for the experimental screen
hardware.outputs.screen_info.bg_col = WhiteIndex(hardware.outputs.screen_info.screen_number) / 2;
hardware.outputs.screen_info.white = WhiteIndex(hardware.outputs.screen_info.screen_number);

%get the screen dimensions
[hardware.outputs.screen_info.width, hardware.outputs.screen_info.height] = Screen('WindowSize', hardware.outputs.screen_info.task_monitor);

%get some useful constants about the task screen for positioning stuff
hardware.outputs.screen_info.percent_x = hardware.outputs.screen_info.width/ 100;
hardware.outputs.screen_info.percent_y = hardware.outputs.screen_info.height/ 100;
