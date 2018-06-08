%function that flips the screen either clearing the buffer or not depending
%on the frame
%for the final frame this should be cleared to allow the new epoch to
%display stuff from only that epoch, otherwise it should not so that we
%don't have to redraw everything each time
function flip_screen(frame, parameters, task_window, epoch)

%simple if statement
if frame == (parameters.timings.TrialTime(epoch))
    Screen('Flip', task_window, [], 0);
else
    Screen('Flip', task_window, [], 1);
end
