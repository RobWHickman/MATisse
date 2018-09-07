%function to generate a semi transparent box randomly within the bidspace 
%to be used as a target for monkey bidding
function stimuli = generate_target_box(modifiers, stimuli, hardware, results)

stimuli.target_box.length = stimuli.bidspace.dimensions.height * results.single_trial.target_box_size;
stimuli.target_box.shift = stimuli.bidspace.dimensions.height * results.single_trial.target_box_shift;

%make sure the width of the target box is slightly wider than the bounding
%box
target_box_width = modifiers.budget.overhang * 2;

target_box_y1 = stimuli.bidspace.position(2);
target_box_y2 = target_box_y1 + stimuli.target_box.length;
%get the full position
stimuli.target_box.position = [stimuli.bidspace.position(1) - target_box_width, target_box_y1 + stimuli.target_box.shift,...
    stimuli.bidspace.position(3) + target_box_width, target_box_y2 + stimuli.target_box.shift];

%semi transparent light blue colouring
stimuli.target_box.colour = [0 0 hardware.screen.colours.white];
