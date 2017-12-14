function [] = draw_epoch_2(stimuli, parameters, task_window)

if isfield(parameters, 'binary_choice')
    if ~parameters.binary_choice.no_fractals
        Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.fractals.fractal_info.fractal_position, 0);
    end
end
Screen('DrawingFinished', task_window);
