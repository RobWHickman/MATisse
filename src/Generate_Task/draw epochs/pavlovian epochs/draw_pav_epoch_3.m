function [] = draw_pav_epoch_3(stimuli, parameters, task_window)

if isfield(parameters, 'binary_choice')
    if ~parameters.binary_choice.no_fractals
        Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], [200,200,200,200], 0);
    end
end