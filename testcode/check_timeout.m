%small function to check if something has passed a timeout check
%in this case if any bid has been made within the first x seconds of
%bidding on the BDM task
function bid_activity = check_timeout(parameters, hardware)
%only check if within the window for making a bid at the start of the
%bidding phase and if no bid has yet been made
if parameters.epoch_frame < (parameters.settings.bid_timeout * hardware.settings.screen_hz) && parameters.task_gates.bid_activity ~= true
    if frame_y_adjust ~= 0
        %as soon as any movement is iniated, counted as a bid and will
        %eventaully pass
        bid_activity = true;
    end
end
