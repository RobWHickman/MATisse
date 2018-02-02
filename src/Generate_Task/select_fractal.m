%function to select the fractal for the upcoming trial and store some
%information about it
function stimuli = select_fractal(parameters, stimuli, task_window)

%select the correct fractal picture and transform it into a texture for PTB
texture_fractal = cell2mat(stimuli.fractals.images(results.single_trial.reward_value));
stimuli.fractals.texture = Screen('MakeTexture', task_window, texture_fractal);
