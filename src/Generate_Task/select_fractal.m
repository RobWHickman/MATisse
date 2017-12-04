%function to select the fractal for the upcoming trial and store some
%information about it
function stimuli = select_fractal(parameters, stimuli, task_window)
%select the correct fractal picture and transform it into a texture for PTB
stimuli.trial.trial_fractal = cell2mat(stimuli.fractals.fractals(parameters.single_trial_values.offer_value));
stimuli.trial.trial_fractal_texture = Screen('MakeTexture', task_window, stimuli.trial.trial_fractal);
