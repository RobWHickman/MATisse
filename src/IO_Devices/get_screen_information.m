%function to open the task window on a specified screen and also grab all
%the information we might need about it
%will also set the background of the screen as grey
%experimental screen should specify which screen will host the experiment
%for the monkey
function hardware = get_screen_information(experimental_monitor)
%we're going to set all this information to a single object
hardware.outputs.screen_info.task_monitor = experimental_monitor;

%find how many monitors are connected
%should be two
hardware.outputs.screen_info.screens = Screen('Screens');
hardware.outputs.screen_info.number = max(screen_info.screens);

%throw an error if this isn't the case
if hardware.outputs.screen_info.number ~= 2
    display('ensure that exactly two screens are connected!!!');
end

%get the screen refresh rate
hardware.outputs.screen_info.hz = Screen('NominalFrameRate', experimental_monitor);

%set the base background colour for the experimental screen
hardware.outputs.screen_info.bg_col = WhiteIndex(experimental_monitor) / 2;

%get the screen dimensions
[hardware.outputs.screen_info.width, hardware.outputs.screen_info.height] = Screen('WindowSize', screen_info.task_monitor);

%get some useful constants about the task screen for positioning stuff
hardware.outputs.screen_info.percent_x = hardware.outputs.screen_info.width/ 100;
hardware.outputs.screen_info.percent_y = hardware.outputs.screen_info.height/ 100;
