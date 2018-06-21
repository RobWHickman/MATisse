%function to select the fractal for the upcoming trial and store some
%information about it
function texture = select_fractal(stimuli, results, task_window)

%select the correct fractal picture and transform it into a texture for PTB
texture_fractal = cell2mat(stimuli.fractals.images(results.single_trial.reward_value));
texture = Screen('MakeTexture', task_window, texture_fractal);
