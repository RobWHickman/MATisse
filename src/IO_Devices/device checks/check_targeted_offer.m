%function to check if the offer made by a monkey is within a predetermined
%target box over the bidspace
%if so, changes the parameter gating for targeting from false to true (and
%so allows the task to proceed to the result section instead of the error
%epoch)
function results = check_targeted_offer(results, stimuli)
%check if the offer is between the y values of the target box
%if so, the targeted offer check passes, else it fails

bid_position = stimuli.bidspace.bidspace_info.position(4) - ...
    (stimuli.bidspace.bidspace_info.height * results.trial_results.monkey_bid);

display(bid_position);
display(stimuli.target_box.position(2));
display(stimuli.target_box.position(4));

if bid_position > stimuli.target_box.position(2) && bid_position < stimuli.target_box.position(4)
    results.trial_values.task_checks.Status('targeted_offer') = 1;
else
    results.trial_values.task_checks.Status('targeted_offer') = 0;
end


