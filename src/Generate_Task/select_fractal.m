%function to select the fractal for the upcoming trial and store some
%information about it
function stimuli = select_fractal(parameters, stimuli, hardware, task_window)
%select the correct fractal picture and transform it into a texture for PTB
stimuli.trial.trial_fractal = cell2mat(stimuli.fractals.fractals(parameters.single_trial_values.offer_value));
stimuli.trial.trial_fractal_texture = Screen('MakeTexture', task_window, stimuli.trial.trial_fractal);

%clear up the clutter for the position a bit
screen = hardware.outputs.screen_info;

%set the position of the fractal as a function of the screen
stimuli.trial.trial_fractal_position = [((screen.width /2) - (screen.percent_x * 10) - (screen.height * 0.5)),...
    (screen.height/2 + (screen.height * 0.5)/2),...
    ((screen.width /2) - (screen.percent_x * 10)),...
    screen.height/2 - (screen.height * 0.5)/2];
    