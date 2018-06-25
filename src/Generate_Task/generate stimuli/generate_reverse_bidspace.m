%function to generate a cover image for the bidspace to reflect the amount
%of the budget left after winning an auction
%this is the area under the computer bid if monkey bid > computer bid
function stimuli = generate_reverse_bidspace(parameters, stimuli, task_window, results)
bidspace = stimuli.bidspace;
trial_values = parameters.single_trial_values;

%crop the reverse bidspace to the size under the computer bid and make a
%texture
if strcmp(parameters.task, 'BDM')
%task parameter for the new bidspace position
value = trial_values.computer_bid_value; %SECOND_PRICE_AUCTION
%value = results.trial_results.monkey_bid; %FIRST_PRICE_AUCTION
%crop the bidspace
reverse_bidspace_crop = imcrop(bidspace.reverse_bidspace,...
    [0 bidspace.bidspace_info.height - (bidspace.bidspace_info.height * value)...
    bidspace.bidspace_info.width bidspace.bidspace_info.height]);
stimuli.trial.reverse_bidspace_texture = Screen('MakeTexture', task_window, reverse_bidspace_crop);

elseif strcmp(parameters.task, 'BC')
value = trial_values.bundle_water;
reverse_bidspace_crop = imcrop(bidspace.reverse_bidspace,...
    [0 bidspace.bidspace_info.height - (bidspace.bidspace_info.height * value)...
    bidspace.bidspace_info.width bidspace.bidspace_info.height]);
stimuli.trial.reverse_bidspace_texture = Screen('MakeTexture', task_window, reverse_bidspace_crop);

%if the budget should contain a random amount of water make the reverse texture for that too
if parameters.binary_choice.random_budget || parameters.binary_choice.pegged_budget
  reverse_budget_crop = imcrop(bidspace.reverse_bidspace,...
    [0 bidspace.bidspace_info.height - (bidspace.bidspace_info.height * trial_values.budget_water)...
    bidspace.bidspace_info.width bidspace.bidspace_info.height]);
  
    stimuli.trial.reverse_budget_texture = Screen('MakeTexture', task_window, reverse_budget_crop);
    
    stimuli.trial.reversed_budget_position = bidspace.bidspace_info.position;
    stimuli.trial.reversed_budget_position(2) = stimuli.trial.reversed_budget_position(4) - (bidspace.bidspace_info.height * trial_values.budget_water);
end

end

%work out the position of the cover image
stimuli.trial.reversed_bidspace_position = bidspace.bidspace_info.position;
stimuli.trial.reversed_bidspace_position(2) = stimuli.trial.reversed_bidspace_position(4) - (bidspace.bidspace_info.height * value);