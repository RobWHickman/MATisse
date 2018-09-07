%function to check if the offer made by a monkey is within a predetermined
%target box over the bidspace
%if so, changes the parameter gating for targeting from false to true (and
%so allows the task to proceed to the result section instead of the error
%epoch)
function parameters = check_targeted_offer(parameters, results, stimuli)
%check if the offer is between the y values of the target box
%if so, the targeted offer check passes, else it fails

bid_position = stimuli.bidspace.position(4) - ...
    (stimuli.bidspace.dimensions.height * (results.single_trial.starting_bid + results.movement.total_movement));

if bid_position > stimuli.target_box.position(2) && bid_position < stimuli.target_box.position(4)
    parameters.task_checks.table.Status('targeted_offer') = 0;
else
    parameters.task_checks.table.Status('targeted_offer') = 1;
end