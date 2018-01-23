%function to generate a semi transparent box randomly within the bidspace 
%to be used as a target for monkey bidding
function target_box = generate_target_box(modifiers, stimuli, hardware, correct_trials)
if stimuli.target_box.static
    target_box.length = stimuli.bidspace.dimensions.height * stimuli.target_box.startsize;
else
    %5% of the original height is ample for it to collapse to
    minimum_size = stimuli.bidspace.dimensions.height * 0.05;
    maximum_size = stimuli.bidspace.dimensions.height * stimuli.target_box.startsize;
    %starts at max size and converges to minimum size with a softmax
    %function
    target_box.length = ((maximum_size - minimum_size) - ((maximum_size - minimum_size) * (1/ (1 + exp(1) ^ (-(correct_trials-50)/20))))) + minimum_size;
end

%generates the upper (in space not value) limit on the targeting box
target_box_y1 = stimuli.bidspace.position(2);
target_box_y2 = target_box_y1 + target_box_box_length;

%make sure the width of the target box is slightly wider than the bounding
%box
target_box_width = modifiers.budget.overhang * 2;

%get the full position
target_box.position = [stimuli.bidspace.position(1) - target_box_width, target_box_y1,...
    stimuli.bidspace.position(3) + target_box_width, target_box_y2];

%semi transparent light blue colouring
target_box.colour = [0 0 hardware.outputs.screen_info.white];
