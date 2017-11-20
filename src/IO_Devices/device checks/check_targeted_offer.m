%function to check if the offer made by a monkey is within a predetermined
%target box over the bidspace
%if so, changes the parameter gating for targeting from false to true (and
%so allows the task to proceed to the result section instead of the error
%epoch)
function results = check_targeted_offer(parameters, results, stimuli)
%check if the offer is between the y values of the target box
%if so, the targeted offer check passes, else it fails

bid_position = stimuli.bidspace.bidspace_info.position(4) - ...
    (stimuli.bidspace.bidspace_info.height * results.trial_results.monkey_bid);

if bid_position > stimuli.target_box.position(2) + parameters.single_trial_values.target_value_shift...
        && bid_position < stimuli.target_box.position(4) + parameters.single_trial_values.target_value_shift
    results.trial_values.task_checks.Status('targeted_offer') = 1;
else
    results.trial_values.task_checks.Status('targeted_offer') = 0;
end

