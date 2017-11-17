%function to check if the offer made by a monkey is within a predetermined
%target box over the bidspace
%if so, changes the parameter gating for targeting from false to true (and
%so allows the task to proceed to the result section instead of the error
%epoch)
function targeted_offer = check_targeted_offer(parameters, stimuli)

%check if the offer is between the y values of the target box
%if so, the targeted offer check passes, else it fails
if stimuli.bid_value > stimuli.target_box.position && stimuli.bid_value < stimuli.target_box.position
    targeted_offer = true;
else
    targeted_offer = false;
end


