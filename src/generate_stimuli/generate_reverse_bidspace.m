%function to generate a cover image for the bidspace to reflect the amount
%of the budget left after winning an auction
%this is the area under the computer bid if monkey bid > computer bid
function stimuli = generate_reverse_bidspace(parameters, results, stimuli, modifiers, task_window)
%crop the reverse bidspace to the size under the computer bid and make a
%texture
if strcmp(parameters.task.type, 'BDM')
    %task parameter for the new bidspace position
    value = results.single_trial.computer_bid;
elseif strcmp(parameters.task.type, 'BC')
    value = 1 - results.single_trial.second_budget_value;
end

%abbreviate bidspace object
bidspace = stimuli.bidspace;

%if the budget should contain a random amount of water make the reverse texture for that too
%doesn't need a position as this will be derived from the bidspace position
%when reflecting the bundle
if strcmp(parameters.task.type, 'BC')
    if modifiers.budget.random || modifiers.budget.pegged
        reverse_budget_crop = imcrop(bidspace.reverse_bidspace_image,...
            [0, bidspace.dimensions.height - (bidspace.dimensions.height * trial_values.budget_water)...
        bidspace.bidspace_info.width bidspace.bidspace_info.height]);
  
        stimuli.budget.reverse_texture = Screen('MakeTexture', task_window, reverse_budget_crop);
    else
        %crop the bidspace
        reverse_bidspace_crop = imcrop(bidspace.reverse_bidspace_image,...
            [0, bidspace.dimensions.height - (bidspace.dimensions.height * value)...
            bidspace.dimensions.width, bidspace.dimensions.height]);
        
        stimuli.bidspace.reverse_texture = Screen('MakeTexture', task_window, reverse_bidspace_crop);
    end
elseif strcmp(parameters.task.type, 'BDM')
    if first_price
    else
    end
end

%work out the position of the cover image
stimuli.bidspace.reverse_texture_position = bidspace.position;
stimuli.bidspace.reverse_texture_position(2) = stimuli.bidspace.reverse_texture_position(4) - (stimuli.bidspace.dimensions.height * value);
