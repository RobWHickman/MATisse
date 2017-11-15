%function to generate a cover image for the bidspace to reflect the amount
%of the budget left after winning an auction
%this is the area under the computer bid if monkey bid > computer bid
function stimuli = generate_reverse_bidspace(parameters, stimuli, task_window)
bidspace = stimuli.bidspace;
trial_values = parameters.single_trial_values;

%crop the reverse bidspace to the size under the computer bid and make a
%texture
reverse_bidspace_crop = imcrop(bidspace.reverse_bidspace,...
    [0 0 bidspace.bidspace_info.width bidspace.bidspace_info.height * trial_values.computer_bid_value]);
stimuli.trial.reverse_bidspace_texture = Screen('MakeTexture', task_window, reverse_bidspace_crop);

%work out the position of the cover image
stimuli.trial.reversed_bidspace_position = bidspace.bidspace_info.position;
stimuli.trial.reversed_bidspace_position(4) = bidspace.bidspace_info.height * trial_values.computer_bid_value;