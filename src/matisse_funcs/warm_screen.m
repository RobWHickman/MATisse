%function to initialise the experiment to be run
%loads as much as possible without opening a task window
%gets information on the screen being used and task parameters (how many
%trials/ which monitor/ etc.)
function =  warm_screen(screen_number)

%open a psychtoolbox screen for the task
%set it to black for now
[task_window, task_windowrect] = PsychImaging('OpenWindow', hardware.screen.number, 0);
Screen('BlendFunction', task_window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
