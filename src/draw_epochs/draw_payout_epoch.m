%function to draw the fifth epoch- the result of the bidding
%this function is called if the monkey wins i.e. if its bid is higher than
%that of the computer
function [] = draw_payout_epoch(stimuli, hardware, task_window, task, outcome)

Screen('FillRect', task_window, hardware.screen.colours.grey);

if strcmp(task, 'BDM')
    if strcmp(outcome, 'win')
    elseif strcmp(outcome, 'lose')
    end

elseif strcmp(task, 'BC')
    if strcmp(outcome, 'bundle')
    elseif strcmp(outcome, 'budget')
    end

elseif strcmp(task, 'PAV')
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
end